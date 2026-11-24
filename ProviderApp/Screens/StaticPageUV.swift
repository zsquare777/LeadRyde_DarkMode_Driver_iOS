////
////  AboutUsUV.swift
////  DriverApp
////
////  Created by ADMIN on 13/05/17.
////  Copyright © 2017 @. All rights reserved.
////
//
//import UIKit
//import WebKit
//
//class StaticPageUV: UIViewController, WKNavigationDelegate {
//
//    @IBOutlet weak var contentView: UIView!
//    
//    var webView = WKWebView()
//    let generalFunc = GeneralFunctions()
//    
//    var loaderView:UIView!
//    
//    var STATIC_PAGE_ID = "1"
//    var chatURL = ""
//    var viewProfileUV : ViewProfileUV!
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.configureRTLView()
//        
//        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.contentView.addSubview(self.generalFunc.loadView(nibName: "StaticPageScreenDesign", uv: self, contentView: contentView))
//        self.addBackBarBtn()
//        setData()
//        
//       loaderView =  self.generalFunc.addMDloader(contentView: self.view)
//       loaderView.backgroundColor = UIColor.clear
//        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        self.webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.size.width , height: self.contentView.frame.size.height))
//        self.webView.navigationDelegate = self
//        self.webView.backgroundColor = UIColor.white
//        self.contentView.addSubview(self.webView)
//        self.webView.scrollView.bounces = false
//        
//        
//        if(STATIC_PAGE_ID == "5"){ /* tawk.to chat Addon changes */
//            self.webView.load(URLRequest(url: URL(string: chatURL)!))
//        }else if(STATIC_PAGE_ID == "6"){ /* stripe connect Addon changes */
//            getStripeConnectData()
//        }else{
//            getAboutUsPageData()
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func setData(){
//        if(STATIC_PAGE_ID == "1"){
//            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ABOUT_US_HEADER_TXT")
//            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ABOUT_US_HEADER_TXT")
//        }else if(STATIC_PAGE_ID == "64"){
//            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRIVACY_POLICY_TEXT")
//            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRIVACY_POLICY_TEXT")
//        }else if(STATIC_PAGE_ID == "63"){
//            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_AND_CONDITION")
//            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_AND_CONDITION")
//        }else if(STATIC_PAGE_ID == "5"){
//            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LIVE_CHAT")
//            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LIVE_CHAT")
//        }else if(STATIC_PAGE_ID == "6"){
//            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STRIPE_CONNECT")
//            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STRIPE_CONNECT")
//        }else{
//            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DETAILS")
//            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DETAILS")
//        }
//    }
//    
//    func getStripeConnectData(){
//        let parameters = ["type":"CreateStripeConnectAccount", "UserType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd()]
//        
//        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
//        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
//            
//            let dataDict = response.getJsonDataDict()
//            
//            if(response != ""){
//                if(dataDict.get("message") == "LBL_STRIPE_CONNECT_ACCOUNT_CREATED"){
//                    self.loaderView.isHidden = true
//                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STRIPE_CONNECT_ACCOUNT_CREATED"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "") { (btnClickedIndex) in
//                        self.closeCurrentScreen()
//                    }
//                    return
//                }
//                self.webView.load(URLRequest(url: URL(string: dataDict.get("message"))!))
//                self.webView.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
//            }else{
//                self.generalFunc.setError(uv: self)
//            }
//            
//            self.loaderView.isHidden = true
//        })
//    }
//    
//    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
//        print(error.localizedDescription)
//    }
//    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
//        if let urlString = navigationAction.request.url?.absoluteString{
//            
//            if (urlString.contains(find: "success=1")){
//                self.loaderView.isHidden = true
//                
//                self.navigationItem.setHidesBackButton(true, animated:false);
//                self.view.isUserInteractionEnabled = false
//                UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
//                self.viewProfileUV.showSuccess()
//                self.closeCurrentScreen()
//            }else if (urlString.contains(find: "success=0")){
//                self.loaderView.isHidden = true
//                
//                self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST_FAILED_PROCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
//                    
//                    UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
//                    self.closeCurrentScreen()
//                })
//            }else{
//                self.loaderView.isHidden = true
//            }
//        }
//        decisionHandler(.allow)
//    }
//    
//
//    func getAboutUsPageData(){
//        
//        let parameters = ["type":"staticPage","iPageId": STATIC_PAGE_ID, "appType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "vLangCode": (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil ? "" : (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String))]
//        
//        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
//        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
//            
//            if(response != ""){
//                let dataDict = response.getJsonDataDict()
//                
//                let page_desc = dataDict.get("page_desc")
//                let content = page_desc.replace("\n", withString: "<br>")
//                
//               let stringFormat = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
//               
//               if(Configurations.isRTLMode()){
//                   self.webView.loadHTMLString(stringFormat + "<html dir=\"rtl\"><body><h1 id=h101>\("")</h1><p id=p01>\(content)</p></body></html>", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "font", ofType: "css")!))
//               }else{
//                   self.webView.loadHTMLString(stringFormat + "<html><body><h1 id=h101>\("")</h1><p id=p01><span>\(content)</span></p></body></html>", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "font", ofType: "css")!))
//               }
//                
//                self.webView.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
//                
//            }else{
//                self.generalFunc.setError(uv: self)
//            }
//            
//            self.loaderView.isHidden = true
//        })
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let javascriptStyle = "var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}'; var head = document.head || document.getElementsByTagName('head')[0]; var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); head.appendChild(style);"
//        webView.evaluateJavaScript(javascriptStyle, completionHandler: nil)
//    }
//    
//}

//
//  AboutUsUV.swift
//  DriverApp
//
//  Created by ADMIN on 13/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import WebKit

class StaticPageUV: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    var webView = WKWebView()
    let generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    
    var STATIC_PAGE_ID = "1"
    var fromDialog = "no"
    
    var chatURL = ""
    var viewProfileUV : ViewProfileUV!
    
    // NEW: Programmatic "Agree to Terms" UI
    var agreeContainerView: UIView!
    var checkBoxBtn: UIButton!
    var checkMarkLbl: UILabel!
    var agreeMessageLbl: UILabel!
    var agreeBtn: UIButton!
    var isTermsAgreed: Bool = false
    
    var agreeBtnHeightConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "StaticPageScreenDesign", uv: self, contentView: contentView))
        self.addBackBarBtn()
        setData()
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
        // NEW: Build the agree UI only for Terms & Conditions page
        if(STATIC_PAGE_ID == "63" && fromDialog == "yes"){
            setupAgreeView()
        }
        
        // Apply initial theme
        applyTheme()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func themeDidChange() {
        applyTheme()
    }
    
    func applyTheme() {
        let themeManager = ThemeManager.shared
        
        // Update main view backgrounds
        self.view.backgroundColor = themeManager.backgroundColor()
        self.contentView.backgroundColor = themeManager.backgroundColor()
        
        // Update WebView background
        if self.webView != nil {
            self.webView.backgroundColor = themeManager.cardBackgroundColor()
            self.webView.isOpaque = false
            
            // Update WebView content styling based on theme
            let cssString: String
            if themeManager.isDarkModeActive {
                cssString = """
                    body { 
                        background-color: #2C2C2E !important; 
                        color: #FFFFFF !important; 
                    }
                    p, div, span, h1, h2, h3, h4, h5, h6 { 
                        color: #FFFFFF !important; 
                    }
                    a { 
                        color: #0A84FF !important; 
                    }
                """
            } else {
                cssString = """
                    body { 
                        background-color: #FFFFFF !important; 
                        color: #000000 !important; 
                    }
                """
            }
            
            let jsString = """
                var style = document.createElement('style');
                style.innerHTML = '\(cssString)';
                document.head.appendChild(style);
            """
            
            self.webView.evaluateJavaScript(jsString, completionHandler: nil)
        }
        
        // Update agree container background if it exists
        if let agreeContainer = self.agreeContainerView {
            agreeContainer.backgroundColor = themeManager.cardBackgroundColor()
        }
        
        if let agreeLabel = self.agreeMessageLbl {
            agreeLabel.textColor = themeManager.textColor()
        }
        
        print("✅ StaticPageUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        fromDialog = "no"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // NEW: reduce webView height using the ACTUAL laid-out container height
        self.view.layoutIfNeeded()
        let bottomInset: CGFloat = (STATIC_PAGE_ID == "63" && self.agreeContainerView != nil) ? self.agreeContainerView.frame.size.height : 0
        
        // Configure WKWebView with proper settings for external URLs
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        if #available(iOS 14.0, *) {
            webConfiguration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            webConfiguration.preferences.javaScriptEnabled = true
        }
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.size.width , height: self.contentView.frame.size.height - bottomInset), configuration: webConfiguration)
        self.webView.navigationDelegate = self
        self.webView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.webView)
        self.webView.scrollView.bounces = false
        
        // NEW: keep agree container above the webView
        if(STATIC_PAGE_ID == "63" && self.agreeContainerView != nil){
            self.view.bringSubviewToFront(self.agreeContainerView)
        }
        
        if(STATIC_PAGE_ID == "5"){ /* tawk.to chat Addon changes */
            self.webView.load(URLRequest(url: URL(string: chatURL)!))
        }else if(STATIC_PAGE_ID == "6"){ /* stripe connect Addon changes */
            getStripeConnectData()
        }else{
            getAboutUsPageData()
        }
        
        // Apply theme after webView is created
        applyTheme()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        if(STATIC_PAGE_ID == "1"){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ABOUT_US_HEADER_TXT")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ABOUT_US_HEADER_TXT")
        }else if(STATIC_PAGE_ID == "64"){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRIVACY_POLICY_TEXT")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRIVACY_POLICY_TEXT")
        }else if(STATIC_PAGE_ID == "63"){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_AND_CONDITION")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_AND_CONDITION")
        }else if(STATIC_PAGE_ID == "5"){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LIVE_CHAT")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LIVE_CHAT")
        }else if(STATIC_PAGE_ID == "6"){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STRIPE_CONNECT")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STRIPE_CONNECT")
        }else{
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DETAILS")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DETAILS")
        }
    }
    
    func getStripeConnectData(){
        print("📞 Calling Stripe Connect API...")
        let parameters = ["type":"CreateStripeConnectAccount", "UserType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            print("📥 Received response from server")
            let dataDict = response.getJsonDataDict()
            
            if(response != ""){
                print("✅ Response is not empty")
                
                if(dataDict.get("message") == "LBL_STRIPE_CONNECT_ACCOUNT_CREATED"){
                    print("ℹ️ Account already created")
                    DispatchQueue.main.async {
                        self.loaderView.isHidden = true
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STRIPE_CONNECT_ACCOUNT_CREATED"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "") { (btnClickedIndex) in
                            self.closeCurrentScreen()
                        }
                    }
                    return
                }
                
                let urlString = dataDict.get("message")
                print("🔗 Stripe Connect URL: \(urlString)")
                
                if let url = URL(string: urlString) {
                    print("✅ URL is valid")
                    DispatchQueue.main.async {
                        print("📲 Loading URL in WebView on main thread...")
                        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
                        self.webView.load(request)
                        self.webView.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
                        print("✅ WebView load() called")
                    }
                } else {
                    print("❌ Invalid URL: \(urlString)")
                    DispatchQueue.main.async {
                        self.loaderView.isHidden = true
                        self.generalFunc.setError(uv: self, title: "", content: "Invalid URL received from server")
                    }
                }
            }else{
                print("❌ Response is empty")
                DispatchQueue.main.async {
                    self.generalFunc.setError(uv: self)
                    self.loaderView.isHidden = true
                }
            }
        })
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("🌐 WebView started loading")
        self.loaderView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("❌ WebView failed to load: \(error.localizedDescription)")
        self.loaderView.isHidden = true
        self.generalFunc.setError(uv: self, title: "Loading Error", content: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("❌ WebView failed provisional navigation: \(error.localizedDescription)")
        self.loaderView.isHidden = true
        self.generalFunc.setError(uv: self, title: "Loading Error", content: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString{
            
            if (urlString.contains(find: "success=1")){
                self.loaderView.isHidden = true
                
                self.navigationItem.setHidesBackButton(true, animated:false);
                self.view.isUserInteractionEnabled = false
                UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
                self.viewProfileUV.showSuccess()
                self.closeCurrentScreen()
            }else if (urlString.contains(find: "success=0")){
                self.loaderView.isHidden = true
                
                self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST_FAILED_PROCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
                    self.closeCurrentScreen()
                })
            }else{
                self.loaderView.isHidden = true
            }
        }
        decisionHandler(.allow)
    }
    
    
