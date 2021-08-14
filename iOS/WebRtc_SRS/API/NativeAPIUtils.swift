//
//  NativeAPIUtils.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit

class NativeAPIUtils: NSObject {
    
    static let shared = NativeAPIUtils()
    
}

extension NativeAPIUtils {
    
    func sendSDPToServer(sdpStr: String?, urlStr: String?, streamUrl: String?, closure: ( ([String: Any]?, Error?) -> () )?) {
        func failed() {
            let error = NSError.init(domain: "sdp data need check", code: -1, userInfo: [
                NSLocalizedDescriptionKey : "sdp data need check.",
            ])
            closure?(nil, error)
        }
        /// check input.
        guard let sdpStr = sdpStr, let urlStr = urlStr, let streamUrl = streamUrl else {
            debug_log("sdpStr is null")
            failed()
            return
        }
        let postParams = createPostParams(sdpStr: sdpStr, urlStr: urlStr, streamUrl: streamUrl)
        apiHttpPost(urlStr: urlStr, postParams: postParams, closure: closure)
    }
    
    func sendSDPToServer(sdpStr: String?, closure: ( ([String: Any]?, Error?) -> () )?) {
        func failed() {
            let error = NSError.init(domain: "sdp data need check", code: -1, userInfo: [
                NSLocalizedDescriptionKey : "sdp data need check.",
            ])
            closure?(nil, error)
        }
        /// check input.
        guard let sdpStr = sdpStr else {
            debug_log("sdpStr is null")
            failed()
            return
        }
        let urlStr = AppConfig.publishLocalHostURLStr
        let streamUrl = AppConfig.localHostStreamURLStr
        let postParams = createPostParams(sdpStr: sdpStr, urlStr: urlStr, streamUrl: streamUrl)
        apiHttpPost(urlStr: urlStr, postParams: postParams, closure: closure)
    }
    
}

fileprivate extension NativeAPIUtils {
    
    func createTid() -> String {
        let date = Date()
        let timeInterval: Int = Int(date.timeIntervalSince1970)
        let random: Int = Int(arc4random())
        let str = String(timeInterval * random)
        let endIndex = str.index(str.startIndex, offsetBy: 7)
        let tid = String(str[..<endIndex])
        debug_log("tid:\(tid)")
        return tid
    }
    
    func createPostParams(sdpStr: String?, urlStr: String?, streamUrl: String?) -> [String: Any]? {
        guard let sdpStr = sdpStr else { return nil }
        guard let urlStr = urlStr else { return nil }
        guard let streamUrl = streamUrl else { return nil }
        let dict = [
            "api": urlStr,
            "tid": createTid(),
            "streamurl": streamUrl,
            "clientip": nil,
            "sdp": sdpStr,
        ]
        return dict as [String : Any]
    }
    
}

fileprivate extension NativeAPIUtils {
    
    func apiHttpPost(urlStr: String?, postParams: [String: Any]?, closure: ( ([String: Any]?, Error?) -> () )?) {
        func apiFailed() {
            if let postParams = postParams {
                debug_log("api failed: \(postParams)")
            }
            let error = NSError.init(domain: "http post failed", code: -1, userInfo: [
                NSLocalizedDescriptionKey : "api failed, please check.",
            ])
            DispatchQueue.main.async {
                closure?(nil, error)
            }
        }
        
        /// check input.
        guard let urlStr = urlStr, let url = URL(string: urlStr), let postParams = postParams else {
            apiFailed()
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 60
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        debug_log("postParams \(postParams)")
        let httpBody = try? JSONSerialization.data(withJSONObject: postParams, options: [])
        request.httpBody = httpBody
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let _ = response as? HTTPURLResponse, let receivedData = data else {
                debug_log("error: not a valid http response")
                apiFailed()
                return
            }
            debug_log("data: \(String(describing: data))")
            debug_log("response: \(String(describing: response))")
            let jsonData = try? JSONSerialization.jsonObject(with: receivedData, options: .allowFragments)
            if let dict = jsonData as? [String: Any] {
                debug_log("dict:\(dict)")
                DispatchQueue.main.async {
                    closure?(dict, nil)
                }
            }else {
                debug_log("api failed")
                apiFailed()
            }
        }
        dataTask.resume()
    }
    
}

extension NativeAPIUtils : URLSessionDelegate {

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }

}

// MARK: - Test

extension NativeAPIUtils {
    
    class func test() {
        NativeAPIUtils.shared.sendSDPToServer(sdpStr: "sdpStr") { (dict, error) in
            if let error = error {
                debug_log("error: \(error)")
                return
            }
            if let dict = dict, let code = dict["code"] {
                debug_log("code : \(code)")
            }
            if let dict = dict, let sdp = dict["sdp"] as? String {
                debug_log("sdp: \(sdp)")
            }
        }
    }
    
}
