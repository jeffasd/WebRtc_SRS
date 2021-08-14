//
//  InputView.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit

class InputView: UIControl {

    fileprivate var publishLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.text = "publish"
        view.textAlignment = .left
        view.textColor = .black
        view.font = .systemFont(ofSize: 16)
        view.backgroundColor = .lightGray
        return view
    }()
    
    var changePublishSDPTextView: UITextView = {
        let view = UITextView()
        view.isHidden = true
        view.textAlignment = .left
        view.textColor = .black
        view.font = .systemFont(ofSize: 16)
        view.backgroundColor = .lightGray
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    fileprivate var playLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.text = "play"
        view.textAlignment = .left
        view.textColor = .black
        view.font = .systemFont(ofSize: 16)
        view.backgroundColor = .lightGray
        return view
    }()
    
    var changePlaySDPTextView: UITextView = {
        let view = UITextView()
        view.isHidden = true
        view.textAlignment = .left
        view.textColor = .black
        view.font = .systemFont(ofSize: 16)
        view.backgroundColor = .lightGray
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    fileprivate var publishStreamURLLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.text = "publish stream"
        view.textAlignment = .left
        view.textColor = .black
        view.font = .systemFont(ofSize: 16)
        view.backgroundColor = .lightGray
        return view
    }()
    
    var publishStreamURLTextView: UITextView = {
        let view = UITextView()
        view.isHidden = true
        view.textAlignment = .left
        view.textColor = .black
        view.adjustsFontForContentSizeCategory = true
        view.font = .systemFont(ofSize: 16)
        view.backgroundColor = .lightGray
        return view
    }()
    
    fileprivate var playStreamURLLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.text = "play stream"
        view.textAlignment = .left
        view.textColor = .black
        view.font = .systemFont(ofSize: 16)
        view.backgroundColor = .lightGray
        return view
    }()
    
    var playStreamURLTextView: UITextView = {
        let view = UITextView()
        view.isHidden = true
        view.textAlignment = .left
        view.textColor = .black
        view.adjustsFontForContentSizeCategory = true
        view.font = .systemFont(ofSize: 16)
        view.backgroundColor = .lightGray
        return view
    }()

    fileprivate lazy var changeBtn: UIButton = {
        let view = UIButton.init(type: .custom)
        view.isHidden = true
        view.backgroundColor = .lightGray
        view.setTitle("change", for: .normal)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(changeBtnAction(sender:)), for: .touchUpInside)
        return view
    }()
    
    lazy var publishBtn: UIButton = {
        let view = UIButton.init(type: .custom)
        view.isHidden = true
        view.backgroundColor = .lightGray
        view.setTitle("publish", for: .normal)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.setTitleColor(.white, for: .normal)
        return view
    }()
    
    lazy var playBtn: UIButton = {
        let view = UIButton.init(type: .custom)
        view.isHidden = true
        view.backgroundColor = .lightGray
        view.setTitle("play", for: .normal)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var publishPlayBtn: UIButton = {
        let view = UIButton.init(type: .custom)
        view.isHidden = true
        view.backgroundColor = .lightGray
        view.setTitle("publish & Play", for: .normal)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.setTitleColor(.white, for: .normal)
        return view
    }()
    
    deinit {
        debug_log("TestInputView deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
}

fileprivate extension InputView {
    
    func setupUI() {
        addTarget(self, action: #selector(touchAction(sender:)), for: .touchUpInside)
        addSubview(publishLabel)
        addSubview(changePublishSDPTextView)
        addSubview(playLabel)
        addSubview(changePlaySDPTextView)
        addSubview(publishStreamURLLabel)
        addSubview(publishStreamURLTextView)
        addSubview(playStreamURLLabel)
        addSubview(playStreamURLTextView)
        publishLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(26)
        }
        changePublishSDPTextView.snp.makeConstraints { (make) in
            make.left.equalTo(publishLabel.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(publishLabel)
            make.height.equalTo(26 * 2)
        }
        playLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(changePublishSDPTextView.snp.bottom).offset(8)
            make.height.equalTo(26)
        }
        changePlaySDPTextView.snp.makeConstraints { (make) in
            make.left.equalTo(playLabel.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(playLabel)
            make.height.equalTo(26 * 2)
        }
        publishStreamURLLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(changePlaySDPTextView.snp.bottom).offset(8)
            make.height.equalTo(26)
        }
        publishStreamURLTextView.snp.makeConstraints { (make) in
            make.left.equalTo(publishStreamURLLabel.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(publishStreamURLLabel)
            make.height.equalTo(26 * 2)
        }
        playStreamURLLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(publishStreamURLTextView.snp.bottom).offset(8)
            make.height.equalTo(26)
        }
        playStreamURLTextView.snp.makeConstraints { (make) in
            make.left.equalTo(playStreamURLLabel.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(playStreamURLLabel)
            make.height.equalTo(26 * 2)
        }
        
        addSubview(changeBtn)
        addSubview(publishBtn)
        addSubview(playBtn)
        addSubview(publishPlayBtn)
        let width = UIScreen.main.bounds.width
        changeBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(0)
            make.width.equalTo(64)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-160 - 90)
        }
        publishBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-width/5)
            make.width.equalTo(64)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-160)
        }
        playBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(width/5)
            make.width.equalTo(64)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-160)
        }
        publishPlayBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(0)
            make.width.equalTo(64 * 2)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-160)
        }
        /// localhostServer()
        remoteServer()
    }
    
    func localhostServer() {
        changePublishSDPTextView.text = AppConfig.publishLocalHostURLStr
        handlePlayURLAndStreamURL()
    }
    
    func remoteServer() {
        changePublishSDPTextView.text = AppConfig.publishRemoteURLStr
        handlePlayURLAndStreamURL()
    }

    func handlePlayURLAndStreamURL() {
        let url = URL.init(string: changePublishSDPTextView.text)
        if let host = url?.host, let port = url?.port {
            let str = "https://\(host):\(port)/rtc/v1/play/"
            debug_log("str: \(str)")
            changePlaySDPTextView.text = str
        }else {
            changePlaySDPTextView.text = AppConfig.playLocalHostURLStr
        }
        if let host = url?.host {
            let str = "webrtc://\(host)/\(AppConfig.appName)/\(AppConfig.streamName)"
            debug_log("str: \(str)")
            publishStreamURLTextView.text = str
            playStreamURLTextView.text = str
        }else {
            publishStreamURLTextView.text = AppConfig.localHostStreamURLStr
            playStreamURLTextView.text = AppConfig.localHostStreamURLStr
        }
    }
    
}

