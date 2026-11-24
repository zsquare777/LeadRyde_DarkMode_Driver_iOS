//
//  ViewProfileUV.swift
//  DriverApp
//
//  Created by ADMIN on 15/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftExtensionData
import LiveChat

struct Headline {
    
    var title : String
    var image : String
    var id    : String
    var attributedTitle: NSMutableAttributedString
    var rightSideImage:String
}

class ViewProfileUV: UIViewController, MyLabelClickDelegate, UITableViewDelegate, UITableViewDataSource, LiveChatDelegate {
    
    

    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profilePicViewArea: UIView!
    @IBOutlet weak var editPicAreaView: UIView!
    @IBOutlet weak var placesSeperatorView: UIView!
    
    @IBOutlet weak var userProfilePicBgView: UIView!
    @IBOutlet weak var userProfilePicBgImgView: UIImageView!
    @IBOutlet weak var usrProfileImgView: UIImageView!
    @IBOutlet weak var fNameTxtField: MyTextField!
    @IBOutlet weak var lNameTxtField: MyTextField!
    @IBOutlet weak var emailTxtField: MyTextField!
//    @IBOutlet weak var countryTxtField: MyTextField!
    @IBOutlet weak var workLocTxtFiledHeightCons: NSLayoutConstraint!
    @IBOutlet weak var workLocTextField: MyTextField!
    @IBOutlet weak var mobileTxtField: MyTextField!
    @IBOutlet weak var languageTxtField: MyTextField!
    @IBOutlet weak var currencyTxtField: MyTextField!
    @IBOutlet weak var langTxtFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var currencyTxtFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceDesHLbl: MyLabel!
    @IBOutlet weak var serviceDesVLbl: MyLabel!
    @IBOutlet weak var editIconImgView: UIImageView!
    
    @IBOutlet weak var placesHLbl: MyLabel!
    @IBOutlet weak var workLocContainerView: UIView!
    @IBOutlet weak var homeLocContainerView: UIView!
    @IBOutlet weak var homeLocImgView: UIImageView!
    @IBOutlet weak var homeLocVLbl: MyLabel!
    @IBOutlet weak var homeLocHLbl: MyLabel!
    @IBOutlet weak var homeLoceditImgContainerView: UIView!
    @IBOutlet weak var homeLocEditImgView: UIImageView!
    @IBOutlet weak var placesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var placesContainerView: UIView!
    
    @IBOutlet weak var workLocVLbl: MyLabel!
    @IBOutlet weak var workLocHLbl: MyLabel!
    @IBOutlet weak var workLocImgView: UIImageView!
    @IBOutlet weak var workLoceditImgContainerView: UIView!
    @IBOutlet weak var workLocEditImgView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerTopBgView: UIView!
    @IBOutlet weak var profileHeaderImgView: UIImageView!
    @IBOutlet weak var nameHeaderLbl: MyLabel!
    @IBOutlet weak var emailHeaderLbl: MyLabel!
    @IBOutlet weak var walletBHLbl: MyLabel!
    @IBOutlet weak var walletBVLbl: MyLabel!
    @IBOutlet weak var headerBtnView1: UIView!
    @IBOutlet weak var headerBtnView2: UIView!
    @IBOutlet weak var headerBtnView3: UIView!
    @IBOutlet weak var headerBtnView4: UIView!
    @IBOutlet weak var btn1ImgView: UIImageView!
    @IBOutlet weak var btn1VLbl: MyLabel!
    @IBOutlet weak var btn2ImgView: UIImageView!
    @IBOutlet weak var btn2VLbl: MyLabel!
    @IBOutlet weak var btn3ImgView: UIImageView!
    @IBOutlet weak var btn3VLbl: MyLabel!
    @IBOutlet weak var btn4ImgView: UIImageView!
    @IBOutlet weak var btn4VLbl: MyLabel!
    @IBOutlet weak var topBottomView: UIView!
    
    //GenderView related OutLets
    @IBOutlet weak var genderVCloseImgView: UIImageView!
    @IBOutlet weak var genderHLbl: MyLabel!
    @IBOutlet weak var maleImgView: UIImageView!
    @IBOutlet weak var femaleImgView: UIImageView!
    @IBOutlet weak var maleLbl: MyLabel!
    @IBOutlet weak var femaleLbl: MyLabel!
    
    @IBOutlet weak var Email_Verify_ImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    var languageNameList = [String]()
    var languageCodes = [String]()
    var currenyList = [String]()
    var selectedCurrency = ""
    var selectedMode = ""
    var selectedLngCode = ""
    
    var colorArrayForLang = [UIColor]()
    var colorArrayForCurr = [UIColor]()
    
    var colorArrayForTextLang = [UIColor]()
    var colorArrayForTextCurr = [UIColor]()
    
    var selectedLngColor = UIColor()
    var selectedCurrColor = UIColor()
    
    var selectedLngTxtColor = UIColor()
    var selectedCurrTxtColor = UIColor()
    
    var currencySymboles = [String]()
    
    var openListView:OpenListView!
    
    var tableHeaderView:UIView!
    let generalFunc = GeneralFunctions()
    var containerViewHeight:CGFloat = 0
    
    var homeTabBar:HomeScreenTabBarUV!
    
    var openImgSelection:OpenImageSelectionOption!
    
    var isFirstLaunch = true
    
    var cntView:UIView!

    var PAGE_HEIGHT:CGFloat = 610
    
    var homeLoc:CLLocation!
    var workLoc:CLLocation!
    
    var numaberOfSection = 5
    
    var rightButton: UIBarButtonItem!
    
    var finalDataArray = NSMutableArray()
    var navView:UIView!
    var userProfileJson:NSDictionary!
    
    
    var MY_BOOKINGS = "0"
    var MANAGE_SERVICES = "1"
    var MANAGE_GALLERY = "2"
    var MY_AVAILABILITY = "3"
    var STATISTICS = "4"
    var USER_FEEDBACK = "5"
    var WAY_BILL = "6"
    var NOTIFICATIONS = "7"
    var INVITE_FRIEND = "8"
    var EMERGENCY_CONTACTS = "9"
    var PERSONAL_DETAILS = "10"
    var MANAGE_DOCUMENT = "11"
    var CHANGE_PASSWORD = "12"
    var CHANGE_CURRENCY = "13"
    var CHANGE_LANGUAGE = "14"
    var PAYMENT_METHOD = "15"
    var BANK_DETAILS = "16"
    var MY_WALLET = "17"
    var ADD_MONEY = "18"
    var SEND_MONEY = "19"
    var ABOUT_US = "20"
    var PRIVACY_POLICY = "21"
    var TERMS_CONDITION = "22"
    var FAQ = "23"
    var CONTACT_US = "24"
    var LOG_OUT = "25"
    var MY_SUBSCRIPTION = "26"
    var VERIFY_MOBILE = "27"
    var VERIFY_EMAIL = "28"
    var LIVE_CHAT = "29"
    var STRIPE_CONNECT = "30"
    var CHANGE_THEME = "31"
    var DELETE_ACCOUNT = "32"
    var CHANGE_MODE = "33"

    var tableViewLastCntOffset:CGPoint!
    var chatLicenseID = ""
    var navAlpha:CGFloat = 0
    
    var APPSTORE_MODE_IOS:AnyObject?
    var navTitleView:UIView!
    
