//
//  PublishViewController.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit
import SnapKit
import WebRTC

class PublishViewController: UIViewController {

    var urlStr: String?
    var streamUrl: String?
    
    fileprivate var webRTCClient: WebRTCClient = {
        let client = WebRTCClient(isPublish: true)
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
    
    fileprivate lazy var publishView: PublishView = {
        let view = PublishView.init(frame: .zero, webRTCClient: webRTCClient)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.webRTCClient.delegate = self
    }

}

fileprivate extension PublishViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(publishView)
        publishView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(publishBtn)
        publishBtn.snp.makeConstraints { (make) in
            make.width.equalTo(64 * 2)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-160)
            make.centerX.equalToSuperview()
        }
    }
    
}

extension PublishViewController {
    
    @objc
    fileprivate func publishBtnAction(sender: UIButton?) {
        sender?.isEnabled = false
        sender?.setTitleColor(.gray, for: .normal)
        webRTCClient.offer { [weak self] (sdp) in
            self?.webRTCClient.changeSDP2Server(sdp: sdp, urlStr: self?.urlStr, streamUrl: self?.streamUrl) { (isServerRetSuc) in
                if isServerRetSuc == false {
                    DelayRetryAction.shared.delay30sRetry(btn: self?.publishBtn)
                }
            }
        }
    }
    
}

extension PublishViewController: WebRTCClientDelegate {
    
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
            self?.publishBtn.setTitle(text, for: .normal)
            self?.publishBtn.setTitleColor(textColor, for: .normal)
            if textColor == .green {
                self?.webRTCClient.speakerOn()
            }
        }
    }
    
}
