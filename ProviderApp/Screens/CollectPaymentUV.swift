//
//  CollectPaymentUV.swift
//  DriverApp
//
//  Created by ADMIN on 29/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class CollectPaymentUV: UIViewController, MyBtnClickDelegate {
    
    /* Create IBOutlet */
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tripFareLbl: MyLabel!
    
    @IBOutlet weak var walletAmtLbl: MyLabel!
    @IBOutlet weak var walletAmtLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var thanksView: UIView!
    @IBOutlet weak var thanksViewTopConstraint: NSLayoutConstraint! 
    @IBOutlet weak var thanksHLbl: MyLabel!
    @IBOutlet weak var rideNoLbl: MyLabel!

    @IBOutlet weak var tripDateVLbl: MyLabel!
    
    @IBOutlet weak var vehicleTypeLbl: MyLabel!
    
    @IBOutlet weak var fareDataContainerView: UIView!
    @IBOutlet weak var fareContainerView: UIStackView!
    @IBOutlet weak var fareContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vTypeNameHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addressContainerView: UIView!
    @IBOutlet weak var addressContainerViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var addressContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sourceLocView: UIView!
    @IBOutlet weak var destLocView: UIView!
    
    @IBOutlet weak var sourceAddressHLbl: MyLabel!
    @IBOutlet weak var sourceAddressVLbl: MyLabel!

    @IBOutlet weak var destAddHLbl: MyLabel!
    @IBOutlet weak var destAddVLbl: MyLabel!
    @IBOutlet weak var dashedView: UIView!

    @IBOutlet weak var chargesHLbl: MyLabel!
    
    /* Create BottomDetailsView IBOutlet */
    @IBOutlet weak var bottomDetailsView: UIView!
    @IBOutlet weak var payImgView: UIImageView!
    @IBOutlet weak var paymentTypeHLbl: MyLabel!
    @IBOutlet weak var generalNoteLbl: MyLabel!
    
    @IBOutlet weak var collectPayBtn: MyButton!
    @IBOutlet weak var btnAreaBottomMargin: NSLayoutConstraint!
    
    let generalFunc = GeneralFunctions()
    
    var isPageLoaded = false
    
    var window:UIWindow!
    
    var tripData:NSDictionary!
    
    var cntView:UIView!
    
    var loaderView:UIView!
    
    var PAGE_HEIGHT:CGFloat = 315
    
    var userProfileJson:NSDictionary!
    
    var isSafeAreaSet = false
    var iphoneXBottomView:UIView!
    
    var isEnableRating = ""
    var isSkipRating = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        self.navigationController?.navigationBar.layer.zPosition = -1
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
        (UIApplication.shared.delegate as! AppDelegate).configureOnlineState(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavigationSensor.getInstance().configSensor(activateDispatch: false)
        
        window = Application.window!
        
        cntView = self.generalFunc.loadView(nibName: "CollectPaymentScreenDesign", uv: self, contentView: scrollView)
        cntView.backgroundColor = UIColor.clear
        
        /** Used for configDriverTripStatus Type */
        GeneralFunctions.saveValue(key: "iTripId", value: "" as AnyObject)
        /** Used for configDriverTripStatus Type */
        
        scrollView.backgroundColor = UIColor(hex: 0xF1F1F1)
        scrollView.addSubview(cntView)
        
        scrollView.bounces = false
        
        Utils.removeAppInactiveStateNotifications()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)

        cntView.isHidden = true
        scrollView.isHidden = true
        bottomDetailsView.isHidden = true
        collectPayBtn.isHidden = true
        
        isEnableRating = userProfileJson.get("ENABLE_RATING")
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidAppear(_ animated: Bool){
        if(isPageLoaded == false){
            
            cntView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.height)
            
            setData()
            
            isPageLoaded = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){

            if(Configurations.isIponeXDevice() || UIDevice().typeApp == .iPhone12Pro || UIDevice().typeApp == .iPhone12ProMax ||  UIDevice().typeApp == .iPhone12 ||  UIDevice().typeApp == .iPhone12Mini || UIDevice().typeApp == .iPhone11 || UIDevice().typeApp == .iPhone11Pro || UIDevice().typeApp == .iPhone11ProMax){
                
                if(iphoneXBottomView == nil){
                    iphoneXBottomView = UIView()
                    self.view.addSubview(iphoneXBottomView)
                }
                
                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
                
                self.iphoneXBottomView.frame = CGRect(x: 0, y: self.collectPayBtn.frame.maxY - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: GeneralFunctions.getSafeAreaInsets().bottom)
                
                btnAreaBottomMargin.constant = GeneralFunctions.getSafeAreaInsets().bottom
            }
            
            isSafeAreaSet = true
        }
    }
    
    func setData(){
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_SUMMARY")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_SUMMARY")

        self.collectPayBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COLLECT_PAYMENT"))
        self.collectPayBtn.clickDelegate = self

        self.paymentTypeHLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT_TYPE_TXT")): "
        
        self.headerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        self.sourceLocView.backgroundColor = UIColor.UCAColor.SourceAddColor
        self.destLocView.backgroundColor = UIColor.UCAColor.DestAddColor
        
        self.thanksView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.thanksView.layer.roundCorners(radius: 10)

        self.detailsView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.detailsView.layer.roundCorners(radius: 10)

        self.bottomDetailsView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
        self.bottomDetailsView.layer.roundCorners(radius: 18)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.bottomDetailsView.roundCorners(corners: [.topLeft, .topRight], radius: 18.0)
