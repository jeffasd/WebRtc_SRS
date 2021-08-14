//
//  PublishView.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit
import WebRTC
import SnapKit

final class PublishView: UIView {
    
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

fileprivate extension PublishView {
    
    func setupUI() {
        #if arch(arm64)
            // Using metal (arm64 only)
            let localRenderer = RTCMTLVideoView(frame: .zero)
            localRenderer.videoContentMode = .scaleAspectFill
            /// face model
            /// when change video model please change transform.
            localRenderer.transform = CGAffineTransform.init(scaleX: -1, y: 1)
        #else
            // Using OpenGLES for the rest
            let localRenderer = RTCEAGLVideoView(frame: CGRect.zero)
        #endif
        
        addSubview(localRenderer)
        localRenderer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.webRTCClient?.startCaptureLocalVideo(renderer: localRenderer)
    }
    
}
