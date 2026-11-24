////
////  SignInUV.swift
////  DriverApp
////
////  Created by ADMIN on 06/05/17.
////  Copyright © 2017 @. All rights reserved.
////
//import UIKit
//import SafariServices
//import GoogleSignIn
//
//class SignInUV: UIViewController, MyLabelClickDelegate, MyTxtFieldOnTextChangeDelegate , MyTxtFieldClickDelegate{
//    
//    @IBOutlet weak var socialLoginStkView: UIStackView!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var signInWithSocial: MyLabel!
//    @IBOutlet weak var googleImgView: UIImageView!
//    @IBOutlet weak var twitterImgView: UIImageView!
//    @IBOutlet weak var fbImgView: UIImageView!
//    @IBOutlet weak var linkdinImgView: UIImageView!
//    @IBOutlet weak var goSignUpLbl: MyLabel!
//    @IBOutlet weak var forgetPasswordLbl: MyLabel!
//    @IBOutlet weak var signInImgHLbl: MyLabel!
//    @IBOutlet weak var passwordTxtField: MyTextField!
//    @IBOutlet weak var userNameTxtField: MyTextField!
//    @IBOutlet weak var orLblContainer: UIView!
//    @IBOutlet weak var orLbl: MyLabel!
//    @IBOutlet weak var contentView: UIView!
//    @IBOutlet weak var userNameTxtFieldHelperLbl: MyLabel!
//    @IBOutlet weak var submitView: UIView!
//    @IBOutlet weak var submitImgView: UIImageView!
//    @IBOutlet weak var submitViewLbl: MyLabel!
//    @IBOutlet weak var cancelImgView: UIImageView!
//    @IBOutlet weak var orrightView: UIView!
//    @IBOutlet weak var orLeftView: UIView!
//    @IBOutlet weak var signinImg: UIImageView!
//    @IBOutlet weak var signInLeadingSpace: NSLayoutConstraint!
//    @IBOutlet weak var countryTxtField: MyTextField!
//    
//    var countryPrefixImgView:UIImageView!
//    var isCountrySelected = false
//    var selectedCountryCode = ""
//    var selectedPhoneCode = ""
//    
//    
//    var isFromAppLogin = true
//    
//    let generalFunc = GeneralFunctions()
//    
//    var required_str = ""
//    
//    var openFbLogin: OpenFbLogin!
//    var openGoogleLogin: OpenGoogleLogin!
//    var openTwitterLogin: OpenTwitterLogin!
//    var openLinkdinLogin: OpenLinkedinLogin!
//    
//    
//    var cntView:UIView!
//    
//    var isPageLoaded = false
//    
////    var isViewProperShutDown = false
//    var PAGE_HEIGHT:CGFloat = 620
//    
//    var isPageSet = false
//    
//    var finalStr:NSMutableAttributedString!
//    
//    var countryListArr:NSArray!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
////        self.contentView.addSubview(self.generalFunc.loadView(nibName: "SignInScreenDesign", uv: self, contentView: contentView))
//        
//        self.addBackBarBtn()
//        
//        cntView = self.generalFunc.loadView(nibName: "SignInScreenDesign", uv: self, contentView: scrollView)
//        
////        cntView.frame = CGRect(x:0, y:0, width: self.contentView.frame.width, height: PAGE_HEIGHT)
//        scrollView.addSubview(cntView)
//        GeneralFunctions.setImgTintColor(imgView: signinImg, color: UIColor.UCAColor.AppThemeColor)
//        
//        scrollView.bounces = false
//        scrollView.backgroundColor = UIColor.clear
//        
//        let facebookLoginEnabled = GeneralFunctions.getValue(key: Utils.FACEBOOK_LOGIN_KEY)
//        let googleLoginEnabled = GeneralFunctions.getValue(key: Utils.GOOGLE_LOGIN_KEY)
//        let twitterLoginEnabled = GeneralFunctions.getValue(key: Utils.TWITTER_LOGIN_KEY)
//        let linkdinLoginEnabled = GeneralFunctions.getValue(key: Utils.LINKDIN_LOGIN_KEY)
//        
//        var isFBLoginEnabled = false
//        var isGoogleLoginEnabled = false
//        var isTwitterLoginEnabled = false
//        var isLinkdinLoginEnabled = false
//        if(facebookLoginEnabled != nil && (facebookLoginEnabled as! String).uppercased() == "NO"){
//            isFBLoginEnabled = false
//            self.fbImgView.isHidden = true
//        }else{
//            isFBLoginEnabled = true
//        }
//        
//        if(googleLoginEnabled != nil && (googleLoginEnabled as! String).uppercased() == "NO"){
//            isGoogleLoginEnabled = false
//            self.googleImgView.isHidden = true
//        }else{
//            isGoogleLoginEnabled = true
//        }
//        
//        if(twitterLoginEnabled != nil && (twitterLoginEnabled as! String).uppercased() == "NO"){
//            isTwitterLoginEnabled = false
//            self.twitterImgView.isHidden = true
//        }else{
//            isTwitterLoginEnabled = true
//        }
//        
//        if(linkdinLoginEnabled != nil && (linkdinLoginEnabled as! String).uppercased() == "NO"){
//            isLinkdinLoginEnabled = false
//            self.linkdinImgView.isHidden = true
//        }else{
//            isLinkdinLoginEnabled = true
//        }
//        
//        if(isFBLoginEnabled == false && isGoogleLoginEnabled == false && isTwitterLoginEnabled == false && isLinkdinLoginEnabled == false){
//            for i in 0..<socialLoginStkView.subviews.count{
//                let subView = socialLoginStkView.subviews[i]
//                
//                self.signInWithSocial.isHidden = true
//                self.orLbl.isHidden = true
//                self.orrightView.isHidden = true
//                self.orLeftView.isHidden = true
//                subView.isHidden = true
//            }
//            
//            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 180
//        }
//
//        self.contentView.alpha = 0
//        setData()
//
//        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
//        
//        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
//        self.navigationController?.navigationBar.isHidden = true
//        
//        CountryListData.getInstance().getCountryListData { (dataArray, isSuccess) in
//            if(isSuccess){
//                self.countryListArr = dataArray
//            }
//        }
//        
//        self.configureRTLView()
//        UIView.animate(withDuration: 0.15, animations: {
//            self.contentView.alpha = 1.0
//        })
//        
//        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
//     
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        
//        
////        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
//        
//        self.navigationController?.navigationBar.isHidden = false
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        
//        if(isPageSet == false){
//            
//            if(PAGE_HEIGHT < self.cntView.frame.height){
//                self.PAGE_HEIGHT = self.cntView.frame.height
//            }
//            self.cntView.frame.size.height = self.PAGE_HEIGHT
//            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
//
//            isPageSet = true
//            
//            if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.SHOW_COUNTRY_LIST) == true && GeneralFunctions.getValue(key: Utils.SHOW_COUNTRY_LIST)?.uppercased == "YES"){
//                           countryTxtField.addImageView(color: UIColor.black, transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)), isCustomImage:true, "ic_arrow_right", 20, 20, nil)
//                           self.countryTxtField.myTxtFieldDelegate = self
//                       }
//                       
//                       self.countryTxtField.addImgeViewToLeft(color:nil,transform: .identity, isCustomImage: true, "ic_invite_detail", 19,27) { (imageView) in
//                           
//                           if(self.countryPrefixImgView == nil){
//                               self.countryPrefixImgView = imageView
//                               self.countryPrefixImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl:GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_IMAGE_KEY) as! String, width: Utils.getValueInPixel(value: 27), height: Utils.getValueInPixel(value: 19))), placeholderImage:nil)
//                           }
//                         
//                       }
//        
//        }
//        
//        self.passwordTxtField.addImageView(color: UIColor.gray, transform: .identity, isCustomImage: true, "ic_show_password") { (imageView) in
//            
//            if(self.passwordTxtField.getTextField()!.isSecureTextEntry == true){
//                imageView.image = UIImage(named: "ic_show_hide_pass")
//                GeneralFunctions.setImgTintColor(imgView: imageView, color: UIColor.gray)
//                self.passwordTxtField.getTextField()!.isSecureTextEntry = false
//            }else{
//                imageView.image = UIImage(named: "ic_show_password")
//                GeneralFunctions.setImgTintColor(imgView: imageView, color: UIColor.gray)
//                self.passwordTxtField.getTextField()!.isSecureTextEntry = true
//            }
//        }
//        
////        if (isViewProperShutDown == true)
////        {
////            passwordTxtField.setText(text: "")
////            userNameTxtField.setText(text: "")
////            isViewProperShutDown = false
////        }
//    }
//    
//    func setData(){
//        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
//        
//        self.orLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OR_TXT")
////        LBL_PHONE_EMAIL
//        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "SignIn", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT")
//        self.title = self.generalFunc.getLanguageLabel(origValue: "SignIn", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT")
//        self.signInImgHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Sign In", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT")
//        
//        self.userNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "PHONE NUMBER OR EMAIL", key: "LBL_PHONE_EMAIL"))
//        self.passwordTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PASSWORD_LBL_TXT"))
//       
//        
//        self.forgetPasswordLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FORGET_YOUR_PASS_TXT")
//        
//        self.forgetPasswordLbl.textColor = UIColor(hex: 0x646464)//UIColor.UCAColor.AppThemeColor
//        self.forgetPasswordLbl.setClickDelegate(clickDelegate: self)
//        
////        self.orLblContainer.transform = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi) / 2)
////        self.orLbl.transform = CGAffineTransform(rotationAngle: -CGFloat(CGFloat.pi) / 2)
//     
//        
//        self.goSignUpLbl.setClickDelegate(clickDelegate: self)
//        
//        self.countryTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COUNTRY_TXT"))
//        self.countryTxtField.setEnable(isEnabled: false)
//        self.countryTxtField.onTextChangedDelegate = self
//        if(GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY) as! String) != "" && GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) as! String) != "" && GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) as! String) != ""){
//            self.selectedCountryCode = (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) as! String)
//            self.selectedPhoneCode = (GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) as! String)
//            
//            self.countryTxtField.setText(text: "+\(self.selectedPhoneCode)")
//            
//            self.isCountrySelected = true
//            self.countryTxtField.getTextField()!.sendActions(for: .editingChanged)
//        }
//        
//        self.passwordTxtField.getTextField()!.isSecureTextEntry = true
//        
//        self.userNameTxtField.getTextField()!.keyboardType = .emailAddress
//        self.passwordTxtField.getTextField()!.isSecureTextEntry = true
//        
//        fbImgView.isUserInteractionEnabled = true
//        googleImgView.isUserInteractionEnabled = true
//        twitterImgView.isUserInteractionEnabled = true
//        linkdinImgView.isUserInteractionEnabled = true
//        
//        let fbImgTapGue = UITapGestureRecognizer()
//        let googleImgTapGue = UITapGestureRecognizer()
//        let twittImgTapGue = UITapGestureRecognizer()
//        let linkdinImgTapGue = UITapGestureRecognizer()
//        
//        fbImgTapGue.addTarget(self, action: #selector(self.fbBtnTapped))
//        googleImgTapGue.addTarget(self, action: #selector(self.googleBtnTapped))
//        twittImgTapGue.addTarget(self, action: #selector(self.twittBtnTapped))
//        linkdinImgTapGue.addTarget(self, action: #selector(self.linkdinBtnTapped))
//        
//        fbImgView.addGestureRecognizer(fbImgTapGue)
//        googleImgView.addGestureRecognizer(googleImgTapGue)
//        twitterImgView.addGestureRecognizer(twittImgTapGue)
//        linkdinImgView.addGestureRecognizer(linkdinImgTapGue)
//        
//        signInWithSocial.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_IN_WITH_SOC_ACC_HINT")
//        
//        finalStr = NSMutableAttributedString.init(string: "")
//        finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONT_HAVE_AN_ACCOUNT"),color:UIColor.black))
//        finalStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNUP"),color:UIColor.UCAColor.AppThemeColor))
//        finalStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOW"),color:UIColor.black))
//        
//        self.goSignUpLbl.attributedText = finalStr
//        self.goSignUpLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
//        
//        self.userNameTxtFieldHelperLbl.text = self.generalFunc.getLanguageLabel(origValue: "Enter without leading + or 00 or country code", key: "LBL_SIGN_IN_MOBILE_EMAIL_HELPER")
//        
//        let helperTxtHeight = self.userNameTxtFieldHelperLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 40, font: UIFont(name: Fonts().light, size: 14)!)
//        if(helperTxtHeight > 0){
//            PAGE_HEIGHT = PAGE_HEIGHT + helperTxtHeight
//        }
//        
//        self.userNameTxtField.onTextChangedDelegate = self
//        
//        self.submitView.backgroundColor = UIColor.UCAColor.AppThemeColor
//        GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
//        self.submitViewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_IN").uppercased()
//        self.submitViewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
//        
//        if(Configurations.isRTLMode()){
//            self.submitImgView.image = self.submitImgView.image?.rotate(180)
//            GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
//        }
//        self.submitView.setOnClickListener { (instance) in
//            self.checkData()
//        }
//        
//        self.cancelImgView.setOnClickListener { (instance) in
//            self.closeCurrentScreen()
//        }
//        
//       // self.cancelImgView.image = self.cancelImgView.image?.addImagePadding(x: 5, y: 5)
//    }
//    
//    func myTxtFieldTapped(sender: MyTextField) {
//        if(sender == self.countryTxtField){
//         
//            let countryListUv = GeneralFunctions.instantiateViewController(pageName: "CountryListUV") as! CountryListUV
//            countryListUv.fromLogIn = true
//            
//            if(countryListArr != nil){
//                countryListUv.countryListArr = countryListArr
//            }
//           
//            countryListUv.modalPresentationStyle = .overCurrentContext
//            self.present(countryListUv, animated: true) {
//                
//            }
//        }
//    }
//    
//    @objc func tapLabel(gesture: UITapGestureRecognizer) {
//        
//        let termsRange = (self.finalStr.string as NSString).range(of: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNUP"))
//        
//        if gesture.didTapAttributedTextInLabel(label: goSignUpLbl, inRange: termsRange) {
//            if(isFromAppLogin){
//                let signUpUv = GeneralFunctions.instantiateViewController(pageName: "SignUpUV") as! SignUpUV
//                signUpUv.isFromAppLogin = false
//                self.pushToNavController(uv: signUpUv)
//            }else{
//                self.closeCurrentScreen()
//            }
//        }
//    }
//    
//    func onTextChanged(sender: MyTextField, text: String) {
//        if(userNameTxtField == sender){
//            self.userNameTxtFieldHelperLbl.isHidden = false
//            
//            if GeneralFunctions.getValue(key: Utils.ENABLE_PHONE_LOGIN_VIA_COUNTRY_SELECTION_METHOD)?.uppercased == "YES"{
//                            if(text.count > 3){
//                               if(text.isNumeric()){
//                                   
//                                   
//                                   view.layoutIfNeeded()
//                                   self.signInLeadingSpace.constant = 135
//
//                                   UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
//                                     self.view.layoutIfNeeded()
//                                   }, completion: { finished in
//                                     self.countryTxtField.isHidden = false
//                                   })
//                                   
//                                   
//                               }else{
//                                   self.countryTxtField.isHidden = true
//                                   view.layoutIfNeeded()
//                                   self.signInLeadingSpace.constant = 30
//
//                                   UIView.animate(withDuration: 0.3, animations: {
//                                        self.view.layoutIfNeeded()
//                                   })
//                               }
//                           }else{
//                               self.countryTxtField.isHidden = true
//                               view.layoutIfNeeded()
//                               self.signInLeadingSpace.constant = 30
//
//                               UIView.animate(withDuration: 0.3, animations: {
//                                    self.view.layoutIfNeeded()
//                               })
//                           }
//                       }
//        }
//    }
//    
////    override func viewDidAppear(_ animated: Bool) {
////        
////        self.userNameTxtField.getTextField()!.autocapitalizationType = .none
////        self.userNameTxtField.getTextField()!.autocorrectionType = .no
////    }
//    
//    @objc func fbBtnTapped(){
////        isViewProperShutDown = true
//        let window = UIApplication.shared.delegate!.window!
//        
//        openFbLogin = OpenFbLogin(uv: self, window: window!)
//        
//        openFbLogin.processData(openFbLoginInst: openFbLogin)
//    }
//    
//    @objc func googleBtnTapped(){
////        isViewProperShutDown = true
//        
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        
//        let window = UIApplication.shared.delegate!.window!
//
//        openGoogleLogin = OpenGoogleLogin(uv: self, window: window!)
//        openGoogleLogin.processData(currGoogleLoginInst: openGoogleLogin)
//
//    }
//    @objc func twittBtnTapped(){
////        isViewProperShutDown = true
//        let window = UIApplication.shared.delegate!.window!
//        
//        openTwitterLogin = OpenTwitterLogin(uv: self, window: window!)
//        openTwitterLogin.processData(currTwitterLoginInst: openTwitterLogin)
//        
//    }
//    
//    @objc func linkdinBtnTapped(){
//        
//        let window = UIApplication.shared.delegate!.window!
//        
//        openLinkdinLogin = OpenLinkedinLogin(uv: self, window: window!)
//        openLinkdinLogin.processData(currLinkedinInst: openLinkdinLogin)
//        
//    }
//    
////    func myBtnTapped(sender: MyButton) {
////
////        if(sender == signInBtn){
////            checkData()
////        }
////
////    }
//    
//    func checkData(){
//        let noWhiteSpace = generalFunc.getLanguageLabel(origValue: "Password should not contain whitespace.", key: "LBL_ERROR_NO_SPACE_IN_PASS");
//        let pass_length = generalFunc.getLanguageLabel(origValue: "Password must be", key: "LBL_ERROR_PASS_LENGTH_PREFIX")
//            + " \(Utils.minPasswordLength)" + " " + generalFunc.getLanguageLabel(origValue: "or more character long.",key: "LBL_ERROR_PASS_LENGTH_SUFFIX");
//        let mobileInvalid = generalFunc.getLanguageLabel(origValue: "Invalid mobile no.", key: "LBL_INVALID_MOBILE_NO")
//        
////        let emailEntered = Utils.checkText(textField: self.userNameTxtField.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.userNameTxtField.getTextField()!)) ? true : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR_TXT"))) : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: required_str)
//
//        
//        let emailEntered = Utils.checkText(textField: self.userNameTxtField.getTextField()!) ? (Utils.getText(textField: self.userNameTxtField.getTextField()!).isNumeric() ? (Utils.getText(textField: self.userNameTxtField.getTextField()!).count >= Utils.minMobileLength ? true : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: mobileInvalid)) : (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.userNameTxtField.getTextField()!)) ? true :  Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR")) )) : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: required_str)
//        
//        let passwordEntered = Utils.checkText(textField: self.passwordTxtField.getTextField()!) ? (Utils.getText(textField: self.passwordTxtField.getTextField()!).contains(" ") ? Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: noWhiteSpace) : (Utils.getText(textField: self.passwordTxtField.getTextField()!).count >= Utils.minPasswordLength ? true : Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: pass_length))) : Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: required_str)
//        
//        if (emailEntered == false || passwordEntered == false) {
//            if(emailEntered == false){
//                self.userNameTxtFieldHelperLbl.isHidden = true
//            }
//            return;
//        }
//
//        if(Utils.getText(textField: self.userNameTxtField.getTextField()!).isNumeric()){
//        }
//        
//        signIn()
//    }
//    
//    func myLableTapped(sender: MyLabel) {
////        isViewProperShutDown = true
//        if(sender == self.forgetPasswordLbl){
//            
////            self.present(SFSafariViewController(url: URL(string: GeneralFunctions.getValue(key: Utils.LINK_FORGET_PASS_KEY) as! String)!), animated: true, completion: nil)
//            let forgetPasswordUV = GeneralFunctions.instantiateViewController(pageName: "ForgetPasswordUV") as! ForgetPasswordUV
//            
//            self.pushToNavController(uv: forgetPasswordUV)
//            
//        }
//
//    }
//    
//    func signIn(){
//        
//        let userSelectedCurrency = GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String
//        let userSelectedLanguage = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
//        
//        var parameters = ["type":"signIn","vEmail": Utils.getText(textField: self.userNameTxtField.getTextField()!), "vPassword": Utils.getText(textField: self.passwordTxtField.getTextField()!), "vDeviceType": Utils.deviceType, "UserType": Utils.appUserType, "vCurrency": userSelectedCurrency, "vLang": userSelectedLanguage]
//        
//        if GeneralFunctions.getValue(key: Utils.ENABLE_PHONE_LOGIN_VIA_COUNTRY_SELECTION_METHOD)?.uppercased == "YES"{
//            parameters["CountryCode"] = self.selectedCountryCode
//            parameters["PhoneCode"] = self.selectedPhoneCode
//        }
//        
//        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
//        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
//        exeWebServerUrl.currInstance = exeWebServerUrl
//        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
//            
//            if(response != ""){
//                let dataDict = response.getJsonDataDict()
//                
//                if(dataDict.get("Action") == "1"){
//                    
//                    
//                    _ = SetUserData(uv: self, userProfileJson: dataDict, isStoreUserId: true)
//                    
//                    let window = UIApplication.shared.delegate!.window!
//                    _ = OpenMainProfile(uv: self, userProfileJson: response, window: window!)
//                    self.closeCurrentScreen()
//                    
//                }else{
//                    if(dataDict.get("eStatus").uppercased() == "DELETED"){
//                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), completionHandler: { (btnClickedIndex) in
//                            if(btnClickedIndex == 1){
//                                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
//                                self.pushToNavController(uv: contactUsUv)
//                            }
//                        })
//                    }else{
//                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
//                    }
//                    
////                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
//                    self.passwordTxtField.setText(text: "")
//                }
//                
//            }else{
//                self.generalFunc.setError(uv: self)
//                self.passwordTxtField.setText(text: "")
//            }
//        })
//    }
//    
//    func getAttributedString(str:String,color:UIColor) -> NSMutableAttributedString
//    {
//        let string_to_color = str
//        
//        let range = (string_to_color as NSString).range(of: string_to_color)
//        let attributedString = NSMutableAttributedString(string:string_to_color)
//        
//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
//        return attributedString
//    }
//    
//    @IBAction func unwindToSignIn(_ segue:UIStoryboardSegue) {
//              
//              if(segue.source .isKind(of: CountryListUV.self)){
//                  let sourceViewController = segue.source as? CountryListUV
//                  let selectedPhoneCode:String = sourceViewController!.selectedCountryHolder!.vPhoneCode
//                  let selectedCountryCode = sourceViewController!.selectedCountryHolder!.vCountryCode
//                  
//                  self.selectedCountryCode = selectedCountryCode
//                  self.selectedPhoneCode = selectedPhoneCode
//                  self.countryPrefixImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl:sourceViewController!.selectedCountryHolder!.vSImage, width: Utils.getValueInPixel(value: 27), height: Utils.getValueInPixel(value: 19))), placeholderImage:nil)
//                  
//                  self.countryTxtField.setText(text: "+\(selectedPhoneCode)")
//                  
//                  self.isCountrySelected = true
//                  self.countryTxtField.getTextField()!.sendActions(for: .editingChanged)
//                  
//              }
//          
//          }
//}


