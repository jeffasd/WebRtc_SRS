//
//  DelayRetryAction.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit

class DelayRetryAction: NSObject {

    static let shared = DelayRetryAction()
    
}

extension DelayRetryAction {
    
    func delay30sRetry(btn: UIButton?) {
        guard let btn = btn else { return }
        var delayTime: Int = 30
        let timer = Timer.init(timeInterval: 1, repeats: true) { (t) in
            delayTime = delayTime - 1
            btn.setTitle("\(delayTime)s Retry", for: .normal)
            if delayTime <= 0 {
                t.invalidate()
                btn.sendActions(for: .touchUpInside)
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
}
