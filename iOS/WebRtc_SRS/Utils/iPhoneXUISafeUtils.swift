//
//  iPhoneXUISafeUtils.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit

/// iPhonex design guide
/// status-bar: 44
/// safe-area-inset-top: 88
/// safe_area-inset-bottom: 34

let k_BottomToolBarDefaultHeight: CGFloat = 49

func iPhoneXStatusBarmHeight() -> CGFloat {
    return 44
}

func iPhoneXSafeAreaInsetTopHeight() -> CGFloat {
    return 88
}

func iPhoneXSafeAreaInsetBottomHeight() -> CGFloat {
    return 34
}

func safeAreaTop() -> CGFloat {
    if #available(iOS 11.0, *) {
        /// SafeAreainsets. top is 20.0 for non-fringe phones after iOS 12.0
        /// SafeAreainSets. top is 0.0 for non-fringe phones before iOS 12.0.
        /// So judge the bottom height first.
        if safeAreaBottom() == 0 {
            return 20.0
        }
        return (appKeyWindow()?.safeAreaInsets.top) ?? 20.0
    }
    return 20.0
}

func safeAreaBottom() -> CGFloat {
    if #available(iOS 11.0, *) {
        return (appKeyWindow()?.safeAreaInsets.bottom) ?? 0
    }
    return 0
}

func hasSafeArea() -> Bool {
    if #available(iOS 11.0, *) {
        return safeAreaBottom() > 0
    } else { return false }
}

func toolBarSafeHeight() -> CGFloat {
    return k_BottomToolBarDefaultHeight + safeAreaBottom()
}

func navigationSafeHeight() -> CGFloat {
    return 44 + safeAreaTop()
}

func isiPhoneXSerial() -> Bool {
    return hasSafeArea()
}

