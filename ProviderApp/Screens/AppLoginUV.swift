//
//  AppLoginUV.swift
//  PassengerApp
//
//  Created by ADMIN on 06/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AppLoginUV: UIViewController, MyBtnClickDelegate, MyTxtFieldClickDelegate, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var languageFieldDownArrow: UIImageView!
    @IBOutlet weak var currencyFieldDownArrow: UIImageView!
    
    @IBOutlet weak var logInBottomStackViewSpace: NSLayoutConstraint!
    @IBOutlet weak var registerBtn: MyButton!
    @IBOutlet weak var signInBtn: MyButton!
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var bgImgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bgImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var bgImgViewYPosition: NSLayoutConstraint!
    @IBOutlet weak var bgImgViewXPosition: NSLayoutConstraint!
    
    @IBOutlet weak var lanCurrStackViewWidth: NSLayoutConstraint!
    @IBOutlet weak var languageSelectView: UIView!
    @IBOutlet weak var currencySelectView: UIView!
    @IBOutlet weak var lngLbl: MyLabel!
    @IBOutlet weak var currencyLbl: MyLabel!
    @IBOutlet weak var selectStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectStackViewBottomMargin: NSLayoutConstraint!

    @IBOutlet weak var loginRegisterStkView: UIStackView!
    @IBOutlet weak var currencyTxtField: MyTextField!
    @IBOutlet weak var languageTxtField: MyTextField!
    
//    var languageTxtField = MyTextField()
//    var currencyTxtField = MyTextField()
    
//    @IBOutlet weak var introLbl: MyLabel!
    @IBOutlet weak var introSubLbl: MyLabel!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    @IBOutlet weak var langCurrStackView: UIStackView!
    @IBOutlet weak var imgSlideShow: iCarousel!
    @IBOutlet weak var imgSlideShowViewHeight: NSLayoutConstraint!
    
    var imageSlideShowPageController: UIPageControl!
    
    var selectedCurrency = ""
    var selectedLngCode = ""
    
    var languageNameList = [String]()
    var languageCodes = [String]()
    
    var colorArrayForLang = [UIColor]()
    var colorArrayForCurr = [UIColor]()
    
    var colorArrayForTextLang = [UIColor]()
    var colorArrayForTextCurr = [UIColor]()
    
    var selectedLngColor = UIColor()
    var selectedCurrColor = UIColor()
    
    var selectedLngTxtColor = UIColor()
    var selectedCurrTxtColor = UIColor()
    
    var currencySymboles = [String]()
    
    var currenyList = [String]()

    let generalFunc = GeneralFunctions()
    
    var languageArrCount = 0
    
    var isViewLoad = false
    
    var openListView:OpenListView!
    
    var isViewRestarted = false
    
    var bannersItemList = [NSDictionary]()
    
    var placeHolderArry = [Placeholder]()
    var isImageLoaded = [Bool]()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.containerView.addSubview(self.generalFunc.loadView(nibName: "AppLoginScreenDesign", uv: self, contentView: containerView))
        