//    func getAboutUsPageData(){
//        
//        let parameters = ["type":"staticPage","iPageId": STATIC_PAGE_ID, "appType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "vLangCode": (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil ? "" : (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String))]
//        
//        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
//        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
//            
//            if(response != ""){
//                let dataDict = response.getJsonDataDict()
//                
//                let page_desc = dataDict.get("page_desc")
//                let content = page_desc.replace("\n", withString: "<br>")
//                
//                let stringFormat = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
//                
//                if(Configurations.isRTLMode()){
//                    self.webView.loadHTMLString(stringFormat + "<html dir=\"rtl\"><body><h1 id=h101>\("")</h1><p id=p01>\(content)</p></body></html>", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "font", ofType: "css")!))
//                }else{
//                    self.webView.loadHTMLString(stringFormat + "<html><body><h1 id=h101>\("")</h1><p id=p01><span>\(content)</span></p></body></html>", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "font", ofType: "css")!))
//                }
//                
//                self.webView.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
//                
//            }else{
//                self.generalFunc.setError(uv: self)
//            }
//            
//            self.loaderView.isHidden = true
//        })
//    }
    
    func getAboutUsPageData(){
        
        let parameters = ["type":"staticPage","iPageId": STATIC_PAGE_ID, "appType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "vLangCode": (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil ? "" : (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String))]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                let page_desc = dataDict.get("page_desc")
                
                // Remove stray \r\n and \r left over from Word export (don't add extra <br>, HTML already has them)
                let content = page_desc
                    .replace("\r\n", withString: "")
                    .replace("\n", withString: "")
                    .replace("\r", withString: "")
                
//                let stringFormat = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>body{margin:10px;padding:0;} table{width:100%;border-collapse:collapse;}</style></header>"
//
                let stringFormat = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>"
                    + "html,body{margin:0;padding:12px;-webkit-text-size-adjust:100%;}"
                    + "body{font-size:15px;line-height:1.45;word-wrap:break-word;}"
                    + "p{margin:0 0 10px 0;}"
                    + "p:empty{display:none;margin:0;}"
                    + "span,b,strong{line-height:normal !important;font-size:inherit !important;}"
                    + "table{width:100% !important;border-collapse:collapse;table-layout:fixed;margin:8px 0;}"
                    + "td{padding:6px !important;vertical-align:top;word-break:break-word;}"
                    + "</style></header>"
                
                if(Configurations.isRTLMode()){
                    self.webView.loadHTMLString(stringFormat + "<html dir=\"rtl\"><body>\(content)</body></html>", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "font", ofType: "css")!))
                }else{
                    self.webView.loadHTMLString(stringFormat + "<html><body>\(content)</body></html>", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "font", ofType: "css")!))
                }
                
                self.webView.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            self.loaderView.isHidden = true
        })
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("✅ WebView finished loading")
        self.loaderView.isHidden = true
        
        // Only apply text selection disable for static pages, not for Stripe Connect
        if STATIC_PAGE_ID != "6" {
            let javascriptStyle = "var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}'; var head = document.head || document.getElementsByTagName('head')[0]; var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); head.appendChild(style);"
            webView.evaluateJavaScript(javascriptStyle, completionHandler: nil)

            // NEW: consecutive <br> collapse + empty paragraphs remove
            let cleanupJS = """
            (function(){
              var brs = Array.prototype.slice.call(document.querySelectorAll('br'));
              brs.forEach(function(b){
                var n = b.nextSibling;
                while(n && n.nodeType === 3 && !n.textContent.replace(/\\u00a0/g,'').trim()){ n = n.nextSibling; }
                if(n && n.nodeName === 'BR'){ b.parentNode.removeChild(b); }
              });
              Array.prototype.slice.call(document.querySelectorAll('p,div')).forEach(function(p){
                if(!p.querySelector('img,table,br') && !p.textContent.replace(/\\u00a0/g,'').trim()){
                  p.parentNode.removeChild(p);
                }
              });
              var last = document.body.lastElementChild;
              while(last && !last.textContent.replace(/\\u00a0/g,'').trim()){
                document.body.removeChild(last); last = document.body.lastElementChild;
              }
            })();
            """
            webView.evaluateJavaScript(cleanupJS, completionHandler: nil)
        }
    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let javascriptStyle = "var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}'; var head = document.head || document.getElementsByTagName('head')[0]; var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); head.appendChild(style);"
