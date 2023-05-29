//
//  WebViewController.swift
//  IMKitWebchatDemoApp
//
//  Created by Howard Sun on 2023/5/28.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: URL?
    
    init(roomId: String, token: String) {
        super.init(nibName: nil, bundle: nil)
        url = URL(string: "https://imkit-vue-sdk.web.app/#/?roomId=\(roomId)&token=\(token)")
        print(url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
}
