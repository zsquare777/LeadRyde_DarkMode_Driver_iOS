//
//  HelpNoteForRideUV.swift
//  PassengerApp
//
//  Created by Admin on 15/10/20.
//  Copyright © 2020 @. All rights reserved.
//

/* Help note changes for Ride*/

import UIKit
import WebKit

class HelpNoteForRideUV: UIViewController, MyBtnClickDelegate , WKNavigationDelegate  {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomLbl: MyLabel!
    @IBOutlet weak var agreeBtn: MyButton!
    @IBOutlet weak var cancelVw: UIImageView!
    
    
    let generalFunc = GeneralFunctions()
    var isRideLater = false
    var webView:WKWebView!
    var loaderView:UIView!
    
    override func viewWillAppear(_ animated: Bool) {
    
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = true
        
        self.configureRTLView()
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.alpha = 1.0
        })
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "HelpNoteForRideScreenDesign", uv: self, contentView: contentView))
        
        setData()
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }

    func setData(){
        
        //self.bottomLbl.isHidden = true
        self.agreeBtn.isHidden = true
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.agreeBtn.setButtonTitle(buttonTitle:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AGREE") )
        
        self.agreeBtn.clickDelegate = self
        
        self.cancelVw.image = UIImage(named:"ic_cancel_forgotpass")?.addImagePadding(x: 20, y: 20)
        self.cancelVw.layer.addShadow(opacity: 0.7, radius: 2)
        self.cancelVw.layer.cornerRadius = 19
        self.cancelVw.backgroundColor = UIColor(hex: 0xffffff)
        self.cancelVw.layer.shadowColor = UIColor.gray.cgColor
        self.cancelVw.setOnClickListener { (instance) in
            self.closeCurrentScreen()
        }
        
        self.webView = WKWebView.init(frame: CGRect(x: 20, y:60, width: Application.screenSize.width - 40, height: Application.screenSize.height - 140 - GeneralFunctions.getSafeAreaInsets().top - GeneralFunctions.getSafeAreaInsets().bottom ))
        self.webView.navigationDelegate = self
        self.webView.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.webView)
        
        self.webView.scrollView.bounces = false
        self.webView.scrollView.showsVerticalScrollIndicator = false
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        
        self.webView.load(URLRequest(url: URL(string: userProfileJson.get("RESTRICT_PASSENGER_LIMIT_INFO_URL"))!))
    }
    
    
    func myBtnTapped(sender: MyButton) {
        self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
           // self.bottomLbl.isHidden = false
            self.agreeBtn.isHidden = false
            self.loaderView.isHidden = true
        }
    }
    
    
}

