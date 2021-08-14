//
//  ProgressWebViewController.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit

class ProgressWebViewController: UIViewController {

    var urlStr: String? {
        didSet {
            webView.urlStr = urlStr
        }
    }
    
    fileprivate lazy var webView: ProgressWebView = {
        let view = ProgressWebView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

fileprivate extension ProgressWebViewController {
    
    func setupUI() {
        view.backgroundColor = .lightGray
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(navigationSafeHeight())
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
}
