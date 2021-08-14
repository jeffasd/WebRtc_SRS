//
//  PublishPlayView.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit
import WebRTC
import SnapKit

final class PublishPlayView: UIView {
    
    fileprivate weak var publishWebRTCClient: WebRTCClient?
    fileprivate weak var playWebRTCClient: WebRTCClient?
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, publishWebRTCClient: WebRTCClient, playWebRTCClient: WebRTCClient) {
        self.init(frame: frame)
        self.publishWebRTCClient = publishWebRTCClient
        self.playWebRTCClient = playWebRTCClient
        setupUI()
    }
    
}

fileprivate extension PublishPlayView {
    
    func setupUI() {
        #if arch(arm64)
        // Using metal (arm64 only)
        let localRenderer = RTCMTLVideoView(frame: .zero)
        localRenderer.videoContentMode = .scaleAspectFill
        /// face model
        /// when change video model please change transform.
        localRenderer.transform = CGAffineTransform.init(scaleX: -1, y: 1)
        let remoteRenderer = RTCMTLVideoView(frame: .zero)
        remoteRenderer.backgroundColor = .lightGray
        remoteRenderer.videoContentMode = .scaleAspectFill
        #else
        // Using OpenGLES for the rest
        let localRenderer = RTCEAGLVideoView(frame: CGRect.zero)
        let remoteRenderer = RTCEAGLVideoView(frame: CGRect.zero)
        #endif
        
        addSubview(localRenderer)
        addSubview(remoteRenderer)
        localRenderer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        remoteRenderer.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(100 * (16.0/9.0))
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(navigationSafeHeight() + 16)
        }
        layoutIfNeeded()
        publishWebRTCClient?.startCaptureLocalVideo(renderer: localRenderer)
        playWebRTCClient?.renderRemoteVideo(to: remoteRenderer)
    }
    
}

