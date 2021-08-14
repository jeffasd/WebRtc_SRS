//
//  MainViewController.swift
//  WebRtc_SRS
//
//  Created by jeffasd on 2021/3/14.
//

import UIKit
import Toast_Swift
import AVFoundation
import SafariServices

extension MainViewController: SelfAware {
    
    static func awake() {
        let naBar = UINavigationBar.appearance()
        naBar.isTranslucent = true
        naBar.setBackgroundImage(UIImage(), for: .default)
        naBar.shadowImage = UIImage()
        
        ToastManager.shared.position = .center
        ToastManager.shared.isTapToDismissEnabled = false
        ToastManager.shared.isQueueEnabled = true
    }
    
}

class MainViewController: UIViewController {
    
    fileprivate struct ReuseIdentifiers {
        static let exampleCellId = "exampleCell"
    }
    
    fileprivate lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.exampleCellId)
        view.tableFooterView = UIView()
        return view
    }()
    
    // MARK: - Constructors
    
    deinit {
        debug_log("MainViewController deinit")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Examples"
        UIApplication.shared.isIdleTimerDisabled = true
        setupUI()
    }
    
    // MARK: - Events
    
    @objc
    private func handleTapToDismissToggled() {
        ToastManager.shared.isTapToDismissEnabled = !ToastManager.shared.isTapToDismissEnabled
    }
    
    @objc
    private func handleQueueToggled() {
        ToastManager.shared.isQueueEnabled = !ToastManager.shared.isQueueEnabled
    }
}

fileprivate extension MainViewController {
    
    func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

fileprivate extension MainViewController {
    
    func checkNetwork() {
        AlamofireAPIUtils.testNetwork()
    }
    
    func checkAudioAuthorization() {
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { (allowed) in
            DispatchQueue.main.async {
                let str = allowed ? "audio suc" : "failed"
                appKeyWindow()?.makeToast(str)
            }
        }
    }
    
    func checkVideoAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == AVAuthorizationStatus.restricted || status == AVAuthorizationStatus.denied {
            appKeyWindow()?.makeToast("failed")
        }else{
            appKeyWindow()?.makeToast("camera suc")
        }
    }
    
    func handleWkWebViewPublish() {
        let progressWebVC = ProgressWebViewController()
        progressWebVC.urlStr = AppConfig.publishWebURLStr
        navigationController?.pushViewController(progressWebVC, animated: true)
    }
    func handleWkWebViewPlay() {
        let progressWebVC = ProgressWebViewController()
        progressWebVC.urlStr = AppConfig.playWebURLStr
        navigationController?.pushViewController(progressWebVC, animated: true)
    }
    
    func handleSFSafariViewControllerPublish() {
        if let safariVC = createSFSafariViewController(urlStr: AppConfig.publishWebURLStr) {
            navigationController?.pushViewController(safariVC, animated: true)
        }
    }
    
    func handleSFSafariViewControllerPlay() {
        if let safariVC = createSFSafariViewController(urlStr: AppConfig.playWebURLStr) {
            navigationController?.pushViewController(safariVC, animated: true)
        }
    }
    
    func createSFSafariViewController(urlStr: String?) -> SFSafariViewController? {
        guard let urlStr = urlStr else { return nil }
        guard let url = URL.init(string: urlStr) else { return nil }
        let vc = SFSafariViewController.init(url: url)
        return vc
    }
    
}

// MARK: - UITableViewDelegate & DataSource Methods

extension MainViewController: UITableViewDelegate & UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.exampleCellId, for: indexPath)
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.accessoryType = .none
            cell.textLabel?.text = "Check Network"
        case 1:
            cell.accessoryType = .none
            cell.textLabel?.text = "Check Audio Authorization"
        case 2:
            cell.accessoryType = .none
            cell.textLabel?.text = "Check Video Authorization"
        case 3: cell.textLabel?.text = "Native Publish"
        case 4: cell.textLabel?.text = "Native Play"
        case 5: cell.textLabel?.text = "Native (Publish & Play)"
        case 6: cell.textLabel?.text = "WKWebView Publish"
        case 7: cell.textLabel?.text = "WKWebView Play"
        case 8: cell.textLabel?.text = "SFSafariViewController Publish"
        case 9: cell.textLabel?.text = "SFSafariViewController Play"
        default: cell.textLabel?.text = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            checkNetwork()
        case 1:
            checkAudioAuthorization()
        case 2:
            checkVideoAuthorization()
        case 3:
            let inputVC = InputViewController()
            inputVC.textInputView.publishStyle()
            navigationController?.pushViewController(inputVC, animated: true)
        case 4:
            let inputVC = InputViewController()
            inputVC.textInputView.playStyle()
            navigationController?.pushViewController(inputVC, animated: true)
        case 5:
            let inputVC = InputViewController()
            inputVC.textInputView.publishPlayStyle()
            navigationController?.pushViewController(inputVC, animated: true)
        case 6:
            handleWkWebViewPublish()
        case 7:
            handleWkWebViewPlay()
        case 8:
            handleSFSafariViewControllerPublish()
        case 9:
            handleSFSafariViewControllerPlay()
        default:
            break
        }
    }
}