//        let APPSTORE_MODE_IOS = GeneralFunctions.getValue(key: Utils.APPSTORE_MODE_IOS_KEY)
//        if(APPSTORE_MODE_IOS != nil && (APPSTORE_MODE_IOS as! String).uppercased() == "REVIEW"){
//            let skipContainerView = UIView()
////            skipContainerView.backgroundColor = UIColor.blue
//
//            let skipLabel = MyLabel()
//            skipLabel.text = "Skip Login"
//            skipLabel.fontFamilyWeight = "Bold"
//            skipLabel.font = UIFont(name: Fonts().bold, size: 17)!
//            skipLabel.textColor = UIColor(hex: 0x272727)
//            skipLabel.backgroundColor = UIColor(hex: 0xFFFFFF)
//            skipLabel.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 20, paddingRight: 20)
////            skipLabel.fitText()
//
//            skipLabel.layer.cornerRadius = 8
//            skipLabel.layer.masksToBounds = true
//            skipContainerView.addSubview(skipLabel)
//            loginRegisterStkView.addArrangedSubview(skipContainerView)
//
//            let widthConstraint = NSLayoutConstraint(item: skipContainerView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: loginRegisterStkView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
//
//            let heightConstraint = NSLayoutConstraint(item: skipContainerView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 45)
//            loginRegisterStkView.addConstraint(widthConstraint)
//            skipContainerView.addConstraints([heightConstraint])
//
//            skipLabel.translatesAutoresizingMaskIntoConstraints = false
//
//            skipLabel.centerXAnchor.constraint(equalTo: skipContainerView.centerXAnchor).isActive = true
//            skipLabel.centerYAnchor.constraint(equalTo: skipContainerView.centerYAnchor).isActive = true
//            skipLabel.sizeToFit()
//
//            loginRegisterStkView.layoutSubviews()
//            loginRegisterStkView.layoutIfNeeded()
//
//            skipLabel.setClickHandler { (instance) in
//                self.skipLoginInfo()
//            }
//        }
        
        
        registerBtn.clickDelegate = self
        signInBtn.clickDelegate = self
        
        setLabels()
        setData()
        
    
        self.lngLbl.setOnClickListener { (instance) in
            self.openListView = OpenListView(uv: self, containerView: self.view)
            self.openListView.openNewList = true
            self.openListView.appLoginUV = self
            self.openListView.newListCodeString = self.languageCodes
            self.openListView.colorArray = self.colorArrayForLang
            self.openListView.textColorArray = self.colorArrayForTextLang
            self.openListView.selectedItem = self.languageTxtField.text
            self.openListView.show(listObjects: self.languageNameList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_LANGUAGE_HINT_TXT"), currentInst: self.openListView, handler: { (selectedItemId) in
               
            })
        }
        
        self.currencyLbl.setOnClickListener { (instance) in
            self.openListView = OpenListView(uv: self, containerView: self.view)
            self.openListView.openNewList = true
            self.openListView.appLoginUV = self
            self.openListView.newListCodeString = self.currencySymboles
            self.openListView.colorArray = self.colorArrayForCurr
            self.openListView.textColorArray = self.colorArrayForTextCurr
            self.openListView.isForCurrency = true
            self.openListView.selectedItem = self.currencyTxtField.text
            self.openListView.show(listObjects: self.currenyList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CURRENCY"), currentInst: self.openListView, handler: { (selectedItemId) in
                
            })
        }
        
        setLanguage()
        
        indicatorView.type = .ballPulse
        indicatorView.tintColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.lngLbl.backgroundColor = self.selectedLngColor
        self.currencyLbl.backgroundColor = self.selectedCurrColor
        self.lngLbl.textColor = self.selectedLngTxtColor
        self.currencyLbl.textColor = self.selectedCurrTxtColor
        
        self.lngLbl.clipsToBounds = true
        
        self.introSubLbl.alpha = 0
        self.langCurrStackView.alpha = 0
        self.loginRegisterStkView.alpha = 0
        self.imgSlideShow.alpha = 0
        self.imgSlideShowViewHeight.constant = Utils.getHeightOfBanner(widthOffset: 70, ratio: "16:9") + 170
        
        Configurations.setDefaultNavBar()
        

        if(isViewRestarted){
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                // 3
                self.view.layoutIfNeeded()
            }, completion: {_ in
                self.lanCurrStackViewWidth.constant = 105
                self.bgImgViewYPosition.constant = -(Application.screenSize.height / 2) + GeneralFunctions.getSafeAreaInsets().top + 35
                
                self.bgImgViewWidth.constant = 85
                self.bgImgViewHeight.constant = 85
                
                if(Configurations.isRTLMode()){
                    self.bgImgViewXPosition.constant = +(Application.screenSize.width / 2) - 60
                }else{
                    self.bgImgViewXPosition.constant = -(Application.screenSize.width / 2) + 60
                }
                
                self.introSubLbl.alpha = 1.0
                self.langCurrStackView.alpha = 1.0
                self.loginRegisterStkView.alpha = 1.0
                self.imgSlideShow.alpha = 1.0
            })
        
        }
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
       // self.navigationController?.navigationBar.isHidden = true
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        
        if(self.isViewLoad == false){
        
            self.imageSlideShowPageController = UIPageControl.init(frame: CGRect(x: 10, y: self.imgSlideShow.frame.origin.y + self.imgSlideShow.frame.height + 5, width: Application.screenSize.width - 20, height:20))
            self.imageSlideShowPageController.currentPage = 0
            self.imageSlideShowPageController.isUserInteractionEnabled = false
            self.imageSlideShowPageController.tintColor = UIColor.lightGray
            self.imageSlideShowPageController.hidesForSinglePage = true
            self.imageSlideShowPageController.pageIndicatorTintColor = UIColor.lightGray
            self.imageSlideShowPageController.currentPageIndicatorTintColor = UIColor.UCAColor.AppThemeColor
            self.containerView.addSubview(self.imageSlideShowPageController)

            imgSlideShow.type = .linear
            imgSlideShow.isPagingEnabled = true
            imgSlideShow.scrollSpeed = 0.8
            imgSlideShow.decelerationRate = 0.8
            self.imgSlideShow.delegate = self
            self.imgSlideShow.dataSource = self
            
            self.bannersItemList.removeAll()
            self.bannersItemList = GeneralFunctions.getValue(key: "APP_LAUNCH_IMAGES") as! [NSDictionary]
            if(Configurations.isRTLMode()){
                self.imageSlideShowPageController.currentPage = 0
                var newreverseArray = [NSDictionary]()
                let totalIndices = self.bannersItemList.count - 1
                for arrayIndex in 0...totalIndices {
                    newreverseArray.append(self.bannersItemList[totalIndices - arrayIndex])
                }
                self.bannersItemList = newreverseArray
                self.imgSlideShow.reloadData()
                self.imgSlideShow.scrollToItem(at: self.bannersItemList.count, duration: 0)
                self.imageSlideShowPageController.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)

            }else{
                self.imgSlideShow.reloadData()
            }
            
        }
        
        if(self.isViewLoad == false && self.isViewRestarted == false){
            self.next()
        }
        
        self.isViewLoad = true
        self.isViewRestarted = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if(self.isViewRestarted == false){
            Configurations.setAppThemeNavBar()
        }
    }
    
    func next() {
      
        self.view.layoutIfNeeded()
        if(!isViewRestarted){
            self.bgImgViewWidth.constant = 140
            self.bgImgViewHeight.constant = 140
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            // 3
            self.view.layoutIfNeeded()
        }, completion: {_ in
            
            self.lanCurrStackViewWidth.constant = 105
            if(Configurations.isRTLMode()){
                self.bgImgViewXPosition.constant = +(Application.screenSize.width / 2) - 60
            }else{
                self.bgImgViewXPosition.constant = -(Application.screenSize.width / 2) + 60
            }
            
            self.bgImgViewYPosition.constant = -(Application.screenSize.height / 2) + GeneralFunctions.getSafeAreaInsets().top + 35
            self.bgImgViewWidth.constant = 85
            self.bgImgViewHeight.constant = 85
            UIView.animate(withDuration:1.0,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.65,
                           options: .transitionCrossDissolve,
                 animations: {
                    self.introSubLbl.alpha = 1.0
                    self.langCurrStackView.alpha = 1.0
                    self.loginRegisterStkView.alpha = 1.0
                    self.imgSlideShow.alpha = 1.0
                    self.view.layoutIfNeeded()
                    
                 }, completion: {
                    //Code to run after animating
                    
                        (value: Bool) in
                    
                
                })
        })
        
        
    }
    
    
    func setData(){

        currencyTxtField.disableMenu()
        currencyTxtField.getTextField()!.clearButtonMode = .never
        currencyTxtField.setEnable(isEnabled: false)
        
//        languageTxtField.allColor = UIColor.UCAColor.AppThemeTxtColor
        languageTxtField.disableMenu()
        languageTxtField.getTextField()!.clearButtonMode = .never
        languageTxtField.setEnable(isEnabled: false)
        
        languageTxtField.myTxtFieldDelegate = self
        currencyTxtField.myTxtFieldDelegate = self
        
        if (Configurations.isRTLMode() == true){
            self.languageTxtField.textPadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 10)
            self.currencyTxtField.textPadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 10)
        }else{
            self.languageTxtField.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
            self.currencyTxtField.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
        }
        
    }
    
   
    func setLabels(){
//        introLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INTRODUCTION")
        self.lngLbl.text = (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String).uppercased()
        self.currencyLbl.text = (GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String).uppercased()
        
        introSubLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_DRIVER_INTRO_DETAILS")
        introSubLbl.fitText()
        
        self.signInBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOGIN"))
        self.registerBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_UP"))
        
        self.languageTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LANGUAGE_TXT"))
        self.currencyTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Currency", key: "LBL_CURRENCY_TXT"))
    }
    
    func skipLoginInfo(){
        let parameters = ["type":"generateReviewModeLogin"]
        
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
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func myTxtFieldTapped(sender: MyTextField) {
        if(sender == self.languageTxtField){
            let openListView = OpenListView(uv: self, containerView: self.view)
            openListView.selectedItem = self.languageTxtField.text
            openListView.show(listObjects: languageNameList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_LANGUAGE_HINT_TXT"), currentInst: openListView, handler: { (selectedItemId) in
                self.lngValueChanged(selectedItemId: selectedItemId)
            })
        }else if(sender == self.currencyTxtField){
            
            let openListView = OpenListView(uv: self, containerView: self.view)
            openListView.selectedItem = self.currencyTxtField.text
            openListView.show(listObjects: currenyList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CURRENCY"), currentInst: openListView, handler: { (selectedItemId) in
                self.currencyValueChanged(selectedItemId: selectedItemId)
            })
        }
    }
   
    func setLanguage(){
        let dataArr = GeneralFunctions.getValue(key: Utils.LANGUAGE_LIST_KEY) as! NSArray
        self.languageArrCount = dataArr.count
        
        for i in 0 ..< dataArr.count{
            let tempItem = dataArr[i] as! NSDictionary
            
            self.colorArrayForLang.append(UIColor.init(hexString: tempItem.get("vService_BG_color"), alpha: 1))
            self.colorArrayForTextLang.append(UIColor.init(hexString: tempItem.get("vService_TEXT_color"), alpha: 1))
            if((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) == tempItem.get("vCode")){
                languageTxtField.setText(text: tempItem.get("vTitle").uppercased())
                self.selectedLngCode = tempItem.get("vCode")
                self.selectedLngColor = self.colorArrayForLang[i]
                self.selectedLngTxtColor = self.colorArrayForTextLang[i]
                
            }
            
            languageNameList.append(tempItem.get("vTitle"))
            languageCodes.append(tempItem.get("vCode"))
            
        }
        
        let LANGUAGE_OPTIONAL = GeneralFunctions.getValue(key: Utils.LANGUAGE_OPTIONAL_KEY)
        
        if(LANGUAGE_OPTIONAL != nil && (LANGUAGE_OPTIONAL as! String).uppercased() == "YES"){
            languageSelectView.isHidden = true
        }else{
            if(dataArr.count < 2){
                languageSelectView.isHidden = true
            }
        }
        
        setCurrency()
       
    }
    
    func lngValueChanged(selectedItemId:Int){
        self.selectedLngCode = self.languageCodes[selectedItemId]
        
        if((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) != self.selectedLngCode){
            changeLanguage()
        }else{
            if(self.openListView != nil){
                self.openListView.bgView.isUserInteractionEnabled = true
                self.openListView.newListView.isUserInteractionEnabled = true
                self.openListView.startLoading = false
                self.openListView.newListView.tableView.reloadData()
                self.openListView.closeNewListView()
            }
        }
    }
    
    func changeLanguage(){
        
        //self.startBottomLoading()
        let parameters = ["type":"changelanguagelabel","vLang": self.selectedLngCode]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    //let window = UIApplication.shared.delegate!.window!
                    
                    
                    GeneralFunctions.saveValue(key: "APP_LAUNCH_IMAGES", value: dataDict.getArrObj("APP_LAUNCH_IMAGES"))
                    
                    GeneralFunctions.saveValue(key: Utils.languageLabelsKey, value: dataDict.getObj(Utils.message_str))
                    
                    GeneralFunctions.saveValue(key: Utils.LANGUAGE_CODE_KEY, value: dataDict.get("vCode") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.LANGUAGE_IS_RTL_KEY, value: dataDict.get("eType") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.DEFAULT_LANGUAGE_TITLE_KEY, value: dataDict.get("vTitle") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY, value: dataDict.get("vGMapLangCode") as AnyObject)
                    GeneralFunctions.languageLabels = nil
                    Configurations.setAppLocal()
                    
                    if(self.openListView != nil){
                        self.openListView.closeNewListView()
                    }
                    
                    //self.setLanguage()
                    self.perform(#selector(self.reloadScreen), with: self, afterDelay: 0.4)
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            if(self.openListView != nil && self.openListView.newListView != nil){
                self.openListView.bgView.isUserInteractionEnabled = true
                self.openListView.newListView.isUserInteractionEnabled = true
                self.openListView.startLoading = false
                self.openListView.newListView.tableView.reloadData()
            }
        })
    }
    
    @objc func reloadScreen(){
        
        self.isImageLoaded.removeAll()
        self.isViewRestarted = true
        let appLoginUv = GeneralFunctions.instantiateViewController(pageName: "AppLoginUV") as! AppLoginUV
        appLoginUv.isViewRestarted = self.isViewRestarted
         
        GeneralFunctions.changeRootViewController(window: Application.window!, viewController: appLoginUv)
        
    }
    
    func startBottomLoading(){
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        self.loginRegisterStkView.isHidden = true
        self.langCurrStackView.isHidden = true
        self.introSubLbl.isHidden = true
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
            
//            currenyList += [tempItem.get("vName")]
            currenyList.append(tempItem.get("vName"))
            currencySymboles.append(tempItem.get("vSymbol"))
            
        }
        
        let CURRENCY_OPTIONAL = GeneralFunctions.getValue(key: Utils.CURRENCY_OPTIONAL_KEY)
        if(CURRENCY_OPTIONAL != nil && (CURRENCY_OPTIONAL as! String).uppercased() == "YES"){
            currencySelectView.isHidden = true
        }else{
            if(dataArr.count < 2){
                currencySelectView.isHidden = true
                
            }
        }
        
        let LANGUAGE_OPTIONAL = GeneralFunctions.getValue(key: Utils.LANGUAGE_OPTIONAL_KEY)
        
        
        
        if(CURRENCY_OPTIONAL != nil && (CURRENCY_OPTIONAL as! String).uppercased() == "YES" && LANGUAGE_OPTIONAL != nil && (LANGUAGE_OPTIONAL as! String).uppercased() == "YES"){
            //selectStackViewHeight.constant = 0
            //selectStackViewBottomMargin.constant = 0
            
            currencySelectView.isHidden = true
            languageSelectView.isHidden = true
            
        }
    }
    
    func currencyValueChanged(selectedItemId:Int){
        self.selectedCurrColor = self.colorArrayForCurr[selectedItemId]
        self.selectedCurrTxtColor = self.colorArrayForTextCurr[selectedItemId]
        self.selectedCurrency = self.currenyList[selectedItemId]
        self.currencyLbl.text = self.selectedCurrency.uppercased()
        self.currencyTxtField.setText(text: self.selectedCurrency.uppercased())
        GeneralFunctions.saveValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY, value: self.selectedCurrency as AnyObject)
    
        self.currencyLbl.backgroundColor = self.selectedCurrColor
        self.currencyLbl.textColor = self.selectedCurrTxtColor
    }

    func myBtnTapped(sender: MyButton) {
        
        UIView.animate(withDuration: 0.1,
            animations: {
                sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    sender.transform = CGAffineTransform.identity
                }
            })

        
        self.isViewRestarted = true
        if(sender == signInBtn){
            self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignInUV"))
        }else if(sender == registerBtn){
            self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignUpUV"))
        }
    }
    
    //carouselview methods
    func numberOfItems(in carousel: iCarousel) -> Int {
        if(self.imageSlideShowPageController != nil){
            self.imageSlideShowPageController.numberOfPages = self.bannersItemList.count
        }
        return self.bannersItemList.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let item = self.bannersItemList[index]
        var mainView:UIView!
        var imageView:UIImageView!
        var titleLbl:MyLabel!
        var subTitleLbl:MyLabel!
        
        
        mainView = UIView.init(frame: CGRect(x: 0, y: 0, width: Application.screenSize.width, height: self.imgSlideShow.frame.height))
        
        let imgWidth = (Application.screenSize.width * 87) / 100
        imageView = UIImageView.init(frame: CGRect(x: (Application.screenSize.width - imgWidth) / 2, y: 0, width: (Application.screenSize.width * 87) / 100, height: Utils.getHeightOfBanner(widthOffset: 70, ratio: "16:9")))
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        imageView.tag = index
        
        mainView.addSubview(imageView)
        
        titleLbl = MyLabel.init(frame: CGRect(x: imageView.frame.origin.x, y: imageView.frame.height + 30, width: imgWidth, height: 45))
        if(Configurations.isRTLMode()){
            titleLbl.textAlignment = .right
        }else{
            titleLbl.textAlignment = .left
        }
        titleLbl.layer.cornerRadius = 10
        titleLbl.clipsToBounds = true
        titleLbl.font = UIFont(name: Fonts().semibold, size: 21)!
        titleLbl.fontFamilyWeight = "Medium"
        titleLbl.numberOfLines = 2
        titleLbl.setFontFamily()
        titleLbl.text = item.get("tTitle")
        titleLbl.sizeToFit()
        mainView.addSubview(titleLbl)
        
        subTitleLbl = MyLabel.init(frame: CGRect(x: imageView.frame.origin.x, y: titleLbl.frame.origin.y + titleLbl.frame.height + 4, width: imgWidth, height: 65))
        
        if(Configurations.isRTLMode()){
            subTitleLbl.textAlignment = .right
        }else{
            subTitleLbl.textAlignment = .left
        }
        subTitleLbl.font = UIFont(name: Fonts().light, size: 14)!
        subTitleLbl.fontFamilyWeight = "Light"
        subTitleLbl.numberOfLines = 4
        subTitleLbl.setFontFamily()
        subTitleLbl.text = item.get("tSubtitle")
        subTitleLbl.sizeToFit()
        
        subTitleLbl.layer.cornerRadius = 10
        subTitleLbl.clipsToBounds = true
        mainView.addSubview(subTitleLbl)
        
  
        self.isImageLoaded.append(false)
        
        if(self.isImageLoaded.count > index && self.isImageLoaded[index] == false){
            let placeholderMarker = Placeholder()
            let viewElements: [UIView] = [

                imageView, titleLbl,subTitleLbl
            ]
            placeholderMarker.register(viewElements)
            placeholderMarker.startAnimation()
            
            self.placeHolderArry.append(placeholderMarker)
        }
        
        print(Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: Utils.getValueInPixel(value: imgWidth), height: Utils.getValueInPixel(value: imageView.frame.height)))

        imageView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: Utils.getValueInPixel(value: imgWidth), height: Utils.getValueInPixel(value: imageView.frame.height))), placeholderImage: nil,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in

            if(self.isImageLoaded.count > index){
                self.isImageLoaded[imageView.tag] = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if(self.placeHolderArry.count > imageView.tag){
                    self.placeHolderArry[imageView.tag].remove()
                }
                
                
            }
            
            
        })
        
        return mainView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if(self.imageSlideShowPageController != nil){
            self.imageSlideShowPageController.currentPage = carousel.currentItemIndex
        }
    }
    
    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0).darker(by: 15) ?? UIColor.black
    }
    

}