//
//  SignInUV.swift
//  DriverApp
//
//  Created by ADMIN on 06/05/17.
//  Copyright © 2017 @. All rights reserved.
//
import UIKit
import SafariServices
import GoogleSignIn

class SignInUV: UIViewController, MyLabelClickDelegate, MyTxtFieldOnTextChangeDelegate , MyTxtFieldClickDelegate{
    
    @IBOutlet weak var socialLoginStkView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signInWithSocial: MyLabel!
    @IBOutlet weak var googleImgView: UIImageView!
    @IBOutlet weak var twitterImgView: UIImageView!
    @IBOutlet weak var fbImgView: UIImageView!
    @IBOutlet weak var linkdinImgView: UIImageView!
    @IBOutlet weak var goSignUpLbl: MyLabel!
    @IBOutlet weak var forgetPasswordLbl: MyLabel!
    @IBOutlet weak var signInImgHLbl: MyLabel!
    @IBOutlet weak var passwordTxtField: MyTextField!
    @IBOutlet weak var userNameTxtField: MyTextField!
    @IBOutlet weak var orLblContainer: UIView!
    @IBOutlet weak var orLbl: MyLabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userNameTxtFieldHelperLbl: MyLabel!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var submitImgView: UIImageView!
    @IBOutlet weak var submitViewLbl: MyLabel!
    @IBOutlet weak var cancelImgView: UIImageView!
    @IBOutlet weak var orrightView: UIView!
    @IBOutlet weak var orLeftView: UIView!
    @IBOutlet weak var signinImg: UIImageView!
    @IBOutlet weak var signInLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var countryTxtField: MyTextField!
    
