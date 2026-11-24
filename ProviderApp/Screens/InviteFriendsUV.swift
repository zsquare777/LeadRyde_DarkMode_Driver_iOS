//
//  InviteFriendsUV.swift
//  DriverApp
//
//  Created by ADMIN on 13/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class InviteFriendsUV: UIViewController, MyBtnClickDelegate{

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var shareHLbl: MyLabel!
    @IBOutlet weak var inviteCodeLbl: MyLabel!
    @IBOutlet weak var descLbl: MyLabel!
    @IBOutlet weak var shareBtn: MyButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let generalFunc = GeneralFunctions()
    var userProfileJson:NSDictionary!
    
    var PAGE_HEIGHT:CGFloat = 405
    
    var cntView:UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
         Configurations.setAppThemeNavBar()
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        cntView = self.generalFunc.loadView(nibName: "InviteFriendsScreenDesign", uv: self, contentView: scrollView)
        self.scrollView.addSubview(cntView)
        
        self.addBackBarBtn()
        
        setData()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
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
        
        // Update main view background
        self.view.backgroundColor = themeManager.backgroundColor()
        
        // Update content view background
        self.contentView.backgroundColor = themeManager.backgroundColor()
        
        // Update scroll view background
        self.scrollView.backgroundColor = themeManager.backgroundColor()
        
        // Update label text colors
        self.shareHLbl.textColor = themeManager.textColor()
        self.descLbl.textColor = themeManager.secondaryTextColor()
        
        // Note: inviteCodeLbl keeps app theme colors (branding)
        // Note: shareBtn keeps app theme colors (branding)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)

        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE_FRIEND_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE_FRIEND_TXT")
        
//        self.descLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE_FRIEND_SHARE_TXT")
        self.descLbl.text = Configurations.convertNumToAppLocal(numStr: self.userProfileJson.get("INVITE_DESCRIPTION_CONTENT"))
        self.shareHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE_FRIEND_SHARE")
        
        self.shareBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE_FRIEND_TXT"))
        self.inviteCodeLbl.text = userProfileJson.get("vRefCode")
        self.inviteCodeLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
//        inviteCodeLbl.backgroundColor =  UIColor.UCAColor.AppThemeColor.withAlphaComponent(0.2)
        
        self.shareBtn.clickDelegate = self
        
        self.descLbl.fitText()
        
        var descTxtHeight = descLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 20, font: UIFont(name: Fonts().light, size: 16)!) - 20
        if(descTxtHeight < 0){
            descTxtHeight = 0
        }
        PAGE_HEIGHT = PAGE_HEIGHT + descTxtHeight
        
        cntView.frame.size = CGSize(width: self.cntView.frame.width, height: PAGE_HEIGHT)
        
        self.scrollView.bounces = false
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
        self.inviteCodeLbl.backgroundColor = UIColor.UCAColor.AppThemeColor.lighter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inviteCodeLbl.dashedBorderLayerWithColor(color: UIColor.UCAColor.AppThemeColor.cgColor)
        
        // Apply theme after views are fully set up
        applyTheme()
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.shareBtn){
            let objectsToShare = ["\(self.userProfileJson.get("INVITE_SHARE_CONTENT"))"]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.shareBtn
            if #available(iOS 11.0, *) {
                activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                    if !completed {
                        DispatchQueue.main.async {
                            Configurations.setAppThemeNavBar()
                            return
                        }
                    }
                }
                DispatchQueue.main.async {
                    Configurations.setDefaultNavBar()
                }
//                UINavigationBar.appearance().backgroundColor = UIColor.UCAColor.AppThemeColor
//                UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
            }
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
