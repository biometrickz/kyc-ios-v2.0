//
//  BiometricKYSViewController.swift
//  BiometricKYS
//
//  Created by Tanirbergen Kaldibai on 13.08.2023.
//

import UIKit
import WebKit

open class BiometricKYSViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: UIScreen.main.bounds, configuration: config)
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        return webView
    }()
    
    // MARK: - Set Api Key For Session
    
    public var session_api_key: String = "Pmm9egy6QqachL3Flw3KfzT6e-8_EKJ_JWm_3Kh83DfRpqg"
    
    // MARK: - Network Manager
    
    private var networkManager: NetworkManager = NetworkManagerImpl()
    
    // MARK: - Props
    private var url = "https://kyc.biometric.kz"
    
    open override func loadView() {
        super.loadView()
        setupNetworkDetails()
        
        // * Ban screen
        
        view.hideContentOnScreenCapture()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let key = change?[NSKeyValueChangeKey.newKey]
        let actionURL = String(describing: key)
        
        if actionURL.contains("finished") {
            /// need to end session.
            
            dismiss(animated: true)
        }
    }
}

private extension BiometricKYSViewController {
    
    func setupNetworkDetails() {
        networkManager.delegate = self
        networkManager.createSession(with: session_api_key)
    }
    
    func configureSubviews() {
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Biometric Request Delegate

extension BiometricKYSViewController: DidObserveSession {
    func didSetSessionToken(session: BiometricResponseModel) {
        makeWebViewDetails(sessionID: session.session_id)
    }
    
    func makeWebViewDetails(sessionID: String) {
        let url = "\(BiometricConstants.createSpace)\(sessionID)?web_view=true"
        guard let url = URL(string: url) else { return }
    
        webView.load(URLRequest(url: url))
    }
}
