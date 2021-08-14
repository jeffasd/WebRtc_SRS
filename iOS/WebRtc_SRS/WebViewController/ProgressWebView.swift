//
//  ProgressWebView.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit
import WebKit

fileprivate let estimatedProgressKeyPath = "estimatedProgress"
fileprivate let titleKeyPath = "title"

extension ProgressWebView {
    
    class func cleanWkWebViewAllCache() {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let dateFrom = Date.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
            /// do nothing.
        }
    }
    
}

class ProgressWebView: UIView {
    
    @objc var urlStr: String? {
        didSet {
            guard let innerStr = urlStr else { return }
            guard let innerUrl = URL.init(string: innerStr) else { return }
            if innerUrl.isFileURL {
                webView?.loadFileURL(innerUrl, allowingReadAccessTo: innerUrl)
            }else {
                let request = URLRequest.init(url: innerUrl, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 15.0)
                webView?.load(request)
            }
        }
    }
    
    fileprivate final class _WkWebView: WKWebView {
        override var safeAreaInsets: UIEdgeInsets { .zero }
    }
    
    fileprivate lazy var webView: _WkWebView? = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = .all
        let view = _WkWebView(frame: CGRect.zero, configuration: config)
        view.scrollView.contentInsetAdjustmentBehavior = .never
        view.scrollView.bounces = false
        view.isOpaque = false
        view.backgroundColor = .white
        view.addObserver(self, forKeyPath: estimatedProgressKeyPath, options: .new, context: nil)
        view.addObserver(self, forKeyPath: titleKeyPath, options: .new, context: nil)
        view.navigationDelegate = self
        return view
    }()
    
    lazy fileprivate var progressView: UIProgressView = {
         let progressView = UIProgressView(progressViewStyle: .default)
        progressView.isUserInteractionEnabled = false
        progressView.alpha = 1
        progressView.trackTintColor = UIColor(white: 1, alpha: 0)
        return progressView
    }()
    
    deinit {
        webView?.stopLoading()
        webView?.navigationDelegate = nil
        webView?.scrollView.delegate = nil
        webView = nil
        debug_log("ProgressWebView deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        webView?.frame = bounds
        layoutProgressViewHeightTo(height: 2)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case estimatedProgressKeyPath?:
            let estimatedProgress = webView?.estimatedProgress ?? 0
            
            progressView.alpha = 1
            progressView.setProgress(Float(estimatedProgress), animated: true)
            
            if estimatedProgress >= 0.98 {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                    self.webView?.backgroundColor = .clear
                }, completion: nil)
            }
            
        case titleKeyPath?:
            let title = webView?.title ?? ""
            debug_log("titleKeyPath title:\(String(describing: title))")
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

fileprivate extension ProgressWebView {
    
    func setupUI() {
        if let webView = webView {
            addSubview(webView)
        }
        addSubview(progressView)
    }
    
    func layoutProgressViewHeightTo(height: CGFloat) {
        let defaultHeight = UIProgressView(progressViewStyle: .default).frame.height
        progressView.transform = CGAffineTransform.identity
        progressView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: defaultHeight)
        let scale = height / defaultHeight
        let transform = CGAffineTransform.identity.scaledBy(x: 1, y: scale)
        progressView.transform = transform
        let y = defaultHeight * scale / 2
        progressView.center = CGPoint.init(x: frame.size.width/2, y: y)
    }
    
}

// MARK: - WKNavigationDelegate

extension ProgressWebView: WKNavigationDelegate {
    
    /// Whether the web page can be accessed.
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else { return }
        let scheme = url.scheme
        if scheme != "http", scheme != "https", scheme != "file" {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    /// web load finish call back.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { (ret, error) in
            if let retStr = ret as? String {
                debug_log("retStr:\(retStr)")
            }
        }
        // autoplay
        webView.evaluateJavaScript("androidready()", completionHandler: nil)
    }
    
}

extension ProgressWebView: NSURLConnectionDelegate {
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let card = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,card)
        }
    }
    
}