    var genderView:UIView!
    var veriFy:UIView!
    
    
    
  
    override func viewWillAppear(_ animated: Bool) {
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
//        self.navigationController?.navigationBar.layer.zPosition = -1
        self.configureRTLView()
        
        APPSTORE_MODE_IOS = GeneralFunctions.getValue(key: Utils.APPSTORE_MODE_IOS_KEY)
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.chatLicenseID = userProfileJson.get("LIVE_CHAT_LICENCE_NUMBER") /* Live Chat Settings .*/
       
        cntView = self.generalFunc.loadView(nibName: "ViewProfileScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        self.scrollView.bounces = false
        self.scrollView.isHidden = true
        //self.btnContinue.clickDelegate = self
        //setData()
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        blurEffectView.frame = userProfilePicBgView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.userProfilePicBgView.addSubview(blurEffectView)
        
    
        setLanguage()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
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
        
        // Update table view background
        self.tableView.backgroundColor = themeManager.backgroundColor()
        
        // Update separator color (Google Wallet style)
        self.tableView.separatorColor = themeManager.separatorColor()
        
        // Update table header view background if needed
        if let headerView = self.tableHeaderView {
            headerView.backgroundColor = themeManager.backgroundColor()
        }
        
        // NOTE: headerTopBgView keeps its branded app theme color (UIColor.UCAColor.AppThemeColor)
        // It's set in setTableView() and should NOT change with light/dark theme
        
        // Update topBottomView (the bottom section with rounded corners and shadow)
        self.topBottomView?.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update shadow color for topBottomView based on theme
        if themeManager.isDarkModeActive {
            self.topBottomView?.layer.shadowColor = UIColor.black.cgColor
        } else {
            self.topBottomView?.layer.shadowColor = UIColor.lightGray.cgColor
        }
        
        // Update header button views backgrounds
        self.headerBtnView1?.backgroundColor = themeManager.cardBackgroundColor()
        self.headerBtnView2?.backgroundColor = themeManager.cardBackgroundColor()
        self.headerBtnView3?.backgroundColor = themeManager.cardBackgroundColor()
        self.headerBtnView4?.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update header labels text colors
        self.btn1VLbl?.textColor = themeManager.textColor()
        self.btn2VLbl?.textColor = themeManager.textColor()
        self.btn3VLbl?.textColor = themeManager.textColor()
        self.btn4VLbl?.textColor = themeManager.textColor()
        
        // Update wallet label colors
        self.walletBHLbl?.textColor = themeManager.secondaryTextColor()
        
        // Update scrollView and contentView backgrounds
        self.scrollView.backgroundColor = themeManager.backgroundColor()
        self.contentView.backgroundColor = themeManager.backgroundColor()
        self.scrollViewContentView.backgroundColor = themeManager.backgroundColor()
        self.view.backgroundColor = themeManager.backgroundColor()
        
        print("✅ ViewProfileUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
        
        // Reload table to update cells
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.layer.zPosition = -1
        self.updateWalletAmount()
        self.setNavItems()
    
        self.tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: (GeneralFunctions.getSafeAreaInsets().bottom > 0 ? (GeneralFunctions.getSafeAreaInsets().bottom - 15) : 20), right: 0)
        
        self.shadowView.dropShadow(color: UIColor.black, opacity: 1.0, offSet: CGSize(width: 0.5, height: 1.0), radius: 1.8, scale: false)
        
        // Apply theme after table is fully set up
        applyTheme()
    }
    
    func setNavItems(){
        navTitleView = generalFunc.loadView(nibName: "ProfileTitleView", uv: self, isWithOutSize: true)
        navTitleView.frame = CGRect(x: 0, y:0, width: Application.screenSize.width, height: 50)
        navTitleView.backgroundColor = UIColor.clear
        (navTitleView.subviews[1] as! MyLabel).text = userProfileJson.get("vName") + " " + userProfileJson.get("vLastName")
        (navTitleView.subviews[1] as! MyLabel).textColor = UIColor.UCAColor.AppThemeTxtColor
        (navTitleView.subviews[0] as! UIImageView).sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImage"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        let FEMALE_RIDE_REQ_ENABLE = userProfileJson.get("FEMALE_RIDE_REQ_ENABLE")
        var image = UIImage(named: "ic_pf_edit")!
        if(FEMALE_RIDE_REQ_ENABLE.uppercased() != "YES" || userProfileJson.get("eGender") == "Male"){
            image = UIImage(named: "ic_pf_edit")!
        }else{
            if(self.userProfileJson.get("eGender") == "" && FEMALE_RIDE_REQ_ENABLE.uppercased() == "YES"){
                image = UIImage(named: "ic_settings")!
            }else{
                image = UIImage(named: "ic_settings")!
            }
        }
        
        let rightButton = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.settingIcTapped))
        if self.homeTabBar != nil {
            self.homeTabBar.navItem.titleView = navTitleView
            self.navTitleView.alpha = navAlpha
            self.homeTabBar.navItem.rightBarButtonItem = rightButton
        }else {
               let rightButton = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.settingIcTapped))
                self.navigationItem.rightBarButtonItem = rightButton
        }
        
        if(isFirstLaunch == true){
            self.setTableView()
            isFirstLaunch = false
        }
        
        self.topBottomView.layer.addShadow(opacity: 0.4, radius: 1, UIColor.lightGray)
        self.topBottomView.layer.roundCorners(radius: 14)
        setTableData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 1
        self.navAlpha = self.navTitleView.alpha
        self.tableView.reloadData()
        if self.homeTabBar != nil {
            self.homeTabBar.navItem.titleView = nil
        }
    }
    
    @objc func settingIcTapped(){
        
        if(Configurations.isRTLMode()){
            self.navigationDrawerController?.closeRightView()
        }else{
            self.navigationDrawerController?.closeLeftView()
        }
        
        let FEMALE_RIDE_REQ_ENABLE = userProfileJson.get("FEMALE_RIDE_REQ_ENABLE")
        
        
        if(FEMALE_RIDE_REQ_ENABLE.uppercased() != "YES" || userProfileJson.get("eGender") == "Male" || self.userProfileJson.get("IS_RIDE_MODULE_AVAIL").uppercased() != "YES"){
            self.editProfileTapped()
        }else{
            if(self.userProfileJson.get("eGender") == "" && FEMALE_RIDE_REQ_ENABLE.uppercased() == "YES"){
                openGenderView()
            }else{
                let setPreferencesUV = GeneralFunctions.instantiateViewController(pageName: "SetPreferencesUV") as! SetPreferencesUV
                self.pushToNavController(uv: setPreferencesUV)
                
            }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.contentOffset.y > 0){
            self.shadowView.isHidden = false
        }else{
            self.shadowView.isHidden = true
        }
        
        if(scrollView.contentOffset.y >= 80){
            UIView.animate(withDuration: 0.15, animations: {
                self.navTitleView.alpha = 1
            })
        }else{
            UIView.animate(withDuration: 0.15, animations: {
                self.navTitleView.alpha = 0
            })
        }
      
    }
    
    @objc func editProfileTapped(){
        
        let uv = GeneralFunctions.instantiateViewController(pageName: "EditProfileUV") as! EditProfileUV
        self.pushToNavController(uv: uv)
    }
    
    func updateWalletAmount(){
       
        let parameters = ["type":"GetMemberWalletBalance", "iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                //                Utils.printLog(msgData: "dataDict:Balance:\(dataDict)")
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: "user_available_balance_amount", value: dataDict.get("user_available_balance_amount") as AnyObject)   // Without Currency Symbole
                    
                    GeneralFunctions.saveValue(key: "user_available_balance", value: dataDict.get("user_available_balance") as AnyObject) // With Currency Symbole
                    
                    
                    if(self.userProfileJson.get("user_available_balance") != dataDict.get("MemberBalance")){
                        GeneralFunctions.saveValue(key: Utils.IS_WALLET_AMOUNT_UPDATE_KEY, value: "true" as AnyObject)
                    }
                    
                    self.walletBVLbl.text = Configurations.convertNumToAppLocal(numStr: GeneralFunctions.getValue(key: "user_available_balance") as! String)
                    
                }
                
            }else{
               
               self.updateWalletAmount()
            }
        })
    }
    
    func setTableView(){
        
        
        selectedCurrency = GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String
        selectedLngCode = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
        
        self.tableView.register(UINib(nibName: "ProfileTVCell", bundle: nil), forCellReuseIdentifier: "ProfileTVCell")
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {}

        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Configure table view appearance for theme support (Google Wallet style)
        self.tableView.backgroundColor = ThemeManager.shared.backgroundColor()
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = ThemeManager.shared.separatorColor()
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
        
        tableHeaderView = self.generalFunc.loadView(nibName: "ProfileHeaderView", uv: self, isWithOutSize: true)
        tableHeaderView.backgroundColor = ThemeManager.shared.backgroundColor()
        tableHeaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 250)
        self.headerTopBgView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.headerTopBgView.layer.shadowColor = UIColor.lightGray.cgColor
        self.headerTopBgView.layer.shadowOpacity = 0.6
        self.headerTopBgView.layer.shadowOffset = CGSize.zero
        self.headerTopBgView.layer.shadowRadius = 3
        
        self.tableView.tableHeaderView = tableHeaderView
        
        self.btn1VLbl.text = userProfileJson.get("ONLYDELIVERALL") == "Yes" ? self.generalFunc.getLanguageLabel(origValue: "Orders", key: "LBL_ORDERS_TXT") : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING")
        self.btn1VLbl.fontFamilyWeight = "Bold"
        self.btn1VLbl.setFontFamily()
