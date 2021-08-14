//
//  InputViewController.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit

class InputViewController: UIViewController {

    var textInputView: InputView = {
        let view = InputView()
        return view
    }()
    
    deinit {
        debug_log("TestInputViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

fileprivate extension InputViewController {
    
    func setupUI() {
        textInputView.publishBtn.addTarget(self, action: #selector(publishBtnAction(sender:)), for: .touchUpInside)
        textInputView.playBtn.addTarget(self, action: #selector(playBtnAction(sender:)), for: .touchUpInside)
        textInputView.publishPlayBtn.addTarget(self, action: #selector(publishPlayBtnAction(sender:)), for: .touchUpInside)
        view.backgroundColor = .white
        view.addSubview(textInputView)
        textInputView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension InputViewController {
    
    @objc
    fileprivate func publishBtnAction(sender: UIButton?) {
        let vc = PublishViewController()
        let urlStr = textInputView.changePublishSDPTextView.text
        let streamUrl = textInputView.publishStreamURLTextView.text
        vc.urlStr = urlStr
        vc.streamUrl = streamUrl
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    fileprivate func playBtnAction(sender: UIButton?) {
        let vc = PlayViewController()
        let urlStr = textInputView.changePlaySDPTextView.text
        let streamUrl = textInputView.playStreamURLTextView.text
        vc.urlStr = urlStr
        vc.streamUrl = streamUrl
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    fileprivate func publishPlayBtnAction(sender: UIButton?) {
        let vc = PublishPlayViewController()
        let publishUrlStr = textInputView.changePublishSDPTextView.text
        let publishStreamUrl = textInputView.publishStreamURLTextView.text
        let playUrlStr = textInputView.changePlaySDPTextView.text
        let playStreamUrl = textInputView.playStreamURLTextView.text
        vc.publishUrlStr = publishUrlStr
        vc.publishStreamUrl = publishStreamUrl
        vc.playUrlStr = playUrlStr
        vc.playStreamUrl = playStreamUrl
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
