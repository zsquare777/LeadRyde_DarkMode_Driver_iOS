//
//  WayBillUV.swift
//  DriverApp
//
//  Created by ADMIN on 25/07/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class WayBillUV: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var driverNameLbl: MyLabel!
    
    @IBOutlet weak var tripView: UIView!
    @IBOutlet weak var tripViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tripLbl: MyLabel!
    @IBOutlet weak var tripNoLbl: MyLabel!
    @IBOutlet weak var tripNoVLbl: MyLabel!
    @IBOutlet weak var tripRateLbl: MyLabel!
    @IBOutlet weak var tripRateVLbl: MyLabel!
    @IBOutlet weak var tripTimeLbl: MyLabel!
    @IBOutlet weak var tripTimeVLbl: MyLabel!

    @IBOutlet weak var passengerNameLbl: MyLabel!
    @IBOutlet weak var passengerNameVLbl: MyLabel!
    @IBOutlet weak var viaLbl: MyLabel!
    @IBOutlet weak var viaVLbl: MyLabel!
    @IBOutlet weak var fromLocLbl: MyLabel!
    @IBOutlet weak var fromLocVLbl: MyLabel!
    @IBOutlet weak var toLocLbl: MyLabel!
    @IBOutlet weak var toLocVLbl: MyLabel!
    @IBOutlet weak var tripAreaBottomView: UIView!
    
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var driverViewHeight: NSLayoutConstraint!
    @IBOutlet weak var driverLbl: MyLabel!
    @IBOutlet weak var driverNameHLbl: MyLabel!
    @IBOutlet weak var driverNameVLbl: MyLabel!
    @IBOutlet weak var carLicPlateLbl: MyLabel!
    @IBOutlet weak var carLicPlateVLbl: MyLabel!
    @IBOutlet weak var passengerCapLbl: MyLabel!
    @IBOutlet weak var passengerCapVLbl: MyLabel!
    @IBOutlet weak var driverAreaBottomView: UIView!
    
    @IBOutlet weak var recNameStackViewTop: NSLayoutConstraint!
    @IBOutlet weak var recnameVLbl: MyLabel!
    @IBOutlet weak var recnameHLbl: MyLabel!
    @IBOutlet weak var recnameStackView: UIStackView!
    @IBOutlet weak var pacDetailsHLbl: MyLabel!
    @IBOutlet weak var pacDetailsVLbl: MyLabel!
    @IBOutlet weak var pacNameHLbl: MyLabel!
    @IBOutlet weak var pacNameVLbl: MyLabel!
    
    @IBOutlet weak var packageDetailsStackView: UIStackView!
    @IBOutlet weak var packageNameStackView: UIStackView!
    
    @IBOutlet weak var paymentTypeHLbl: MyLabel!
    @IBOutlet weak var paymentTypeVLbl: MyLabel!
    
    
    var PAGE_HEIGHT:CGFloat = 500
    
    let generalFunc = GeneralFunctions()
    
    var cntView:UIView!
    var loaderView:UIView!
    
    var isFirstLaunch = true
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        cntView = self.generalFunc.loadView(nibName: "WayBillScreenDesign", uv: self, contentView: contentView)
        
        self.scrollView.addSubview(cntView)
        self.scrollView.backgroundColor = UIColor(hex: 0xf2f2f4)
        
        scrollView.bounces = false
        scrollView.isHidden = true
        
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
        
        // Update scroll view background
        self.scrollView.backgroundColor = themeManager.backgroundColor()
        
        // Update content view background
        self.contentView.backgroundColor = themeManager.backgroundColor()
        
        // Update trip view (card)
        if self.tripView != nil {
            self.tripView.backgroundColor = themeManager.cardBackgroundColor()
            self.tripView.layer.shadowOpacity = themeManager.isDarkModeActive ? 0.3 : 0.6
            self.tripView.layer.shadowColor = themeManager.isDarkModeActive ? UIColor.black.cgColor : UIColor.lightGray.cgColor
        }
        
        // Update driver view (card)
        if self.driverView != nil {
            self.driverView.backgroundColor = themeManager.cardBackgroundColor()
            self.driverView.layer.shadowOpacity = themeManager.isDarkModeActive ? 0.3 : 0.6
            self.driverView.layer.shadowColor = themeManager.isDarkModeActive ? UIColor.black.cgColor : UIColor.lightGray.cgColor
        }
        
        // Update label text colors
        if self.tripNoLbl != nil {
            self.tripNoLbl.textColor = themeManager.textColor()
            self.tripTimeLbl.textColor = themeManager.textColor()
            self.tripRateLbl.textColor = themeManager.textColor()
            self.passengerNameLbl.textColor = themeManager.textColor()
            self.viaLbl.textColor = themeManager.textColor()
            self.fromLocLbl.textColor = themeManager.textColor()
            self.toLocLbl.textColor = themeManager.textColor()
            self.driverNameHLbl.textColor = themeManager.textColor()
            self.carLicPlateLbl.textColor = themeManager.textColor()
            self.paymentTypeHLbl.textColor = themeManager.textColor()
            
            // Value labels (secondary text)
            self.tripNoVLbl.textColor = themeManager.secondaryTextColor()
            self.tripRateVLbl.textColor = themeManager.secondaryTextColor()
            self.tripTimeVLbl.textColor = themeManager.secondaryTextColor()
            self.passengerNameVLbl.textColor = themeManager.secondaryTextColor()
            self.viaVLbl.textColor = themeManager.secondaryTextColor()
            self.fromLocVLbl.textColor = themeManager.secondaryTextColor()
            self.toLocVLbl.textColor = themeManager.secondaryTextColor()
            self.driverNameVLbl.textColor = themeManager.secondaryTextColor()
            self.carLicPlateVLbl.textColor = themeManager.secondaryTextColor()
            self.passengerCapVLbl.textColor = themeManager.secondaryTextColor()
            self.paymentTypeVLbl.textColor = themeManager.secondaryTextColor()
            self.recnameVLbl.textColor = themeManager.secondaryTextColor()
            self.pacDetailsVLbl.textColor = themeManager.secondaryTextColor()
            self.pacNameVLbl.textColor = themeManager.secondaryTextColor()
            self.recnameHLbl.textColor = themeManager.textColor()
            self.pacDetailsHLbl.textColor = themeManager.textColor()
            self.pacNameHLbl.textColor = themeManager.textColor()
        }
        
        // Note: topHeaderView keeps app theme color (branding)
        // Note: tripLbl and driverLbl keep app theme color (branding)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = -1
        
        if(isFirstLaunch == true){
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
            
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            isFirstLaunch = false
            
            loadData()
        }
        
        // Apply theme after views are fully set up
        applyTheme()
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Way Bill", key: "LBL_MENU_WAY_BILL")
        self.title = self.generalFunc.getLanguageLabel(origValue: "Way Bill", key: "LBL_MENU_WAY_BILL")
        
        self.tripLbl.text = ""
        self.tripNoLbl.text = ""
        
        self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT_TYPE_TXT")
        self.paymentTypeHLbl.fontFamilyWeight = "Bold"
        self.paymentTypeHLbl.setFontFamily()
        self.tripTimeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TIME_TXT")
        self.tripTimeLbl.fontFamilyWeight = "Bold"
        self.tripTimeLbl.setFontFamily()
        self.tripRateLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATE")
        self.tripRateLbl.fontFamilyWeight = "Bold"
        self.tripRateLbl.setFontFamily()
        self.passengerNameLbl.text = self.generalFunc.getLanguageLabel(origValue: "Passenger Name", key: "LBL_PASSENGER_NAME_TEXT")
        self.passengerNameLbl.fontFamilyWeight = "Bold"
        self.passengerNameLbl.setFontFamily()
        self.viaLbl.text = self.generalFunc.getLanguageLabel(origValue: "Via", key: "LBL_VIA_TXT")
        self.viaLbl.fontFamilyWeight = "Bold"
        self.viaLbl.setFontFamily()
        self.fromLocLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_From")
        self.fromLocLbl.fontFamilyWeight = "Bold"
        self.fromLocLbl.setFontFamily()
        self.toLocLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_To")
        self.toLocLbl.fontFamilyWeight = "Bold"
        self.toLocLbl.setFontFamily()
        
        self.driverLbl.text = self.generalFunc.getLanguageLabel(origValue: "Driver", key: "LBL_DIVER").uppercased()
        self.driverLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.driverLbl.fontFamilyWeight = "Bold"
        self.driverLbl.setFontFamily()
        self.driverNameHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Name", key: "LBL_NAME_TXT")
        self.driverNameHLbl.fontFamilyWeight = "Bold"
        self.driverNameHLbl.setFontFamily()
        self.carLicPlateLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LICENCE_PLATE_TXT") + "# "
        self.carLicPlateLbl.fontFamilyWeight = "Bold"
        self.carLicPlateLbl.setFontFamily()
        self.passengerCapLbl.text = ""
        
        self.recnameStackView.isHidden = true
        self.packageNameStackView.isHidden = true
        self.packageDetailsStackView.isHidden = true
        
        self.topHeaderView.layer.shadowOpacity = 0.5
        self.topHeaderView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.topHeaderView.layer.shadowColor = UIColor(hex: 0xc0c0c1).cgColor
        self.topHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        // Shadow colors will be set by applyTheme()
        tripView.layer.shadowOffset = CGSize.zero
        
        driverView.layer.shadowOffset = CGSize.zero
    }
    
    func loadData(){
        scrollView.isHidden = true
        
        if(loaderView != nil){
            loaderView.removeFromSuperview()
        }
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"displayWayBill","UserType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                if(dataDict.get("Action") == "1"){
                    let msgData = dataDict.getObj(Utils.message_str)
                    if(msgData.get("eType") == Utils.cabGeneralType_Deliver) || (msgData.get("eType") == Utils.cabGeneralType_Multi_Delivery) || (msgData.get("eType").uppercased() == "DELIVER") {
                        self.tripLbl.text = self.generalFunc.getLanguageLabel(origValue: "Delivery", key: "LBL_DELIVERY").uppercased()
                        self.tripLbl.fontFamilyWeight = "Bold"
                        self.tripLbl.setFontFamily()
                        self.tripNoLbl.text = self.generalFunc.getLanguageLabel(origValue: "Delivery", key: "LBL_DELIVERY") + "# "
                        self.tripNoLbl.fontFamilyWeight = "Bold"
                        self.tripNoLbl.setFontFamily()
                        self.driverLbl.text = self.generalFunc.getLanguageLabel(origValue: "Carrier", key: "LBL_CARRIER").uppercased()
                        self.tripLbl.textColor = UIColor.UCAColor.AppThemeColor
                        self.driverLbl.textColor = UIColor.UCAColor.AppThemeColor
                        self.driverLbl.fontFamilyWeight = "Bold"
                        self.driverLbl.setFontFamily()
                    }else{
                        self.tripLbl.text = self.generalFunc.getLanguageLabel(origValue: "Trip", key: "LBL_TRIP_DETAILS_TXT").uppercased()
                        self.tripLbl.fontFamilyWeight = "Bold"
                        self.tripLbl.setFontFamily()
                        self.tripLbl.textColor = UIColor.UCAColor.AppThemeColor
                        
                        self.tripNoLbl.text = self.generalFunc.getLanguageLabel(origValue: "Trip", key: "LBL_TRIP_TXT") + "# "
                        self.tripNoLbl.fontFamilyWeight = "Bold"
                        self.tripNoLbl.setFontFamily()
                        self.driverLbl.text = self.generalFunc.getLanguageLabel(origValue: "Driver", key: "LBL_DIVER").uppercased()
                        self.driverLbl.textColor = UIColor.UCAColor.AppThemeColor
                        self.driverLbl.fontFamilyWeight = "Bold"
                        self.driverLbl.setFontFamily()
                    }
                    
                    self.paymentTypeVLbl.text = msgData.get("vDisplayPaymentMode")
                    self.paymentTypeVLbl.fontFamilyWeight = "Bold"
                    self.paymentTypeVLbl.setFontFamily()
                    self.driverNameLbl.text = msgData.get("DriverName")
                    self.tripNoVLbl.text = Configurations.convertNumToAppLocal(numStr: msgData.get("vRideNo"))
                    self.tripNoVLbl.fontFamilyWeight = "Bold"
                    self.tripNoVLbl.setFontFamily()
                    self.tripTimeVLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: msgData.get("tTripRequestDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateWithTime).uppercased()
                    self.tripTimeVLbl.fontFamilyWeight = "Bold"
                    self.tripTimeVLbl.setFontFamily()
                    self.tripRateVLbl.text = Configurations.convertNumToAppLocal(numStr: msgData.get("Rate"))
                    self.tripRateVLbl.fontFamilyWeight = "Bold"
                    self.tripRateVLbl.setFontFamily()
                    
                    self.passengerNameVLbl.text = msgData.get("PassengerName")
                    self.passengerNameVLbl.fontFamilyWeight = "Bold"
                    self.passengerNameVLbl.setFontFamily()
                    self.viaVLbl.text = msgData.get("ProjectName")
                    self.viaVLbl.fontFamilyWeight = "Bold"
                    self.viaVLbl.setFontFamily()
                    self.fromLocVLbl.text = msgData.get("tSaddress")
                    self.fromLocVLbl.fontFamilyWeight = "Bold"
                    self.fromLocVLbl.setFontFamily()
                    self.toLocVLbl.text = msgData.get("tDaddress") == "" ? "--" : msgData.get("tDaddress")
                    self.toLocVLbl.fontFamilyWeight = "Bold"
                    self.toLocVLbl.setFontFamily()
                    
                    self.driverNameVLbl.text = msgData.get("DriverName")
                    self.driverNameVLbl.fontFamilyWeight = "Bold"
                    self.driverNameVLbl.setFontFamily()
                    self.carLicPlateVLbl.text =  msgData.get("eType") == Utils.cabGeneralType_UberX ? "--" : msgData.get("Licence_Plate")
                    self.carLicPlateVLbl.fontFamilyWeight = "Bold"
                    self.carLicPlateVLbl.setFontFamily()
                    
                    if (msgData.get("eType") == Utils.cabGeneralType_Deliver || msgData.get("eType") == Utils.cabGeneralType_UberX){
                        if(msgData.get("eType") == Utils.cabGeneralType_UberX){
                            self.recNameStackViewTop.constant = -20.5
                        }else{
                            self.passengerCapLbl.isHidden = true
                            self.passengerCapVLbl.isHidden = true
                        }
                    }else{
                        self.passengerCapLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PASSENGER_TXT") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CAPACITY")
                        self.passengerCapLbl.fontFamilyWeight = "Bold"
                        self.passengerCapLbl.setFontFamily()
                        self.passengerCapVLbl.text = Configurations.convertNumToAppLocal(numStr: msgData.get("PassengerCapacity"))
                        self.passengerCapVLbl.fontFamilyWeight = "Bold"
                        self.passengerCapVLbl.setFontFamily()
                        
                        self.recNameStackViewTop.constant = -20.5
                        self.recnameStackView.isHidden = true
                    }
                    
                    if(msgData.get("eType") == Utils.cabGeneralType_Deliver){
                        self.packageNameStackView.isHidden = false
                        self.packageDetailsStackView.isHidden = false
                        self.recnameStackView.isHidden = false
                        
                        self.recnameHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIVER_NAME")
                        self.recnameHLbl.fontFamilyWeight = "Bold"
                        self.recnameHLbl.setFontFamily()
                        self.recnameVLbl.text = msgData.get("vReceiverName")
                        self.recnameVLbl.fontFamilyWeight = "Bold"
                        self.recnameVLbl.setFontFamily()
                        self.pacNameHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PACKAGE_TYPE")
                        self.pacNameHLbl.fontFamilyWeight = "Bold"
                        self.pacNameHLbl.setFontFamily()
                        self.pacDetailsHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PACKAGE_DETAILS")
                        self.pacDetailsHLbl.fontFamilyWeight = "Bold"
                        self.pacDetailsHLbl.setFontFamily()
                        self.passengerNameLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SENDER_NAME")
                        self.passengerNameLbl.fontFamilyWeight = "Bold"
                        self.passengerNameLbl.setFontFamily()
                        self.toLocLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIVER_LOCATION")
                        self.toLocLbl.fontFamilyWeight = "Bold"
                        self.toLocLbl.setFontFamily()
                        self.pacNameVLbl.text = msgData.get("PackageName")
                        self.pacNameVLbl.fontFamilyWeight = "Bold"
                        self.pacNameVLbl.setFontFamily()
                        self.pacDetailsVLbl.text = msgData.get("tPackageDetails")
                        self.pacDetailsVLbl.fontFamilyWeight = "Bold"
                        self.pacDetailsVLbl.setFontFamily()
                        
                    }
//                    self.viaVLbl.fitText()
                    self.fromLocVLbl.fitText()
//                    self.recnameVLbl.fitText()
                    self.toLocVLbl.fitText()
                    self.tripRateVLbl.fitText()
//                    self.tripTimeVLbl.fitText()
//                    self.pacNameVLbl.fitText()
                    self.pacDetailsVLbl.fitText()
                    
                    //                    self.carLicPlateVLbl.fitText()
                    
                    //                    print("BottomViewY1:\(self.tripAreaBottomView.frame.maxY)")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                        //                        print("BottomViewY:\(self.tripAreaBottomView.frame.maxY)")
                        let borderColor = UIColor.lightGray.withAlphaComponent(0.5)
//                        let borderColor = UIColor.lightGray.withAlphaComponent(0.5)
                        self.paymentTypeHLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.paymentTypeVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.tripNoLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.tripNoVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.tripTimeLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.tripTimeVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.tripRateLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.tripRateVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.passengerNameLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.passengerNameVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.viaLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.viaVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.fromLocLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.fromLocVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        if(msgData.get("eType") == Utils.cabGeneralType_Deliver){
                          self.recnameHLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                          self.recnameVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        }
                        self.toLocLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        self.toLocVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
//                        self.driverNameHLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
//                        self.driverNameVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
//                        self.passengerCapLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7)
//                        self.passengerCapVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7)
//                        self.carLicPlateLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
//                        self.carLicPlateVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                        
                        if(msgData.get("eType") == Utils.cabGeneralType_Deliver){
                            self.pacNameHLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                            self.pacNameVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
//                            self.pacDetailsHLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
//                            self.pacDetailsVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                            self.tripViewHeight.constant = self.tripAreaBottomView.frame.maxY + 10
                        }else{
                            self.tripViewHeight.constant = self.tripAreaBottomView.frame.maxY + 10 - 60
                        }
                        
                        self.driverViewHeight.constant = self.driverAreaBottomView.frame.maxY + 10
                        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.tripViewHeight.constant + self.driverViewHeight.constant + 90)
                        
                        self.loaderView.isHidden = true
                        self.scrollView.isHidden = false
                        for i in 0..<self.driverView.subviews.count {
                            let views = self.driverView.subviews[i]
                            
                            if((self.passengerCapLbl.isHidden == true && i == self.driverView.subviews.count - 3) || (self.passengerCapLbl.isHidden == false && i == self.driverView.subviews.count - 2)){
                                break
                            }else{
                                if(i != 0){
                                    views.layer.addDashedBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: 0.7, true)
                                }
                            }
                            
                        }
                    })
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        //                        self.loadData()
                        self.closeCurrentScreen()
                    })
                    
                    //                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                    
                    self.loaderView.isHidden = true
                }
                
            }else{
                //                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                //
                //                    self.loadData()
                //                })
                
                //                self.generalFunc.setError(uv: self)
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Please try again later" : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    //                        self.loadData()
                    self.closeCurrentScreen()
                })
                
                self.loaderView.isHidden = true
            }
            
        })
    }
}
