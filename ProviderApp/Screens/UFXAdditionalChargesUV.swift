//
//  UFXAdditionalChargesUV.swift
//  DriverApp
//
//  Created by Admin on 26/07/18.
//  Copyright © 2018 @. All rights reserved.
//

import UIKit

class UFXAdditionalChargesUV: UIViewController, MyBtnClickDelegate, MyTxtFieldOnTextChangeDelegate,OnTaskRunCalledDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var btnAreaBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var btnAreaContainerView: UIView!
    @IBOutlet weak var skipBtn: MyButton!
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var submitButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var currentChargesHLbl: MyLabel!
    @IBOutlet weak var currentChargesVLbl: MyLabel!
    @IBOutlet weak var materialFeeHLbl: MyLabel!
    @IBOutlet weak var materialFeeCurrencyLbl: MyLabel!
    @IBOutlet weak var materialFeeTxtField: MyTextField!
    
    @IBOutlet weak var disciuntViewHeight: NSLayoutConstraint!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var miscFeeView: UIView!
    @IBOutlet weak var miscFeeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var miscFeeHLbl: MyLabel!
    @IBOutlet weak var miscFeeCurrencyLbl: MyLabel!
    @IBOutlet weak var miscFeeTxtField: MyTextField!
    
    @IBOutlet weak var providerDiscountHLbl: MyLabel!
    @IBOutlet weak var providerDiscountCurrencyLbl: MyLabel!
    @IBOutlet weak var providerDiscountTxtField: MyTextField!
    @IBOutlet weak var finalTotalHLbl: MyLabel!
    @IBOutlet weak var finalTotalVLbl: MyLabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noteHLbl: MyLabel!
    @IBOutlet weak var noteVLbl: MyLabel!
    @IBOutlet weak var btnAreaCntViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblMaterialCurrencyTraling: NSLayoutConstraint!
    @IBOutlet weak var lblMiscCurrencyTraling: NSLayoutConstraint!
    @IBOutlet weak var verificationViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var lblProvderDiscountTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var materialTextFiledTraling: NSLayoutConstraint!
    @IBOutlet weak var miscTextFiledTrailing: NSLayoutConstraint!
    @IBOutlet weak var providerDiscountTextFiledTraling: NSLayoutConstraint!
    @IBOutlet weak var verificationView: UIView!
    @IBOutlet weak var verificationHLbl: MyLabel!
    @IBOutlet weak var verificationSHLbl: MyLabel!
    @IBOutlet weak var verificationCancelLbl: MyLabel!
    @IBOutlet weak var verificationLoaderView: UIView!
    @IBOutlet weak var verificationBgView: UIView!
    @IBOutlet weak var otpVerificationView: SROTPView!
    @IBOutlet weak var otpSubmitBtn: MyButton!
    @IBOutlet weak var viewMaterial: UIView!
    
    var PAGE_HEIGHT:CGFloat = 300
    
    var isSafeAreaSet = false
    var iphoneXBottomView:UIView!
    
    var generalFunc = GeneralFunctions()
    
    var cntView:UIView!
    var animTask:UpdateFreqTask!

    var userProfileJson:NSDictionary!
    
    var fareValue:Double = 0
    var currentMaterialFee:Double = 0
    var currentMiscFee:Double = 0
    var currentProviderDiscount:Double = 0
    var otpEnteredValue = ""
    var isTextEditingBlock = false
    
    var currentFare = ""
    var loaderView:UIView!
    var currencySymbol = ""
    var navZposition:CGFloat = 0
     var receivedCode:String!

    var tripData:NSDictionary!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