    @IBOutlet weak var tabIndicatorView: UIView!
    @IBOutlet weak var tabBottomLine: UIView!
    @IBOutlet weak var loginTypeView: UIView!
    @IBOutlet weak var phoneTabBtn: UIButton!
    @IBOutlet weak var emailTabBtn: UIButton!
    @IBOutlet weak var tabIndicatorLeading: NSLayoutConstraint!
    
    var isPhoneLoginSelected = true
    
    var countryPrefixImgView:UIImageView!
    var isCountrySelected = false
    var selectedCountryCode = ""
    var selectedPhoneCode = ""
    
    
    var isFromAppLogin = true
    
    let generalFunc = GeneralFunctions()
    
    var required_str = ""
    
    var openFbLogin: OpenFbLogin!
    var openGoogleLogin: OpenGoogleLogin!
    var openTwitterLogin: OpenTwitterLogin!
    var openLinkdinLogin: OpenLinkedinLogin!
    
    
    var cntView:UIView!
    
    var isPageLoaded = false
    
//    var isViewProperShutDown = false
    var PAGE_HEIGHT:CGFloat = 710 // was 620; +90 for the 60pt login-type tab bar and its 30pt top spacing
    
    var isPageSet = false
    
    var finalStr:NSMutableAttributedString!
    
