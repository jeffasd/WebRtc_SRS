//
//  WebRTCClient+ChangeSDP2Server.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import WebRTC

extension WebRTCClient {
    
    func changeSDP2Server(sdp: RTCSessionDescription, urlStr: String?, streamUrl: String?, closure: ( (_ isServerRetSuc: Bool) -> () )? = nil) {
        let sdpStr = sdp.sdp
        debug_log("sdpStr: \n\(sdpStr)")
        NativeAPIUtils.shared.sendSDPToServer(sdpStr: sdpStr, urlStr: urlStr, streamUrl: streamUrl) { [weak self] (dict, error) in
            func handleError() {
                closure?(false)
            }
            if let error = error {
                debug_log("error: \(error)")
                handleError()
                return
            }
            if let dict = dict, let code = dict["code"] as? Int, code != 0 {
                debug_log("code : \(code)")
                handleError()
                return
            }
            if let dict = dict, let sdp = dict["sdp"] as? String, sdp.count > 0 {
                self?.handleAnswer(sdp: sdp)
                closure?(true)
            }else {
                debug_log("server ret sdp length zero")
                handleError()
            }
        }
    }
    
    func handleAnswer(sdp: String) {
        debug_log("\nanswer sdp:\n\(sdp)")
        let remoteSdp = RTCSessionDescription.init(type: .answer, sdp: sdp)
        self.set(remoteSdp: remoteSdp) { (error) in
            if let error = error {
                debug_log("error : \(error)")
            }
        }
    }
    
}
