//
//  DriverStatesUV.swift
//  DriverApp
//
//  Created by ADMIN on 19/06/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class DriverStatesUV: UIViewController, UITableViewDelegate, UITableViewDataSource, MyBtnClickDelegate {

    @IBOutlet weak var checkAccStatusBtn: MyButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var bottomViewBottomSpace: NSLayoutConstraint!
    
    
    var window:UIWindow!
    
    let generalFunc = GeneralFunctions()
    
    var numOfItems = 0
    
    var selectedRow = -1
    
    var statusOfStates = [Bool]()
    
    var loaderView:UIView!
    
    var userProfileJson:NSDictionary!
    
    var isPageLoaded = false
    var cntView:UIView!
    
    var isSafeAreaSet = false
    
    var inCompleteDialog:MTDialog!
    var completeDialog:MTDialog!
    
    var currExeWebServerUrl:ExeServerUrl!

    var totalAddedVehicles : Int = 0
    
    var accountActivatedView : UIView!
    var accountActivatedbgView : UIView!
    
    var homeTabBar:HomeScreenTabBarUV!
    
    var kBarHeight:CGFloat = 44
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        if(statusOfStates.count > 0 && self.completeDialog == nil){
            reloadData(isFromCheckBtn: false)
        }
        
//        self.navigationController?.navigationBar.tintColor = UIColor(hex: 0x33b4ff)
//        self.navigationController?.navigationBar.barTintColor = UIColor(hex: 0x33b4ff)
        
//        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
        self.setnavBarTintColor(color: UIColor(hex: 0x15ADDE))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.UCAColor.AppThemeColor
        self.navigationController?.navigationBar.barTintColor = UIColor.UCAColor.AppThemeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "DriverStatesScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        window = Application.window!

        self.tableView.contentInset = UIEdgeInsets.init(top: 6, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 6, right: 0)

        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {}
        
        self.tableView.register(UINib(nibName: "DriverStateTVCell", bundle: nil), forCellReuseIdentifier: "DriverStateTVCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.bounces = false
        self.tableView.showsVerticalScrollIndicator = false

        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.userProfileJson = userProfileJson
        
        showLoader()
        
        checkAccStatusBtn.setButtonTitle(buttonTitle: generalFunc.getLanguageLabel(origValue: "Check Account Status", key: "LBL_CHECK_ACC_STATUS"))
        checkAccStatusBtn.clickDelegate = self
        
        self.checkAccStatusBtn.isHidden = true
        self.bottomView.isHidden = true
        
        GeneralFunctions.removeValue(key: "GO_ONLINE")
        
        if #available(iOS 15.0, *) {
            if self.homeTabBar != nil {
                //(GeneralFunctions.getSafeAreaInsets().bottom > 0 ? (GeneralFunctions.getSafeAreaInsets().bottom - 15) : 20)
                self.bottomViewBottomSpace.constant = kBarHeight + (GeneralFunctions.getSafeAreaInsets().bottom > 0 ? 50 : 0) //GeneralFunctions.getSafeAreaInsets().bottom //self.homeTabBar.tabBar.frame.size.height
            }
        }else{
            self.bottomViewBottomSpace.constant = 0
        }
        