    var countryListArr:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.contentView.addSubview(self.generalFunc.loadView(nibName: "SignInScreenDesign", uv: self, contentView: contentView))
        
        self.addBackBarBtn()
        
        cntView = self.generalFunc.loadView(nibName: "SignInScreenDesign", uv: self, contentView: scrollView)
        
//        cntView.frame = CGRect(x:0, y:0, width: self.contentView.frame.width, height: PAGE_HEIGHT)
        scrollView.addSubview(cntView)
        GeneralFunctions.setImgTintColor(imgView: signinImg, color: UIColor.UCAColor.AppThemeColor)
        
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clear
        
        let facebookLoginEnabled = GeneralFunctions.getValue(key: Utils.FACEBOOK_LOGIN_KEY)
        let googleLoginEnabled = GeneralFunctions.getValue(key: Utils.GOOGLE_LOGIN_KEY)
        let twitterLoginEnabled = GeneralFunctions.getValue(key: Utils.TWITTER_LOGIN_KEY)
        let linkdinLoginEnabled = GeneralFunctions.getValue(key: Utils.LINKDIN_LOGIN_KEY)
        
        var isFBLoginEnabled = false
        var isGoogleLoginEnabled = false
        var isTwitterLoginEnabled = false
        var isLinkdinLoginEnabled = false
        if(facebookLoginEnabled != nil && (facebookLoginEnabled as! String).uppercased() == "NO"){
            isFBLoginEnabled = false
            self.fbImgView.isHidden = true
        }else{
            isFBLoginEnabled = true
        }
        
