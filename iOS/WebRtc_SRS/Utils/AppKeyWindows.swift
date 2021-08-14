//
//  AppKeyWindows.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit

func appKeyWindow() -> UIWindow? {
    var keyWin: UIWindow? = nil
    for scene in UIApplication.shared.connectedScenes {
        if let s = scene as? UIWindowScene {
            if s.activationState != .unattached {
                keyWin = s.windows.first
                break
            }
        }
    }
    if keyWin == nil {
        keyWin = UIApplication.shared.windows.first
    }
    return keyWin
}
