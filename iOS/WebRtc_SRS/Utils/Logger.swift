//
//  Logger.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit

func debug_log<T>(_ msg: T,
                file: NSString = #file,
                line: Int = #line,
                fn: String = #function) {
#if DEBUG
    let prefix = "==> {class: \(file.lastPathComponent) function: \(fn) line: \(line)}"
    print(prefix, msg)
#endif
}

/**
@inline(never)
func debug_log(_ items: Any...,
               file: NSString = #file,
               line: Int = #line,
               fn: String = #function) {
#if DEBUG
    print(items)
#endif
}
 */
 