//    override func viewDidLayoutSubviews() {
//        if(isSafeAreaSet == false){
//            if(Configurations.isIponeXDevice()){
//                if(iphoneXBottomView == nil){
//                    iphoneXBottomView = UIView()
//                    self.view.addSubview(iphoneXBottomView)
//                }
//                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
//                iphoneXBottomView.frame = CGRect(x: 0, y: self.contentView.frame.maxY - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: GeneralFunctions.getSafeAreaInsets().bottom)
//
//                btnAreaBottomMargin.constant = GeneralFunctions.getSafeAreaInsets().bottom
//            }
//            isSafeAreaSet = true
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        /** Used for configDriverTripStatus Type */
        GeneralFunctions.saveValue(key: "iTripId", value: "" as AnyObject)
        /** Used for configDriverTripStatus Type */
        
        cntView = self.generalFunc.loadView(nibName: "UFXAdditionalChargesScreenDesign", uv: self, contentView: scrollView)
        self.scrollView.backgroundColor = UIColor(hex: 0xFFFFFF)
        self.scrollView.addSubview(cntView)
        self.scrollView.bounces = false
        
        otpVerificationView.otpTextFieldsCount = 4
        otpVerificationView.otpTextFieldActiveBorderColor = UIColor.UCAColor.AppThemeColor
        otpVerificationView.otpTextFieldDefaultBorderColor = UIColor.UCAColor.AppThemeColor.lighter(by: 0.5)!
        otpVerificationView.otpTextFieldFontColor = UIColor.UCAColor.AppThemeColor
        otpVerificationView.activeHeight = 4
        otpVerificationView.inactiveHeight = 4
        otpVerificationView.otpType = .Bordered
        otpVerificationView.otpEnteredString = { pin in
            self.otpEnteredValue = pin
        }
        otpVerificationView.setUpOtpView()
        
        self.setData()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    func setData(){
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADDITIONAL_CHARGES")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADDITIONAL_CHARGES")
        
        self.noteHLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE")):-"
        self.noteVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADDITIONAL_CHARGE_NOTE")
        
        let noteValueHeight = noteVLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().regular, size: 16)!)
        
        PAGE_HEIGHT = PAGE_HEIGHT + noteValueHeight
        
        currentFare = tripData.get("fEstTripGenerateFare")
        fareValue = GeneralFunctions.parseDouble(origValue: 0.0, data: tripData.get("fEstTripGenerateFare"))
        currencySymbol = userProfileJson.get("UberXFareCurrencySymbol")
        let fTripGenerateFareNew = userProfileJson.get("fTripGenerateFareNew")
        
        materialFeeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MATERIAL_FEE")
//        currentChargesHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SERVICE_COST")
        currentChargesHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRIP_FARE_TXT")
        miscFeeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MISC_FEE")
        providerDiscountHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROVIDER_DISCOUNT")
        
        skipBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SKIP_TXT"))
        submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OVERRIDE_TXT"))
        
        finalTotalHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Final total", key: "LBL_FINAL_TOTAL").uppercased()
        finalTotalVLbl.text = Configurations.convertNumToAppLocal(numStr: currentFare ) //currentFare
//        currentChargesVLbl.text =  Configurations.convertNumToAppLocal(numStr: currentFare )//currentFare
        currentChargesVLbl.text =  tripData.get("fEstTripGenerateFareWithSymbol")
        currentChargesHLbl.textColor = UIColor.UCAColor.AppThemeColor
        currentChargesHLbl.backgroundColor = UIColor.clear
        currentChargesVLbl.textColor = UIColor.UCAColor.AppThemeColor
        materialFeeCurrencyLbl.text = self.currencySymbol
        miscFeeCurrencyLbl.text = self.currencySymbol
        providerDiscountCurrencyLbl.text = "- \(self.currencySymbol)"
        
        skipBtn.clickDelegate = self
        submitBtn.clickDelegate = self
        
        materialFeeTxtField.getTextField()!.keyboardType = .decimalPad
        miscFeeTxtField.getTextField()!.keyboardType = .decimalPad
        providerDiscountTxtField.getTextField()!.keyboardType = .decimalPad
        
        materialFeeTxtField.onTextChangedDelegate = self
        miscFeeTxtField.onTextChangedDelegate = self
        providerDiscountTxtField.onTextChangedDelegate = self
        
        if(Configurations.isRTLMode()){
            currentChargesVLbl.textAlignment = .left
            finalTotalVLbl.textAlignment = .left
        }
        materialFeeTxtField.maxCharacterLimit = 10
        miscFeeTxtField.maxCharacterLimit = 10
        providerDiscountTxtField.maxCharacterLimit = 10
        
        materialFeeTxtField.setPlaceHolder(placeHolder: Configurations.convertNumToAppLocal(numStr: "0.00"))
        miscFeeTxtField.setPlaceHolder(placeHolder: Configurations.convertNumToAppLocal(numStr: "0.00"))
        providerDiscountTxtField.setPlaceHolder(placeHolder: Configurations.convertNumToAppLocal(numStr: "0.00"))
        materialFeeTxtField.getTextField()!.placeholderAnimation = .hidden
        miscFeeTxtField.getTextField()!.placeholderAnimation = .hidden
        providerDiscountTxtField.getTextField()!.placeholderAnimation = .hidden
        