//            self.bottomDetailsView.clipsToBounds = true
//        }

        self.chargesHLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHARGES_TXT"))"

        Utils.delayWithSeconds(0.5) {
            self.getTripData()
        }
        
    }

    func getTripData(){
        cntView.isHidden = true
        scrollView.isHidden = true
        bottomDetailsView.isHidden = true
        collectPayBtn.isHidden = true
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"displayFare","iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.tripFareLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.getObj(Utils.message_str).get("FareSubTotal"))
                 
//                    self.thanksHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("eType").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || dataDict.get("eType") == "Multi-Delivery" ? "LBL_THANKS_DELIVERY_TXT" : (dataDict.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_THANKS_JOB_TXT" : "LBL_THANKS_RIDING_TXT")).capitalized
//                    if(dataDict.get("eHailTrip") == "Yes"){
//                        self.thanksHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_THANKS_TXT")
//                    }
                    
                    self.thanksHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_THANKS_TXT")
                    
                    self.rideNoLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("eType") == Utils.cabGeneralType_Ride ? "LBL_RIDE" : (dataDict.get("eType") == Utils.cabGeneralType_UberX ? "LBL_SERVICES" : "LBL_DELIVERY")).capitalized) #\(Configurations.convertNumToAppLocal(numStr: dataDict.getObj(Utils.message_str).get("vRideNo")))"
                    
                    //let tripDateHStr = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("eType").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || dataDict.get("eType") == "Multi-Delivery" ? "LBL_DELIVERY_DATE_TXT" : (dataDict.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_JOB_REQ_DATE" : "LBL_TRIP_DATE_TXT")).uppercased()
                    
                    self.tripDateVLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: dataDict.getObj(Utils.message_str).get("tStartDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateWithTime).uppercased()
                    
                    self.sourceAddressHLbl.text = self.generalFunc.getLanguageLabel(origValue: dataDict.get("eType") == Utils.cabGeneralType_UberX ? "Job Location" : (dataDict.get("eType") == Utils.cabGeneralType_Deliver ? "Sender's location" : "Pick up location"), key: dataDict.get("eType") == Utils.cabGeneralType_UberX ? "LBL_JOB_LOCATION_TXT" : (dataDict.get("eType") == Utils.cabGeneralType_Deliver || dataDict.get("eType") == "Multi-Delivery" ? "LBL_SENDER_LOCATION" : "LBL_PICK_UP_LOCATION")).uppercased()
                    
                    self.destAddHLbl.text = self.generalFunc.getLanguageLabel(origValue: dataDict.get("eType") == Utils.cabGeneralType_Deliver || dataDict.get("eType") == "Multi-Delivery" ? "Receiver's location" : "Destination location", key: dataDict.get("eType") == Utils.cabGeneralType_Deliver || dataDict.get("eType") == "Multi-Delivery" ? "LBL_RECEIVER_LOCATION" : "LBL_DEST_LOCATION").uppercased()
                    
                    self.walletAmtLbl.isHidden = true
                    self.headerViewHeight.constant = 160
                    self.thanksViewTopConstraint.constant = 105
                    self.walletAmtLblHeight.constant = 0
                    
                    if(dataDict.get("eWalletAmtAdjusted").uppercased() == "YES"){
                        self.tripFareLbl.font = UIFont(name: Fonts().semibold, size: 45)!
                        
                        self.walletAmtLbl.isHidden = true
                        self.headerViewHeight.constant = 160
                        self.thanksViewTopConstraint.constant = 105
                        self.walletAmtLblHeight.constant = 0
                        
                        self.walletAmtLbl.text = self.generalFunc.getLanguageLabel(origValue: "Money deducted from Wallet", key: "LBL_DEDUCTED_MONEY_WALLET_TXT")
                        
                        /*self.tripFareLbl.font = UIFont(name: Fonts().semibold, size: 45)!
                        self.walletAmtLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WALLET_AMT_ADJUSTED")): \(dataDict.get("fWalletAmountAdjusted"))"
                        self.walletAmtLbl.isHidden = false*/
                    }
                    
                    let fDiscount = dataDict.getObj(Utils.message_str).get("fDiscount")
                    _ = dataDict.getObj(Utils.message_str).get("CurrencySymbol")
                    let vTripPaymentMode = dataDict.getObj(Utils.message_str).get("vTripPaymentMode")
                  
                    self.vehicleTypeLbl.text = dataDict.getObj(Utils.message_str).get("vServiceDetailTitle")
                    
                    let vTypeNameHeight = self.vehicleTypeLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().semibold, size: 18)!)
                    
                    self.vTypeNameHeight.constant = vTypeNameHeight
                    
                    self.detailsViewHeight.constant = 30 + vTypeNameHeight
                    
                    if (fDiscount != "" && fDiscount != "0" && fDiscount != "0.00") {
                        
                    }else{
                        
                    }