        if(googleLoginEnabled != nil && (googleLoginEnabled as! String).uppercased() == "NO"){
            isGoogleLoginEnabled = false
            self.googleImgView.isHidden = true
        }else{
            isGoogleLoginEnabled = true
        }
        
        if(twitterLoginEnabled != nil && (twitterLoginEnabled as! String).uppercased() == "NO"){
            isTwitterLoginEnabled = false
            self.twitterImgView.isHidden = true
        }else{
            isTwitterLoginEnabled = true
        }
        
        if(linkdinLoginEnabled != nil && (linkdinLoginEnabled as! String).uppercased() == "NO"){
            isLinkdinLoginEnabled = false
            self.linkdinImgView.isHidden = true
        }else{
            isLinkdinLoginEnabled = true
        }
        
        if(isFBLoginEnabled == false && isGoogleLoginEnabled == false && isTwitterLoginEnabled == false && isLinkdinLoginEnabled == false){
            for i in 0..<socialLoginStkView.subviews.count{
                let subView = socialLoginStkView.subviews[i]
                
                self.signInWithSocial.isHidden = true
                self.orLbl.isHidden = true
                self.orrightView.isHidden = true
                self.orLeftView.isHidden = true
                subView.isHidden = true
            }
            
            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 180
        }

        self.contentView.alpha = 0
        setData()

        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = true
        
        CountryListData.getInstance().getCountryListData { (dataArray, isSuccess) in
            if(isSuccess){
                self.countryListArr = dataArray
            }
        }
        
        self.configureRTLView()
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.alpha = 1.0
        })
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if(isPageSet == false){
            
            if(PAGE_HEIGHT < self.cntView.frame.height){
                self.PAGE_HEIGHT = self.cntView.frame.height
            }
            self.cntView.frame.size.height = self.PAGE_HEIGHT
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)

            isPageSet = true
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.SHOW_COUNTRY_LIST) == true && GeneralFunctions.getValue(key: Utils.SHOW_COUNTRY_LIST)?.uppercased == "YES"){
                           countryTxtField.addImageView(color: UIColor.black, transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)), isCustomImage:true, "ic_arrow_right", 20, 20, nil)
                           self.countryTxtField.myTxtFieldDelegate = self
                       }
                       
                       self.countryTxtField.addImgeViewToLeft(color:nil,transform: .identity, isCustomImage: true, "ic_invite_detail", 19,27) { (imageView) in
                           
                           if(self.countryPrefixImgView == nil){
                               self.countryPrefixImgView = imageView
                               self.countryPrefixImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl:GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_IMAGE_KEY) as! String, width: Utils.getValueInPixel(value: 27), height: Utils.getValueInPixel(value: 19))), placeholderImage:nil)
                           }
                         
                       }
        
        }
        
        self.passwordTxtField.addImageView(color: UIColor.gray, transform: .identity, isCustomImage: true, "ic_show_password") { (imageView) in
            
            if(self.passwordTxtField.getTextField()!.isSecureTextEntry == true){
                imageView.image = UIImage(named: "ic_show_hide_pass")
                GeneralFunctions.setImgTintColor(imgView: imageView, color: UIColor.gray)
                self.passwordTxtField.getTextField()!.isSecureTextEntry = false
            }else{
                imageView.image = UIImage(named: "ic_show_password")
                GeneralFunctions.setImgTintColor(imgView: imageView, color: UIColor.gray)
                self.passwordTxtField.getTextField()!.isSecureTextEntry = true
            }
        }
        