//        self.btn2VLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALL_ZONE_TXT")
        self.btn2VLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WALLET_TXT")
        self.btn2VLbl.fontFamilyWeight = "Bold"
        self.btn2VLbl.setFontFamily()
        self.btn3VLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOP_UP")
        self.btn3VLbl.fontFamilyWeight = "Bold"
        self.btn3VLbl.setFontFamily()
        self.btn4VLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE")
        self.btn4VLbl.fontFamilyWeight = "Bold"
        self.btn4VLbl.setFontFamily()
        
        self.btn1ImgView.image = UIImage(named: "ic_pf_top_bookings")
        self.btn2ImgView.image = UIImage(named: "ic_pf_top_wallet")
        self.btn3ImgView.image = UIImage(named: "ic_pf_top_wallettopup")
        self.btn4ImgView.image = UIImage(named: "ic_pf_top_Invite")
        
        let REFERRAL_SCHEME_ENABLE = userProfileJson.get("REFERRAL_SCHEME_ENABLE")
        if(REFERRAL_SCHEME_ENABLE.uppercased() != "YES"){
            self.headerBtnView4.isHidden = true
        }
        let WALLET_ENABLE = userProfileJson.get("WALLET_ENABLE")
        if(WALLET_ENABLE.uppercased() != "YES"){
            self.headerBtnView3.isHidden = true
            self.headerBtnView2.isHidden = true
        }
        
        if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() == "CASH"){
            self.headerBtnView3.isHidden = true
        }
        
        self.btn1ImgView.setOnClickListener { (instance) in
            self.tableViewLastCntOffset = self.tableView.contentOffset
            self.openBookings()
        }
        
        self.btn2ImgView.setOnClickListener { (instance) in
            self.tableViewLastCntOffset = self.tableView.contentOffset
            self.openMyWallet()
        }
        self.btn3ImgView.setOnClickListener { (instance) in
            self.tableViewLastCntOffset = self.tableView.contentOffset
            self.openMyWallet(true, false)
        }
        self.btn4ImgView.setOnClickListener { (instance) in
            self.tableViewLastCntOffset = self.tableView.contentOffset
            self.openInviteFriends()
        }
        
    }
    
    func setTableData(){
        
        self.finalDataArray.removeAllObjects()

        self.profileHeaderImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImage"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        self.nameHeaderLbl.text = (userProfileJson.get("vName") + " " + userProfileJson.get("vLastName")).capitalized
        
        self.emailHeaderLbl.text = ""
       
        //self.emailHeaderLbl.isHidden = true
        
        
        
        if userProfileJson.get("vEmail").trim() != ""{
            
            self.emailHeaderLbl.text = userProfileJson.get("vEmail")
        }else{
            self.emailHeaderLbl.text = userProfileJson.get("vPhone")
        }
        self.emailHeaderLbl.fontFamilyWeight = "Bold"
        self.emailHeaderLbl.setFontFamily()
        
        self.nameHeaderLbl.fontFamilyWeight = "Bold"
        self.nameHeaderLbl.setFontFamily()
        
        if (self.userProfileJson.get("eEmailVerified").uppercased() != "YES" && self.userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES"){
            self.Email_Verify_ImageView.isHidden = false
            self.Email_Verify_ImageView.setOnClickListener { (instance) in
                self.openVerifyView()

            }
        }else{
           
            self.Email_Verify_ImageView.isHidden = true
        }
        
        self.nameHeaderLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.emailHeaderLbl.textColor = UIColor.UCAColor.AppThemeTxtColor

        self.walletBHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WALLET_BALANCE")
        self.walletBVLbl.text = Configurations.convertNumToAppLocal(numStr: GeneralFunctions.getValue(key: "user_available_balance") as! String)
        self.walletBVLbl.textColor = UIColor.UCAColor.AppThemeColor
            
        
        for i in 0..<numaberOfSection{
            var sectionDataArray = [Headline]()
            if(i == 0){
                
                if(userProfileJson.get("ONLYDELIVERALL") != "Yes"){
                    let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_BOOKINGS"), image: "ic_pf_bookings", id: MY_BOOKINGS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray1)
                }else{
                    let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ORDERS"), image: "ic_pf_bookings", id: MY_BOOKINGS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray1)
                }
                
                if((self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX) && userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                    let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MANANGE_SERVICES"), image: "ic_pf_manage_service", id: MANAGE_SERVICES, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray2)
                }else{
                    let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MANAGE_VEHICLES"), image: "ic_pf_manage_service", id: MANAGE_SERVICES, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray2)
                }
                
                if((userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() || userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased()) && userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                    let dataArray3 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "Manage Gallery", key: "LBL_MANAGE_GALLARY"), image: "ic_pf_managegallery", id: MANAGE_GALLERY, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray3)
                }
                
                if((userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() || userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased()) && userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                    let dataArray4 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "My Availability", key: "LBL_MY_AVAILABILITY"), image: "ic_pf_avaibility", id: MY_AVAILABILITY, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray4)
                }
                
                if(userProfileJson.get("ONLYDELIVERALL") != "Yes"){
                    if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
                        let dataArray5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STATISTICS"), image: "ic_pf_statistics", id: STATISTICS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                        sectionDataArray.append(dataArray5)
                    }else{
                        let dataArray5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRIP_STATISTICS_TXT"), image: "ic_pf_statistics", id: STATISTICS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                        sectionDataArray.append(dataArray5)
                    }
                    
                }else{
                    let dataArray5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRIP_STATISTICS_TXT_DL"), image: "ic_pf_statistics", id: STATISTICS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray5)
                }
                
                if(userProfileJson.get("APP_TYPE").uppercased() == "RIDE-DELIVERY-UBERX" || userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                    let dataArray6 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USER_FEEDBACK"), image: "ic_user_feedback", id: USER_FEEDBACK, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray6)
                }else if(userProfileJson.get("APP_TYPE").uppercased() == "DELIVERY"){
                    let dataArray6 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SENDER_fEEDBACK"), image: "ic_user_feedback", id: USER_FEEDBACK, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray6)
                }else if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
                    let dataArray6 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDER_FEEDBACK"), image: "ic_user_feedback", id: USER_FEEDBACK, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray6)
                }else{
                    let dataArray6 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USER_FEEDBACK"), image: "ic_user_feedback", id: USER_FEEDBACK, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray6)
                }
                if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                    if (userProfileJson.get("WAYBILL_ENABLE").uppercased() == "YES"){
                        let dataArray7 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MENU_WAY_BILL"), image: "ic_pf_waybill", id: WAY_BILL, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                        sectionDataArray.append(dataArray7)
                    }
                }
                
                if (userProfileJson.get("ENABLE_NEWS_SECTION").uppercased() == "YES")
                {
                    let dataArray8 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS"), image: "ic_pf_notification", id: NOTIFICATIONS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray8)
                }
                if(userProfileJson.get("REFERRAL_SCHEME_ENABLE").uppercased() == "YES"){
                    let dataArray9 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE_FRIEND_TXT"), image: "ic_pf_Invite", id: INVITE_FRIEND, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray9)
                }
                if(userProfileJson.get("ONLYDELIVERALL") != "Yes"){
                    let dataArray10 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMERGENCY_CONTACT"), image: "ic_pf_emr_contact", id: EMERGENCY_CONTACTS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray10)
                }
                
            }else if(i == 1){
                
                if (self.userProfileJson.get("eEmailVerified").uppercased() != "YES" && self.userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES") {
                    let dataArray11 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_VERIFY"), image: "ic_pf_emailvery", id: VERIFY_EMAIL, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray11)
                }
                if  (self.userProfileJson.get("ePhoneVerified").uppercased() != "YES" && self.userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES") {
                    let dataArray12 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MOBILE_VERIFY"), image: "ic_pf_phonevery", id: VERIFY_MOBILE, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray12)
                }

                let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSONAL_DETAILS"), image: "ic_pf_personaldetails", id: PERSONAL_DETAILS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray1)
                let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MANAGE_DOCUMENT"), image: "ic_managedoc", id: MANAGE_DOCUMENT, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray2)
                if(userProfileJson.get("DRIVER_SUBSCRIPTION_ENABLE").uppercased() == "YES"){
                    let dataArray = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_SUBSCRIPTION"), image: "ic_pf_subscribe", id: MY_SUBSCRIPTION, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray)
                }
                let dataArray3 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE_PASSWORD_TXT"), image: "ic_pf_change_password", id: CHANGE_PASSWORD, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray3)
                let dataArray4 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE_CURRENCY"), image: "ic_pf_change_currency", id: CHANGE_CURRENCY, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray4)
                
                let dataArr = GeneralFunctions.getValue(key: Utils.LANGUAGE_LIST_KEY) as! NSArray
                
                if dataArr.count > 1{
                    let dataArray5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE_LANGUAGE"), image: "ic_pf_change_location", id: CHANGE_LANGUAGE, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray5)
                }
                
                // Add Theme Toggle option
                let dataArray7 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "Theme", key: "LBL_CHANGE_THEME"), image: "ic_pf_theme", id: CHANGE_THEME, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray7)
                
                let dataArray6 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "Change Mode", key: "LBL_CHANGE_MODE"), image: "ic_pf_change_currency", id: CHANGE_MODE, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
               /// sectionDataArray.append(dataArray6)
                
            }else if(i == 2){
                
                if(userProfileJson.get("ONLYDELIVERALL") == "Yes" || userProfileJson.get("DELIVERALL") == "Yes"){
                    
                    if (GeneralFunctions.isKeyExistInUserDefaults(key: "IS_LIVE_TASK_AVAILABLE") == true) {
                        let IS_LIVE_TASK_AVAILABLE = GeneralFunctions.getValue(key: "IS_LIVE_TASK_AVAILABLE") as! String
                        if((userProfileJson.get("APP_PAYMENT_MODE").uppercased()) != "CASH" && IS_LIVE_TASK_AVAILABLE != "true" && GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "1"){ /* PAYMENT FLOW CHANGES */
                            let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT_METHOD"), image: "ic_pf_payment_method", id: PAYMENT_METHOD, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                            sectionDataArray.append(dataArray1)
                        }
                    }
                }else{
                    if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "1"){
                        if(userProfileJson.get("APP_PAYMENT_MODE").uppercased() != "CASH"){
                            let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT_METHOD"), image: "ic_pf_payment_method", id: PAYMENT_METHOD, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                            sectionDataArray.append(dataArray1)
                        }
                    }
                }
                
                if((APPSTORE_MODE_IOS != nil && (APPSTORE_MODE_IOS as! String).uppercased() != "REVIEW")){
                    let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BANK_DETAILS_TXT"), image: "ic_pf_bankdetails", id: BANK_DETAILS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray2)
                }
                if(userProfileJson.get("WALLET_ENABLE").uppercased() == "YES"){
                    let dataArray3 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_WALLET"), image: "ic_pf_wallet", id: MY_WALLET, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray3)
                    if(userProfileJson.get("APP_PAYMENT_MODE").uppercased() != "CASH"){
                        let dataArray4 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_MONEY"), image: "ic_pf_wallettopup", id: ADD_MONEY, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                        sectionDataArray.append(dataArray4)
                    }
                    if(userProfileJson.get("ENABLE_GOPAY").uppercased() == "YES"){
                        let dataArray5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_MONEY"), image: "ic_pf_wallet_send", id: SEND_MONEY, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                        sectionDataArray.append(dataArray5)
                    }
                    
                }
                
                if(userProfileJson.get("ENABLE_STRIPE_CONNECT").uppercased() == "YES"){
                    let dataArray6 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STRIPE_CONNECT"), image: "ic_stripe_connect", id: STRIPE_CONNECT, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray6)
                }
              
            }else if(i == 3){
                
                if(userProfileJson.get("showAboutUs").uppercased() == "YES"){
                    let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ABOUT_US_TXT"), image: "ic_pf_aboutus", id: ABOUT_US, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray1)
                }
                
                if(userProfileJson.get("showPrivacyPolicy").uppercased() == "YES"){
                    let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRIVACY_POLICY_TEXT"), image: "ic_pf_privacy", id: PRIVACY_POLICY, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray2)
                }
                
                if(userProfileJson.get("showTermsCondition").uppercased() == "YES"){
                    let dataArray3 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_CONDITION"), image: "ic_pf_terms", id: TERMS_CONDITION, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray3)
                }
                
                let dataArray4 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAQ_TXT"), image: "ic_pf_faq", id: FAQ, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray4)
                
                /* tawk.to chat Addon changes */
                if(userProfileJson.get("ENABLE_DIRECT_CHAT").uppercased() == "YES"){
                    self.configLiveChat()
                    let dataArray5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LIVE_CHAT"), image: "ic_pf_livechat", id: LIVE_CHAT, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray5)
                }
                let dataArray6 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), image: "ic_pf_contactus", id: CONTACT_US, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray6)
            }else{
                
                if(userProfileJson.get("ENABLE_DELETE_ACCOUNT").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                    let cell5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_ACCOUNT"), image: "ic_pf_delete", id: DELETE_ACCOUNT, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(cell5)
                }
                
                let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOGOUT"), image: "ic_pf_logout", id: LOG_OUT, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray1)
            }
            
            self.finalDataArray.add(sectionDataArray)
        }
        
        self.tableView.reloadData()
        if(self.tableViewLastCntOffset != nil){
            self.tableView.setContentOffset(self.tableViewLastCntOffset, animated: false)
        }