//                    self.generalNoteLbl.textColor = UIColor.UCAColor.AppThemeColor_1
                    
                    if self.tripData.get("eType") != "Multi-Delivery"{
                        if(vTripPaymentMode == "Cash"){
                            self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Cash", key: "LBL_TRIP_CASH_PAYMENT").uppercased()
                            self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.getObj(Utils.message_str).get("eType").uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_COLLECT_MONEY_FRM_RIDER" : (dataDict.getObj(Utils.message_str).get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_COLLECT_MONEY_FRM_USER" : "LBL_COLLECT_MONEY_FRM_RECIPIENT"))
//                            self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Cash", key: "LBL_CASH_TXT").uppercased()
//                            self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GREY_TEXT_CASH")
                            self.payImgView.image = UIImage(named: "ic_pay_cash")!
                            self.collectPayBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_IN_ALL_CASES"))
                        }else if(vTripPaymentMode == "Card"){
//                            self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Card", key: "LBL_TRIP_CARD_PAYMENT").uppercased()
//                            self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.getObj(Utils.message_str).get("eType").uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_DEDUCTED_RIDER_CARD" : (dataDict.getObj(Utils.message_str).get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_DEDUCTED_USER_CARD" : "LBL_DEDUCTED_SENDER_CARD"))
                            self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Card", key: "LBL_PAID_IN_APP").uppercased()
                            self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEDUCTED_RIDER_CARD")
                            self.payImgView.image = UIImage(named: "ic_card_new")!
                            self.collectPayBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_IN_ALL_CASES"))
                            
                            /* PAYMENT FLOW CHANGES */
                            if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2"){
//                                self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT").uppercased()
//                                self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.getObj(Utils.message_str).get("eType").uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_DEDUCTED_RIDER_WALLET" : (dataDict.getObj(Utils.message_str).get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_DEDUCTED_USER_WALLET" : "LBL_DEDUCTED_SENDER_WALLET"))
                                self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT").uppercased()
                                self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GREY_TEXT_WALLET")
                                self.payImgView.image = UIImage(named: "ic_wallet_pay")!
                                self.collectPayBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_IN_ALL_CASES"))
                                
                            }/* ............ */
                        
	                    }else{
                        
	                        self.paymentTypeHLbl.text = "--"
	                        self.generalNoteLbl.text = "--"
	                    }
                        
                        if(self.tripData.get("ePaymentBy") == "Organization"){
                            self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ORGANIZATION").uppercased()
                            self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MONEY_PAID_ORGANIZATION")
                            self.collectPayBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_NEXT_TXT"))
                        }
                        
                    }else{
                        if(vTripPaymentMode == "Cash"){
                            print(dataDict.get("PaymentPerson"))
//                            self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Cash", key: "LBL_CASH_TXT").uppercased()
                            self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Cash", key: "LBL_TRIP_CASH_PAYMENT")
                            self.payImgView.image = UIImage(named: "ic_pay_cash")!
//                            self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GREY_TEXT_CASH")
                            self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAID_BY_TXT") + ": " + dataDict.get("PaymentPerson")
                            self.collectPayBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_IN_ALL_CASES"))
//                            self.collectPayBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_DELIVERY_TXT"))
                        }else{
                            self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Card", key: "LBL_PAID_IN_APP").uppercased()
//                            self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Card", key: "LBL_TRIP_CARD_PAYMENT").uppercased()
//                            self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.getObj(Utils.message_str).get("eType").uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_DEDUCTED_RIDER_CARD" : (dataDict.getObj(Utils.message_str).get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_DEDUCTED_USER_CARD" : "LBL_DEDUCTED_SENDER_CARD"))
                            self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEDUCTED_RIDER_CARD")
                            self.payImgView.image = UIImage(named: "ic_card_new")!
                            self.collectPayBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_IN_ALL_CASES"))
                            /* PAYMENT FLOW CHANGES */
                            if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2"){
//                                self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT").uppercased()
//                                self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.getObj(Utils.message_str).get("eType").uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_DEDUCTED_RIDER_WALLET" : (dataDict.getObj(Utils.message_str).get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_DEDUCTED_USER_WALLET" : "LBL_DEDUCTED_SENDER_WALLET"))
                                self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT").uppercased()
                                self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GREY_TEXT_WALLET")
                                self.payImgView.image = UIImage(named: "ic_wallet_pay")!
                            }/* ............ */
                            
                        }
                    }
                    
                    let eTypeLower   = self.tripData.get("eType").lowercased()
                    let payModeLower = vTripPaymentMode.lowercased()

                    if(eTypeLower == "admin"){

                        self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(
                            origValue: "", key: "LBL_Account_Job").uppercased()
                        self.generalNoteLbl.text  = self.generalFunc.getLanguageLabel(
                            origValue: "", key: "LBL_GREY_TEXT_ADMIN")
                        self.generalNoteLbl.isHidden = false
                        self.collectPayBtn.setButtonTitle(
                            buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_IN_ALL_CASES"))

                    }else if(eTypeLower == "wallet"){

                        self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(
                            origValue: "", key: "LBL_PAY_BY_WALLET_TXT").uppercased()
                        self.generalNoteLbl.text  = self.generalFunc.getLanguageLabel(
                            origValue: "", key: "LBL_GREY_TEXT_WALLET")
                        self.generalNoteLbl.isHidden = false
                        self.payImgView.image = UIImage(named: "ic_wallet_pay")!
                        self.collectPayBtn.setButtonTitle(
                            buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_IN_ALL_CASES"))
                    }
                    
//                    if (self.tripData.get("eType").lowercased() == "admin"){
//                        self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Account_Job").uppercased()
//                        self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GREY_TEXT_ADMIN")
//                        self.collectPayBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_IN_ALL_CASES"))
//                    }
//                    if ((self.tripData.get("eType").lowercased() == "wallet") && (vTripPaymentMode.lowercased() == "wallet")){
//                        self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT").uppercased()
//                        self.generalNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GREY_TEXT_WALLET")
//                        print(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GREY_TEXT_WALLET"))
//                        self.collectPayBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_IN_ALL_CASES"))
//                    }
                    
//                    if(GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("TripFare")) <= 0.0){
//                        self.generalNoteLbl.text = ""
//                    }
                   
                    GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)

                    self.addFareDetails(dataDict: dataDict)
                    
                    let tSaddress = dataDict.getObj(Utils.message_str).get("tSaddress").trim()
                    let tDAddress = dataDict.getObj(Utils.message_str).get("tDaddress").trim()
                    
                    self.sourceAddressVLbl.text = tSaddress
                    self.destAddVLbl.text = tDAddress
                    self.sourceAddressVLbl.numberOfLines = 0
                    self.destAddVLbl.numberOfLines = 0
                    
                    let sourceAddHeight = tSaddress.height(withConstrainedWidth: Application.screenSize.width - 90, font: UIFont(name: Fonts().regular, size: 14)!)
                    let destAddHeight = tDAddress.height(withConstrainedWidth: Application.screenSize.width - 90, font: UIFont(name: Fonts().regular, size: 14)!)
                    
//                    self.addressContainerViewHeight.constant = 115 + sourceAddHeight + destAddHeight

                    self.addressContainerViewHeight.constant = 90 + sourceAddHeight + destAddHeight
                    
                    if(tDAddress.trim() == ""){
                        self.destAddHLbl.isHidden = true
                        self.destAddVLbl.text = ""
                        self.destAddVLbl.fitText()
                        self.dashedView.isHidden = true
                        self.destLocView.isHidden = true
                        self.addressContainerViewHeight.constant = sourceAddHeight + 40
                    }
                    
                    self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.addressContainerViewHeight.constant
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                        self.dashedView.addDashedLine(color: UIColor(hex: 0x141414), lineWidth: 2, true)
                        self.setPageHeight()
                    })
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                        
                        if(btnClickedId == 0){
                            self.getTripData()
                        }
                    })
                }
                
            }else{
                self.generalFunc.setError(uv: self)
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again later", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                    
                    if(btnClickedId == 0){
                        self.getTripData()
                    }
                })
            }
            
            self.loaderView.isHidden = true
            self.cntView.isHidden = false
            self.scrollView.isHidden = false
            self.bottomDetailsView.isHidden = false
            self.collectPayBtn.isHidden = false
        })
    }
    
