//
//  OpenUserPreferences.swift
//  PassengerApp
//
//  Created by  on 23/03/20.
//  Copyright © 2020 @. All rights reserved.
//

import UIKit
import WebKit

class OpenUserPreferences: NSObject, MyLabelClickDelegate, WKNavigationDelegate {
    typealias CompletionHandler = (_ isContinueBtnTapped:Bool, _ isTollSkipped:Bool) -> Void
    
    var uv:UIViewController!
    var containerView:UIView!
    
    var currentInst:OpenUserPreferences!
    
    let generalFunc = GeneralFunctions()
    
    var userPreferencesDesignView:UserPreferencesDesign!
    var userPreferencesDesignBGView:UIView!
    
    var handler:CompletionHandler!
    var isWithdrawable = false
    var isNonWithdrawable = false
    
    var proofDeclined = false
    
    var isShowCancel = false
    var isFromEmailVerify = false
    
    var isCustomImg = ""
    var htmlString = ""
    
    var webView:WKWebView!
    
    init(uv:UIViewController, containerView:UIView){
        self.uv = uv
        self.containerView = containerView
        super.init()
    }
    
    func setViewHandler(handler: @escaping CompletionHandler){
        self.handler = handler
    }
    
    func show(preferenceDescription:String, _ title: String = ""){
                
        let desc = preferenceDescription.replace("\\n", withString: "\n")
              
        var descHeight = desc.height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont(name: Fonts().regular, size: 17)!) + 30
        if isWithdrawable {
            descHeight =  descHeight + 15
        }
        let width = Application.screenSize.width - 50
        
        var height:CGFloat = 240 + (self.htmlString == "" ? descHeight : 0.0)
        
        height = height - (title == "" ? 20 : 0.0)
        if height > Application.screenSize.height{
            height = Application.screenSize.height - 40
        }
        if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S{
            height = height + 50
        }
        
        userPreferencesDesignView = UserPreferencesDesign(frame: CGRect(x:0, y:0, width: width, height: height))
        
        if(self.htmlString != ""){
            self.setWebView()
        }
        
        userPreferencesDesignView.frame.size = CGSize(width: width, height: height)
        
        userPreferencesDesignView.center = CGPoint(x: Application.screenSize.width / 2, y: self.containerView.frame.height / 2)
        
        let bgView = UIView()
        
