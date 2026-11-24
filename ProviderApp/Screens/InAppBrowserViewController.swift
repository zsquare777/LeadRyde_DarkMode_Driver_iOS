//
//  InAppBrowserViewController.swift
//  UserApp
//
//  Created by Suleman Hassan on 06/05/2026.
//


import UIKit
import WebKit

class InAppBrowserViewController: UIViewController {
    
    private let url: String
    private var webView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView!
    
    let generalFunc = GeneralFunctions()
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = self.generalFunc.getLanguageLabel(origValue: "Terms & Conditions", key: "LBL_TERMS_CONDITIONS_TEXT")
        view.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.UCAColor.AppThemeColor
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
           
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .done,
            target: self,
            action: #selector(closeTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        // WebView
        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
          
        }
        activityIndicator.center = view.center
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        loadURL()
    }
    
    private func loadURL() {
        if let validUrl = URL(string: url) {
            activityIndicator.startAnimating()
            webView.load(URLRequest(url: validUrl))
        }
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

// MARK: - WKNavigationDelegate
extension InAppBrowserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadURL()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}