//        webView.evaluateJavaScript(javascriptStyle, completionHandler: nil)
//    }
    
    // MARK: - NEW: Programmatic Agree-to-Terms UI (STATIC_PAGE_ID == "63" only)
    
    func setupAgreeView(){
        
        agreeContainerView = UIView()
        agreeContainerView.backgroundColor = UIColor.white
        agreeContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Rounded bordered box (checkbox + message)
        let roundedBox = UIView()
        roundedBox.backgroundColor = UIColor.white
        roundedBox.layer.cornerRadius = 10
        roundedBox.layer.borderWidth = 1
        roundedBox.layer.borderColor = UIColor(hex: 0xDDDDDD).cgColor
        roundedBox.translatesAutoresizingMaskIntoConstraints = false
        
        // Checkbox button
        checkBoxBtn = UIButton(type: .custom)
        checkBoxBtn.layer.borderWidth = 2.5
        checkBoxBtn.layer.borderColor = UIColor(hex: 0x202020).cgColor
        checkBoxBtn.layer.cornerRadius = 3
        checkBoxBtn.backgroundColor = UIColor.clear
        checkBoxBtn.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        checkBoxBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // Checkmark label inside the checkbox (hidden until checked)
        checkMarkLbl = UILabel()
        checkMarkLbl.text = "✓"
        checkMarkLbl.font = UIFont.boldSystemFont(ofSize: 15)
        checkMarkLbl.textColor = UIColor.white
        checkMarkLbl.textAlignment = .center
        checkMarkLbl.isHidden = true
        checkMarkLbl.isUserInteractionEnabled = false
        checkMarkLbl.translatesAutoresizingMaskIntoConstraints = false
        checkBoxBtn.addSubview(checkMarkLbl)
        
        // Message label — direct text (language key ka stored label override kar deta hai)
        agreeMessageLbl = UILabel()
        agreeMessageLbl.text = self.generalFunc.getLanguageLabel(origValue: "I agree to terms and conditions please check the box", key: "LBL_TERMS_CONDITIONS_TEXT_CHECK")
        agreeMessageLbl.font = UIFont(name: Fonts().regular, size: 15)
        agreeMessageLbl.textColor = UIColor(hex: 0x9B9B9B)
        agreeMessageLbl.numberOfLines = 2
        agreeMessageLbl.translatesAutoresizingMaskIntoConstraints = false
        
        // Agree button — edge-to-edge, bottom-flush, sirf TOP corners rounded
        agreeBtn = UIButton(type: .custom)
        agreeBtn.backgroundColor = UIColor.UCAColor.AppThemeColor
        agreeBtn.setTitleColor(UIColor.white, for: .normal)
        agreeBtn.titleLabel?.font = UIFont(name: Fonts().semibold, size: 16)
        agreeBtn.setTitle(self.generalFunc.getLanguageLabel(origValue: "I Agree To Terms And Conditions", key: "LBL_TERMS_CONDITIONS_TEXT").uppercased(), for: .normal)
        agreeBtn.addTarget(self, action: #selector(agreeBtnTapped), for: .touchUpInside)
        agreeBtn.layer.cornerRadius = 16
        agreeBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // top-left + top-right only
        agreeBtn.clipsToBounds = true
        agreeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        roundedBox.addSubview(checkBoxBtn)
        roundedBox.addSubview(agreeMessageLbl)
        
        agreeContainerView.addSubview(roundedBox)
        agreeContainerView.addSubview(agreeBtn)
        
        self.view.addSubview(agreeContainerView)
        
        NSLayoutConstraint.activate([
            // Container view ke REAL bottom tak (safe area nahi) — white strip khatam
            agreeContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            agreeContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            agreeContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            // Rounded box inside container (with side margins + top spacing)
            roundedBox.topAnchor.constraint(equalTo: agreeContainerView.topAnchor, constant: 10),
            roundedBox.leadingAnchor.constraint(equalTo: agreeContainerView.leadingAnchor, constant: 15),
            roundedBox.trailingAnchor.constraint(equalTo: agreeContainerView.trailingAnchor, constant: -15),
            roundedBox.heightAnchor.constraint(equalToConstant: 64),
            
            // Checkbox inside rounded box
            checkBoxBtn.leadingAnchor.constraint(equalTo: roundedBox.leadingAnchor, constant: 15),
            checkBoxBtn.centerYAnchor.constraint(equalTo: roundedBox.centerYAnchor),
            checkBoxBtn.widthAnchor.constraint(equalToConstant: 22),
            checkBoxBtn.heightAnchor.constraint(equalToConstant: 22),
            
            // Checkmark centered in the checkbox
            checkMarkLbl.centerXAnchor.constraint(equalTo: checkBoxBtn.centerXAnchor),
            checkMarkLbl.centerYAnchor.constraint(equalTo: checkBoxBtn.centerYAnchor),
            
            // Message label next to checkbox
            agreeMessageLbl.leadingAnchor.constraint(equalTo: checkBoxBtn.trailingAnchor, constant: 15),
            agreeMessageLbl.trailingAnchor.constraint(equalTo: roundedBox.trailingAnchor, constant: -15),
            agreeMessageLbl.centerYAnchor.constraint(equalTo: roundedBox.centerYAnchor),
            
            // Button: full width, no side margins, container ke bottom tak flush
            agreeBtn.topAnchor.constraint(equalTo: roundedBox.bottomAnchor, constant: 14),
            agreeBtn.leadingAnchor.constraint(equalTo: agreeContainerView.leadingAnchor),
            agreeBtn.trailingAnchor.constraint(equalTo: agreeContainerView.trailingAnchor),
            agreeBtn.bottomAnchor.constraint(equalTo: agreeContainerView.bottomAnchor)
        ])
        
        // Height alag property mein — safe area change par constant update, duplicate constraint nahi
        agreeBtnHeightConstraint = agreeBtn.heightAnchor.constraint(equalToConstant: 56)
        agreeBtnHeightConstraint.isActive = true
        
        isTermsAgreed = false
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if agreeBtn != nil, agreeBtnHeightConstraint != nil {
            let bottomInset = self.view.safeAreaInsets.bottom
            // Title home indicator se upar rahe, button visible 56pt + safe area extension
            agreeBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
            agreeBtnHeightConstraint.constant = 56 + bottomInset
        }
    }
    
    func acceptTermsAndCondtion(){
        let parameters = ["type":"acceptTnC", "iMemberId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    isTncAcceptedThisSession = true
                    self.navigationController?.popViewController(animated: true)
                   
                }else{
                    
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
        
    @objc func checkBoxTapped(){
        isTermsAgreed = !isTermsAgreed
        
        if(isTermsAgreed){
            checkBoxBtn.backgroundColor = UIColor.UCAColor.AppThemeColor
            checkBoxBtn.layer.borderColor = UIColor.UCAColor.AppThemeColor.cgColor
            checkMarkLbl.isHidden = false
        }else{
            checkBoxBtn.backgroundColor = UIColor.clear
            checkBoxBtn.layer.borderColor = UIColor(hex: 0x202020).cgColor
            checkMarkLbl.isHidden = true
        }
    }
    
    @objc func agreeBtnTapped(){
        if(isTermsAgreed == false){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please check the box to agree to terms and conditions.", key: "LBL_PLEASE_CHECK_BOX"))
            return
        }
        
        self.acceptTermsAndCondtion()
    }
    
}