        bgView.frame = CGRect(x:0, y:0, width:Application.screenSize.width, height: self.containerView.frame.height)
        
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: self.containerView.frame.height / 2)
        
        bgView.backgroundColor = UIColor.black
        
        bgView.isUserInteractionEnabled = true
        
        self.userPreferencesDesignBGView = bgView
        
        Application.window?.addSubview(bgView)
        Application.window?.addSubview(userPreferencesDesignView)
        
        bgView.alpha = 0
        self.userPreferencesDesignView.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                bgView.alpha = 0.80
                self.userPreferencesDesignView.alpha = 1
        }
        )
        
        self.userPreferencesDesignView.cornerRadius = 10
        self.userPreferencesDesignView.clipsToBounds = true
        userPreferencesDesignView.prefHBGView.backgroundColor = UIColor.UCAColor.AppThemeColor
        if(title != ""){
            userPreferencesDesignView.userPreferencesTitleLbl.text = title.uppercased()
        }else{
            userPreferencesDesignView.userPreferencesTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_PREF")
        }
        
        if(self.htmlString == ""){
            userPreferencesDesignView.userPreferencesNoteTextView.text = desc
        }
        
        userPreferencesDesignView.userPreferencesOkLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")
        userPreferencesDesignView.userPreferencesOkLbl.setClickDelegate(clickDelegate: self)
        userPreferencesDesignView.userPreferencesOkLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        userPreferencesDesignView.userPreferencesNoteTextViewHeight.constant = descHeight
        if (240 + descHeight) > Application.screenSize.height{
            userPreferencesDesignView.userPreferencesNoteTextView.isScrollEnabled = true
        }
        
        if(self.isCustomImg != ""){
            userPreferencesDesignView.headerImgView.image = UIImage(named:self.isCustomImg)
        }else{
            if(isWithdrawable || isNonWithdrawable){
                if(isWithdrawable){
                    userPreferencesDesignView.headerImgView.image = UIImage(named:"ic_withdrawble_help")
                }else{
                    userPreferencesDesignView.headerImgView.image = UIImage(named:"ic_nonwithdrawble_help")
                }
                userPreferencesDesignView.userPreferencesTitleLbl.isHidden = true
                userPreferencesDesignView.userPerferencesLblHight.constant = 0
            }
        }
        
        
        userPreferencesDesignView.cancelLbl.borderColor = UIColor.UCAColor.AppThemeColor
        userPreferencesDesignView.cancelLbl.textColor = UIColor.UCAColor.AppThemeColor
        userPreferencesDesignView.cancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased()
        userPreferencesDesignView.cancelLbl.setOnClickListener { (instance) in
              self.closeView()
        }
        
        if(self.proofDeclined == true){
           userPreferencesDesignView.userPreferencesTitleLbl.isHidden = true
           userPreferencesDesignView.cancelLbl.isHidden = false
           userPreferencesDesignView.userPreferencesOkLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT")
           userPreferencesDesignView.headerImgView.image = UIImage(named:"ic_proof_decline")
        }
        
        if(self.isShowCancel){
            userPreferencesDesignView.cancelLbl.isHidden = false
        }
        
        
        if(self.isFromEmailVerify){
            userPreferencesDesignView.userPreferencesOkLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN").uppercased()
            userPreferencesDesignView.headerImgView.image = UIImage(named:"ic_email_New")
            userPreferencesDesignView.userPreferencesNoteTextView.textAlignment = .center
        }
        
    }
        
    func closeView(){
        userPreferencesDesignView.frame.origin.y = Application.screenSize.height + 2500
        userPreferencesDesignView.removeFromSuperview()
        userPreferencesDesignBGView.removeFromSuperview()
    }

    func setWebView(){
        self.webView = WKWebView.init(frame: CGRect(x: 10, y:155, width: self.userPreferencesDesignView.frame.width - 20, height: self.userPreferencesDesignView.frame.height - 240))
          self.webView.navigationDelegate = self
          
          self.webView.backgroundColor = UIColor.clear
          self.userPreferencesDesignView.addSubview(self.webView)
          
          self.webView.scrollView.bounces = false
          
        
        let page_desc = self.htmlString
          let content = page_desc.replace("\n", withString: "<br>")
                         
          let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        

           if(Configurations.isRTLMode()){
               self.webView.loadHTMLString(headerString + "<html dir=\"rtl\"><body><p style=color:#343434>\(content)</p></body></html>", baseURL: nil)
           }else{
               self.webView.loadHTMLString(headerString + "<html><body><p style=color:#343434>\(content)</p></body></html>", baseURL:nil)
           }


          self.webView.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
            
    }
       
    
       func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
               print(webView.scrollView.contentSize.height)
               
               let width = Application.screenSize.width - 50
               var height = webView.scrollView.contentSize.height + 220
               
               if(height > Application.screenSize.height - 50){
                   height = Application.screenSize.height - 50
               }
               self.userPreferencesDesignView.frame = CGRect(x:0, y:0, width: width, height: height)
               
               self.userPreferencesDesignView.frame.size = CGSize(width: width, height: height)
               
               self.userPreferencesDesignView.center = CGPoint(x: Application.screenSize.width / 2, y: self.containerView.frame.height / 2)
               
               
               self.webView.frame = CGRect(x: 10, y:155, width: self.userPreferencesDesignView.frame.width - 20, height: self.userPreferencesDesignView.frame.height - 220)
               
               
           }
       }
    
    func myLableTapped(sender: MyLabel) {
        
        if(self.proofDeclined == true){
           closeView()
           let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
           self.uv.pushToNavController(uv: contactUsUv)
           return
        }
        
        if(self.userPreferencesDesignView != nil && sender == self.userPreferencesDesignView.userPreferencesOkLbl){
            
            if(self.isFromEmailVerify){
                let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                accountVerificationUv.isForMobile = false
                self.uv.pushToNavController(uv: accountVerificationUv)
            }
            closeView()
        }
    }
}