extension InputView {
    
    @objc
    fileprivate func touchAction(sender: UIControl?) {
        changePublishSDPTextView.resignFirstResponder()
        changePlaySDPTextView.resignFirstResponder()
        publishStreamURLTextView.resignFirstResponder()
        playStreamURLTextView.resignFirstResponder()
    }
    
    @objc
    fileprivate func changeBtnAction(sender: UIButton?) {
        changePublishPlayStyle()
    }
    
}

extension InputView {
    
    func publishStyle() {
        publishLabel.isHidden = false
        changePublishSDPTextView.isHidden = false
        publishStreamURLLabel.isHidden = false
        publishStreamURLTextView.isHidden = false
        publishBtn.isHidden = false
        publishBtn.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview().offset(0)
        }
    }
    
    func playStyle() {
        playLabel.isHidden = false
        changePlaySDPTextView.isHidden = false
        playStreamURLLabel.isHidden = false
        playStreamURLTextView.isHidden = false
        playBtn.isHidden = false
        playBtn.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview().offset(0)
        }
    }
    
    func publishPlayStyle() {
        publishStyle()
        playStyle()
        publishBtn.isHidden = true
        playBtn.isHidden = true
        changeBtn.isHidden = false
        publishPlayBtn.isHidden = false
        let text = publishStreamURLTextView.text ?? ""
        publishStreamURLTextView.text = text + "_publish"
        playStreamURLTextView.text = text + "_play"
    }
    
    fileprivate func changePublishPlayStyle() {
        publishPlayStyle()
        let text = publishStreamURLTextView.text ?? ""
        let sub: [Substring] = text.split(separator: "_")
        guard sub.count >= 2 else { return }
        let _text = sub.first ?? ""
        if sub[1] == "publish" {
            publishStreamURLTextView.text = _text + "_play"
            playStreamURLTextView.text = _text + "_publish"
        }else {
            publishStreamURLTextView.text = _text + "_publish"
            playStreamURLTextView.text = _text + "_play"
        }
    }
    
}
