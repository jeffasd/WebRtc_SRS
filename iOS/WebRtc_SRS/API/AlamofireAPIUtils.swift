//
//  AlamofireAPIUtils.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit
import Alamofire

class AlamofireAPIUtils: NSObject {
    
    fileprivate static let manager = ServerTrustManager(evaluators:
                                                            [
                                                                "localhost": DisabledTrustEvaluator(),
                                                                "localhost.charlesproxy.com": DisabledTrustEvaluator(),
                                                                "d.ossrs.net": DisabledTrustEvaluator(),
                                                            ])
    /// fileprivate static let session = Session(serverTrustManager: manager)
    fileprivate static let session = Session(serverTrustManager: ServerTrustManager.init(allHostsMustBeEvaluated: true, evaluators: [:]))
    
    /// Reference to `Session.default` for quick bootstrapping and examples.
    fileprivate static let AFDisableSSL = session
    
}

// MARK: - Test

extension AlamofireAPIUtils {
    
    class func testAPIZero() {
        let dic = [
            "api": "urlStr",
            "tid": "createTid",
            "streamurl": "streamUrl",
            "clientip": nil,
            "sdp": "sdpStr",
        ]
        
        let urlStr = AppConfig.publishRemoteURLStr

        /// Content-Type is "application/x-www-form-urlencoded; charset=utf-8"
        AFDisableSSL.request(urlStr, method: .post, parameters: dic as Parameters, encoding: URLEncoding.default, headers: nil).response { response in
            debugPrint(response)
        }
        
        /// Content-Type is "application/json"
        AFDisableSSL.request(urlStr, method: .post, parameters: dic as Parameters, encoding: JSONEncoding.default, headers: nil).response { response in
            debugPrint(response)
        }
        
    }
    
