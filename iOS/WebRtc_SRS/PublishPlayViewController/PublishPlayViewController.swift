//
//  PublishPlayViewController.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit
import SnapKit
import WebRTC

class PublishPlayViewController: UIViewController {
    
    var publishUrlStr: String?
    var publishStreamUrl: String?
    var playUrlStr: String?
    var playStreamUrl: String?
    
    fileprivate var publishWebRTCClient: WebRTCClient = {
        let client = WebRTCClient(isPublish: true)
        return client
    }()
    
    fileprivate var playWebRTCClient: WebRTCClient = {
        let client = WebRTCClient(isPublish: false)
        return client
    }()
    
    fileprivate lazy var publishBtn: UIButton = {
        let view = UIButton.init(type: .custom)
        view.backgroundColor = .lightGray
        view.setTitle("start publish", for: .normal)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(publishBtnAction(sender:)), for: .touchUpInside)
        return view
    }()
    
    fileprivate lazy var playBtn: UIButton = {
        let view = UIButton.init(type: .custom)
        view.backgroundColor = .lightGray
        view.setTitle("play", for: .normal)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(playBtnAction(sender:)), for: .touchUpInside)
        return view
    }()
    
    fileprivate lazy var publishPlayView: PublishPlayView = {
        let view = PublishPlayView.init(frame: .zero, publishWebRTCClient: publishWebRTCClient, playWebRTCClient: playWebRTCClient)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        publishWebRTCClient.delegate = self
        playWebRTCClient.delegate = self
    }

}

fileprivate extension PublishPlayViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(publishPlayView)
        publishPlayView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(publishBtn)
        view.addSubview(playBtn)
        let width = UIScreen.main.bounds.width
        publishBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-width/4)
            make.width.equalTo(64 * 2)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-160)
        }
        playBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(width/4)
            make.width.equalTo(64 * 2)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-160)
        }
    }
    
}

extension PublishPlayViewController {
    
    @objc
    fileprivate func publishBtnAction(sender: UIButton?) {
        sender?.isEnabled = false
        sender?.setTitleColor(.gray, for: .normal)
        publishWebRTCClient.offer { [weak self] (sdp) in
            self?.publishWebRTCClient.changeSDP2Server(sdp: sdp, urlStr: self?.publishUrlStr, streamUrl: self?.publishStreamUrl) { (isServerRetSuc) in
                if isServerRetSuc == false {
                    DelayRetryAction.shared.delay30sRetry(btn: self?.publishBtn)
                }
            }
        }
    }
    
    @objc
    fileprivate func playBtnAction(sender: UIButton?) {
        sender?.isEnabled = false
        sender?.setTitleColor(.gray, for: .normal)
        playWebRTCClient.offer { [weak self] (sdp) in
            self?.playWebRTCClient.changeSDP2Server(sdp: sdp, urlStr: self?.playUrlStr, streamUrl: self?.playStreamUrl) { (isServerRetSuc) in
                debug_log("isServerRetSuc:\(isServerRetSuc)")
            }
        }
    }
    
}

extension PublishPlayViewController: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        debug_log("discovered local candidate")
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        let textColor: UIColor
        switch state {
        case .connected, .completed:
            textColor = .green
        case .disconnected:
            textColor = .orange
        case .failed, .closed:
            textColor = .red
        case .new, .checking, .count:
            textColor = .black
        @unknown default:
            textColor = .black
        }
        DispatchQueue.main.async { [weak self] in
            let text = state.description.capitalized
            let textColor = textColor
            var btn: UIButton? = nil
            if client == self?.publishWebRTCClient {
                btn = self?.publishBtn
            }else {
                btn = self?.playBtn
            }
            btn?.setTitle(text, for: .normal)
            btn?.setTitleColor(textColor, for: .normal)
            if textColor == .green {
                client.speakerOn()
            }
        }
    }
    
}
