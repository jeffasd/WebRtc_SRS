//
//  PlayViewController.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit
import SnapKit
import WebRTC

class PlayViewController: UIViewController {

    var urlStr: String?
    var streamUrl: String?
    
    fileprivate var webRTCClient: WebRTCClient = {
        let client = WebRTCClient(isPublish: false)
        return client
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
    
    fileprivate lazy var playView: PlayView = {
        let view = PlayView.init(frame: .zero, webRTCClient: webRTCClient)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.webRTCClient.delegate = self
        playBtnAction(sender: playBtn)
    }

}

fileprivate extension PlayViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(playView)
        playView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.addSubview(playBtn)
        playBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(64*2)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-160)
        }
    }
    
}

extension PlayViewController {
    
    @objc
    fileprivate func playBtnAction(sender: UIButton?) {
        sender?.isEnabled = false
        sender?.setTitleColor(.gray, for: .normal)
        webRTCClient.offer { [weak self] (sdp) in
            self?.webRTCClient.changeSDP2Server(sdp: sdp, urlStr: self?.urlStr, streamUrl: self?.streamUrl) { (isServerRetSuc) in
                debug_log("isServerRetSuc:\(isServerRetSuc)")
            }
        }
    }
    
}

extension PlayViewController: WebRTCClientDelegate {
    
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
            self?.playBtn.setTitle(text, for: .normal)
            self?.playBtn.setTitleColor(textColor, for: .normal)
            if textColor == .green {
                self?.webRTCClient.speakerOn()
            }
        }
    }
    
}