//        if (isViewProperShutDown == true)
//        {
//            passwordTxtField.setText(text: "")
//            userNameTxtField.setText(text: "")
//            isViewProperShutDown = false
//        }
    }
    
    func setupLoginTypeTabs() {
        let phoneLbl = generalFunc.getLanguageLabel(origValue: "Phone", key: "LBL_PHONE")
        let emailLbl = generalFunc.getLanguageLabel(origValue: "Email", key: "LBL_EMAIL")

        phoneTabBtn.setTitle(phoneLbl, for: .normal)
        phoneTabBtn.setTitle(phoneLbl, for: .selected)
        emailTabBtn.setTitle(emailLbl, for: .normal)
        emailTabBtn.setTitle(emailLbl, for: .selected)

        // hardcoded blue ki jagah app theme
        phoneTabBtn.setTitleColor(UIColor.UCAColor.AppThemeColor, for: .selected)
        emailTabBtn.setTitleColor(UIColor.UCAColor.AppThemeColor, for: .selected)
        tabIndicatorView.backgroundColor = UIColor.UCAColor.AppThemeColor

        phoneTabBtn.addTarget(self, action: #selector(loginTypeTabTapped(_:)), for: .touchUpInside)
        emailTabBtn.addTarget(self, action: #selector(loginTypeTabTapped(_:)), for: .touchUpInside)

        selectLoginType(isPhone: true, animated: false)
    }

    @objc func loginTypeTabTapped(_ sender: UIButton) {
        let isPhone = (sender == phoneTabBtn)
        if isPhone == isPhoneLoginSelected { return }
        selectLoginType(isPhone: isPhone, animated: true)
    }

    func selectLoginType(isPhone: Bool, animated: Bool) {
        _ = Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: "")
        isPhoneLoginSelected = isPhone
        phoneTabBtn.isSelected  = isPhone
        emailTabBtn.isSelected  = !isPhone

//        let showCountry = isPhone &&
//            GeneralFunctions.getValue(key: Utils.ENABLE_PHONE_LOGIN_VIA_COUNTRY_SELECTION_METHOD)?.uppercased == "YES"
        let showCountry = isPhone

        self.view.layoutIfNeeded()
        tabIndicatorLeading.constant = isPhone ? 0 : loginTypeView.bounds.width / 2
        signInLeadingSpace.constant  = showCountry ? 135 : 30

        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.countryTxtField.isHidden = !showCountry
            })
        } else {
            self.view.layoutIfNeeded()
            self.countryTxtField.isHidden = !showCountry
        }

//        userNameTxtField.getTextField()!.keyboardType = isPhone ? .phonePad : .emailAddress
//        userNameTxtField.setText(text: "")
        let tf = userNameTxtField.getTextField()!

        tf.keyboardType           = isPhone ? .phonePad : .emailAddress
        tf.textContentType        = isPhone ? .telephoneNumber : .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType     = .no

        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = false
        tf.inputAccessoryView = isPhone ? makeDoneToolbar() : nil

        userNameTxtField.setText(text: "")

        if tf.isFirstResponder {
            tf.reloadInputViews()
        }
        userNameTxtField.setPlaceHolder(placeHolder: isPhone
            ? generalFunc.getLanguageLabel(origValue: "Mobile Number", key: "LBL_MOBILE_NO")
            : generalFunc.getLanguageLabel(origValue: "Email", key: "LBL_EMAIL"))
        userNameTxtFieldHelperLbl.isHidden = true
//        userNameTxtFieldHelperLbl.isHidden = !isPhone
    }
    
    func addKeyboardDismissSupport() {
        scrollView.keyboardDismissMode = .interactive

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tap)

        let userTf = userNameTxtField.getTextField()!
        let passTf = passwordTxtField.getTextField()!

        passTf.returnKeyType = .done
        passTf.enablesReturnKeyAutomatically = false

        userTf.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
        passTf.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
    }
    
    func setData(){
        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
        
        self.orLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OR_TXT")
//        LBL_PHONE_EMAIL
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "SignIn", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "SignIn", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT")
        self.signInImgHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Sign In", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT")
        
        self.userNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "PHONE NUMBER OR EMAIL", key: "LBL_PHONE_EMAIL"))
        self.passwordTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PASSWORD_LBL_TXT"))
       
        
        self.forgetPasswordLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FORGET_YOUR_PASS_TXT")
        
        self.forgetPasswordLbl.textColor = UIColor(hex: 0x646464)//UIColor.UCAColor.AppThemeColor
        self.forgetPasswordLbl.setClickDelegate(clickDelegate: self)
        
