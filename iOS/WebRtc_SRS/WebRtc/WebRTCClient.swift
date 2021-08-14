//
//  WebRTCClient.swift
//  WebRTC
//
//  Created by Stasel on 20/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import UIKit
import WebRTC

protocol WebRTCClientDelegate: AnyObject {
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate)
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState)
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data)
}

extension WebRTCClientDelegate {
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {}
}

final class WebRTCClient: NSObject {
    
    // The `RTCPeerConnectionFactory` is in charge of creating new RTCPeerConnection instances.
    // A new RTCPeerConnection should be created every new call, but the factory is shared.
    private static let factory: RTCPeerConnectionFactory = {
        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        for codec in videoEncoderFactory.supportedCodecs() {
            if let profile_level_id = codec.parameters["profile-level-id"], profile_level_id == "42e01f" {
                videoEncoderFactory.preferredCodec = codec
                break
            }
        }
        return RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }()
    
    weak var delegate: WebRTCClientDelegate?
    private let isPublish: Bool
    private let peerConnection: RTCPeerConnection
    private let rtcAudioSession =  RTCAudioSession.sharedInstance()
    private let audioQueue = DispatchQueue(label: "audio")
    private var mediaConstrains = [kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueFalse,
                                   kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueFalse,
                                   "IceRestart": kRTCMediaConstraintsValueTrue]
    private let publishMediaConstrains = [kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueFalse,
                                          kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueFalse,
                                          "IceRestart": kRTCMediaConstraintsValueTrue]
    private let playMediaConstrains = [kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueTrue,
                                       kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueTrue,
                                       "IceRestart": kRTCMediaConstraintsValueTrue]
    
    private var videoCapturer: RTCVideoCapturer?
    private var localAudioTrack: RTCAudioTrack?
    private var localVideoTrack: RTCVideoTrack?
    private var remoteVideoTrack: RTCVideoTrack?
    private var remoteRenderView: RTCVideoRenderer?
        
    // srs not support data channel.
    private var localDataChannel: RTCDataChannel?
    private var remoteDataChannel: RTCDataChannel?
    
    @available(*, unavailable)
    override init() {
        fatalError("WebRTCClient:init is unavailable")
    }
    
    required init(isPublish: Bool) {
        self.isPublish = isPublish
        // Define media constraints. DtlsSrtpKeyAgreement is required to be true to be able to connect with web browsers.
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil,
                                              optionalConstraints: ["DtlsSrtpKeyAgreement":kRTCMediaConstraintsValueTrue])
        let newConfig = RTCConfiguration()
        // newConfig.continualGatheringPolicy = .gatherOnce
        newConfig.sdpSemantics = .unifiedPlan
        self.peerConnection = WebRTCClient.factory.peerConnection(with: newConfig, constraints: constraints, delegate: nil)
        