//        UIView.transition(with: tableView,
//                          duration: 0.35,
//                          options: .transitionCrossDissolve,
//                          animations:
//            { () -> Void in
//
//        }, completion: nil);
    
    }

    func setData(){
       // self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_TITLE_TXT")
      //  self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_TITLE_TXT")
        
        fNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FIRST_NAME_HEADER_TXT"))
        lNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LAST_NAME_HEADER_TXT"))
        emailTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_LBL_TXT"))
        mobileTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MOBILE_NUMBER_HEADER_TXT"))
        languageTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LANGUAGE_TXT"))
        currencyTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CURRENCY_TXT"))
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        fNameTxtField.setText(text: userProfileJson.get("vName"))
        lNameTxtField.setText(text: userProfileJson.get("vLastName"))
        emailTxtField.setText(text: userProfileJson.get("vEmail"))
//        countryTxtField.setText(text: userProfileJson.get("vCode"))
        mobileTxtField.setText(text: "+\(userProfileJson.get("vCode"))\(userProfileJson.get("vPhone"))")
        languageTxtField.setText(text: userProfileJson.get("vName"))
        currencyTxtField.setText(text: userProfileJson.get("vCurrencyDriver"))
        
        fNameTxtField.setEnable(isEnabled: false)
        lNameTxtField.setEnable(isEnabled: false)
        emailTxtField.setEnable(isEnabled: false)
//        countryTxtField.setEnable(isEnabled: false)
        mobileTxtField.setEnable(isEnabled: false)
        languageTxtField.setEnable(isEnabled: false)
        currencyTxtField.setEnable(isEnabled: false)
        
        fNameTxtField.configDivider(isDividerEnabled: false)
        lNameTxtField.configDivider(isDividerEnabled: false)
        emailTxtField.configDivider(isDividerEnabled: false)
        mobileTxtField.configDivider(isDividerEnabled: false)
        languageTxtField.configDivider(isDividerEnabled: false)
        currencyTxtField.configDivider(isDividerEnabled: false)
        
        fNameTxtField.configHighlighted(isHighLightedEnabled: true)
        lNameTxtField.configHighlighted(isHighLightedEnabled: true)
        emailTxtField.configHighlighted(isHighLightedEnabled: true)
        mobileTxtField.configHighlighted(isHighLightedEnabled: true)
        languageTxtField.configHighlighted(isHighLightedEnabled: true)
        currencyTxtField.configHighlighted(isHighLightedEnabled: true)
        
        userProfilePicBgImgView.sd_setImage(with: URL(string: CommonUtils.user_image_url + GeneralFunctions.getMemberd() + "/" + userProfileJson.get("vImage")), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        usrProfileImgView.sd_setImage(with: URL(string: CommonUtils.user_image_url + GeneralFunctions.getMemberd() + "/" + userProfileJson.get("vImage")), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        Utils.createRoundedView(view: usrProfileImgView, borderColor: UIColor.UCAColor.AppThemeColor_1, borderWidth: 2)
        setLanguage()
        
        editPicAreaView.backgroundColor = UIColor.UCAColor.AppThemeColor_1
        Utils.createRoundedView(view: editPicAreaView, borderColor: UIColor.clear, borderWidth: 0)
        
        GeneralFunctions.setImgTintColor(imgView: editIconImgView, color: UIColor.UCAColor.AppThemeTxtColor_1)
        
        let userProfileImgTapGue = UITapGestureRecognizer()
        userProfileImgTapGue.addTarget(self, action: #selector(self.profilePicTapped))
        
        self.profilePicViewArea.isUserInteractionEnabled = true
        self.profilePicViewArea.addGestureRecognizer(userProfileImgTapGue)
        
        if((userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) && userProfileJson.get("ONLYDELIVERALL") != "Yes"){
            self.PAGE_HEIGHT = 540
            self.serviceDesHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SERVICE_DESCRIPTION")
            self.serviceDesHLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
            self.serviceDesHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            self.serviceDesHLbl.isHidden = false
            self.serviceDesVLbl.isHidden = false
            self.serviceDesVLbl.text = userProfileJson.get("tProfileDescription") == "" ? "--" : userProfileJson.get("tProfileDescription")
            self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.serviceDesVLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 44, font: UIFont.init(name: Fonts().light, size: 16)!)
            
        }
        
    }
    
    @objc func profilePicTapped(){
        
        if(self.userProfileJson.get("ENABLE_EDIT_DRIVER_PROFILE").uppercased() == "NO" && self.userProfileJson.get("vImage") == ""){
            
            self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_IMAGE_BLOCK"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
                self.openImgSelection = OpenImageSelectionOption(uv: self)
                self.openImgSelection.isChooseCategory = false
                self.openImgSelection.show { (isImageUpload) in
                    if(isImageUpload == true){
                        self.setData()
                    }
                }
            })
            return
        }
        
        self.openImgSelection = OpenImageSelectionOption(uv: self)
        self.openImgSelection.isChooseCategory = false
        self.openImgSelection.show { (isImageUpload) in
            if(isImageUpload == true){
                self.setData()
            }
        }
        
        
        
    }
    
    func setLanguage(){
        let dataArr = GeneralFunctions.getValue(key: Utils.LANGUAGE_LIST_KEY) as! NSArray
        
        for i in 0 ..< dataArr.count{
            let tempItem = dataArr[i] as! NSDictionary
            
            self.colorArrayForLang.append(UIColor.init(hexString: tempItem.get("vService_BG_color"), alpha: 1))
            self.colorArrayForTextLang.append(UIColor.init(hexString: tempItem.get("vService_TEXT_color"), alpha: 1))
            
            if((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) == tempItem.get("vCode")){
                languageTxtField.setText(text: tempItem.get("vTitle"))
               
                self.selectedLngCode = tempItem.get("vCode")
                self.selectedLngColor = self.colorArrayForLang[i]
                self.selectedLngTxtColor = self.colorArrayForTextLang[i]
            }
            
            languageNameList += [tempItem.get("vTitle")]
            languageCodes += [tempItem.get("vCode")]
        }
        
        if(dataArr.count < 2){
           
            self.langTxtFieldHeight.constant = 0.0
            self.languageTxtField.isHidden = true
        }
        
        setCurrency()
    }
    
    func setCurrency(){
        let dataArr = GeneralFunctions.getValue(key: Utils.CURRENCY_LIST_KEY) as! NSArray
        
        for i in 0 ..< dataArr.count{
            let tempItem = dataArr[i] as! NSDictionary
            self.colorArrayForCurr.append(UIColor.init(hexString: tempItem.get("vService_BG_color"), alpha: 1))
            self.colorArrayForTextCurr.append(UIColor.init(hexString: tempItem.get("vService_TEXT_color"), alpha: 1))
            if((GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String) == tempItem.get("vName")){
                self.currencyTxtField.setText(text: tempItem.get("vName"))
                self.selectedCurrency = tempItem.get("vName")
                self.selectedCurrColor = self.colorArrayForCurr[i]
                self.selectedCurrTxtColor = self.colorArrayForTextCurr[i]
                
            }
            
            currenyList += [tempItem.get("vName")]
            currencySymboles.append(tempItem.get("vSymbol"))
        }
        
    }
    
    
    func myLableTapped(sender: MyLabel) {
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.finalDataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.finalDataArray[section] as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileTVCell", for: indexPath) as! ProfileTVCell
        cell.selectionStyle = .none
        
        // Get theme manager
        let themeManager = ThemeManager.shared
        
        // Log current theme state for debugging
        print("🎨 Theme Debug - isDarkModeActive: \(themeManager.isDarkModeActive)")
        print("🎨 Current Theme: \(themeManager.currentTheme.rawValue)")
        print("🎨 Card BG Color: \(themeManager.cardBackgroundColor())")
        print("🎨 Text Color: \(themeManager.textColor())")
        
        // FORCE background colors IMMEDIATELY (override XIB) - Use explicit colors
        if themeManager.isDarkModeActive {
            // Dark mode colors
            cell.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1.0) // #2C2C2E
            cell.contentView.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1.0)
        } else {
            // Light mode colors  
            cell.backgroundColor = UIColor.white
            cell.contentView.backgroundColor = UIColor.white
        }
        
        let headerData = self.finalDataArray[indexPath.section] as! [Headline]
        if(headerData[indexPath.row].attributedTitle == NSMutableAttributedString.init(string: "")){
            cell.titleLbl.text = headerData[indexPath.row].title
            
        }else{
            cell.titleLbl.attributedText = headerData[indexPath.row].attributedTitle
        }
        cell.titleLbl.fontFamilyWeight = "Bold"
        cell.titleLbl.setFontFamily()
        
        // FORCE text color
        if themeManager.isDarkModeActive {
            cell.titleLbl.textColor = UIColor.white
        } else {
            cell.titleLbl.textColor = UIColor.black
        }
        
        cell.iconImgView.image = UIImage(named: headerData[indexPath.row].image)
        
        var rightImage = ""
        if(headerData[indexPath.row].rightSideImage == ""){
            rightImage = "ic_arrow_right"
        }else{
            rightImage = headerData[indexPath.row].rightSideImage
        }
        if(Configurations.isRTLMode()){
            cell.nextArrowImgView.image = UIImage(named:rightImage)?.rotate(180)
        }else{
            cell.nextArrowImgView.image = UIImage(named:rightImage)
        }
        
        // Apply theme-aware arrow color
        let arrowColor = themeManager.isDarkModeActive ? UIColor.white.withAlphaComponent(0.6) : UIColor.lightGray
        GeneralFunctions.setImgTintColor(imgView: cell.nextArrowImgView, color: arrowColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 55))
        view.backgroundColor = ThemeManager.shared.backgroundColor()
        
        let label = UILabel.init(frame: CGRect(x:20, y:10, width: tableView.frame.size.width - 40, height: 55 - 10))
        label.font = UIFont.init(name: Fonts().semibold, size: 17)
        label.numberOfLines = 2
        label.textColor = ThemeManager.shared.textColor()
        if(section == 0){
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GENERAL_SETTING").uppercased()
        }else if(section == 1){
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_SETTING").uppercased()
        }else if(section == 2){
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT").uppercased()
        }else if(section == 3){
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUPPORT").uppercased()
        }else{
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OTHER_TXT").uppercased()
        }
        label.textColor = UIColor.UCAColor.AppThemeColor
        view.addSubview(label)
        return view
        
    }
    
    
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableViewLastCntOffset = self.tableView.contentOffset
        let selectedRow = (self.self.finalDataArray[indexPath.section] as! [Headline])[indexPath.row].id
        
        switch selectedRow {
        case MY_BOOKINGS:
            self.openBookings()
            break
        case MANAGE_SERVICES:
           self.openManageVehicles()
            break
        case MANAGE_GALLERY:
            self.openUFXGallery()
            break
        case MY_AVAILABILITY:
            self.openMyAvailability()
            break
        case STATISTICS:
            self.openStatistics()
            break
        case USER_FEEDBACK:
            self.openFeedback()
            break
        case WAY_BILL:
            openWayBill()
            break
        case NOTIFICATIONS:
           openNotifications()
            break
        case INVITE_FRIEND:
            self.openInviteFriends()
            break
        case EMERGENCY_CONTACTS:
            self.openEmeContact()
            break
        case VERIFY_MOBILE:
            AccountVerification(isMobile: true)
            break
        case VERIFY_EMAIL:
            AccountVerification(isMobile: false)
            break
        case PERSONAL_DETAILS:
            editProfileTapped()
            break
        case MANAGE_DOCUMENT:
            openYourDocument()
            break
        case MY_SUBSCRIPTION:
            openSubscription()
            break
        case CHANGE_PASSWORD:
            openChangePassword()
            break
        case CHANGE_CURRENCY:
            changeCurrencyTapped()
            break
        case CHANGE_MODE:
            changeModeTapped()
            break
        case CHANGE_LANGUAGE:
            changeLanguageTapped()
            break
        case CHANGE_THEME:
            changeThemeTapped()
            break
        case PAYMENT_METHOD:
            openPayment()
            break
        case BANK_DETAILS:
            openBankDetails()
            break
        case MY_WALLET:
            self.openMyWallet()
            break
        case ADD_MONEY:
            self.openMyWallet(true, false)
            break
        case SEND_MONEY:
            self.openMyWallet(false, true)
            break
        case STRIPE_CONNECT:
            self.openStripeConnect()
            break
        case ABOUT_US:
            openAbout()
            break
        case PRIVACY_POLICY:
            openPrivacy()
            break
        case TERMS_CONDITION:
            openTerms()
            break
        case FAQ:
            openHelp()
            break
        case LIVE_CHAT:
            self.openLiveChat()
            break
        case CONTACT_US:
            openContactUs()
            break
        case LOG_OUT:
            self.signOutTapped()
            break
        case DELETE_ACCOUNT :
            self.openDeleteAccount()
            break
        default:
            break
        }
    }
    
    func openStripeConnect(){
        /* stripe connect Addon changes */
        let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
        staticPageUV.STATIC_PAGE_ID = "6"
        staticPageUV.viewProfileUV = self
        self.pushToNavController(uv: staticPageUV)
    }
    
    
    func openDeleteAccount(){
        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WANT_DEL_ACCOUNT_APP_TXT"), positiveBtn:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: {(btnClickedId) in
            if(btnClickedId == 0){
                
                let parameters = ["type":"sendContactQuery", "UserType": Utils.appUserType, "UserId": GeneralFunctions.getMemberd(),"message": self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_ACCOUNT_MSG_REQUEST") , "subject": self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_ACCOUNT_SUBJECT_REQUEST") ,"isDeleteAccount" : "Yes"]
                
                let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
                exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
                exeWebServerUrl.currInstance = exeWebServerUrl
                exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                    
                    if(response != ""){
                        let dataDict = response.getJsonDataDict()
                        if(dataDict.get("Action") == "1"){
                            
                            self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_DELETE_QUERY_SUCCESS_TXT") , positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                                self.logOut()
                            })
                        }
                    }else{
                        self.generalFunc.setError(uv: self)
                    }
                })
                
            }
            if(btnClickedId == 1){
            }
        })
        
    }
    
    func logOut(){
        
        let window = UIApplication.shared.delegate!.window!
        
        let parameters = ["type":"callOnLogout", "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                
                GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                
                GeneralFunctions.logOutUser()
                GeneralFunctions.restartApp(window: window!)
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func openBookings(){
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
            
            if(userProfileJson.get("ONLYDELIVERALL") == "Yes"){
                let orderUV = GeneralFunctions.instantiateViewController(pageName: "BookingsUV") as! BookingsUV
                orderUV.PAGE_TYPE = "ORDER"
                orderUV.homeTabBar = self.homeTabBar
                orderUV.isFromViewProfile = true
                orderUV.navItem = self.navigationItem
                self.pushToNavController(uv: orderUV)
                
            }else{
                let bookingTabUV = GeneralFunctions.instantiateViewController(pageName: "BookingTabUV") as! BookingTabUV
                bookingTabUV.isFromViewProfile = true
                self.pushToNavController(uv: bookingTabUV)
            }
        }else{
            let bookingUV = GeneralFunctions.instantiateViewController(pageName: "BookingsUV") as! BookingsUV
            bookingUV.PAGE_TYPE = "BOOKING"
            bookingUV.homeTabBar = self.homeTabBar
            bookingUV.isFromViewProfile = true
            bookingUV.navItem = self.navigationItem
            self.pushToNavController(uv: bookingUV)
        
        }
        
        
    }
    
    func openManageVehicles(){
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("eShowVehicles").uppercased() == "NO" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes")){
           
        }else if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("eShowVehicles").uppercased() == "YES" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
            let appTypeSelectionUv = GeneralFunctions.instantiateViewController(pageName: "AppTypeSelectionUV") as! AppTypeSelectionUV
            appTypeSelectionUv.screenToNavigate = "MANAGE_VEHICLE"
            self.pushToNavController(uv: appTypeSelectionUv)
        }else{
            let manageVehiclesUV = GeneralFunctions.instantiateViewController(pageName: "ManageVehiclesUV") as! ManageVehiclesUV
            self.pushToNavController(uv: manageVehiclesUV)
        }
    }
    
    func openSubscription(){
        let subscriptionUV = GeneralFunctions.instantiateViewController(pageName: "SubscriptionUV") as! SubscriptionUV
       self.pushToNavController(uv: subscriptionUV)
    }
    
    func openWayBill(){
        if(self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"){
            let wayBillMultiUV = GeneralFunctions.instantiateViewController(pageName: "WayBillMultiUV") as! WayBillMultiUV
            self.pushToNavController(uv: wayBillMultiUV)
        }else{
            let wayBillUV = GeneralFunctions.instantiateViewController(pageName: "WayBillUV") as! WayBillUV
            self.pushToNavController(uv: wayBillUV)
        }
    }
    
    func openMyAvailability(){
    }
    
    func openUFXGallery(){
    }
    
    func openStatistics(){
        if(userProfileJson.get("ONLYDELIVERALL") != "Yes"){
            if(userProfileJson.get("DELIVERALL") == "Yes"){
                let statisticsTabUV = GeneralFunctions.instantiateViewController(pageName: "StatisticsTabUV") as! StatisticsTabUV
                self.pushToNavController(uv: statisticsTabUV)
            }else{
                let statisticsUV = GeneralFunctions.instantiateViewController(pageName: "StatisticsUV") as! StatisticsUV
                self.pushToNavController(uv: statisticsUV)
            }
        }
    }
    
    /* Notofication Code*/
    func openNotifications(){
        let notificationsTabUV = GeneralFunctions.instantiateViewController(pageName: "NotificationsTabUV") as! NotificationsTabUV
        self.pushToNavController(uv: notificationsTabUV)
        
    }/* Notofication Code*/

    
    func AccountVerification(isMobile:Bool) {
        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
        accountVerificationUv.isForMobile = isMobile
        self.pushToNavController(uv: accountVerificationUv)
    }
    
    func openFeedback(){
        
        let feedbackUV = GeneralFunctions.instantiateViewController(pageName: "DriverFeedBackUV") as! DriverFeedBackUV
        self.pushToNavController(uv:feedbackUV)
        
    }
    
    func openInviteFriends(){
        if GeneralFunctions.getMemberd() == ""
        {
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            self.pushToNavController(uv: uv)
        }else
        {
            let inviteFriendsUv = GeneralFunctions.instantiateViewController(pageName: "InviteFriendsUV") as! InviteFriendsUV
            self.pushToNavController(uv:inviteFriendsUv)
        }
    }
    
    func openEmeContact(){
        
        let emergencyContactsUv = GeneralFunctions.instantiateViewController(pageName: "EmergencyContactsUV") as! EmergencyContactsUV
        self.pushToNavController(uv:emergencyContactsUv)
    }
    
    func openChangePassword(){
        //        ChangePasswordView
        let openChangePassword = OpenChangePassword(uv: self, containerView: self.contentView, vPassword: userProfileJson.get("vPassword"), userProfileJson: self.userProfileJson, SITE_TYPE_DEMO_MSG: userProfileJson.get("SITE_TYPE_DEMO_MSG"))
        openChangePassword.show()
        openChangePassword.setViewHandler { (isPasswordCange) in
            if(isPasswordCange == true){
                self.setData()
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INFO_UPDATED_TXT"), uv: self)
            }
        }
    }
   
    func lngValueChanged(selectedItemId:Int){
        self.selectedLngCode = self.languageCodes[selectedItemId]
        self.updateProfile()
        
        if(self.openListView != nil){
            self.openListView.bgView.isUserInteractionEnabled = true
            self.openListView.newListView.isUserInteractionEnabled = true
            self.openListView.startLoading = false
            self.openListView.newListView.tableView.reloadData()
            self.openListView.closeNewListView()
        }
    }
    
  
    func changeLanguageTapped(){
        
        self.openListView = OpenListView(uv: nil, containerView: self.view)
        self.openListView.openNewList = true
        self.openListView.viewProfileUV = self
        self.openListView.newListCodeString = self.languageCodes
        self.openListView.colorArray = self.colorArrayForLang
        self.openListView.textColorArray = self.colorArrayForTextLang
        self.openListView.selectedItem = (GeneralFunctions.getValue(key: Utils.DEFAULT_LANGUAGE_TITLE_KEY) as! String).uppercased()
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        let dataArr = GeneralFunctions.getValue(key: Utils.LANGUAGE_LIST_KEY) as! NSArray
        for i in 0 ..< dataArr.count{
            let tempItem = dataArr[i] as! NSDictionary
            if((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) == tempItem.get("vCode")){
                openListView.selectedItem = tempItem.get("vTitle")
            }
        }
        self.openListView.show(listObjects: self.languageNameList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_LANGUAGE_HINT_TXT"), currentInst: self.openListView, handler: { (selectedItemId) in
            self.lngValueChanged(selectedItemId: selectedItemId)
        })
    }
    
    func changeThemeTapped() {
        let alert = UIAlertController(title: self.generalFunc.getLanguageLabel(origValue: "Theme", key: "LBL_CHANGE_THEME"), message: self.generalFunc.getLanguageLabel(origValue: "Select your preferred theme", key: "LBL_SELECT_THEME"), preferredStyle: .actionSheet)
        
        let lightAction = UIAlertAction(title: self.generalFunc.getLanguageLabel(origValue: "Light", key: "LBL_THEME_LIGHT"), style: .default) { _ in
            ThemeManager.shared.currentTheme = .light
        }
        
        let darkAction = UIAlertAction(title: self.generalFunc.getLanguageLabel(origValue: "Dark", key: "LBL_THEME_DARK"), style: .default) { _ in
            ThemeManager.shared.currentTheme = .dark
        }
        
        let cancelAction = UIAlertAction(title: self.generalFunc.getLanguageLabel(origValue: "Cancel", key: "LBL_CANCEL_TXT"), style: .cancel, handler: nil)
        
        // Add checkmark to current selection
        let currentTheme = ThemeManager.shared.currentTheme
        switch currentTheme {
        case .light:
            lightAction.setValue(true, forKey: "checked")
        case .dark:
            darkAction.setValue(true, forKey: "checked")
        }
        
        alert.addAction(lightAction)
        alert.addAction(darkAction)
        alert.addAction(cancelAction)
        
        // For iPad support
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openBankDetails(){
        let bankDetailsUV = GeneralFunctions.instantiateViewController(pageName: "BankDetailsUV") as! BankDetailsUV
        self.pushToNavController(uv: bankDetailsUV)
    }
    
    func changeModeTapped() {

        let modeList = ["Light", "Dark"]
        let modeCodes = ["light", "dark"]

        self.openListView = OpenListView(uv: nil, containerView: self.view)
        self.openListView.openNewList = true
        self.openListView.viewProfileUV = self
        self.openListView.newListCodeString = modeCodes
        self.openListView.isForMode = true
        let currentStyle = UserDefaults.standard.string(forKey: "APP_THEME") ?? "light"
        self.openListView.selectedItem = currentStyle == "dark" ? "Dark" : "Light"

        self.openListView.show(
            listObjects: modeList,
            title: "Select Mode",
            currentInst: self.openListView
        ) { selectedItemId in
            self.modeValueChanged(selectedItemId: selectedItemId)
        }
    }

    func modeValueChanged(selectedItemId: Int) {

        let modeList = ["Light", "Dark"]
        let selectedItem = modeList[selectedItemId]
        let modeLower = selectedItem.lowercased()

        // Save selection
        UserDefaults.standard.set(modeLower, forKey: "APP_THEME")

        // Apply mode immediately
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = modeLower == "dark" ? .dark : .light

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.overrideUserInterfaceStyle = modeLower == "dark" ? .dark : .light
            }
        }

    }


    
    func changeCurrencyTapped(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
     
        self.openListView = OpenListView(uv: nil, containerView: self.view)
        self.openListView.openNewList = true
        self.openListView.viewProfileUV = self
        self.openListView.newListCodeString = self.currencySymboles
        self.openListView.colorArray = self.colorArrayForCurr
        self.openListView.textColorArray = self.colorArrayForTextCurr
        self.openListView.isForCurrency = true
        if GeneralFunctions.getMemberd() == "" {
             openListView.selectedItem =  (GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String)
        }else {
            openListView.selectedItem = userProfileJson.get("vCurrencyDriver")
        }
        self.openListView.show(listObjects: self.currenyList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CURRENCY"), currentInst: self.openListView, handler: { (selectedItemId) in
            self.currencyValueChanged(selectedItemId: selectedItemId)
        })
    }
    
    func currencyValueChanged(selectedItemId:Int){
        
        self.selectedCurrency = self.currenyList[selectedItemId]
        self.updateProfile()
        
        self.selectedCurrColor = self.colorArrayForCurr[selectedItemId]
        self.selectedCurrTxtColor = self.colorArrayForTextCurr[selectedItemId]
        self.selectedCurrency = self.currenyList[selectedItemId]
        self.currencyTxtField.setText(text: self.selectedCurrency.uppercased())
        GeneralFunctions.saveValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY, value: self.selectedCurrency as AnyObject)
        
    }
    
    func openPayment(){
        let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
        self.pushToNavController(uv: paymentUV)
    }
    
    func openMyWallet(_ isOpenAddMoney:Bool = false, _ isOpenSendMoney:Bool = false) {
        
        if GeneralFunctions.getMemberd() == ""
        {
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            self.pushToNavController(uv: uv)
        }else
        {
            let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
//            if(isOpenAddMoney == true){
//                manageWalletUV.isOpenAddMoney = true
//            }
//            if(isOpenSendMoney == true){
//                manageWalletUV.isOpenSendMoney = true
//            }
            self.pushToNavController(uv: manageWalletUV)
            
        }
        
    }
    
    func openYourDocument(){
        
        let listOfDocumentUV = GeneralFunctions.instantiateViewController(pageName: "ListOfDocumentUV") as! ListOfDocumentUV
        self.pushToNavController(uv:listOfDocumentUV)
    }
    
    
    func openAbout(){
        let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
        staticPageUV.STATIC_PAGE_ID = "1"
        self.pushToNavController(uv: staticPageUV)
    }
    
    func openPrivacy(){
        let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
        staticPageUV.STATIC_PAGE_ID = "64"
        self.pushToNavController(uv: staticPageUV)
    }
    
    func openTerms(){
        let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
        staticPageUV.STATIC_PAGE_ID = "63"
        self.pushToNavController(uv: staticPageUV)
    }
    
    func openContactUs(){
        let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
        self.pushToNavController(uv: contactUsUv)
    }
    
    func openHelp(){        
        let helpUv = GeneralFunctions.instantiateViewController(pageName: "HelpUV") as! HelpUV
        self.pushToNavController(uv: helpUv)
    }
    
    func updateProfile(){
        let parameters = ["type":"updateUserProfileDetail","vName": userProfileJson.get("vName"), "vLastName": userProfileJson.get("vLastName"), "vEmail": userProfileJson.get("vEmail"), "vPhone": userProfileJson.get("vPhone"), "vPhoneCode": userProfileJson.get("vCode"), "vCountry": userProfileJson.get("vCountry"), "vDeviceType": Utils.deviceType, "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "LanguageCode": selectedLngCode, "CurrencyCode": self.selectedCurrency, "tProfileDescription":"", "eSelectWorkLocation": ""]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    _ = SetUserData(uv: self, userProfileJson: dataDict, isStoreUserId: false)
                    
                    let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    
                    let vCurrencyDriver = userProfileJson.get("vCurrencyDriver")
                    let vLang = userProfileJson.get("vLang")
                    
                    if(vLang != self.selectedLngCode || vCurrencyDriver != self.selectedCurrency){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_TRIP_CANCEL_CONFIRM_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFY_RESTART_APP_TO_CHANGE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            let window = UIApplication.shared.delegate!.window!
                            
                            GeneralFunctions.restartApp(window: window!)
                        })
                        
                        return
                    }
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    //                    self.manageProfileUv!.openViewProfileUv()
                    //                    if(self.manageProfileUv.isFromAccountVerifyScreen == true){
                    //                        self.manageProfileUv!.performSegue(withIdentifier: "unwindToAccountVerificationScreen", sender: self.manageProfileUv)
                    //                    }else{
                    //                        self.manageProfileUv!.openViewProfileUv()
                    //                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    
    func signOutTapped(){
        
        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOGOUT"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WANT_LOGOUT_APP_TXT"), positiveBtn:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: {(btnClickedId) in
            if(btnClickedId == 0){
             
                let window = UIApplication.shared.delegate!.window!
                
                let parameters = ["type":"callOnLogout", "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
                
                let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
                exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
                exeWebServerUrl.currInstance = exeWebServerUrl
                exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                    
                    if(response != ""){
                        
                        GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                        
                        GeneralFunctions.logOutUser()
                        GeneralFunctions.restartApp(window: window!)
                        
                    }else{
                        self.generalFunc.setError(uv: self)
                    }
                })
                
            }
            if(btnClickedId == 1){
            }
        })
    }
    
    func openGenderView(){
        
        genderView = self.generalFunc.loadView(nibName: "GenderView", uv: self, isWithOutSize: true)
        
        genderView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height)
        
        Application.window!.addSubview(genderView)
        
        let closeTapGue = UITapGestureRecognizer()
        closeTapGue.addTarget(self, action: #selector(self.closeGenderView))
        
        self.genderVCloseImgView.isUserInteractionEnabled = true
        self.genderVCloseImgView.addGestureRecognizer(closeTapGue)
        
        self.genderHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Select your gender to continue", key: "LBL_SELECT_GENDER")
        self.maleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Male", key: "LBL_MALE_TXT")
        self.femaleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Female", key: "LBL_FEMALE_TXT")
        GeneralFunctions.setImgTintColor(imgView: self.genderVCloseImgView, color: UIColor.white)
        
        self.maleImgView.image = self.maleImgView.image?.addImagePadding(x: 25, y: 25)
        self.femaleImgView.image = self.femaleImgView.image?.addImagePadding(x: 25, y: 25)
        Utils.createRoundedView(view: self.maleImgView, borderColor: UIColor(hex: 0xF1F1F1), borderWidth: 4)
        Utils.createRoundedView(view: self.femaleImgView, borderColor: UIColor(hex: 0xF1F1F1), borderWidth: 4)
        
        let maleTapGue = UITapGestureRecognizer()
        maleTapGue.addTarget(self, action: #selector(self.maleImgTapped))
        
        self.maleImgView.isUserInteractionEnabled = true
        self.maleImgView.addGestureRecognizer(maleTapGue)
        
        let femaleTapGue = UITapGestureRecognizer()
        femaleTapGue.addTarget(self, action: #selector(self.femaleImgTapped))
        
        self.femaleImgView.isUserInteractionEnabled = true
        self.femaleImgView.addGestureRecognizer(femaleTapGue)
    }
    
    @objc func maleImgTapped(){
        
        self.closeGenderView()
        updateUserGender(eGender: "Male")
    }
    
    @objc func femaleImgTapped(){
        self.closeGenderView()
        updateUserGender(eGender: "Female")
    }
    
    @objc func closeGenderView(){
        if(self.genderView != nil){
            self.genderView.removeFromSuperview()
        }
    }
    
    func updateUserGender(eGender:String){
        
        let parameters = ["type":"updateUserGender", "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "eGender": eGender]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            print("Response:\(response)")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    
                    self.userProfileJson = userProfileJson
                    
                    self.setNavItems()
                    
                    // NEW CHANGES AS PER ANDROID
                    let FEMALE_RIDE_REQ_ENABLE = self.userProfileJson.get("FEMALE_RIDE_REQ_ENABLE")
                    if(FEMALE_RIDE_REQ_ENABLE.uppercased() != "YES" || self.userProfileJson.get("eGender") == "Male"){}else{
                        if(self.userProfileJson.get("eGender") == "" && FEMALE_RIDE_REQ_ENABLE.uppercased() == "YES"){}else{
                            let setPreferencesUV = GeneralFunctions.instantiateViewController(pageName: "SetPreferencesUV") as! SetPreferencesUV
                            self.pushToNavController(uv: setPreferencesUV)
                        }
                        
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    /* Live Chat Settings .*/
    func configLiveChat(){
        LiveChat.licenseId = userProfileJson.get("LIVE_CHAT_LICENCE_NUMBER")
        LiveChat.name = userProfileJson.get("vName") + " " + userProfileJson.get("vLastName")
        LiveChat.email = userProfileJson.get("vEmail")
        LiveChat.setVariable(withKey:"FNAME", value:userProfileJson.get("vName"))
        LiveChat.setVariable(withKey:"LNAME", value:userProfileJson.get("vLastName"))
        LiveChat.setVariable(withKey:"EMAIL", value:userProfileJson.get("vEmail"))
        LiveChat.setVariable(withKey:"USERTYPE", value:Utils.appUserType)
        
        LiveChat.delegate = self
    }
    
    // MARK: LiveChatDelegate
    func received(message: LiveChatMessage) {
        if (!LiveChat.isChatPresented) {
            // Notifying user
            let alert = UIAlertController(title: "Support", message: message.text, preferredStyle: .alert)
            let chatAction = UIAlertAction(title: "Go to Chat", style: .default) { alert in
                // Presenting chat if not presented:
                if !LiveChat.isChatPresented {
                    LiveChat.presentChat()
                }
            }
            alert.addAction(chatAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    /* Live Chat Settings .*/
    func openLiveChat(){
//        LiveChat.presentChat()
        
        /* tawk.to chat Addon changes */
        let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
        staticPageUV.STATIC_PAGE_ID = "5"
        staticPageUV.chatURL = self.userProfileJson.get("DIRECT_CHAT_LINK")
        self.pushToNavController(uv: staticPageUV)
    }
    
    @objc func clearChat(){
        LiveChat.clearSession()
        LiveChat.dismissChat()
        btnClearsession.removeFromSuperview()
    }
    
    let btnClearsession = UIButton(frame: CGRect(60 , 25, 60, 60))

    func closeLiveChatSetup(){
        
        btnClearsession.frame.origin.x = (self.view.frame.size.width - 70)
        btnClearsession.setImage(UIImage(named: "ic_close_detail"), for: .normal)

        GeneralFunctions.setImgTintColor(imgView: btnClearsession.imageView!, color: UIColor(hex: 0x000000))
        btnClearsession.backgroundColor = .white
        btnClearsession.addTarget(self, action: #selector(clearChat), for: .touchUpInside)
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(btnClearsession)
    }/* Live Chat Settings .*/
    
    
    
    func openVerifyView(){
        
        let openUserPreferences = OpenUserPreferences(uv: self, containerView: Application.window!)
        openUserPreferences.isShowCancel = true
        openUserPreferences.isFromEmailVerify = true
        openUserPreferences.show(preferenceDescription: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_VERIFY_NOTE_TXT"), self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_VERIFY"))
    }
    
    func showSuccess(){
        Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STRIPE_CONNECT_ACCOUNT_CREATED"), uv: self)
    }
    
    
}
 