    class func testAPI() {
        let dic = [
            "api": AppConfig.publishLocalHostURLStr,
            "tid": "5940a1d",
            "streamurl": AppConfig.localHostStreamURLStr,
            "clientip": nil,
            "sdp": "v=0\r\no=- 6219214292409387369 2 IN IP4 127.0.0.1\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0 1\r\na=extmap-allow-mixed\r\na=msid-semantic: WMS\r\nm=audio 9 UDP/TLS/RTP/SAVPF 111 103 104 9 0 8 106 105 13 110 112 113 126\r\nc=IN IP4 0.0.0.0\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=ice-ufrag:uc/O\r\na=ice-pwd:adWXB0IQt8/jAGBLYpWyZ6Pu\r\na=ice-options:trickle\r\na=fingerprint:sha-256 EA:3E:CD:C1:15:33:D3:A1:1F:E5:01:C7:B5:19:B1:2B:D8:B8:98:43:5A:B1:71:6E:58:CD:86:32:BB:65:0A:E8\r\na=setup:actpass\r\na=mid:0\r\na=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\r\na=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time\r\na=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01\r\na=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid\r\na=extmap:5 urn:ietf:params:rtp-hdrext:sdes:rtp-stream-id\r\na=extmap:6 urn:ietf:params:rtp-hdrext:sdes:repaired-rtp-stream-id\r\na=sendonly\r\na=msid:- 6152d576-2b30-4fe9-9cf8-5c717274e0a5\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=rtcp-fb:111 transport-cc\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:103 ISAC/16000\r\na=rtpmap:104 ISAC/32000\r\na=rtpmap:9 G722/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:106 CN/32000\r\na=rtpmap:105 CN/16000\r\na=rtpmap:13 CN/8000\r\na=rtpmap:110 telephone-event/48000\r\na=rtpmap:112 telephone-event/32000\r\na=rtpmap:113 telephone-event/16000\r\na=rtpmap:126 telephone-event/8000\r\na=ssrc:2297968633 cname:qNTVbiiB/IVZdQVP\r\na=ssrc:2297968633 msid:- 6152d576-2b30-4fe9-9cf8-5c717274e0a5\r\na=ssrc:2297968633 mslabel:-\r\na=ssrc:2297968633 label:6152d576-2b30-4fe9-9cf8-5c717274e0a5\r\nm=video 9 UDP/TLS/RTP/SAVPF 96 97 98 99 100 101 102 121 127 120 125 107 108 109 35 36 124 119 123 118 114 115 116\r\nc=IN IP4 0.0.0.0\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=ice-ufrag:uc/O\r\na=ice-pwd:adWXB0IQt8/jAGBLYpWyZ6Pu\r\na=ice-options:trickle\r\na=fingerprint:sha-256 EA:3E:CD:C1:15:33:D3:A1:1F:E5:01:C7:B5:19:B1:2B:D8:B8:98:43:5A:B1:71:6E:58:CD:86:32:BB:65:0A:E8\r\na=setup:actpass\r\na=mid:1\r\na=extmap:14 urn:ietf:params:rtp-hdrext:toffset\r\na=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time\r\na=extmap:13 urn:3gpp:video-orientation\r\na=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01\r\na=extmap:12 http://www.webrtc.org/experiments/rtp-hdrext/playout-delay\r\na=extmap:11 http://www.webrtc.org/experiments/rtp-hdrext/video-content-type\r\na=extmap:7 http://www.webrtc.org/experiments/rtp-hdrext/video-timing\r\na=extmap:8 http://www.webrtc.org/experiments/rtp-hdrext/color-space\r\na=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid\r\na=extmap:5 urn:ietf:params:rtp-hdrext:sdes:rtp-stream-id\r\na=extmap:6 urn:ietf:params:rtp-hdrext:sdes:repaired-rtp-stream-id\r\na=sendonly\r\na=msid:- 8558a423-0a0d-44ed-9bb4-488501cfa877\r\na=rtcp-mux\r\na=rtcp-rsize\r\na=rtpmap:96 VP8/90000\r\na=rtcp-fb:96 goog-remb\r\na=rtcp-fb:96 transport-cc\r\na=rtcp-fb:96 ccm fir\r\na=rtcp-fb:96 nack\r\na=rtcp-fb:96 nack pli\r\na=rtpmap:97 rtx/90000\r\na=fmtp:97 apt=96\r\na=rtpmap:98 VP9/90000\r\na=rtcp-fb:98 goog-remb\r\na=rtcp-fb:98 transport-cc\r\na=rtcp-fb:98 ccm fir\r\na=rtcp-fb:98 nack\r\na=rtcp-fb:98 nack pli\r\na=fmtp:98 profile-id=0\r\na=rtpmap:99 rtx/90000\r\na=fmtp:99 apt=98\r\na=rtpmap:100 VP9/90000\r\na=rtcp-fb:100 goog-remb\r\na=rtcp-fb:100 transport-cc\r\na=rtcp-fb:100 ccm fir\r\na=rtcp-fb:100 nack\r\na=rtcp-fb:100 nack pli\r\na=fmtp:100 profile-id=2\r\na=rtpmap:101 rtx/90000\r\na=fmtp:101 apt=100\r\na=rtpmap:102 H264/90000\r\na=rtcp-fb:102 goog-remb\r\na=rtcp-fb:102 transport-cc\r\na=rtcp-fb:102 ccm fir\r\na=rtcp-fb:102 nack\r\na=rtcp-fb:102 nack pli\r\na=fmtp:102 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=42001f\r\na=rtpmap:121 rtx/90000\r\na=fmtp:121 apt=102\r\na=rtpmap:127 H264/90000\r\na=rtcp-fb:127 goog-remb\r\na=rtcp-fb:127 transport-cc\r\na=rtcp-fb:127 ccm fir\r\na=rtcp-fb:127 nack\r\na=rtcp-fb:127 nack pli\r\na=fmtp:127 level-asymmetry-allowed=1;packetization-mode=0;profile-level-id=42001f\r\na=rtpmap:120 rtx/90000\r\na=fmtp:120 apt=127\r\na=rtpmap:125 H264/90000\r\na=rtcp-fb:125 goog-remb\r\na=rtcp-fb:125 transport-cc\r\na=rtcp-fb:125 ccm fir\r\na=rtcp-fb:125 nack\r\na=rtcp-fb:125 nack pli\r\na=fmtp:125 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=42e01f\r\na=rtpmap:107 rtx/90000\r\na=fmtp:107 apt=125\r\na=rtpmap:108 H264/90000\r\na=rtcp-fb:108 goog-remb\r\na=rtcp-fb:108 transport-cc\r\na=rtcp-fb:108 ccm fir\r\na=rtcp-fb:108 nack\r\na=rtcp-fb:108 nack pli\r\na=fmtp:108 level-asymmetry-allowed=1;packetization-mode=0;profile-level-id=42e01f\r\na=rtpmap:109 rtx/90000\r\na=fmtp:109 apt=108\r\na=rtpmap:35 AV1X/90000\r\na=rtcp-fb:35 goog-remb\r\na=rtcp-fb:35 transport-cc\r\na=rtcp-fb:35 ccm fir\r\na=rtcp-fb:35 nack\r\na=rtcp-fb:35 nack pli\r\na=rtpmap:36 rtx/90000\r\na=fmtp:36 apt=35\r\na=rtpmap:124 H264/90000\r\na=rtcp-fb:124 goog-remb\r\na=rtcp-fb:124 transport-cc\r\na=rtcp-fb:124 ccm fir\r\na=rtcp-fb:124 nack\r\na=rtcp-fb:124 nack pli\r\na=fmtp:124 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=4d0032\r\na=rtpmap:119 rtx/90000\r\na=fmtp:119 apt=124\r\na=rtpmap:123 H264/90000\r\na=rtcp-fb:123 goog-remb\r\na=rtcp-fb:123 transport-cc\r\na=rtcp-fb:123 ccm fir\r\na=rtcp-fb:123 nack\r\na=rtcp-fb:123 nack pli\r\na=fmtp:123 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=640032\r\na=rtpmap:118 rtx/90000\r\na=fmtp:118 apt=123\r\na=rtpmap:114 red/90000\r\na=rtpmap:115 rtx/90000\r\na=fmtp:115 apt=114\r\na=rtpmap:116 ulpfec/90000\r\na=ssrc-group:FID 1050208032 2380405351\r\na=ssrc:1050208032 cname:qNTVbiiB/IVZdQVP\r\na=ssrc:1050208032 msid:- 8558a423-0a0d-44ed-9bb4-488501cfa877\r\na=ssrc:1050208032 mslabel:-\r\na=ssrc:1050208032 label:8558a423-0a0d-44ed-9bb4-488501cfa877\r\na=ssrc:2380405351 cname:qNTVbiiB/IVZdQVP\r\na=ssrc:2380405351 msid:- 8558a423-0a0d-44ed-9bb4-488501cfa877\r\na=ssrc:2380405351 mslabel:-\r\na=ssrc:2380405351 label:8558a423-0a0d-44ed-9bb4-488501cfa877\r\n"
        ]