//    func addFareDetails(dataDict:NSDictionary){
//        
//        let FareDetailsNewArr = dataDict.getObj(Utils.message_str).getArrObj("FareDetailsNewArr")
//        
//        var totalSeperatorViews = 0
//        let seperatorViewHeight = 1
//        
//        for i in 0..<FareDetailsNewArr.count {
//            
//            let dict_temp = FareDetailsNewArr[i] as! NSDictionary
//            
//            for (key, value) in dict_temp {
//                
//                let totalSubViewCounts = self.fareDataContainerView.subviews.count
//                
//                if((key as! String) == "eDisplaySeperator"){
//                    
//                    let viewWidth = Application.screenSize.width - 30
//                    
//                    let viewCus = UIView(frame: CGRect(x: 10, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth - 20, height: 1))
//                    
//                    viewCus.backgroundColor = UIColor(hex: 0xdedede)
//                
//                    self.fareDataContainerView.addSubview(viewCus)
//                    
//                    totalSeperatorViews = totalSeperatorViews + 1
//                }else{
//                    let viewWidth = Application.screenSize.width - 30
//                    
//                    let viewCus = UIView(frame: CGRect(x: 0, y:  CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth, height: 40))
//                    
//                    let titleStr = Configurations.convertNumToAppLocal(numStr: key as! String)
//                    let valueStr = Configurations.convertNumToAppLocal(numStr: value as! String)
//                    
//                    var font:UIFont!
//                    
//                    if(i == FareDetailsNewArr.count - 1){
//                        font = UIFont(name: Fonts().semibold, size: 18)!
//                    }else{
//                        font = UIFont(name: Fonts().regular, size: 13)!
//                    }
//
//                    var widthOfTitle = titleStr.width(withConstrainedHeight: 40, font: font) + 15
//                    var widthOfvalue = valueStr.width(withConstrainedHeight: 40, font: font) + 15
//                    
//                    if(widthOfTitle > ((viewWidth * 20) / 100) && widthOfvalue > ((viewWidth * 80) / 100)){
//                        widthOfvalue = ((viewWidth * 80) / 100)
//                        widthOfTitle = ((viewWidth * 20) / 100)
//                    }else if(widthOfTitle < ((viewWidth * 20) / 100) && widthOfvalue > ((viewWidth * 80) / 100) && (viewWidth - widthOfTitle - widthOfvalue) < 0){
//                        widthOfvalue = viewWidth - widthOfTitle
//                    }
//                    
//                    let widthOfParentView = viewWidth - widthOfvalue
//                    
//                    var lblTitle = MyLabel(frame: CGRect(x: 0, y: 0, width: widthOfParentView - 5, height: 40))
//                    var lblValue = MyLabel(frame: CGRect(x: widthOfParentView - 5, y: 0, width: widthOfvalue, height: 40))
//                    
//                    if(Configurations.isRTLMode()){
//                        lblTitle = MyLabel(frame: CGRect(x: widthOfvalue + 5, y: 0, width: widthOfParentView, height: 40))
//                        lblValue = MyLabel(frame: CGRect(x: 5, y: 0, width: widthOfvalue, height: 40))
//                        
//                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
//                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
//                    }else{
//                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
//                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
//                    }
//                    
//                    lblTitle.textColor = UIColor(hex: 0x141414)
//                    lblValue.textColor = UIColor(hex: 0x141414)
//                    
//                    lblTitle.font = font
//                    lblValue.font = font
//                    
//                    lblTitle.fontFamilyWeight = "Medium"//"Regular"
//                    lblValue.fontFamilyWeight = "Medium"//"Regular"
//                    lblTitle.setFontFamily()
//                    lblValue.setFontFamily()
//                    
//                    lblTitle.numberOfLines = 2
//                    lblValue.numberOfLines = 2
//                    
//                    lblTitle.minimumScaleFactor = 0.5
//                    lblValue.minimumScaleFactor = 0.5
//                    
//                    lblTitle.text = titleStr
//                    lblValue.text = valueStr
//                    
//                    viewCus.addSubview(lblTitle)
//                    viewCus.addSubview(lblValue)
//                    
//                    self.fareDataContainerView.addSubview(viewCus)
//                    
//                    if(Configurations.isRTLMode()){
//                        lblValue.textAlignment = .left
//                    }else{
//                        lblValue.textAlignment = .right
//                    }
//                    
//                    if(i == FareDetailsNewArr.count - 1){
//                        lblTitle.font = UIFont(name: Fonts().semibold, size: 15)!
//                        lblValue.font = UIFont(name: Fonts().semibold, size: 15)!
//                        lblTitle.fontFamilyWeight = "Medium"//"Medium"
//                        lblValue.fontFamilyWeight = "Medium"//"Medium"
//                        lblTitle.setFontFamily()
//                        lblValue.setFontFamily()
//                        lblTitle.textColor = UIColor(hex: 0x141414)
//                        lblValue.textColor = UIColor.UCAColor.AppThemeColor
//                        
//                    }
//                }
//            }
//        }
//        
//        self.fareContainerView.layoutIfNeeded()
//        
//        self.fareContainerViewHeight.constant = CGFloat((self.fareDataContainerView.subviews.count - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight))
//        
//        self.detailsViewHeight.constant = self.detailsViewHeight.constant +  self.fareContainerViewHeight.constant
//        
//        self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.detailsViewHeight.constant
//        
//        self.setPageHeight()
//        
////        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
////            self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: self.PAGE_HEIGHT)
////            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
////        })
//
//    }
    
    func addFareDetails(dataDict:NSDictionary){
        let FareDetailsNewArr = dataDict.getObj(Utils.message_str).getArrObj("FareDetailsNewArr")

        var totalSeperatorViews = 0
        let seperatorViewHeight = 1

        for i in 0..<FareDetailsNewArr.count {
            let dict_temp = FareDetailsNewArr[i] as! NSDictionary

            for (key, value) in dict_temp {
                let totalSubViewCounts = self.fareDataContainerView.subviews.count

                if ((key as! String) == "eDisplaySeperator") {

                    let viewWidth = Application.screenSize.width - 30
                    let viewCus = UIView(
                        frame: CGRect(
                            x: 10,
                            y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)),
                            width: viewWidth - 20,
                            height: 1
                        )
                    )
                    viewCus.backgroundColor = UIColor(hex: 0xdedede)
                    self.fareDataContainerView.addSubview(viewCus)
                    totalSeperatorViews += 1

                } else {

                    let viewWidth = Application.screenSize.width - 30
                    let viewCus = UIView(
                        frame: CGRect(
                            x: 0,
                            y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)),
                            width: viewWidth,
                            height: 40
                        )
                    )

                    let titleStr = Configurations.convertNumToAppLocal(numStr: key as! String)
                    let valueStr = Configurations.convertNumToAppLocal(numStr: value as! String)

                    // fonts
                    let font: UIFont = (i == FareDetailsNewArr.count - 1)
                        ? UIFont(name: Fonts().semibold, size: 18)!
                        : UIFont(name: Fonts().regular,  size: 13)!

                
                    let valueColumnMin: CGFloat = 80
                    let valueColumnPct: CGFloat = 0.28
                    let widthOfValue: CGFloat = max(valueColumnMin, floor(viewWidth * valueColumnPct))
                    let widthOfTitle: CGFloat = viewWidth - widthOfValue
                

                    var lblTitle = MyLabel(frame: CGRect(x: 0, y: 0, width: widthOfTitle - 5, height: 40))
                    var lblValue = MyLabel(frame: CGRect(x: widthOfTitle - 5, y: 0, width: widthOfValue, height: 40))

                    if (Configurations.isRTLMode()) {
                        lblTitle = MyLabel(frame: CGRect(x: widthOfValue + 5, y: 0, width: widthOfTitle, height: 40))
                        lblValue = MyLabel(frame: CGRect(x: 5, y: 0, width: widthOfValue, height: 40))
                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0,  paddingRight: 15)
                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                    } else {
                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 10)
                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 15)
                    }

                    lblTitle.textColor = UIColor(hex: 0x141414)
                    lblValue.textColor = UIColor(hex: 0x141414)

                    lblTitle.font = font
                    lblValue.font = font

                    lblTitle.fontFamilyWeight = "Bold"
                    lblValue.fontFamilyWeight = "Bold"
                    lblTitle.setFontFamily()
                    lblValue.setFontFamily()

                    // ---- KEEP ON ONE LINE ----
                    lblTitle.numberOfLines = 1
                    lblTitle.lineBreakMode = .byTruncatingTail

                    lblValue.numberOfLines = 1
                    lblValue.adjustsFontSizeToFitWidth = true
                    lblValue.minimumScaleFactor = 0.7
                    // ---------------------------

                    lblTitle.text = titleStr
                    lblValue.text = valueStr

                    viewCus.addSubview(lblTitle)
                    viewCus.addSubview(lblValue)
                    self.fareDataContainerView.addSubview(viewCus)

                    lblValue.textAlignment = Configurations.isRTLMode() ? .left : .right

                    if (i == FareDetailsNewArr.count - 1) {
                        lblTitle.font = UIFont(name: Fonts().semibold, size: 15)!
                        lblValue.font = UIFont(name: Fonts().semibold, size: 15)!
                        lblTitle.fontFamilyWeight = "Bold"
                        lblValue.fontFamilyWeight = "Bold"
                        lblTitle.setFontFamily()
                        lblValue.setFontFamily()
                        lblTitle.textColor = UIColor(hex: 0x141414)
                        lblValue.textColor = UIColor.UCAColor.AppThemeColor
                    }
                }
            }
        }

        self.fareContainerView.layoutIfNeeded()

        self.fareContainerViewHeight.constant = CGFloat(
            (self.fareDataContainerView.subviews.count - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)
        )

        self.detailsViewHeight.constant = self.detailsViewHeight.constant + self.fareContainerViewHeight.constant
        self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.detailsViewHeight.constant
        self.setPageHeight()
    }

    
    func setPageHeight(){
        self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: self.PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
    }
    
    func myBtnTapped(sender: MyButton){
        if(sender == self.collectPayBtn){
            if isEnableRating.uppercased() == "YES" {
                self.collectPayment(isCollectCash: "")
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SKIP_RATING"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SKIP_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedId) in
                    
                    if(btnClickedId == 0){
                        self.isSkipRating = "Yes"
                    }else{
                        self.isSkipRating = "No"
                    }
                    
                    self.collectPayment(isCollectCash: "")
                })
            }
        }
    }
    
    func collectPayment(isCollectCash:String){
        
        var parameters = ["type":"CollectPayment", "iTripId": tripData!.get("TripId"), "isCollectCash": isCollectCash]
        
        if isEnableRating.uppercased() == "NO" {
            parameters["isSkipRating"] = isSkipRating
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let window = Application.window
                    
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COLLECT_CASH"), completionHandler: { (btnClickedId) in
                        
                        if(btnClickedId == 0){
                            self.collectPayment(isCollectCash: "")
                        }else{
                            self.collectPayment(isCollectCash: "true")
                        }
                    })
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    
    }
}
