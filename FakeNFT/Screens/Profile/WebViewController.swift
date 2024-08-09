//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 09.08.2024.
//  
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private var webView: WKWebView!
    private var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
