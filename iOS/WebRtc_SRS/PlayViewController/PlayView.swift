//
//  PlayView.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit
import WebRTC
import SnapKit

final class PlayView: UIView {
    
    fileprivate weak var webRTCClient: WebRTCClient?
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, webRTCClient: WebRTCClient) {
        self.init(frame: frame)
        self.webRTCClient = webRTCClient
        setupUI()
    }
    
}

fileprivate extension PlayView {
    
    func setupUI() {
        #if arch(arm64)
        // Using metal (arm64 only)
        let remoteRenderer = RTCMTLVideoView(frame: .zero)
        remoteRenderer.videoContentMode = .scaleAspectFill
        /// face model
        /// remoteRenderer.transform = CGAffineTransform.init(scaleX: -1, y: 1)
        /// when change video model please change transform.
        #else
        // Using OpenGLES for the rest
        let remoteRenderer = RTCEAGLVideoView(frame: .zero)
        #endif
        
        addSubview(remoteRenderer)
        remoteRenderer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        layoutIfNeeded()
        self.webRTCClient?.renderRemoteVideo(to: remoteRenderer)
    }
    
}

