//
//  AccountSuspendUV.swift
//  DriverApp
//
//  Created by ADMIN on 20/06/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class AccountSuspendUV: UIViewController, MyBtnClickDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentLbl: MyLabel!
    @IBOutlet weak var contactUsBtn: MyButton!
    @IBOutlet weak var lockImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    var homeTabBar:HomeScreenTabBarUV!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "AccountSuspendScreenDesign", uv: self, contentView: contentView))
        
        contentLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_STATUS_SUSPENDED_DRIVER")
        contentLbl.fitText()
        
        self.contactUsBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"))
        self.contactUsBtn.clickDelegate = self
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let navHeight = 64
        let width = ((navHeight * 350) / 119)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: ((width * 119) / 350)))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "ic_your_logo")
        imageView.image = image
        self.homeTabBar.navItem.titleView = imageView
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.homeTabBar.navItem.leftBarButtonItem = leftButton
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nav_logout")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.logOutTapped))
        self.homeTabBar.navItem.rightBarButtonItem = rightButton
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.contactUsBtn){
            let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
            self.pushToNavController(uv: contactUsUv)
        }
    }
    
    @objc func logOutTapped(){
        let window = Application.window
        GeneralFunctions.logOutUser()
        GeneralFunctions.restartApp(window: window!)
    }
}