//        self.materialFeeTxtField.defaultTextAlignment = .center
//        self.miscFeeTxtField.defaultTextAlignment = .center
//        self.providerDiscountTxtField.defaultTextAlignment = .center

        
        self.scrollView.contentSize = CGSize(width: Application.screenSize.width, height: PAGE_HEIGHT)
        if(tripData.get("ENABLE_VERIFY_ADDITIONAL_CHARGE_FLOW").uppercased() == "YES" && self.tripData.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                   
                   self.skipBtn.isHidden = true
                 //self.submitButtonWidth.constant = btnAreaContainerView.frame.size.width
           
                 
                    if(self.sepratorView != nil){
                        self.sepratorView.isHidden = true
                    }
                   
                   if(self.tripData.get("vChargesDetailData") != "" && self.tripData.get("vChargesDetailData").getJsonDataDict().count > 0){
                       
                         self.otpVerificationView.isHidden = true
                         let chargesData = self.tripData.get("vChargesDetailData").getJsonDataDict()
                         materialFeeTxtField.setPlaceHolder(placeHolder: Configurations.convertNumToAppLocal(numStr: chargesData.get("fMaterialFee")))
                         miscFeeTxtField.setPlaceHolder(placeHolder: Configurations.convertNumToAppLocal(numStr: chargesData.get("fMiscFee")))
                         providerDiscountTxtField.setPlaceHolder(placeHolder: Configurations.convertNumToAppLocal(numStr: chargesData.get("fDriverDiscount")))
                         self.currentMaterialFee = GeneralFunctions.parseDouble(origValue: 0.0, data: chargesData.get("fMaterialFee"))
                         self.currentMiscFee = GeneralFunctions.parseDouble(origValue: 0.0, data: chargesData.get("fMiscFee"))
                         self.currentProviderDiscount = GeneralFunctions.parseDouble(origValue: 0.0, data: chargesData.get("fDriverDiscount"))
                       
                        self.fareValue = fareValue + GeneralFunctions.parseDouble(origValue: 0.0, data: chargesData.get("fMaterialFee")) + GeneralFunctions.parseDouble(origValue: 0.0, data: chargesData.get("fMiscFee")) + GeneralFunctions.parseDouble(origValue: 0.0, data: chargesData.get("fDriverDiscount"))
                        
                         finalTotalVLbl.text = currencySymbol + " " + Configurations.convertNumToAppLocal(numStr: "\(self.fareValue)")
                   
                       if(tripData.get("ADDITIONAL_CHARGE_VERIFICATION_METHOD").uppercased() == "APPROVAL" && self.tripData.get("eApproveRequestSentByDriver").uppercased() == "YES"){
                           self.openVerificationView()
                           
                             self.animTask = UpdateFreqTask(interval: 5)
                             self.animTask.currInst = self.animTask
                             self.animTask.setTaskRunListener(onTaskRunCalled: self)
                             self.animTask.startRepeatingTask()
                       }else{
                           self.openOtpVerification()
                       }
                         
                   }
                   
                   if(tripData.get("ADDITIONAL_CHARGE_VERIFICATION_METHOD").uppercased() == "APPROVAL"){
                       self.verificationHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFY_CHARGES_TITLE_TXT")
                       self.verificationSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFY_CHARGES_NOTE_TXT")
                       self.verificationCancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
                       
                       self.otpVerificationView.isHidden = true
                       
                   }else{
                       
                       self.otpSubmitBtn.isHidden = false
                       self.otpSubmitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONE"))
                       self.otpSubmitBtn.clickDelegate = self
                       
                       self.verificationHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFY_CHARGES_TITLE_TXT")
                       self.verificationSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFY_CHARGES_BY_USER_NOTE_TXT")
                    
                       self.verificationCancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
                       
                   }
                   
                   self.verificationCancelLbl.setOnClickListener { (instance) in
                       if(self.tripData.get("ADDITIONAL_CHARGE_VERIFICATION_METHOD").uppercased() == "APPROVAL"){
                           self.startVerification(eApproveRequestSentByDriver: "No")
                       }else{
                           self.stopVerificationProcess()
                       }
                   }
        }
           
        if(Configurations.isIponeXDevice()){
           self.btnAreaCntViewHeight.constant = self.btnAreaCntViewHeight.constant + 30
        }
      
        

        if((self.tripData.get("ENABLE_MANUAL_TOLL_FEATURE").uppercased() == "YES" || self.tripData.get("ENABLE_OTHER_CHARGES_FEATURE").uppercased() == "YES") && self.tripData.get("eType").uppercased() != Utils.cabGeneralType_UberX.uppercased()){
            
           
            self.verificationCancelLbl.setOnClickListener { (instance) in
                if(self.tripData.get("ADDITIONAL_CHARGE_VERIFICATION_METHOD").uppercased() == "APPROVAL"){
                    self.startVerification(eApproveRequestSentByDriver: "No")
                }else{
                    self.stopVerificationProcess()
                }
            }
            
            if(tripData.get("ENABLE_MANUAL_TOLL_VERIFICATION_METHOD").uppercased() == "APPROVAL"){
                self.verificationHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFICATION")
                self.verificationSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFY_CHARGES_NOTE_TXT")
                self.verificationCancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
                
                self.otpVerificationView.isHidden = true
                
            }else{
                
                self.otpSubmitBtn.isHidden = false
                self.otpSubmitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONE"))
                self.otpSubmitBtn.clickDelegate = self
                
                self.verificationHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFICATION")
                self.verificationSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHARGES_VERIFY_NOTE")
             
                self.verificationCancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
                
            }
            
            self.skipBtn.isHidden = false
            self.headerViewHeight.constant = 40
            
           // self.headerViewHeight.constant = 0
           // self.headerView.isHidden = true
            
            self.headerView.backgroundColor = UIColor.white
            
          //  self.currentChargesHLbl.isHidden = true
          //  self.currentChargesVLbl.isHidden = true
            
            self.discountView.isHidden = true
            self.miscFeeView.isHidden = true
            self.disciuntViewHeight.constant = 0
            self.miscFeeViewHeight.constant = 0
            
            self.currencySymbol = userProfileJson.get("CurrencySymbol")
            finalTotalVLbl.text = tripData.get("fEstTripGenerateFareWithSymbol")
            
            if(self.tripData.get("ENABLE_MANUAL_TOLL_FEATURE").uppercased() == "YES" && self.tripData.get("ENABLE_OTHER_CHARGES_FEATURE").uppercased() == "YES"){
                  
                self.miscFeeView.isHidden = false
                self.miscFeeViewHeight.constant = 40
                
                materialFeeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOLL_CHARGES")
                miscFeeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OTHER_CHARGES")
                
                self.noteVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOLL_CHARGE_NOTE") + "\n" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AND_TXT") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OTHER_CHARGE_NOTE") + " " + self.generalFunc.getLanguageLabel(origValue: "Trip fare may vary once you enter Toll and Other Charges", key: "LBL_TRIP_FARE_TOLL_OTHER_CHARGES_NOTE")
            
                
            }else if(self.tripData.get("ENABLE_MANUAL_TOLL_FEATURE").uppercased() == "YES"){
                
                materialFeeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOLL_CHARGES")
                
                self.noteVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOLL_CHARGE_NOTE") + "\n" + self.generalFunc.getLanguageLabel(origValue: "Trip fare may vary once you enter Toll Charges", key: "LBL_TRIP_FARE_TOLL_CHARGES_NOTE")
                
            }else if(self.tripData.get("ENABLE_OTHER_CHARGES_FEATURE").uppercased() == "YES"){
                
                materialFeeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OTHER_CHARGES")
                
                self.noteVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OTHER_CHARGE_NOTE") + "\n" + self.generalFunc.getLanguageLabel(origValue: "Trip fare may vary once you enter Other Charges", key: "LBL_TRIP_FARE_OTHER_CHARGES_NOTE")
            }
        }
    
        if(Configurations.isRTLMode()){
//            self.lblMaterialCurrencyTraling.constant = self.viewMaterial.frame.size.width - 10
//            lblMiscCurrencyTraling.constant = self.viewMaterial.frame.size.width - 10
//            lblProvderDiscountTrailing.constant = self.viewMaterial.frame.size.width - 15
//            self.materialTextFiledTraling.constant = 15
//            self.miscTextFiledTrailing.constant = 15
//            self.providerDiscountTextFiledTraling.constant = 15
        }
        if userProfileJson.get("eReverseSymbolEnable").uppercased() == "YES" {
            if !(Configurations.isRTLMode()){
            self.lblMaterialCurrencyTraling.constant = 90
            lblMiscCurrencyTraling.constant = 90//self.viewMaterial.frame.size.width - 10
            lblProvderDiscountTrailing.constant = 80
            }//self.viewMaterial.frame.size.width - 15
        }
        
        if self.tripData.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() {
            finalTotalHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Final total", key: "LBL_FINAL_TOTAL").uppercased()
        }else{
            finalTotalHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Charges", key: "LBL_TOTAL_EXTRA_CHARGES_TXT").uppercased()
        }
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
        if(sender == materialFeeTxtField){
            let currentMaterialFee = GeneralFunctions.parseDouble(origValue: 0.00, data: Utils.getText(textField: sender.getTextField()!))
            if(self.currentMaterialFee > 0){
                self.fareValue = self.fareValue - self.currentMaterialFee
            }
            self.fareValue = self.fareValue + currentMaterialFee
            
            self.currentMaterialFee = currentMaterialFee
        }
        if(sender == miscFeeTxtField){
            let currentMiscFee = GeneralFunctions.parseDouble(origValue: 0.00, data: Utils.getText(textField: sender.getTextField()!))
            if(self.currentMiscFee > 0){
                self.fareValue = self.fareValue - self.currentMiscFee
            }
            self.fareValue = self.fareValue + currentMiscFee
            
            self.currentMiscFee = currentMiscFee
        }
        if(sender == providerDiscountTxtField){
            if(isTextEditingBlock){
                isTextEditingBlock = false
                return
            }
            var currentProviderDiscount = GeneralFunctions.parseDouble(origValue: 0.00, data: Utils.getText(textField: sender.getTextField()!))
            if(self.currentProviderDiscount > 0){
                self.fareValue = self.fareValue + self.currentProviderDiscount
            }
            if((self.fareValue - currentProviderDiscount) < 0){
                currentProviderDiscount = self.fareValue
                isTextEditingBlock = true
                providerDiscountTxtField.setText(text: "\(String(format: "%.02f", self.fareValue))")
            }
            self.fareValue = self.fareValue - currentProviderDiscount
            
            self.currentProviderDiscount = currentProviderDiscount
        }
        
        finalTotalVLbl.text = "\(self.currencySymbol)\(String(format: "%.02f", fareValue))"
    }
    
    func myBtnTapped(sender: MyButton) {
        
        if(sender == self.otpSubmitBtn){
            if(otpEnteredValue == "" || otpEnteredValue.count < 4){
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_VERIFICATION_CODE"))
                return
            }
            
            if(self.receivedCode == nil || self.otpEnteredValue != self.receivedCode){
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFICATION_CODE_INVALID"))
                return
            }
            
            processEndTrip(isSkip: false)
            return
        }
        
        if(sender == skipBtn){
            processEndTrip(isSkip: true)
            return
        }
        
        if(tripData.get("ENABLE_VERIFY_ADDITIONAL_CHARGE_FLOW").uppercased() == "YES" && self.tripData.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            
            if(tripData.get("ADDITIONAL_CHARGE_VERIFICATION_METHOD").uppercased() == "APPROVAL"){
                
                //self.startVerification(eApproveRequestSentByDriver: "Yes")
                if self.currentMaterialFee <= 0 {
                    self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SURE_ADDITIONAL_CHARGES_EMPTY_TXT"), isApproval: true, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN"))
                    return
                }else {
                    self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ARE_YOU_SURE_YOU_WANT_TO_PROCEED_WITH_ADDITIONAL_CHARGES"), isApproval: true, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT") )
                    return
                }
            }else{
               // self.startVerification(eApproveRequestSentByDriver: "")
                if self.currentMaterialFee <= 0 {
                    self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SURE_ADDITIONAL_CHARGES_EMPTY_TXT"), isApproval: false, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN"))
                    return
                    
                }else {
                    self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ARE_YOU_SURE_YOU_WANT_TO_PROCEED_WITH_ADDITIONAL_CHARGES"), isApproval: false, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT") )
                    return
                }
            }
        
            return
        }else if((self.tripData.get("ENABLE_MANUAL_TOLL_FEATURE").uppercased() == "YES" || self.tripData.get("ENABLE_OTHER_CHARGES_FEATURE").uppercased() == "YES") && self.tripData.get("eType").uppercased() != Utils.cabGeneralType_UberX.uppercased()){
            
            if(tripData.get("ENABLE_MANUAL_TOLL_VERIFICATION_METHOD").uppercased() == "APPROVAL"){
                if self.currentMaterialFee <= 0  &&  self.currentMiscFee <= 0 && self.currentProviderDiscount  <= 0 {
                    self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SURE_ADDITIONAL_CHARGES_EMPTY_TXT"), isApproval: true, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN"))
                    return
                }else {
                    self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ARE_YOU_SURE_YOU_WANT_TO_PROCEED_WITH_ADDITIONAL_CHARGES"), isApproval: true, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT") )
                    return
                }
                //self.startVerification(eApproveRequestSentByDriver: "Yes")
            }else{
                
                if self.currentMaterialFee <= 0  &&  self.currentMiscFee <= 0 && self.currentProviderDiscount  <= 0 {
                    self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SURE_ADDITIONAL_CHARGES_EMPTY_TXT"), isApproval: false, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN"))
                    return
                    
                }else {
                    self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ARE_YOU_SURE_YOU_WANT_TO_PROCEED_WITH_ADDITIONAL_CHARGES"), isApproval: false, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT") )
                    return
                }
                