//        self.orLblContainer.transform = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi) / 2)
//        self.orLbl.transform = CGAffineTransform(rotationAngle: -CGFloat(CGFloat.pi) / 2)
     
        
        self.goSignUpLbl.setClickDelegate(clickDelegate: self)
        
        self.countryTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COUNTRY_TXT"))
        self.countryTxtField.setEnable(isEnabled: false)
        self.countryTxtField.onTextChangedDelegate = self
        if(GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY) as! String) != "" && GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) as! String) != "" && GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) as! String) != ""){
            self.selectedCountryCode = (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) as! String)
            self.selectedPhoneCode = (GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) as! String)
            
            self.countryTxtField.setText(text: "+\(self.selectedPhoneCode)")
            
            self.isCountrySelected = true
            self.countryTxtField.getTextField()!.sendActions(for: .editingChanged)
        }
        
        self.passwordTxtField.getTextField()!.isSecureTextEntry = true
        
        self.userNameTxtField.getTextField()!.keyboardType = .emailAddress
        self.passwordTxtField.getTextField()!.isSecureTextEntry = true
        
        fbImgView.isUserInteractionEnabled = true
        googleImgView.isUserInteractionEnabled = true
        twitterImgView.isUserInteractionEnabled = true
        linkdinImgView.isUserInteractionEnabled = true
        
        let fbImgTapGue = UITapGestureRecognizer()
        let googleImgTapGue = UITapGestureRecognizer()
        let twittImgTapGue = UITapGestureRecognizer()
        let linkdinImgTapGue = UITapGestureRecognizer()
        
        fbImgTapGue.addTarget(self, action: #selector(self.fbBtnTapped))
        googleImgTapGue.addTarget(self, action: #selector(self.googleBtnTapped))
        twittImgTapGue.addTarget(self, action: #selector(self.twittBtnTapped))
        linkdinImgTapGue.addTarget(self, action: #selector(self.linkdinBtnTapped))
        
        fbImgView.addGestureRecognizer(fbImgTapGue)
        googleImgView.addGestureRecognizer(googleImgTapGue)
        twitterImgView.addGestureRecognizer(twittImgTapGue)
        linkdinImgView.addGestureRecognizer(linkdinImgTapGue)
        
        signInWithSocial.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_IN_WITH_SOC_ACC_HINT")
        
        finalStr = NSMutableAttributedString.init(string: "")
        finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONT_HAVE_AN_ACCOUNT"),color:UIColor.black))
        finalStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNUP"),color:UIColor.UCAColor.AppThemeColor))
        finalStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOW"),color:UIColor.black))
        
        self.goSignUpLbl.attributedText = finalStr
        self.goSignUpLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        self.userNameTxtFieldHelperLbl.text = self.generalFunc.getLanguageLabel(origValue: "Enter without leading + or 00 or country code", key: "LBL_SIGN_IN_MOBILE_EMAIL_HELPER")
        
        let helperTxtHeight = self.userNameTxtFieldHelperLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 40, font: UIFont(name: Fonts().light, size: 14)!)
        if(helperTxtHeight > 0){
            PAGE_HEIGHT = PAGE_HEIGHT + helperTxtHeight
        }
        
        self.userNameTxtField.onTextChangedDelegate = self
        
        self.submitView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.submitViewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_IN").uppercased()
        self.submitViewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        if(Configurations.isRTLMode()){
            self.submitImgView.image = self.submitImgView.image?.rotate(180)
            GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }
        self.submitView.setOnClickListener { (instance) in
            self.checkData()
        }
        
        self.cancelImgView.setOnClickListener { (instance) in
            self.closeCurrentScreen()
        }
        
       // self.cancelImgView.image = self.cancelImgView.image?.addImagePadding(x: 5, y: 5)
        setupLoginTypeTabs()
        addKeyboardDismissSupport()
    }
    
    func myTxtFieldTapped(sender: MyTextField) {
        if(sender == self.countryTxtField){
         
            let countryListUv = GeneralFunctions.instantiateViewController(pageName: "CountryListUV") as! CountryListUV
            countryListUv.fromLogIn = true
            
            if(countryListArr != nil){
                countryListUv.countryListArr = countryListArr
            }
           
            countryListUv.modalPresentationStyle = .overCurrentContext
            self.present(countryListUv, animated: true) {
                
            }
        }
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        
        let termsRange = (self.finalStr.string as NSString).range(of: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNUP"))
        
        if gesture.didTapAttributedTextInLabel(label: goSignUpLbl, inRange: termsRange) {
            if(isFromAppLogin){
                let signUpUv = GeneralFunctions.instantiateViewController(pageName: "SignUpUV") as! SignUpUV
                signUpUv.isFromAppLogin = false
                self.pushToNavController(uv: signUpUv)
            }else{
                self.closeCurrentScreen()
            }
        }
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
        guard userNameTxtField == sender else { return }
        userNameTxtFieldHelperLbl.isHidden = true
//        userNameTxtFieldHelperLbl.isHidden = !isPhoneLoginSelected
    }
    
//    func onTextChanged(sender: MyTextField, text: String) {
//        if(userNameTxtField == sender){
//            self.userNameTxtFieldHelperLbl.isHidden = false
            
//            if GeneralFunctions.getValue(key: Utils.ENABLE_PHONE_LOGIN_VIA_COUNTRY_SELECTION_METHOD)?.uppercased == "YES"{
//                            if(text.count > 3){
//                               if(text.isNumeric()){
                                   
                                   
//                                   view.layoutIfNeeded()
//                                   self.signInLeadingSpace.constant = 135

//                                   UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
//                                     self.view.layoutIfNeeded()
//                                   }, completion: { finished in
//                                     self.countryTxtField.isHidden = false
//                                   })
                                   
                                   
//                               }else{
//                                   self.countryTxtField.isHidden = true
//                                   view.layoutIfNeeded()
//                                   self.signInLeadingSpace.constant = 30

//                                   UIView.animate(withDuration: 0.3, animations: {
//                                        self.view.layoutIfNeeded()
//                                   })
//                               }
//                           }else{
//                               self.countryTxtField.isHidden = true
//                               view.layoutIfNeeded()
//                               self.signInLeadingSpace.constant = 30

//                               UIView.animate(withDuration: 0.3, animations: {
//                                    self.view.layoutIfNeeded()
//                               })
//                           }
//                       }
//        }
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        self.userNameTxtField.getTextField()!.autocapitalizationType = .none
//        self.userNameTxtField.getTextField()!.autocorrectionType = .no
//    }
    
    @objc func fbBtnTapped(){
//        isViewProperShutDown = true
        let window = UIApplication.shared.delegate!.window!
        
        openFbLogin = OpenFbLogin(uv: self, window: window!)
        
        openFbLogin.processData(openFbLoginInst: openFbLogin)
    }
    
    @objc func googleBtnTapped(){
//        isViewProperShutDown = true
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        let window = UIApplication.shared.delegate!.window!

        openGoogleLogin = OpenGoogleLogin(uv: self, window: window!)
        openGoogleLogin.processData(currGoogleLoginInst: openGoogleLogin)

    }
    @objc func twittBtnTapped(){
//        isViewProperShutDown = true
        let window = UIApplication.shared.delegate!.window!
        
        openTwitterLogin = OpenTwitterLogin(uv: self, window: window!)
        openTwitterLogin.processData(currTwitterLoginInst: openTwitterLogin)
        
    }
    
    @objc func linkdinBtnTapped(){
        
        let window = UIApplication.shared.delegate!.window!
        
        openLinkdinLogin = OpenLinkedinLogin(uv: self, window: window!)
        openLinkdinLogin.processData(currLinkedinInst: openLinkdinLogin)
        
    }
    
//    func myBtnTapped(sender: MyButton) {
//
//        if(sender == signInBtn){
//            checkData()
//        }
//
//    }
    
    func checkData(){
        let noWhiteSpace = generalFunc.getLanguageLabel(origValue: "Password should not contain whitespace.", key: "LBL_ERROR_NO_SPACE_IN_PASS");
        let pass_length = generalFunc.getLanguageLabel(origValue: "Password must be", key: "LBL_ERROR_PASS_LENGTH_PREFIX")
            + " \(Utils.minPasswordLength)" + " " + generalFunc.getLanguageLabel(origValue: "or more character long.",key: "LBL_ERROR_PASS_LENGTH_SUFFIX");
        let mobileInvalid = generalFunc.getLanguageLabel(origValue: "Invalid mobile no.", key: "LBL_INVALID_MOBILE_NO")
        
//        let emailEntered = Utils.checkText(textField: self.userNameTxtField.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.userNameTxtField.getTextField()!)) ? true : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR_TXT"))) : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: required_str)

        
//        let emailEntered = Utils.checkText(textField: self.userNameTxtField.getTextField()!) ? (Utils.getText(textField: self.userNameTxtField.getTextField()!).isNumeric() ? (Utils.getText(textField: self.userNameTxtField.getTextField()!).count >= Utils.minMobileLength ? true : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: mobileInvalid)) : (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.userNameTxtField.getTextField()!)) ? true :  Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR")) )) : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: required_str)
        let userNameText = Utils.getText(textField: self.userNameTxtField.getTextField()!).trimmingCharacters(in: .whitespacesAndNewlines)
        var emailEntered = true
        if userNameText.isEmpty {
            emailEntered = Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: required_str)
        } else if isPhoneLoginSelected {
            emailEntered = (userNameText.isNumeric() && userNameText.count >= Utils.minMobileLength) ? true : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: mobileInvalid)
        } else {
            emailEntered = GeneralFunctions.isValidEmail(testStr: userNameText) ? true : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR"))
        }
        
        let passwordEntered = Utils.checkText(textField: self.passwordTxtField.getTextField()!) ? (Utils.getText(textField: self.passwordTxtField.getTextField()!).contains(" ") ? Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: noWhiteSpace) : (Utils.getText(textField: self.passwordTxtField.getTextField()!).count >= Utils.minPasswordLength ? true : Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: pass_length))) : Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: required_str)
        
        if (emailEntered == false || passwordEntered == false) {
            if(emailEntered == false){
                self.userNameTxtFieldHelperLbl.isHidden = true
            }
            return;
        }

        if(Utils.getText(textField: self.userNameTxtField.getTextField()!).isNumeric()){
        }
        
        signIn()
    }
    
    func myLableTapped(sender: MyLabel) {
//        isViewProperShutDown = true
        if(sender == self.forgetPasswordLbl){
            
//            self.present(SFSafariViewController(url: URL(string: GeneralFunctions.getValue(key: Utils.LINK_FORGET_PASS_KEY) as! String)!), animated: true, completion: nil)
            let forgetPasswordUV = GeneralFunctions.instantiateViewController(pageName: "ForgetPasswordUV") as! ForgetPasswordUV
            
            self.pushToNavController(uv: forgetPasswordUV)
            
        }

    }
    
    func signIn(){
        
        let userSelectedCurrency = GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String
        let userSelectedLanguage = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
        let inputType = isPhoneLoginSelected ? "phone" : "email"
        
        var parameters = ["type":"signIn","vEmail": Utils.getText(textField: self.userNameTxtField.getTextField()!), "vPassword": Utils.getText(textField: self.passwordTxtField.getTextField()!), "vDeviceType": Utils.deviceType, "UserType": Utils.appUserType, "vCurrency": userSelectedCurrency, "vLang": userSelectedLanguage, "input_type": inputType]
        
        if isPhoneLoginSelected,
           GeneralFunctions.getValue(key: Utils.ENABLE_PHONE_LOGIN_VIA_COUNTRY_SELECTION_METHOD)?.uppercased == "YES" {
            parameters["CountryCode"] = self.selectedCountryCode
            parameters["PhoneCode"]   = self.selectedPhoneCode
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    _ = SetUserData(uv: self, userProfileJson: dataDict, isStoreUserId: true)
                    
                    let window = UIApplication.shared.delegate!.window!
                    _ = OpenMainProfile(uv: self, userProfileJson: response, window: window!)
                    self.closeCurrentScreen()
                    
                }else{
                    if(dataDict.get("eStatus").uppercased() == "DELETED"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), completionHandler: { (btnClickedIndex) in
                            if(btnClickedIndex == 1){
                                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                self.pushToNavController(uv: contactUsUv)
                            }
                        })
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                    
//                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    self.passwordTxtField.setText(text: "")
                }
                
            }else{
                self.generalFunc.setError(uv: self)
                self.passwordTxtField.setText(text: "")
            }
        })
    }
    
    func getAttributedString(str:String,color:UIColor) -> NSMutableAttributedString
    {
        let string_to_color = str
        
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attributedString = NSMutableAttributedString(string:string_to_color)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        return attributedString
    }
    
    @IBAction func unwindToSignIn(_ segue:UIStoryboardSegue) {
              
              if(segue.source .isKind(of: CountryListUV.self)){
                  let sourceViewController = segue.source as? CountryListUV
                  let selectedPhoneCode:String = sourceViewController!.selectedCountryHolder!.vPhoneCode
                  let selectedCountryCode = sourceViewController!.selectedCountryHolder!.vCountryCode
                  
                  self.selectedCountryCode = selectedCountryCode
                  self.selectedPhoneCode = selectedPhoneCode
                  self.countryPrefixImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl:sourceViewController!.selectedCountryHolder!.vSImage, width: Utils.getValueInPixel(value: 27), height: Utils.getValueInPixel(value: 19))), placeholderImage:nil)
                  
                  self.countryTxtField.setText(text: "+\(selectedPhoneCode)")
                  
                  self.isCountrySelected = true
                  self.countryTxtField.getTextField()!.sendActions(for: .editingChanged)
                  
              }
          
          }
}


extension UIViewController {

    func makeDoneToolbar() -> UIToolbar {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Application.screenSize.width, height: 44))
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(
            title: GeneralFunctions().getLanguageLabel(origValue: "Done", key: "LBL_BTN_DONE_TXT"),
            style: .done, target: self, action: #selector(dismissKeyboard))
        done.tintColor = UIColor.UCAColor.AppThemeColor
        bar.items = Configurations.isRTLMode() ? [done, flex] : [flex, done]
        bar.sizeToFit()
        return bar
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
