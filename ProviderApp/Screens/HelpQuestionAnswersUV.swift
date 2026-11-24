//
//  HelpQuestionAnswersUV.swift
//  DriverApp
//
//  Created by ADMIN on 15/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import WebKit

class HelpQuestionAnswersUV: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    /*BottomView IBOutlet Created*/
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var helpTilteHLbl: MyLabel!
    @IBOutlet weak var contactUsLbl: MyLabel!
    
    let generalFunc = GeneralFunctions()
    
    var webView: WKWebView!
    var selectedHelpCategoryItem:NSDictionary!
    
    var currentSelectedPosition = -1
    var currentHeight:CGFloat = 0
    
    var answerHeightContainer = [CGFloat]()
    var heightContainerDict = [String:CGFloat]()
    
    var isFirst = true
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "HelpQuestionAnswersScreenDesign", uv: self, contentView: contentView))
        self.addBackBarBtn()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(Configurations.isRTLMode()){
            self.bottomViewHeight.constant = self.bottomViewHeight.constant + 20
        }
        
        self.webView = WKWebView.init(frame: CGRect(x: 0, y:0, width: self.view.frame.size.width, height: (self.view.frame.size.height - self.bottomViewHeight.constant)))
        self.webView.navigationDelegate = self
        self.webView.scrollView.minimumZoomScale = 5.0
        self.webView.backgroundColor = UIColor.clear
        self.webView.isOpaque = false
        self.contentView.addSubview(self.webView)
        self.webView.scrollView.bounces = false
        self.webView.contentMode = .scaleToFill
        setData()
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAQ_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAQ_TXT")
        
        self.helpTilteHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Still need Help?", key: "LBL_STILL_NEED_HELP")
        
        self.contactUsLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.contactUsLbl.text = self.generalFunc.getLanguageLabel(origValue: "Contact Us", key: "LBL_FOOTER_HOME_CONTACT_US_TXT")
        
        self.contactUsLbl.setClickHandler { (instance) in
            self.openContactUs()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
            self.bottomView.clipsToBounds = true
        }
        
//        let page_desc = String(format: "%@", selectedHelpCategoryItem.get("tAnswer"))
//        let content = page_desc.replace("\n", withString: "<br>")


        let page_title = selectedHelpCategoryItem.get("vTitle")
        let page_desc = selectedHelpCategoryItem.get("tAnswer")
        let content = page_desc.replace("\n", withString: "<br>")
        
        let stringFormat = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        
        if(Configurations.isRTLMode()){
            self.webView.loadHTMLString(stringFormat + "<html dir=\"rtl\"><body><h1 id=h101>\(page_title)</h1><p id=p01>\(content)</p></body></html>", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "font", ofType: "css")!))
        }else{
            self.webView.loadHTMLString(stringFormat + "<html><body><h1 id=h101>\(page_title)</h1><p id=p01><span>\(content)</span></p></body></html>", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "font", ofType: "css")!))
        }
        
        self.webView.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascriptStyle = "var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}'; var head = document.head || document.getElementsByTagName('head')[0]; var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); head.appendChild(style);"
        webView.evaluateJavaScript(javascriptStyle, completionHandler: nil)
    }
    
    func openContactUs(){
        let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
        self.pushToNavController(uv: contactUsUv)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