        super.init()
        self.createMediaSenders()
        self.createMediaReceivers()
        // srs not support data channel.
        // self.createDataChannel()
        self.configureAudioSession()
        self.peerConnection.delegate = self
    }
    
    // MARK: Signaling
    func offer(completion: @escaping (_ sdp: RTCSessionDescription) -> Void) {
        if isPublish {
            self.mediaConstrains = publishMediaConstrains
        }else {
            self.mediaConstrains = playMediaConstrains
        }
        let constrains = RTCMediaConstraints(mandatoryConstraints: self.mediaConstrains,
                                             optionalConstraints: nil)
        debug_log("peerConnection:\(self.peerConnection)")
        self.peerConnection.offer(for: constrains) { (sdp, error) in
            guard let sdp = sdp else {
                return
            }
            
            self.peerConnection.setLocalDescription(sdp, completionHandler: { (error) in
                completion(sdp)
            })
        }
    }
    
    func answer(completion: @escaping (_ sdp: RTCSessionDescription) -> Void)  {
        let constrains = RTCMediaConstraints(mandatoryConstraints: self.mediaConstrains,
                                             optionalConstraints: nil)
        self.peerConnection.answer(for: constrains) { (sdp, error) in
            guard let sdp = sdp else {
                return
            }
            
            self.peerConnection.setLocalDescription(sdp, completionHandler: { (error) in
                completion(sdp)
            })
        }
    }
    
    func set(remoteSdp: RTCSessionDescription, completion: @escaping (Error?) -> ()) {
        self.peerConnection.setRemoteDescription(remoteSdp, completionHandler: completion)
    }
    
    func set(remoteCandidate: RTCIceCandidate) {
        self.peerConnection.add(remoteCandidate)
    }
    
    func set(maxBitrate: Int) {
        let videoSenders = self.peerConnection.senders.filter { (sender) -> Bool in
            sender.track?.kind == "video"
        }
        let parameters = videoSenders.first?.parameters
        let maxBitrateBps = NSNumber.init(value: maxBitrate)
        parameters?.encodings.first?.maxBitrateBps = maxBitrateBps
    }
    
    func set(maxFramerate: Int) {
        let videoSenders = self.peerConnection.senders.filter { (sender) -> Bool in
            sender.track?.kind == "video"
        }
        let parameters = videoSenders.first?.parameters
        let maxFramerateNum = NSNumber.init(value: maxFramerate)
        parameters?.encodings.first?.maxFramerate = maxFramerateNum
    }
    
    // MARK: Media
    func startCaptureLocalVideo(renderer: RTCVideoRenderer?) {
        guard isPublish else { return }
        guard let renderer = renderer else { return }
        guard let capturer = self.videoCapturer else { return }
        
        if let capturer = capturer as? RTCCameraVideoCapturer {
            guard let frontCamera = (RTCCameraVideoCapturer.captureDevices().first { $0.position == .front }) else { return }
            let formatNilable = RTCCameraVideoCapturer.supportedFormats(for: frontCamera).compactMap({ (format) -> AVCaptureDevice.Format? in
                let width = CMVideoFormatDescriptionGetDimensions(format.formatDescription).width
                let height = CMVideoFormatDescriptionGetDimensions(format.formatDescription).height
                
                // only use 16:9 format.
                if Float(width) / Float(height) >= 16 / 9 {
                    return format
                }else {
                    return nil
                }
            }).sorted { (f1, f2) -> Bool in
                let width1 = CMVideoFormatDescriptionGetDimensions(f1.formatDescription).width
                let width2 = CMVideoFormatDescriptionGetDimensions(f2.formatDescription).width
                let height2 = CMVideoFormatDescriptionGetDimensions(f2.formatDescription).height
                if Float(width2) / Float(height2) <= 1.7 {
                    return false
                }
                return width1 < width2
            }.last
            
            guard let format = formatNilable else { return }
            debugPrint("format \(format)")
            
            do {
                let formatArr: [AVCaptureDevice.Format] = RTCCameraVideoCapturer.supportedFormats(for: frontCamera)
                for format in formatArr {
                    debugPrint("format \(format)")
                }
            }
            
            // choose highest fps
            // let fps = (format.videoSupportedFrameRateRanges.sorted { return $0.maxFrameRate < $1.maxFrameRate }.last)
            
            capturer.startCapture(with: frontCamera,
                                  format: format,
                                  fps: 20)
        }
        if let capturer = capturer as? RTCFileVideoCapturer {
            capturer.startCapturing(fromFileNamed: "beautyPicture.mp4") { (error) in
                debug_log("RTCFileVideoCapturer start error: \(error)")
            }
        }
        self.localVideoTrack?.add(renderer)
    }
    
    func renderRemoteVideo(to renderer: RTCVideoRenderer?) {
        guard isPublish == false else { return }
        self.remoteRenderView = renderer
    }
    
    private func configureAudioSession() {
        self.rtcAudioSession.lockForConfiguration()
        do {
            try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
            try self.rtcAudioSession.setMode(AVAudioSession.Mode.voiceChat.rawValue)
        } catch let error {
            debugPrint("Error changeing AVAudioSession category: \(error)")
        }
        self.rtcAudioSession.unlockForConfiguration()
    }
    
    private func createMediaSenders() {
        guard isPublish else { return }
        let streamId = "stream"
        // Audio
        let audioTrack = self.createAudioTrack()
        self.localAudioTrack = audioTrack;
        let audioTrackTransceiver = RTCRtpTransceiverInit.init()
        audioTrackTransceiver.direction = .sendOnly
        audioTrackTransceiver.streamIds = [streamId]
        self.peerConnection.addTransceiver(with: audioTrack, init: audioTrackTransceiver)
        // Video
        let videoTrack = self.createVideoTrack()
        self.localVideoTrack = videoTrack
        let videoTrackTransceiver = RTCRtpTransceiverInit.init()
        videoTrackTransceiver.direction = .sendOnly
        videoTrackTransceiver.streamIds = [streamId]
        self.peerConnection.addTransceiver(with: videoTrack, init: videoTrackTransceiver)
    }
    
    private func createMediaReceivers() {
        guard isPublish == false else { return }
        self.remoteVideoTrack = self.peerConnection.transceivers.first { $0.mediaType == .video }?.receiver.track as? RTCVideoTrack
    }
    
    private func createAudioTrack() -> RTCAudioTrack {
        /// enable google 3A algorithm.
        let mandatory = [
            "googEchoCancellation": kRTCMediaConstraintsValueTrue,
            "googAutoGainControl": kRTCMediaConstraintsValueTrue,
            "googNoiseSuppression": kRTCMediaConstraintsValueTrue,
        ]
        let audioConstrains = RTCMediaConstraints(mandatoryConstraints: mandatory, optionalConstraints: nil)
        let audioSource = WebRTCClient.factory.audioSource(with: audioConstrains)
        let audioTrack = WebRTCClient.factory.audioTrack(with: audioSource, trackId: "audio0")
        return audioTrack
    }
    
    private func createVideoTrack() -> RTCVideoTrack {
        let videoSource = WebRTCClient.factory.videoSource()
        
        #if targetEnvironment(simulator)
        /// your simulator code
        self.videoCapturer = RTCFileVideoCapturer(delegate: videoSource)
        #else
        /// your real device code
        self.videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)
        #endif
        
        let videoTrack = WebRTCClient.factory.videoTrack(with: videoSource, trackId: "video0")
        return videoTrack
    }
    
    // MARK: Data Channels -- srs not support.
    private func createDataChannel() -> RTCDataChannel? {
        let config = RTCDataChannelConfiguration()
        guard let dataChannel = self.peerConnection.dataChannel(forLabel: "WebRTCData", configuration: config) else {
            debugPrint("Warning: Couldn't create data channel.")
            return nil
        }
        dataChannel.delegate = self
        self.localDataChannel = dataChannel
        return dataChannel
    }
    
    func sendData(_ data: Data) {
        let buffer = RTCDataBuffer(data: data, isBinary: true)
        self.remoteDataChannel?.sendData(buffer)
    }
}