//        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        self.setnavBarTintColor(color: UIColor(hex: 0x15ADDE))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoaded == false){
//            DispatchQueue.main.async {
//            }
            loadData(isFromCheckBtn: false)
            isPageLoaded = true
        }
        
        let navHeight = 64
        let width = ((navHeight * 350) / 119)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: ((width * 119) / 350)))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "ic_your_logo")
        imageView.image = image
          if self.homeTabBar != nil {
            self.homeTabBar.navItem.titleView = imageView
            let rightView = UIView.init(frame: CGRect(x:0, y:0, width:28, height: 28))
            let rightImageView = UIImageView.init(frame: rightView.bounds)
            rightImageView.image = UIImage(named: "ic_notification_bell")!.tint(with: UIColor.UCAColor.AppThemeTxtColor)
            rightView.addSubview(rightImageView)
            rightView.setOnClickListener { (instance) in
                self.notificationTapped()
            }
            self.homeTabBar.navItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightView)
            
            let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
            self.homeTabBar.navItem.leftBarButtonItem = leftButton
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            if(cntView != nil){
                self.cntView.frame = self.view.frame

                if(GeneralFunctions.getSafeAreaInsets().bottom == 0){
                    cntView.frame.size.height = self.cntView.frame.size.height - self.homeTabBar.tabBar.height + GeneralFunctions.getSafeAreaInsets().bottom + 40
                }else{
                    cntView.frame.size.height = self.cntView.frame.size.height - self.homeTabBar.tabBar.height + GeneralFunctions.getSafeAreaInsets().bottom + 60
                }

//                cntView.frame.size.height = cntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
                
                self.bottomView.backgroundColor = UIColor.clear
                
                self.bottomViewHeight.constant = GeneralFunctions.getSafeAreaInsets().bottom / 2
            }
            
            isSafeAreaSet = true
        }
    }
    
    deinit {
        releaseAllTask()
    }
    
    func reloadData(isFromCheckBtn:Bool){
        loadData(isFromCheckBtn: isFromCheckBtn)
    }
    
    func showLoader(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
            loaderView.isHidden = false
        }else{
            loaderView.isHidden = false
        }
    }

    @objc func notificationTapped(){
        let notificationsTabUV = GeneralFunctions.instantiateViewController(pageName: "NotificationsTabUV") as! NotificationsTabUV
        self.pushToNavController(uv: notificationsTabUV)
    }
    
    func loadData(isFromCheckBtn:Bool){
    
        if(currExeWebServerUrl != nil){
            currExeWebServerUrl.cancel()
        }
        if(self.statusOfStates.count == 0){
            showLoader()
        }
        
        let parameters = ["type":"getDriverStates","UserType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: isFromCheckBtn)
        currExeWebServerUrl = exeWebServerUrl
        
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.loaderView.isHidden = true
            self.checkAccStatusBtn.isHidden = false
            self.bottomView.isHidden = false
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.statusOfStates.removeAll()
                    self.numOfItems = 0
                    self.tableView.reloadData()
                    
                    self.statusOfStates += [true]
                    
                    self.totalAddedVehicles = GeneralFunctions.parseInt(origValue: 0, data: dataDict.get("TotalVehicles"))
                    
                    if(dataDict.get("IS_DOCUMENT_PROCESS_COMPLETED") != "Yes"){
                        self.statusOfStates += [false]
                    }else{
                        self.statusOfStates += [true]
                    }
                    
                    if(dataDict.get("IS_VEHICLE_PROCESS_COMPLETED") != "Yes"){
                        self.statusOfStates += [false]
                    }else{
                        self.statusOfStates += [true]
                    }
                    
                    if((self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                        if(dataDict.get("IS_DRIVER_MANAGE_TIME_AVAILABLE") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                            self.statusOfStates += [false]
                        }else{
                            self.statusOfStates += [true]
                        }
                        self.numOfItems = 5
                    }else{
                        self.numOfItems = 4
                    }
                    
                    if(dataDict.get("IS_DRIVER_STATE_ACTIVATED") != "Yes"){
                        self.statusOfStates += [false]
                    }else{
                        self.statusOfStates += [true]
                    }
                    
                    var isAllCompleted = true

                    for i in 0..<self.statusOfStates.count{
                        if(self.statusOfStates[i] == false){
                            isAllCompleted = false
                            break
                        }
                    }
                    
                    self.tableView.reloadData()
                    self.tableView.reloadData()
                    if(isFromCheckBtn == true && isAllCompleted == false){
                        if(self.inCompleteDialog != nil){
                            self.inCompleteDialog.disappear()
                            self.inCompleteDialog = nil
                        }
                        self.inCompleteDialog = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please wait for admin's approval if you have completed all required steps.", key: "LBL_DRIVER_STATUS_INCOMPLETE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                        })
                    }
                    
                    
                    if(isFromCheckBtn == true && isAllCompleted == true){
                        self.loadAccountActivatedView()
                        return
                    }
                    
                    if(isAllCompleted == true){
                        let window = Application.window!
                        
                        let getUserData = GetUserData(uv: self, window: window)
                        getUserData.getdata()
                        return
                    }

                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                        
                        if(btnClickedIndex == 0){
                            self.loadData(isFromCheckBtn: isFromCheckBtn)
                        }
                        
                    })
                }
                
            }else{
                if(isFromCheckBtn){
                    self.generalFunc.setError(uv: self)
                }
//                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
//
//                    self.loadData()
//                })
            }
            
        })
    }
    
    func loadAccountActivatedView(){
        accountActivatedView = self.generalFunc.loadView(nibName: "AccountActivatedView", uv: self, isWithOutSize: true)
        
        let width = Application.screenSize.width > 380 ? 370 : Application.screenSize.width - 50
        
        let accountActivatedLblHeight = self.generalFunc.getLanguageLabel(origValue: "Your account has been activated.", key: "LBL_DRIVER_STATUS_COMPLETE").height(withConstrainedWidth: width - 30, font: UIFont (name: Fonts().semibold, size: 21)!) - 26
        
        accountActivatedView.frame.size = CGSize(width: width, height: 388 + accountActivatedLblHeight)
        accountActivatedView.center = CGPoint(x: self.contentView.frame.width / 2, y: Application.screenSize.height / 2)
        
        accountActivatedbgView = UIView()
        accountActivatedbgView.frame = CGRect(x:0, y:0, width: self.contentView.frame.width, height: Application.screenSize.height)
        accountActivatedbgView.center = CGPoint(x: self.contentView.frame.width / 2, y: Application.screenSize.height / 2)
        accountActivatedbgView.backgroundColor = UIColor.black
        accountActivatedbgView.isUserInteractionEnabled = true
        
        accountActivatedView.layer.shadowOpacity = 0.5
        accountActivatedView.layer.shadowOffset = CGSize(width: 0, height: 3)
        accountActivatedView.layer.shadowColor = UIColor.black.cgColor
        
        let currentWindow = Application.window
        currentWindow?.addSubview(accountActivatedbgView)
        currentWindow?.addSubview(accountActivatedView)
        
        accountActivatedbgView.alpha = 0
        accountActivatedView.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.accountActivatedbgView.alpha = 0.4
                self.accountActivatedView.alpha = 1
                
        }
        )
        Utils.createRoundedView(view: accountActivatedView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        (accountActivatedView.subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "Your account has been activated.", key: "LBL_DRIVER_STATUS_COMPLETE")
        (accountActivatedView.subviews[1] as! MyLabel).fitText()
        
        (accountActivatedView.subviews[2] as! MyButton).setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"))
        (accountActivatedView.subviews[2] as! MyButton).btnType = "ACCOUNT_ACTIVATED_OK"
        (accountActivatedView.subviews[2] as! MyButton).clickDelegate = self
        
        
    }

    func releaseAllTask(){
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverStateTVCell", for: indexPath) as! DriverStateTVCell
        
        cell.actionLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        cell.actionLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        if Configurations.isRTLMode(){
        
        cell.actionLbl.roundCorners([.bottomRight, .topRight], radius: 4)
            //cell.actionLbl.paddingRight = 3
            //cell.actionLbl.paddingLeft = 3
            
        }else{
        cell.actionLbl.roundCorners([.bottomLeft, .topLeft], radius: 4)
        }
       
        //DispatchQueue.main.async {
             //cell.actionLblWidth.constant = cell.actionLbl.frame.width + 5
        //}
        if(indexPath.item == 0) {
            cell.stateNumLbl.isHidden = true
            cell.stateFinishedImgView.isHidden = false
            cell.topSeperatorView.isHidden = true
        }else{
            cell.stateNumLbl.isHidden = false
            cell.stateFinishedImgView.isHidden = true
            cell.topSeperatorView.isHidden = false
        }
        
        switch indexPath.item {
        case 0:
            cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Registration Successful", key: "LBL_REGISTRATION_SUCCESS")
            cell.actionLbl.isHidden = true
            if Configurations.isRTLMode(){
                cell.stateNoteLbl.textAlignment = .right
                cell.stateTitleLbl.textAlignment = .right
            }else{
                cell.stateNoteLbl.textAlignment = .left
                cell.stateTitleLbl.textAlignment = .left
            }
            break
            
        case 1:
            cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Upload your documents", key: "LBL_UPLOAD_YOUR_DOCS")
            if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("ONLYDELIVERALL") != "Yes"){
                cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPLOAD_DOCS_NOTE")
            }else{
                cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "We need to verify your driving documents to activate your account.", key: "LBL_UPLOAD_YOUR_DOCS_NOTE")
            }
            
            
            
            cell.actionLbl.text = self.generalFunc.getLanguageLabel(origValue: "Upload Document", key: "LBL_UPLOAD_DOC")
            cell.actionLbl.isHidden = false
            cell.actionLbl.lblType = "UPLOAD_DOC"
            
            if(statusOfStates[indexPath.item] == true){
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Documents uploaded successfully.", key: "LBL_UPLOADDOC_SUCCESS")
                cell.actionLbl.isHidden = true
            }
            if Configurations.isRTLMode(){
                cell.stateNoteLbl.textAlignment = .right
                cell.stateTitleLbl.textAlignment = .right
            }else{
                cell.stateNoteLbl.textAlignment = .left
                cell.stateTitleLbl.textAlignment = .left
            }
            break
        case 2:
            cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "Add your services" : "Add vehicles with document", key: ((self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "LBL_ADD_SERVICE_TITLE" : "LBL_ADD_VEHICLE_AND_DOC")
            cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "Please select your services as per your expertise and industry." : "Please add your vehicles and its document. After that we will verify its registration.", key: (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "LBL_ADD_SERVICE_NOTE" : "LBL_ADD_VEHICLE_AND_DOC_NOTE")
            cell.actionLbl.text = self.generalFunc.getLanguageLabel(origValue:  (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "Select Services" : "Add Vehicle", key: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "LBL_SELECT_SERVICE" : "LBL_ADD_VEHICLE")
            cell.actionLbl.isHidden = false
            cell.actionLbl.lblType = "ADD_VEHICLE"
            
            if (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue:"", key: "LBL_ADD_SERVICES_AND_DOC")
                cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue:"", key: "LBL_ADD_SERVICES_AND_DOC_NOTE")
                cell.actionLbl.text = self.generalFunc.getLanguageLabel(origValue:"", key: "LBL_MANANGE_SERVICES")
            }
            
            if((self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX && self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_Ride_Delivery_UberX) || self.userProfileJson.get("ONLYDELIVERALL") == "Yes" || self.userProfileJson.get("UFX_SERVICE_AVAILABLE") != "Yes"){
                if totalAddedVehicles > 0 {
                    cell.actionLbl.text = self.generalFunc.getLanguageLabel(origValue:"Manage Vehicles", key: "LBL_MANAGE_VEHICLES")
                    cell.actionLbl.lblType = "MANAGE_VEHICLE"
                }
            }
            
            if(statusOfStates[indexPath.item] == true){
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: ((self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "Service added successfully" : "", key: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "LBL_SERVICE_ADD_SUCCESS" : "LBL_VEHICLE_ADD_SUCCESS")
                
                cell.actionLbl.isHidden = true
            }
            if (Configurations.isRTLMode()){
                cell.stateNoteLbl.textAlignment = .right
                cell.stateTitleLbl.textAlignment = .right
            }else{
                cell.stateNoteLbl.textAlignment = .left
                cell.stateTitleLbl.textAlignment = .left
            }
            break
        case 3:
            if((self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Add your availability", key: "LBL_ADD_YOUR_AVAILABILITY")
                cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "Add your availability for scheduled booking requests", key: "LBL_ADD_AVAILABILITY_DOC_NOTE")
                cell.actionLbl.isHidden = statusOfStates[indexPath.item]
                cell.actionLbl.lblType = "ADD_SERVICE_AVAIL"
                cell.actionLbl.text = self.generalFunc.getLanguageLabel(origValue:  "Set Availability", key: "LBL_SET_AVAILABILITY_TXT")
                if(statusOfStates[indexPath.item] == true){
                    cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AVAILABILITY_ADD_SUCESS_MSG")
                }
                if (Configurations.isRTLMode()){
                    cell.stateNoteLbl.textAlignment = .right
                    cell.stateTitleLbl.textAlignment = .right
                }else{
                    cell.stateNoteLbl.textAlignment = .left
                    cell.stateTitleLbl.textAlignment = .left
                }
            }else{
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Waiting for admin's approval", key: "LBL_WAIT_ADMIN_APPROVE")
                cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "We will check your provided information and get back to you soon.", key: "LBL_WAIT_ADMIN_APPROVE_NOTE")
                cell.actionLbl.isHidden = true
                cell.actionLbl.lblType = "CONTACT_US"
                
                
                if(statusOfStates[indexPath.item] == true){
                    cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADMIN_APPROVE")
                    cell.stateNoteLbl.text = ""
//                    cell.stateNoteLbl.fitText()
                    
                    cell.actionLbl.isHidden = true
                }
                if Configurations.isRTLMode(){
                    cell.stateNoteLbl.textAlignment = .right
                    cell.stateTitleLbl.textAlignment = .right
                }else{
                    cell.stateNoteLbl.textAlignment = .left
                    cell.stateTitleLbl.textAlignment = .left
                }
            }
            break
        case 4:
            cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Waiting for admin's approval", key: "LBL_WAIT_ADMIN_APPROVE")
            cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "We will check your provided information and get back to you soon.", key: "LBL_WAIT_ADMIN_APPROVE_NOTE")
            cell.actionLbl.isHidden = true
            cell.actionLbl.lblType = "CONTACT_US"
            
            if(statusOfStates[indexPath.item] == true){
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADMIN_APPROVE")
                cell.stateNoteLbl.text = ""
//                cell.stateNoteLbl.fitText()
                
                cell.actionLbl.isHidden = true
            }
            
            if Configurations.isRTLMode(){
                cell.stateNoteLbl.textAlignment = .right
                cell.stateTitleLbl.textAlignment = .right
            }else{
                cell.stateNoteLbl.textAlignment = .left
                cell.stateTitleLbl.textAlignment = .left
            }
            break
        default:
            break
            
        }
        
        cell.actionLbl.setOnClickListener { (instance) in
            self.actionLblTapped(sender: instance as! MyLabel)
        }
        