        /// last / must by add. when you not like this, please change srs source.
        let urlStr = AppConfig.publishLocalHostURLStr
        
        /// Content-Type is "application/json"
        AFDisableSSL.request(urlStr, method: .post, parameters: dic as Parameters, encoding: JSONEncoding.default, headers: nil).response { response in
            debugPrint(response)
        }
        
    }
    
    class func testAPIOne() {
        let dic = [
            "api": AppConfig.publishLocalHostURLStr,
            "tid": "5940a1d",
            "streamurl": AppConfig.localHostStreamURLStr,
            "clientip": nil,
            "sdp": "sdp"
        ]
        let urlStr = AppConfig.publishLocalHostURLStr
        /// Content-Type is  "application/json"
        AFDisableSSL.request(urlStr, method: .post, parameters: dic as Parameters, encoding: JSONEncoding.default, headers: nil).response { response in
            debugPrint(response)
        }
    }
    
}

extension AlamofireAPIUtils {
    
    class func testNetwork() {
        let urlStr = AppConfig.checkNetWorkURLStr
        AF.request(urlStr, method: .get, parameters: nil).response { response in
            let statusCode = response.response?.statusCode ?? -1
            let str = "http response statusCode \(statusCode)"
            appKeyWindow()?.makeToast(str)
        }
    }
    
}

