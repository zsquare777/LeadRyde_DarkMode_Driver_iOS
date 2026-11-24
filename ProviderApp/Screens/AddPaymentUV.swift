//
//  AddPaymentUV.swift
//  DriverApp
//
//  Created by ADMIN on 19/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import SwiftExtensionData
import Stripe
import WebKit

class AddPaymentUV: UIViewController, MyBtnClickDelegate, WKNavigationDelegate, STPPaymentCardTextFieldDelegate, MyTxtFieldOnTextChangeDelegate { //CardIOPaymentViewControllerDelegate
    
    var PAGE_HEIGHT:CGFloat = 595
    
    @IBOutlet weak var cardImgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var creditCardNumView: UIView!
    @IBOutlet weak var creditCardTxtField: MyTextField!
    @IBOutlet weak var cardNameAreaView: UIView!
    @IBOutlet weak var cardNameTxtField: MyTextField!
    @IBOutlet weak var expiryView: UIView!
    @IBOutlet weak var monthTxtField: MyTextField!
    @IBOutlet weak var yearTxtField: MyTextField!
    @IBOutlet weak var cvvView: UIView!
    @IBOutlet weak var cvvTxtField: MyTextField!
    @IBOutlet weak var configCardBtn: MyButton!
    @IBOutlet weak var stripeCardTxtField: STPPaymentCardTextField!
    
    let generalFunc = GeneralFunctions()
    
    var webView:WKWebView!
    var paymentUv:PaymentUV!
    
    var payMentMethod = ""
    var PAGE_MODE = "ADD"
    var isPageLoad = false
    
    var required_str = ""
    var invalid_str = ""
    
    var cntView:UIView!
    var loadingDialog:NBMaterialLoadingDialog!
    var payMayaToken = ""
    
    var userProfileJson:NSDictionary!
    
    override func viewWillAppear(_ animated: Bool){
        self.configureRTLView()
        self.addBackBarBtn()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.addBackBarBtn()
        
        cntView = self.generalFunc.loadView(nibName: "AddPaymentScreenDesign", uv: self, contentView: scrollView)
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
        self.scrollView.addSubview(cntView)
        self.scrollView.bounces = false
        

        self.contentView.isHidden = true
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
     
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(self.navigationController != nil){
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
       
//        if(("CardIOCreditCardInfo").classFromString()){
//            let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_camera_nav")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openCardScanner))
//            if(self.navigationController != nil){
//                self.navigationItem.rightBarButtonItem = rightButton
//            }
//        }
        
        self.webView = WKWebView.init(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height))
        self.webView.isHidden = true
        self.webView.navigationDelegate = self
        self.webView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.webView)
        self.contentView.isHidden = false
        