extension WebRTCClient: RTCPeerConnectionDelegate {
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        debugPrint("peerConnection new signaling state: \(stateChanged)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        debugPrint("peerConnection did add stream")
        guard isPublish == false else { return }
        if let track = stream.videoTracks.first {
            print("video track found")
            self.remoteVideoTrack = track
        }
        if let remoteVideoTrack = self.remoteVideoTrack, let remoteRender = self.remoteRenderView {
            remoteVideoTrack.add(remoteRender)
        }
        /**
         if let audioTrack = stream.audioTracks.first{
         print("audio track faund")
         audioTrack.source.volume = 8
         }
         */
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        debugPrint("peerConnection did remove stream")
    }
    
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        debugPrint("peerConnection should negotiate")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        debugPrint("peerConnection new connection state: \(newState)")
        self.delegate?.webRTCClient(self, didChangeConnectionState: newState)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        debugPrint("peerConnection new gathering state: \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        self.delegate?.webRTCClient(self, didDiscoverLocalCandidate: candidate)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        debugPrint("peerConnection did remove candidate(s)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        debugPrint("peerConnection did open data channel")
        self.remoteDataChannel = dataChannel
    }
}

extension WebRTCClient {
    private func setTrackEnabled<T: RTCMediaStreamTrack>(_ type: T.Type, isEnabled: Bool) {
        peerConnection.transceivers
            .compactMap { return $0.sender.track as? T }
            .forEach { $0.isEnabled = isEnabled }
    }
}

// MARK: - Video control
extension WebRTCClient {
    func hideVideo() {
        self.setVideoEnabled(false)
    }
    func showVideo() {
        self.setVideoEnabled(true)
    }
    private func setVideoEnabled(_ isEnabled: Bool) {
        setTrackEnabled(RTCVideoTrack.self, isEnabled: isEnabled)
    }
}

// MARK:- Audio control
extension WebRTCClient {
    func muteAudio() {
        self.setAudioEnabled(false)
    }
    
    func unmuteAudio() {
        self.setAudioEnabled(true)
    }
    
    // Fallback to the default playing device: headphones/bluetooth/ear speaker
    func speakerOff() {
        self.audioQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            self.rtcAudioSession.lockForConfiguration()
            do {
                try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
                try self.rtcAudioSession.overrideOutputAudioPort(.none)
            } catch let error {
                debugPrint("Error setting AVAudioSession category: \(error)")
            }
            self.rtcAudioSession.unlockForConfiguration()
        }
    }
    
    // Force speaker
    func speakerOn() {
        self.audioQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            self.rtcAudioSession.lockForConfiguration()
            do {
                try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
                try self.rtcAudioSession.overrideOutputAudioPort(.speaker)
                try self.rtcAudioSession.setActive(true)
            } catch let error {
                debugPrint("Couldn't force audio to speaker: \(error)")
            }
            self.rtcAudioSession.unlockForConfiguration()
        }
    }
    
    private func setAudioEnabled(_ isEnabled: Bool) {
        setTrackEnabled(RTCAudioTrack.self, isEnabled: isEnabled)
    }
}

extension WebRTCClient: RTCDataChannelDelegate {
    func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
        debugPrint("dataChannel did change state: \(dataChannel.readyState)")
    }
    
    func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
        self.delegate?.webRTCClient(self, didReceiveData: buffer.data)
    }
}