//                if self.currentMaterialFee <= 0 {
//
//                    if(self.tripData.get("ENABLE_OTHER_CHARGES_FEATURE").uppercased() == "YES"){
//                        if self.currentMiscFee <= 0{
//                            self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SURE_ADDITIONAL_CHARGES_EMPTY_TXT"), isApproval: false, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN"))
//                            return
//                        }else{
//                            self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ARE_YOU_SURE_YOU_WANT_TO_PROCEED_WITH_ADDITIONAL_CHARGES"), isApproval: false, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT") )
//                            return
//                        }
//                    }else{
//                        self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SURE_ADDITIONAL_CHARGES_EMPTY_TXT"), isApproval: false, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN"))
//                        return
//                    }
//
//                }else {
//                    self.tollCharegeEmptyCheck(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ARE_YOU_SURE_YOU_WANT_TO_PROCEED_WITH_ADDITIONAL_CHARGES"), isApproval: false, positiveButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT") )
//                    return
//                }
                //self.startVerification(eApproveRequestSentByDriver: "")
            }
        }
        
        if self.currentMaterialFee <= 0  &&  self.currentMiscFee <= 0 && self.currentProviderDiscount  <= 0 {
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SURE_ADDITIONAL_CHARGES_EMPTY_TXT"), positiveBtn:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN") , nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: {(btnClickedId) in
                if(btnClickedId == 0){
                 
                    self.processEndTrip(isSkip: false)
                }
                if(btnClickedId == 1){
                }
            })
        }else{
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ARE_YOU_SURE_YOU_WANT_TO_PROCEED_WITH_ADDITIONAL_CHARGES"), positiveBtn:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT") , nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: {(btnClickedId) in
                if(btnClickedId == 0){
                 
                    self.processEndTrip(isSkip: false)
                }
                if(btnClickedId == 1){
                }
            })
            
            
           // self.processEndTrip(isSkip: false)
        }
        
    }
    
    func processEndTrip(isSkip:Bool){
        var parameters = ["type":"ProcessEndTrip", "TripId": tripData!.get("TripId"), "PassengerId": tripData!.get("PassengerId"),"DriverId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "fMaterialFee": isSkip == false ? "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "")" : "", "fMiscFee": isSkip == false ? "\(currentMiscFee > 0 ? "\(currentMiscFee)" : "")" : "", "fDriverDiscount": isSkip == false ? "\(currentProviderDiscount > 0 ? "\(currentProviderDiscount)" : "")" : "", "latList": tripData!.get("sourceLatitude"), "lonList": tripData!.get("sourceLongitude"), "dest_lat": tripData!.get("DestLocLatitude"), "dest_lon": tripData!.get("DestLocLongitude")]
        
        if(self.tripData.get("eType").uppercased() != Utils.cabGeneralType_UberX.uppercased() && isSkip == false){
            
            if(self.tripData.get("ENABLE_MANUAL_TOLL_FEATURE").uppercased() == "YES" && self.tripData.get("ENABLE_OTHER_CHARGES_FEATURE").uppercased() == "YES") {
                                parameters["fTollPrice"] = "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")"
                                parameters["fOtherCharges"] = "\(currentMiscFee > 0 ? "\(currentMiscFee)" : "0")"
                            }
                            else if self.tripData.get("ENABLE_MANUAL_TOLL_FEATURE").uppercased() == "YES"{
                                parameters["fTollPrice"] = "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")"
                                parameters["fOtherCharges"] = "0"
                            }
                            else{
                                parameters["fTollPrice"] = "0"
                                parameters["fOtherCharges"] = "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")"
                            }
            //parameters["fTollPrice"] = isSkip == false ? "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "")" : ""
           // parameters["fOtherCharges"] = isSkip == false ? "\(currentMiscFee > 0 ? "\(currentMiscFee)" : "")" : ""
            
            parameters["fDriverDiscount"] = isSkip == false ? "\(currentProviderDiscount > 0 ? "\(currentProviderDiscount)" : "")" : ""
            parameters["fMaterialFee"] = ""
            parameters["fMiscFee"] = ""
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
                        
                    }else if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
            })
        
    }
    func startVerification(eApproveRequestSentByDriver:String){
            
        var parameters = ["type":"sendChargeVerificationCode"]
        if(eApproveRequestSentByDriver == ""){
             parameters = ["type":"sendChargeVerificationCode", "TripId": tripData!.get("TripId"), "PassengerId": tripData!.get("PassengerId"),"DriverId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "fMaterialFee": "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")", "fMiscFee": "\(currentMiscFee > 0 ? "\(currentMiscFee)" : "0")", "fDriverDiscount": "\(currentProviderDiscount > 0 ? "\(currentProviderDiscount)" : "0")", "iTripTimeId": tripData!.get("iTripTimeId")]
            
            if(self.tripData.get("eType").uppercased() != Utils.cabGeneralType_UberX.uppercased()){
                
                if(self.tripData.get("ENABLE_MANUAL_TOLL_FEATURE").uppercased() == "YES" && self.tripData.get("ENABLE_OTHER_CHARGES_FEATURE").uppercased() == "YES") {
                                    parameters["fTollPrice"] = "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")"
                                    parameters["fOtherCharges"] = "\(currentMiscFee > 0 ? "\(currentMiscFee)" : "0")"
                                }
                                else if self.tripData.get("ENABLE_MANUAL_TOLL_FEATURE").uppercased() == "YES"{
                                    parameters["fTollPrice"] = "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")"
                                    parameters["fOtherCharges"] = "0"
                                }
                                else{
                                    parameters["fTollPrice"] = "0"
                                    parameters["fOtherCharges"] = "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")"
                                }
                
                parameters["fDriverDiscount"] = "\(currentProviderDiscount > 0 ? "\(currentProviderDiscount)" : "0")"
                parameters["eType"] = self.tripData.get("eType")
                parameters["fMaterialFee"] = ""
                parameters["fMiscFee"] = ""
               
            }
            
        }else{
             parameters = ["type":"sendChargeVerificationCode", "TripId": tripData!.get("TripId"), "PassengerId": tripData!.get("PassengerId"),"DriverId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "fMaterialFee": "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")", "fMiscFee": "\(currentMiscFee > 0 ? "\(currentMiscFee)" : "0")", "fDriverDiscount": "\(currentProviderDiscount > 0 ? "\(currentProviderDiscount)" : "0")", "iTripTimeId": tripData!.get("iTripTimeId"), "eApproveRequestSentByDriver":eApproveRequestSentByDriver]
            
            if(self.tripData.get("eType").uppercased() != Utils.cabGeneralType_UberX.uppercased()){
               
                if(self.tripData.get("ENABLE_MANUAL_TOLL_FEATURE").uppercased() == "YES" && self.tripData.get("ENABLE_OTHER_CHARGES_FEATURE").uppercased() == "YES") {
                                    parameters["fTollPrice"] = "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")"
                                    parameters["fOtherCharges"] = "\(currentMiscFee > 0 ? "\(currentMiscFee)" : "0")"
                                }
                                else if self.tripData.get("ENABLE_MANUAL_TOLL_FEATURE").uppercased() == "YES"{
                                    parameters["fTollPrice"] = "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")"
                                    parameters["fOtherCharges"] = "0"
                                }
                                else{
                                    parameters["fTollPrice"] = "0"
                                    parameters["fOtherCharges"] = "\(currentMaterialFee > 0 ? "\(currentMaterialFee)" : "0")"
                                }
                //parameters["fOtherCharges"] = "\(currentMiscFee > 0 ? "\(currentMiscFee)" : "0")"
                parameters["fDriverDiscount"] = "\(currentProviderDiscount > 0 ? "\(currentProviderDiscount)" : "0")"
                parameters["eType"] = self.tripData.get("eType")
                parameters["fMaterialFee"] = ""
                parameters["fMiscFee"] = ""
            }
        }
        

          let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
          exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
          exeWebServerUrl.currInstance = exeWebServerUrl
          
              exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                  
                  if(response != ""){
                      let dataDict = response.getJsonDataDict()
                      
                      if(dataDict.get("Action") == "1"){
                        
                        let messageStr = dataDict.get("message")
                        
                        if(messageStr.uppercased() == "LBL_NO_FURTHER_PROCESS"){
                            
                            self.stopVerificationProcess()
                            self.processEndTrip(isSkip: false)
                            return
                        }
                        
                        if self.tripData.get("eType") != "Ride" {
                        if(self.tripData.get("ADDITIONAL_CHARGE_VERIFICATION_METHOD").uppercased() == "APPROVAL"){
                            let eApproveRequestSentByDriver = dataDict.get("eApproveRequestSentByDriver")
                            if(eApproveRequestSentByDriver.uppercased() == "NO"){
                                self.stopVerificationProcess()
                            }else{
                                  self.openVerificationView()
                                
                                  self.animTask = UpdateFreqTask(interval: 5)
                                  self.animTask.currInst = self.animTask
                                  self.animTask.setTaskRunListener(onTaskRunCalled: self)
                                  self.animTask.startRepeatingTask()
                            }
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                            
                        }else{
                            
                            self.receivedCode = dataDict.get("vConfirmationCode")
                            self.openOtpVerification()
                        }
                        
                        }else {
                            if(self.tripData.get("ENABLE_MANUAL_TOLL_VERIFICATION_METHOD").uppercased() == "APPROVAL"){
                                let eApproveRequestSentByDriver = dataDict.get("eApproveRequestSentByDriver")
                                if(eApproveRequestSentByDriver.uppercased() == "NO"){
                                    self.stopVerificationProcess()
                                }else{
                                      self.openVerificationView()
                                    
                                      self.animTask = UpdateFreqTask(interval: 5)
                                      self.animTask.currInst = self.animTask
                                      self.animTask.setTaskRunListener(onTaskRunCalled: self)
                                      self.animTask.startRepeatingTask()
                                }
                                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                                
                            }else{
                                
                                let eApproveRequestSentByDriver = dataDict.get("eApproveRequestSentByDriver")
                                if(eApproveRequestSentByDriver.uppercased() == "NO"){
                                    self.stopVerificationProcess()
                    return
                                }else{
                                    self.receivedCode = dataDict.get("vConfirmationCode")
                                    self.openOtpVerification()
                     return
                                }
                                
                            }
                        }
                      }else if(dataDict.get("Action") == "2"){
                        
                        self.generalFunc.setAlertMessage(uv: nil, title: "", content: dataDict.get("message"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            self.stopVerificationProcess()
                            self.processEndTrip(isSkip: false)
                            return
                        })
                          
                      }else{
                        
                        if(self.tripData.get("ADDITIONAL_CHARGE_VERIFICATION_METHOD").uppercased() == "APPROVAL"){
                            self.stopVerificationProcess()
                        }
                          self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                      }
                      
                  }else{
                      self.generalFunc.setError(uv: self)
                  }
        })
    }
    
    func stopVerificationProcess(){
           self.verificationView.isHidden = true
           if(self.loaderView != nil){
               self.loaderView.isHidden = true
           }
           
           self.verificationBgView.isHidden = true
               
           if (self.animTask != nil) {
               self.animTask.stopRepeatingTask()
               self.animTask = nil
           }
       }
    func openVerificationView(){
           self.verificationView.isHidden = false
           self.loaderView =  self.generalFunc.addMDloader(contentView: self.verificationLoaderView)
           self.verificationBgView.isHidden = false
       }
    func openOtpVerification(){
        self.otpVerificationView.isHidden = false
        self.verificationView.isHidden = false
        self.verificationBgView.isHidden = false
        
        let extraHeight = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFY_CHARGES_BY_USER_NOTE_TXT").height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont.init(name: Fonts().light, size: 15)!)
        if(extraHeight > 45){
            self.verificationViewTopSpace.constant = Application.screenSize.height - 450 + (extraHeight - 45)
        }else{
            self.verificationViewTopSpace.constant = Application.screenSize.height - 450
        }
        
        
        otpVerificationView.initializeUI()
    }
    func onTaskRun(currInst: UpdateFreqTask) {
        let parameters = ["type":"getApprovalStatus", "TripId": tripData!.get("TripId"), "PassengerId": tripData!.get("PassengerId"),"DriverId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        let eApproved = dataDict.get("eApproved")
                        
                        if (self.animTask != nil) {
                            self.animTask.stopRepeatingTask()
                            self.animTask = nil
                          
                        }
                        
                        if(self.loaderView != nil){
                            self.loaderView.isHidden = true
                        }
                        if(eApproved.uppercased() == "YES"){
                            
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                            
                            self.processEndTrip(isSkip: false)
                        }else{
                            self.generalFunc.setAlertMessage(uv: nil, title: "", content: dataDict.get("message"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                                
                                self.stopVerificationProcess()
                            })
                        }

                    }
                }else{
                    ///self.generalFunc.setError(uv: self)
                }
            })
    }
    func tollCharegeEmptyCheck(title : String, isApproval : Bool, positiveButtonTitle : String ){
        
        self.generalFunc.setAlertMessage(uv: self, title: "", content: title, positiveBtn: positiveButtonTitle, nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: {(btnClickedId) in
            if(btnClickedId == 0){
             
                if isApproval == true {
                self.startVerification(eApproveRequestSentByDriver: "Yes")
                }else{
                self.startVerification(eApproveRequestSentByDriver: "")
                }
            }
            if(btnClickedId == 1){
            }
        })
    }
}