        setData()
    }
    
    func setData(){
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: self.PAGE_MODE == "ADD" ? "LBL_ADD_CARD" : "LBL_CHANGE_CARD")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: self.PAGE_MODE == "ADD" ? "LBL_ADD_CARD" : "LBL_CHANGE_CARD")
        
        creditCardNumView.layer.shadowOpacity = 0.5
        creditCardNumView.layer.shadowOffset = CGSize(width: 0, height: 3)
        creditCardNumView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
        expiryView.layer.shadowOpacity = 0.5
        expiryView.layer.shadowOffset = CGSize(width: 0, height: 3)
        expiryView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
        cvvView.layer.shadowOpacity = 0.5
        cvvView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cvvView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
        self.creditCardTxtField.textFieldType = "CARD"
        self.creditCardTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Card Number", key: "LBL_CARD_NUMBER_TXT"))
        self.cardNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Card Holder Name", key: "LBL_CARD_HOLDER_NAME_TXT"))
        self.monthTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EXP_MONTH_HINT_TXT"))
        self.yearTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EXP_YEAR_HINT_TXT"))
        self.cvvTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "CVV", key: "LBL_CVV"))
        
        self.cvvTxtField.maxCharacterLimit = 5
        self.creditCardTxtField.maxCharacterLimit = 20
        self.monthTxtField.maxCharacterLimit = 2
        self.yearTxtField.maxCharacterLimit = 4

        self.configCardBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: self.PAGE_MODE == "ADD" ? "LBL_ADD_CARD" : "LBL_CHANGE_CARD"))
        
        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
        invalid_str =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVALID")
        
        self.configCardBtn.clickDelegate = self

        self.creditCardTxtField.getTextField()!.keyboardType = .numberPad
        self.monthTxtField.getTextField()!.keyboardType = .numberPad
        self.yearTxtField.getTextField()!.keyboardType = .numberPad
        self.cvvTxtField.getTextField()!.keyboardType = .numberPad
        
        self.cvvTxtField.getTextField()!.isSecureTextEntry = true
        
        cardImgView.image = UIImage(named: "ic_card_unknown")
        
        self.cardNameAreaView.isHidden = true
        self.stripeCardTxtField.isHidden = true
        
        self.creditCardTxtField.onTextChangedDelegate = self
        
        if(self.payMentMethod.uppercased() == "STRIPE"){
            self.stripeCardTxtField.isHidden = false
            self.creditCardNumView.isHidden = true
            self.expiryView.isHidden = true
            self.cvvView.isHidden = true
            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 164
            self.stripeCardTxtField.delegate = self
        }
        //CardIOUtilities.preload()
    }
    

    
    func onTextChanged(sender: MyTextField, text: String) {
        if(sender == self.creditCardTxtField){
            self.setCardImage(text)
        }
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        if(textField.cardNumber != nil){
            self.setCardImage(textField.cardNumber!)
        }
        
//        Utils.printLog(msgData: "CardName:\(STPCardValidator.brand(forNumber: textField.cardNumber!))")
    }
    
    func setCardImage(_ cardNumber:String){
        switch STPCardValidator.brand(forNumber: cardNumber) {
        case STPCardBrand.visa:
//            Utils.printLog(msgData: "Visa")
            cardImgView.image = UIImage(named: "ic_visa")
            break
        case STPCardBrand.amex:
            cardImgView.image = UIImage(named: "ic_amex")
//            Utils.printLog(msgData: "Amex")
            break
        case STPCardBrand.dinersClub:
            cardImgView.image = UIImage(named: "ic_diners")
//            Utils.printLog(msgData: "DinnersClub")
            break
        case STPCardBrand.discover:
            cardImgView.image = UIImage(named: "ic_discover")
//            Utils.printLog(msgData: "Discover")
            break
        case STPCardBrand.JCB:
            cardImgView.image = UIImage(named: "ic_jcb")
//            Utils.printLog(msgData: "JCB")
            break
        case STPCardBrand.masterCard:
            cardImgView.image = UIImage(named: "ic_mastercard")
//            Utils.printLog(msgData: "MasterCard")
            break
        case STPCardBrand.unionPay:
            cardImgView.image = UIImage(named: "ic_unionpay")
//            Utils.printLog(msgData: "UnionPay")
            break
        default:
            cardImgView.image = UIImage(named: "ic_card_unknown")
//            Utils.printLog(msgData: "NotFound")
            break
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.configCardBtn){
            checkData()
        }
    }
    
    func checkData(){
        
        if(self.payMentMethod == "Stripe" && self.stripeCardTxtField.isValid == false){
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVALID_CARD_DETAILS"), uv: self)
            return
        }
        var isCardNameEntered = true
        if(self.cardNameAreaView.isHidden == false){
          isCardNameEntered =  Utils.checkText(textField: creditCardTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.creditCardTxtField.getTextField()!, error: required_str)
        }
        let monthNum = Utils.getText(textField: self.monthTxtField.getTextField()!).isNumeric() ? GeneralFunctions.parseFloat(origValue: 0, data: Utils.getText(textField: self.monthTxtField.getTextField()!)) : 0
        
        let cardNoEntered = Utils.checkText(textField: creditCardTxtField.getTextField()!) ? (STPCardValidator.validationState(forNumber: Utils.getText(textField: self.creditCardTxtField.getTextField()!), validatingCardBrand: true) == .valid ? true : Utils.setErrorFields(textField: self.creditCardTxtField.getTextField()!, error: invalid_str)) : Utils.setErrorFields(textField: self.creditCardTxtField.getTextField()!, error: required_str)
        
        let monthEntered = Utils.checkText(textField: monthTxtField.getTextField()!) ? ((Utils.getText(textField: self.monthTxtField.getTextField()!).isNumeric() == false || Utils.getText(textField: self.monthTxtField.getTextField()!).count < 2) ? Utils.setErrorFields(textField: self.monthTxtField.getTextField()!, error: invalid_str) : ( monthNum > 12 ? Utils.setErrorFields(textField: self.monthTxtField.getTextField()!, error: invalid_str) : true)) : Utils.setErrorFields(textField: self.monthTxtField.getTextField()!, error: required_str)

        let yearEntered = Utils.checkText(textField: yearTxtField.getTextField()!) ? ((Utils.getText(textField: self.yearTxtField.getTextField()!).isNumeric() == false || Utils.getText(textField: self.yearTxtField.getTextField()!).count < 4 || Utils.getText(textField: self.yearTxtField.getTextField()!).count > 4) ? Utils.setErrorFields(textField: self.yearTxtField.getTextField()!, error: invalid_str) : true) : Utils.setErrorFields(textField: self.yearTxtField.getTextField()!, error: required_str)
        
        let cvvEntered = Utils.checkText(textField: cvvTxtField.getTextField()!) ? ((Utils.getText(textField: self.cvvTxtField.getTextField()!).isNumeric() == false || Utils.getText(textField: self.cvvTxtField.getTextField()!).count < 2 || Utils.getText(textField: self.cvvTxtField.getTextField()!).count > 4) ? Utils.setErrorFields(textField: self.cvvTxtField.getTextField()!, error: invalid_str) : true) : Utils.setErrorFields(textField: self.cvvTxtField.getTextField()!, error: required_str)

        if (self.payMentMethod != "Stripe" && (cardNoEntered == false || cvvEntered == false || monthEntered == false || yearEntered == false || isCardNameEntered == false)) {
            return;
        }
        
        DispatchQueue.main.async() {
            self.generateStripeToken()
        }
    }
   
    
    // FOR STRIPE
    func generateStripeToken(){
        let cardParams = STPCardParams()
        cardParams.number = stripeCardTxtField.cardNumber!.trim()
        cardParams.expMonth = stripeCardTxtField.expirationMonth
        cardParams.expYear = stripeCardTxtField.expirationYear
        cardParams.cvc = stripeCardTxtField.cvc
        
        
        self.creditCardTxtField.setText(text: stripeCardTxtField.cardNumber!.trim())
        
        loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(self.contentView, isCancelable: false, message: (GeneralFunctions()).getLanguageLabel(origValue: "Loading", key: "LBL_LOADING_TXT"))
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if error != nil {
                // show the error to the user
//                self.generalFunc.setError(uv: self)
                if let Msg = error?.localizedDescription{
                    let errorMsg = Msg.replace("\\", withString: "")
                    self.generalFunc.setError(uv: self, title: "", content:  errorMsg)
                }else{
                    self.generalFunc.setError(uv: self)
                }
            } else if let token = token {
                
                self.addTokenToServer(token: token.tokenId, "")
            }
            
            self.loadingDialog.hideDialog()
        }
    }

    // FOR ALL PAYMENT GATEWAY
    func addTokenToServer(token:String, _ vXenditAuthId:String){
        var maskedCreditCardNo = ""
        
        let creditCardNo = Utils.getText(textField: self.creditCardTxtField.getTextField()!).replace(" ", withString: "")
        
        for i in 0 ..< creditCardNo.count {
            if(i < ((creditCardNo.count) - 4)){
                maskedCreditCardNo = "\(maskedCreditCardNo)X"
            }else{
                maskedCreditCardNo = "\(maskedCreditCardNo)\(creditCardNo.charAt(i: i))"
            }
        }
        
        let parameters = ["type":"GenerateCustomer","iUserId": GeneralFunctions.getMemberd(), "vStripeToken": self.payMentMethod == "Stripe" ? token : "", "UserType": Utils.appUserType, "CardNo": maskedCreditCardNo, "vPaymayaToken": "", "vXenditToken": "", "vXenditAuthId": "", "vOmiseToken": ""]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    self.paymentUv!.showSuccessMessage()
                    self.paymentUv!.setData()
                    self.closeCurrentScreen()
                    
               
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
   
    func customerVerified(){
        let parameters = ["type":"UpdateCustomerToken","iUserId": GeneralFunctions.getMemberd(), "vPaymayaToken": self.payMayaToken, "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            //            print("Response:\(response)")
            if(response != ""){
                self.navigationItem.setHidesBackButton(false, animated:true);
                self.view.isUserInteractionEnabled = true
                let dataDict = response.getJsonDataDict()
                
                
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    self.paymentUv!.setData()
                    UIBarButtonItem.appearance().tintColor = UIColor.black
                    self.closeCurrentScreen()
                    
                }else{
                    
                    self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.customerVerified()
                    })
                    
                }
                
            }else{
                self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.customerVerified()
                })
            }
        })
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString{
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            
            if (urlString.contains(find: "PAYMENT_SUCCESS") || urlString.contains(find: "success") || urlString.contains(find: "success.php")){
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.navigationItem.setHidesBackButton(true, animated:false);
                self.view.isUserInteractionEnabled = false
                UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
                self.customerVerified()
                
            }else if (urlString.contains(find: "PAYMENT_FAILURE") || urlString.contains(find: "failure") || urlString.contains(find: "failure.php")){
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST_FAILED_PROCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
                    self.closeCurrentScreen()
                })
            }else{
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
}