//        cell.stateTitleLbl.fitText()
//        cell.stateNoteLbl.fitText()
        
        GeneralFunctions.setImgTintColor(imgView: cell.stateFinishedImgView, color: UIColor.UCAColor.AppThemeColor)
        
//        if(self.selectedRow == indexPath.item){
//            cell.stateNoteLbl.isHidden = false
//        }else{
//            cell.stateNoteLbl.isHidden = true
//        }
        
        if((indexPath.item + 1) == self.numOfItems){
            cell.stateSeperatorView.isHidden = true
        }else{
            cell.stateSeperatorView.isHidden = false
        }
        
        if(statusOfStates[indexPath.item] == false){
            cell.stateNoteLbl.isHidden = false
            cell.stateFinishedImgView.isHidden = true
            cell.stateNumLbl.isHidden = false
            cell.stateNumLbl.textColor = UIColor.black
            cell.stateNumLbl.backgroundColor = UIColor(hex:0xDFE0E1)
            cell.stateNumLbl.borderColor = UIColor(hex:0xC7C8C9)
            cell.stateNumLbl.borderWidth = 0.5
        }else{
            cell.stateNoteLbl.isHidden = true
            cell.stateNumLbl.isHidden = true
            cell.stateFinishedImgView.isHidden = false
            cell.stateNumLbl.borderColor = UIColor.UCAColor.AppThemeTxtColor
            cell.stateNumLbl.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        }
        
        
        cell.stateNumLbl.text = "\(indexPath.item + 1)"
        
        Utils.createRoundedView(view: cell.stateFinishedImgView, borderColor: UIColor.clear, borderWidth: 0)
        Utils.createRoundedView(view: cell.stateNumLbl, borderColor: UIColor.clear, borderWidth: 0)
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(statusOfStates[indexPath.item] == false){
            self.selectedRow = indexPath.item
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

//        indexPath.item == 0 ||
//        if((statusOfStates.count > 0 && statusOfStates[indexPath.item] == true)){
//            return 55
//        }
        
        var titleHeight:CGFloat = 0
        var noteTextHeight:CGFloat = 0
        var defaultHeight:CGFloat = 142
        
        switch indexPath.item {
        case 0:
            titleHeight = self.generalFunc.getLanguageLabel(origValue: "Registration Successful", key: "LBL_REGISTRATION_SUCCESS").height(withConstrainedWidth: Application.screenSize.width - 109, font: UIFont (name: Fonts().light, size: 15)!)
            defaultHeight = 77 + titleHeight//Total base height for first cell
            break
        case 1:
            titleHeight = self.generalFunc.getLanguageLabel(origValue: statusOfStates.count > 0 && statusOfStates[indexPath.item] == true ? "Documents uploaded successfully." : "Upload your documents", key: statusOfStates.count > 0 && statusOfStates[indexPath.item] == true ? "LBL_UPLOADDOC_SUCCESS" : "LBL_UPLOAD_YOUR_DOCS").height(withConstrainedWidth: Application.screenSize.width - 109, font: UIFont (name: Fonts().light, size: 15)!)
           
            noteTextHeight = self.generalFunc.getLanguageLabel(origValue: (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "" : "We need to verify your driving documents to activate your account.", key: (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "LBL_UPLOAD_DOCS_NOTE" : "LBL_UPLOAD_YOUR_DOCS_NOTE").height(withConstrainedWidth: Application.screenSize.width - 109, font: UIFont (name: Fonts().light, size: 12)!)
            
            if(statusOfStates.count > 0 && statusOfStates[indexPath.item] == true){
                defaultHeight = 77
            }
            break
        case 2:
            var titleTxt = self.generalFunc.getLanguageLabel(origValue: (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "Add your services" : "Add vehicles with document", key: ((self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "LBL_ADD_SERVICE_TITLE" : "LBL_ADD_VEHICLE_AND_DOC")
            if (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                titleTxt = self.generalFunc.getLanguageLabel(origValue:"", key: "LBL_ADD_SERVICES_AND_DOC")
            }
            
            if(statusOfStates[indexPath.item] == true){
                titleTxt = self.generalFunc.getLanguageLabel(origValue: ((self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "Service added successfully" : "", key: (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "LBL_SERVICE_ADD_SUCCESS" : "LBL_VEHICLE_ADD_SUCCESS")
            }
            
             titleHeight = titleTxt.height(withConstrainedWidth: Application.screenSize.width - 109, font: UIFont (name: Fonts().light, size: 15)!)
            
            noteTextHeight = self.generalFunc.getLanguageLabel(origValue: (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "Please select your services as per your expertise and industry." : "Please add your vehicles and its document. After that we will verify its registration.", key: (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? "LBL_ADD_SERVICE_NOTE" : "LBL_ADD_VEHICLE_AND_DOC_NOTE").height(withConstrainedWidth: Application.screenSize.width - 109, font: UIFont (name: Fonts().light, size: 12)!)
            
            if(statusOfStates.count > 0 && statusOfStates[indexPath.item] == true){
                defaultHeight = 77
            }
            break
        case 3:
            if((self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                titleHeight = self.generalFunc.getLanguageLabel(origValue: statusOfStates.count > 0 && statusOfStates[indexPath.item] == true ? "Availability added successfully." : "Add your availability", key: statusOfStates.count > 0 && statusOfStates[indexPath.item] == true ? "LBL_AVAILABILITY_ADD_SUCESS_MSG" : "LBL_ADD_YOUR_AVAILABILITY").height(withConstrainedWidth: Application.screenSize.width - 109, font: UIFont (name: Fonts().light, size: 15)!)
                
                noteTextHeight = self.generalFunc.getLanguageLabel(origValue: "Add your availability for scheduled booking requests", key: "LBL_ADD_AVAILABILITY_DOC_NOTE").height(withConstrainedWidth: Application.screenSize.width - 109, font: UIFont (name: Fonts().light, size: 12)!)
                
                if(statusOfStates.count > 0 && statusOfStates[indexPath.item] == true){
                    defaultHeight = 77
                }
                
            }else{
                noteTextHeight = self.generalFunc.getLanguageLabel(origValue: "We will check your provided information and get back to you soon.", key: "LBL_WAIT_ADMIN_APPROVE_NOTE").height(withConstrainedWidth: Application.screenSize.width - 109, font: UIFont (name: Fonts().light, size: 12)!)
                
                defaultHeight = defaultHeight - 30 // minus button Height + margin
//                noteTextHeight = noteTextHeight - 60 - 10
            }
            break
        case 4:
            
            titleHeight = self.generalFunc.getLanguageLabel(origValue: statusOfStates[indexPath.item] == true ? "" : "Waiting for admin's approval", key: statusOfStates[indexPath.item] == true ? "LBL_ADMIN_APPROVE" : "LBL_WAIT_ADMIN_APPROVE").height(withConstrainedWidth: Application.screenSize.width - 106, font: UIFont (name: Fonts().light, size: 15)!)
            
            noteTextHeight = self.generalFunc.getLanguageLabel(origValue: "We will check your provided information and get back to you soon.", key: "LBL_WAIT_ADMIN_APPROVE_NOTE").height(withConstrainedWidth: Application.screenSize.width - 106, font: UIFont (name: Fonts().light, size: 12)!)
                
            defaultHeight = defaultHeight - 30 // minus button Height + margin
//                noteTextHeight = noteTextHeight - 60 - 10
            
            break
        default:
            break
            
        }
        titleHeight = titleHeight - 18
        if(titleHeight < 0){
            titleHeight = 0
        }
        noteTextHeight = noteTextHeight - 18
        if(noteTextHeight < 0){
            noteTextHeight = 0
        }
        
        
        if((statusOfStates.count > 0 && statusOfStates[indexPath.item] == true)){
            
            print("\n\nFor true status\n\n")
            print("titleHeight for \(indexPath.row) : \(titleHeight)")
            print("defaultHeight \(indexPath.row) : \(defaultHeight)")

            return defaultHeight + titleHeight
        }
        
        print("\n\nFor false status\n\n")
        print("titleHeight for \(indexPath.row) : \(titleHeight)")
        print("defaultHeight \(indexPath.row) : \(defaultHeight)")
        print("noteTextHeight \(indexPath.row) : \(noteTextHeight)")
        
        return defaultHeight + noteTextHeight + titleHeight
    }
    
    func actionLblTapped(sender : MyLabel){
        if(sender.lblType == "UPLOAD_DOC"){
            let listOfDocumentUV = GeneralFunctions.instantiateViewController(pageName: "ListOfDocumentUV") as! ListOfDocumentUV
            self.pushToNavController(uv: listOfDocumentUV)
        }else if(sender.lblType == "ADD_VEHICLE"){
            
            if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("eShowVehicles").uppercased() == "NO" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes")){
            }else if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("eShowVehicles").uppercased() == "YES" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                let appTypeSelectionUv = GeneralFunctions.instantiateViewController(pageName: "AppTypeSelectionUV") as! AppTypeSelectionUV
                appTypeSelectionUv.isFromDriverStatesUV = true
                appTypeSelectionUv.totalAddedVehicles = totalAddedVehicles
                appTypeSelectionUv.screenToNavigate = "MANAGE_VEHICLE"
                self.pushToNavController(uv: appTypeSelectionUv)
            }else{
                let addVehiclesUv = GeneralFunctions.instantiateViewController(pageName: "AddVehiclesUV") as! AddVehiclesUV
                addVehiclesUv.isFromDriverStatesUV = true
                self.pushToNavController(uv: addVehiclesUv)
            }
            
        }else if(sender.lblType == "MANAGE_VEHICLE"){
            if (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
                if(self.userProfileJson.get("eShowVehicles").uppercased() == "YES"){
                    let appTypeSelectionUv = GeneralFunctions.instantiateViewController(pageName: "AppTypeSelectionUV") as! AppTypeSelectionUV
                    appTypeSelectionUv.screenToNavigate = "MANAGE_VEHICLE"
                    appTypeSelectionUv.totalAddedVehicles = totalAddedVehicles
                    self.pushToNavController(uv: appTypeSelectionUv)
                }else{
                }
            }else{
                let manageVehiclesUv = GeneralFunctions.instantiateViewController(pageName: "ManageVehiclesUV") as! ManageVehiclesUV
                self.pushToNavController(uv: manageVehiclesUv)
            }
            
        }else if(sender.lblType == "ADD_SERVICE_AVAIL"){
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(checkAccStatusBtn != nil && sender == checkAccStatusBtn){
            reloadData(isFromCheckBtn: true)
            return
        }else if(sender.btnType == "ACCOUNT_ACTIVATED_OK"){
            accountActivatedView.frame.origin.y = Application.screenSize.height + 2500
            accountActivatedView.removeFromSuperview()
            
            accountActivatedbgView.removeFromSuperview()
            
            let window = Application.window!
            let getUserData = GetUserData(uv: self, window: window)
            getUserData.getdata()
        }
    }
    
}
