//
//  EditProfileUV.swift
//  DriverApp
//
//  Created by ADMIN on 15/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class EditProfileUV: UIViewController, MyBtnClickDelegate, MyTxtFieldClickDelegate, MyLabelClickDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollViewCOntentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePicViewArea: UIView!
    
    @IBOutlet weak var userProfilePicBgView: UIView!
    @IBOutlet weak var userProfilePicBgImgView: UIImageView!
    @IBOutlet weak var usrProfileImgView: UIImageView!
    @IBOutlet weak var fNameTxtField: MyTextField!
    @IBOutlet weak var lNameTxtField: MyTextField!
    @IBOutlet weak var emailTxtField: MyTextField!
    @IBOutlet weak var countryTxtField: MyTextField!
    @IBOutlet weak var mobileTxtField: MyTextField!
    @IBOutlet weak var languageTxtField: MyTextField!
    @IBOutlet weak var currencyTxtField: MyTextField!
    @IBOutlet weak var serviceDescriptionTxtField: MyTextField!
    @IBOutlet weak var editIconImgView: UIImageView!
    @IBOutlet weak var serviceDescriptionTxtFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var editPicAreaView: UIView!
    @IBOutlet weak var workLocTxtFiled: MyTextField!
    @IBOutlet weak var workLocTxtFieldHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var langTxtFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var currencyTxtFieldHeight: NSLayoutConstraint!
    
    @IBOutlet weak var updateBtn: MyButton!
    var countryPrefixImgView:UIImageView!

    var manageProfileUv:ManageProfileUV!
    
    var containerViewHeight:CGFloat = 0
    
    let generalFunc = GeneralFunctions()
    
    var required_str = ""
    
    var isCountrySelected = false
    var selectedCountryCode = ""
    var selectedPhoneCode = ""
    
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
    
    var workLocationsValue = [String]()
    var selectedWorkLoc = ""
    
    var isFirstLaunch = true
    var cntView:UIView!
    
    var userProfileJson:NSDictionary!
    
    var openImgSelection:OpenImageSelectionOption!
    
    var PAGE_HEIGHT:CGFloat = 625
    
    var countryListArr:NSArray!
    
    var openListView:OpenListView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        CountryListData.getInstance().getCountryListData { (dataArray, isSuccess) in
            if(isSuccess){
                self.countryListArr = dataArray
            }
        }
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        cntView = self.generalFunc.loadView(nibName: "EditProfileScreenDesign", uv: self, contentView: scrollView)
        
        self.scrollView.addSubview(cntView)
        
        
        
//        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
//        blurEffectView.frame = userProfilePicBgView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.userProfilePicBgView.addSubview(blurEffectView)
        self.userProfilePicBgView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
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
        
        // Update scroll view content view background
        self.scrollViewContentView.backgroundColor = themeManager.backgroundColor()
        
        // Update content view background
        self.contentView.backgroundColor = themeManager.backgroundColor()
        
        // Apply theme to all text fields
        applyThemeToTextField(fNameTxtField, themeManager: themeManager)
        applyThemeToTextField(lNameTxtField, themeManager: themeManager)
        applyThemeToTextField(emailTxtField, themeManager: themeManager)
        applyThemeToTextField(countryTxtField, themeManager: themeManager)
        applyThemeToTextField(mobileTxtField, themeManager: themeManager)
        applyThemeToTextField(languageTxtField, themeManager: themeManager)
        applyThemeToTextField(currencyTxtField, themeManager: themeManager)
        applyThemeToTextField(serviceDescriptionTxtField, themeManager: themeManager)
        applyThemeToTextField(workLocTxtFiled, themeManager: themeManager)
        
        print("✅ EditProfileUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
    }
    
    func applyThemeToTextField(_ textField: MyTextField, themeManager: ThemeManager) {
        // Update MyTextField container background
        textField.backgroundColor = themeManager.cardBackgroundColor()
        
        // Get the underlying ErrorTextField
        guard let errorTextField = textField.getTextField() else { return }
        
        // Update text color
        errorTextField.textColor = themeManager.textColor()
        
        // Update background color
        errorTextField.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update placeholder colors based on theme
        let placeholderColor = themeManager.secondaryTextColor()
        errorTextField.placeholderNormalColor = placeholderColor
        errorTextField.placeholderActiveColor = themeManager.textColor()
        
        // Update divider colors based on theme
        let dividerColor = themeManager.isDarkModeActive ? UIColor.white.withAlphaComponent(0.3) : UIColor.lightGray
        let dividerActiveColor = themeManager.isDarkModeActive ? UIColor.white.withAlphaComponent(0.8) : UIColor.UCAColor.AppThemeColor
        errorTextField.dividerNormalColor = dividerColor
        errorTextField.dividerActiveColor = dividerActiveColor
        
        // Update the placeholder label directly (it's not optional)
        errorTextField.placeholderLabel.textColor = placeholderColor
        
        // Refresh the text field to apply changes
        errorTextField.setNeedsDisplay()
        errorTextField.layoutIfNeeded()
    }

    func setData(){
        

        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
        
    
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_PROFILE_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_PROFILE_TXT")
//        LBL_EDIT_PROFILE_TXT
        fNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FIRST_NAME_HEADER_TXT"))
        lNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LAST_NAME_HEADER_TXT"))
        emailTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_LBL_TXT"))
        countryTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COUNTRY_TXT"))
        mobileTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MOBILE_NUMBER_HEADER_TXT"))
        languageTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LANGUAGE_TXT"))
        currencyTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CURRENCY_TXT"))
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        /*if userProfileJson.get("PROVIDER_AVAIL_LOC_CUSTOMIZE") == "Yes" && userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX
        {
            
            self.workLocTxtFieldHeightCons.constant = 50
            self.scrollViewCOntentViewHeight.constant = self.scrollViewCOntentViewHeight.constant + self.workLocTxtFieldHeightCons.constant
            self.PAGE_HEIGHT = self.PAGE_HEIGHT + 80
            self.workLocTxtFiled.isHidden = false
            workLocTxtFiled.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WORKLOCATION"))
            
            if userProfileJson.get("eSelectWorkLocation") == "Fixed"
            {
                 workLocTxtFiled.setText(text: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SPECIFIED_LOCATION"))
                self.selectedWorkLoc = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SPECIFIED_LOCATION")
            }
            else if userProfileJson.get("eSelectWorkLocation") == "Dynamic"
            {
                workLocTxtFiled.setText(text: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ANY_LOCATION"))
                self.selectedWorkLoc = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ANY_LOCATION")
            }
           
           
            workLocTxtFiled.setEnable(isEnabled: false)
            workLocTxtFiled.disableMenu()
            self.workLocTxtFiled.myTxtFieldDelegate = self
            
            workLocationsValue.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SPECIFIED_LOCATION"))
            workLocationsValue.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ANY_LOCATION"))
           
        }*/
        
        fNameTxtField.setText(text: userProfileJson.get("vName"))
        lNameTxtField.setText(text: userProfileJson.get("vLastName"))
        emailTxtField.setText(text: userProfileJson.get("vEmail"))
        countryTxtField.setText(text: "+" + userProfileJson.get("vCode"))
        mobileTxtField.setText(text: userProfileJson.get("vPhone"))
        languageTxtField.setText(text: userProfileJson.get("vLang"))
        currencyTxtField.setText(text: userProfileJson.get("vCurrencyDriver"))
        
        languageTxtField.disableMenu()
        currencyTxtField.disableMenu()
        countryTxtField.disableMenu()
        self.countryTxtField.setEnable(isEnabled: false)
        
        
        languageTxtField.setEnable(isEnabled: false)
        currencyTxtField.setEnable(isEnabled: false)
        self.languageTxtField.myTxtFieldDelegate = self
        self.currencyTxtField.myTxtFieldDelegate = self
        
        if((userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) && userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes"){
            self.PAGE_HEIGHT = self.PAGE_HEIGHT + 80
            serviceDescriptionTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SERVICE_DESCRIPTION"))
            self.serviceDescriptionTxtField.isHidden = false
            self.serviceDescriptionTxtField.setText(text: userProfileJson.get("tProfileDescription"))
        }else{
            self.serviceDescriptionTxtFieldHeight.constant = 0
        }
        
        self.selectedCurrency = userProfileJson.get("vCurrencyDriver")
        
        if(userProfileJson.get("vCode") != ""){
            isCountrySelected = true
            selectedCountryCode = userProfileJson.get("vCountry")
            selectedPhoneCode = userProfileJson.get("vCode")
        }
        
        self.updateBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPDATE"))
        self.updateBtn.clickDelegate = self
        
        print( userProfileJson.get("vImage"))
        userProfilePicBgImgView.sd_setImage(with: URL(string: CommonUtils.user_image_url + GeneralFunctions.getMemberd() + "/" + userProfileJson.get("vImage")), placeholderImage:UIImage(named:"ic_no_pic_user"))
        usrProfileImgView.sd_setImage(with: URL(string: CommonUtils.user_image_url + GeneralFunctions.getMemberd() + "/" + userProfileJson.get("vImage")), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        Utils.createRoundedView(view: usrProfileImgView, borderColor: UIColor.UCAColor.AppThemeTxtColor, borderWidth: 2)
        
        editPicAreaView.backgroundColor = UIColor.white
       
        editPicAreaView.layer.addShadow(opacity: 0.8, radius: 3, UIColor.lightGray)
        editPicAreaView.layer.roundCorners(radius: 17)
        
        GeneralFunctions.setImgTintColor(imgView: editIconImgView, color: UIColor.UCAColor.AppThemeTxtColor_1)
        if(userProfileJson.get("vImage").trim() == ""){
            editIconImgView.image = UIImage(named: "ic_plus")
        }else {
            editIconImgView.image = UIImage(named: "ic_edit")
        }
        
        self.editIconImgView.image = self.editIconImgView.image?.addImagePadding(x: 5, y: 5)
        GeneralFunctions.setImgTintColor(imgView: editIconImgView, color: UIColor.UCAColor.AppThemeColor)
        
        let mobileTf = self.mobileTxtField.getTextField()!
        let emailTf  = self.emailTxtField.getTextField()!

        mobileTf.keyboardType = .numberPad
        emailTf.keyboardType  = .emailAddress

        let plainFields: [MyTextField?] = [fNameTxtField, lNameTxtField, emailTxtField,
                                           serviceDescriptionTxtField]

        for field in plainFields {
            guard let tf = field?.getTextField() else { continue }
            tf.returnKeyType = .done
            tf.enablesReturnKeyAutomatically = false
            tf.addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
        }

        mobileTf.addTarget(self, action: #selector(attachMobileToolbar(_:)), for: .editingDidBegin)
        
        setLanguage()
        
        let userProfileImgTapGue = UITapGestureRecognizer()
        userProfileImgTapGue.addTarget(self, action: #selector(self.profilePicTapped))
        
        self.profilePicViewArea.isUserInteractionEnabled = true
        self.profilePicViewArea.addGestureRecognizer(userProfileImgTapGue)
        
        if self.userProfileJson.get("ENABLE_EDIT_DRIVER_PROFILE").uppercased() == "NO"
        {
            self.fNameTxtField.isEnabled = false
            self.lNameTxtField.isEnabled = false
            
            self.fNameTxtField.cusBGColor = UIColor.lightGray.withAlphaComponent(0.15)
            self.lNameTxtField.cusBGColor = UIColor.lightGray.withAlphaComponent(0.15)
            
        }
        if(self.userProfileJson.get("ENABLE_EDIT_DRIVER_PROFILE").uppercased() == "NO"){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_EDIT_BLOCK_TXT"))
        }

    }
    
    
    @objc func attachMobileToolbar(_ textField: UITextField) {
        if textField.inputAccessoryView == nil {
            textField.inputAccessoryView = makeDoneToolbar()
            textField.reloadInputViews()
        }
    }
    
    @objc func profilePicTapped(){
        
        if self.userProfileJson.get("vImage") != "" && self.userProfileJson.get("ENABLE_EDIT_DRIVER_PROFILE").uppercased() == "NO"
        {
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_PROFILE_DISABLED"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                return

            })

        }else
        {
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isFirstLaunch == true){
            let themeManager = ThemeManager.shared
            let arrowColor = themeManager.isDarkModeActive ? UIColor.white.withAlphaComponent(0.6) : UIColor.black
            
            languageTxtField.addImageView(color: arrowColor, transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)), isCustomImage:true, "ic_arrow_right", 25, 25, nil)
            currencyTxtField.addImageView(color: arrowColor, transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)), isCustomImage:true, "ic_arrow_right", 25, 25, nil)
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.SHOW_COUNTRY_LIST) == true && GeneralFunctions.getValue(key: Utils.SHOW_COUNTRY_LIST)?.uppercased == "YES"){
                countryTxtField.addImageView(color: arrowColor, transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)), isCustomImage:true, "ic_arrow_right", 25, 25, nil)
                self.countryTxtField.myTxtFieldDelegate = self
                
            }
            
            self.countryTxtField.addImgeViewToLeft(color:nil,transform: .identity, isCustomImage: true, "ic_invite_detail", 19,27) { (imageView) in

                if(self.countryPrefixImgView == nil){
                    self.countryPrefixImgView = imageView
                    if(self.userProfileJson.get("vSCountryImage") != ""){
                        self.countryPrefixImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl:self.userProfileJson.get("vSCountryImage") , width: Utils.getValueInPixel(value: 27), height: Utils.getValueInPixel(value: 19))), placeholderImage:nil)
                    }else{
                        self.countryPrefixImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl:GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_IMAGE_KEY) as! String, width: Utils.getValueInPixel(value: 27), height: Utils.getValueInPixel(value: 19))), placeholderImage:nil)
                    }
                }
            }
            
            
            workLocTxtFiled.addImageView(color: arrowColor, transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)), isCustomImage:true, "ic_arrow_right", 25, 25, nil)
            
//            if(containerViewHeight > self.scrollViewCOntentViewHeight.constant){
                self.scrollViewCOntentViewHeight.constant = PAGE_HEIGHT
//            }
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
            
            self.scrollView.bounces = false
            
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            isFirstLaunch = false
        }
        
//        if(self.userProfileJson.get("ENABLE_EDIT_DRIVER_PROFILE").uppercased() == "NO"){
//            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_EDIT_BLOCK_TXT"))
//        }
        
        if(userProfileJson.get("ENABLE_EDIT_DRIVER_PROFILE").uppercased() == "NO"){
            fNameTxtField.setEnable(isEnabled: false)
            lNameTxtField.setEnable(isEnabled: false)
            
        }
        
        // Apply theme after view fully appears
        applyTheme()
    }
    
    func myTxtFieldTapped(sender: MyTextField) {
        if(sender == self.countryTxtField){
            
            let countryListUv = GeneralFunctions.instantiateViewController(pageName: "CountryListUV") as! CountryListUV
            countryListUv.fromEditProfile = true
            
            if(countryListArr != nil){
                countryListUv.countryListArr = countryListArr
            }
           
            countryListUv.modalPresentationStyle = .overCurrentContext
            self.present(countryListUv, animated: true) {
                
            }
            
        }else if(sender == self.currencyTxtField){
            self.openListView = OpenListView(uv: nil, containerView: self.view)
            self.openListView.openNewList = true
            self.openListView.editProfileUV = self
            self.openListView.newListCodeString = self.currencySymboles
            self.openListView.colorArray = self.colorArrayForCurr
            self.openListView.textColorArray = self.colorArrayForTextCurr
            self.openListView.isForCurrency = true
            self.openListView.selectedItem = self.currencyTxtField.text
            self.openListView.show(listObjects: self.currenyList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CURRENCY"), currentInst: self.openListView, handler: { (selectedItemId) in
                
            })
            
        }else if(sender == self.languageTxtField){
            
            self.openListView = OpenListView(uv: nil, containerView: self.view)
            self.openListView.openNewList = true
            self.openListView.editProfileUV = self
            self.openListView.newListCodeString = self.languageCodes
            self.openListView.colorArray = self.colorArrayForLang
            self.openListView.textColorArray = self.colorArrayForTextLang
            self.openListView.selectedItem = self.languageTxtField.text
            self.openListView.show(listObjects: self.languageNameList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_LANGUAGE_HINT_TXT"), currentInst: self.openListView, handler: { (selectedItemId) in
               
            })
            
        }
        else if(sender == self.workLocTxtFiled){
            let openListView = OpenListView(uv: self, containerView: self.view)
            openListView.selectedText = workLocTxtFiled.text
            openListView.show(listObjects: workLocationsValue, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WORKLOCATION"), currentInst: openListView, handler: { (selectedItemId) in
                self.workLocValueChanged(selectedItemId: selectedItemId)
            })
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
            self.scrollViewCOntentViewHeight.constant = self.scrollViewCOntentViewHeight.constant - self.langTxtFieldHeight.constant - 20
            self.langTxtFieldHeight.constant = 0.0
            self.languageTxtField.isHidden = true
        }
        
        setCurrency()
    }
    
    func workLocValueChanged(selectedItemId:Int)
    {
        if workLocationsValue[selectedItemId] == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SPECIFIED_LOCATION")
        {
            self.selectedWorkLoc = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SPECIFIED_LOCATION")
        }
        else if workLocationsValue[selectedItemId] == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ANY_LOCATION")
        {
            self.selectedWorkLoc = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ANY_LOCATION")
        }
        self.workLocTxtFiled.setText(text: self.selectedWorkLoc)
    }
    func lngValueChanged(selectedItemId:Int){
        self.selectedLngCode = self.languageCodes[selectedItemId]
        self.languageTxtField.setText(text: self.languageNameList[selectedItemId])
        
        if(self.openListView != nil){
            self.openListView.bgView.isUserInteractionEnabled = true
            self.openListView.newListView.isUserInteractionEnabled = true
            self.openListView.startLoading = false
            self.openListView.newListView.tableView.reloadData()
            self.openListView.closeNewListView()
        }
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
        
        if(dataArr.count < 2){
            self.scrollViewCOntentViewHeight.constant = self.scrollViewCOntentViewHeight.constant - self.currencyTxtFieldHeight.constant - 20
            self.currencyTxtFieldHeight.constant = 0.0
            self.currencyTxtField.isHidden = true
        }
    }
    
    func currencyValueChanged(selectedItemId:Int){
        
        self.selectedCurrency = self.currenyList[selectedItemId]
        self.currencyTxtField.setText(text: self.selectedCurrency)
    
        self.selectedCurrColor = self.colorArrayForCurr[selectedItemId]
        self.selectedCurrTxtColor = self.colorArrayForTextCurr[selectedItemId]
        self.selectedCurrency = self.currenyList[selectedItemId]
        self.currencyTxtField.setText(text: self.selectedCurrency.uppercased())
        GeneralFunctions.saveValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY, value: self.selectedCurrency as AnyObject)
    
    }
    
    func myBtnTapped(sender: MyButton) {
        _ = generalFunc.getLanguageLabel(origValue: "Password should not contain whitespace.", key: "LBL_ERROR_NO_SPACE_IN_PASS");
        _ = generalFunc.getLanguageLabel(origValue: "Password must be", key: "LBL_ERROR_PASS_LENGTH_PREFIX")
            + " \(Utils.minPasswordLength)"  + generalFunc.getLanguageLabel(origValue: "or more character long.",key: "LBL_ERROR_PASS_LENGTH_SUFFIX");
        
        let mobileInvalid = generalFunc.getLanguageLabel(origValue: "Invalid mobile no.", key: "LBL_INVALID_MOBILE_NO")
        
        let fNameEntered = Utils.checkText(textField: self.fNameTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.fNameTxtField.getTextField()!, error: required_str)
        let lNameEntered = Utils.checkText(textField: self.lNameTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.lNameTxtField.getTextField()!, error: required_str)
        
       let isEmailOptional =  GeneralFunctions.getValue(key: Utils.ENABLE_EMAIL_OPTIONAL)?.uppercased
        var emailValidEntered = false
        let isEmailEntered = Utils.checkText(textField: self.emailTxtField.getTextField()!)
        
        if isEmailOptional == "YES" {
            if isEmailEntered {
                emailValidEntered = Utils.checkText(textField: self.emailTxtField.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.emailTxtField.getTextField()!)) ? true : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR"))) : false
            }
        }else{
            emailValidEntered = Utils.checkText(textField: self.emailTxtField.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.emailTxtField.getTextField()!)) ? true : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR"))) : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: required_str)
        }
//        let mobileEntered = Utils.checkText(textField: self.mobileTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.mobileTxtField.getTextField()!, error: required_str)
        
        let mobileEntered = Utils.checkText(textField: self.mobileTxtField.getTextField()!) ? (Utils.getText(textField: self.mobileTxtField.getTextField()!).count >= Utils.minMobileLength ? true : Utils.setErrorFields(textField: self.mobileTxtField.getTextField()!, error: mobileInvalid)) : Utils.setErrorFields(textField: self.mobileTxtField.getTextField()!, error: required_str)
        
        let countryEntered = isCountrySelected ? true : Utils.setErrorFields(textField: self.countryTxtField.getTextField()!, error: required_str)
        
        if (fNameEntered == false || lNameEntered == false  || mobileEntered == false
            || countryEntered == false) {
            return;
        }
        
        if isEmailOptional == "YES"{
                  if isEmailEntered {
                      if emailValidEntered == false{
                          return;
                      }
                  }
              }else{
                  if(emailValidEntered == false){
                      return;
                  }
              }
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        let vPhoneCode = userProfileJson.get("vCode")
        let vPhone = userProfileJson.get("vPhone")
        
        if let SITE_TYPE = GeneralFunctions.getValue(key: Utils.SITE_TYPE_KEY) as? String{
            if(SITE_TYPE == "Demo" && userProfileJson.get("vEmail") == "driver@gmail.com"){
                self.generalFunc.setError(uv: self, title: "", content: userProfileJson.get("SITE_TYPE_DEMO_MSG"))
                return
            }
        }
        
        if(GeneralFunctions.getValue(key: Utils.MOBILE_VERIFICATION_ENABLE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.MOBILE_VERIFICATION_ENABLE_KEY) as! String).uppercased() == "YES" && (vPhoneCode != self.selectedPhoneCode  || vPhone != Utils.getText(textField: self.mobileTxtField.getTextField()!))){
            
            DispatchQueue.main.async() {
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFY_MOBILE_CONFIRM_MSG"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedId) in
                    
                    if(btnClickedId == 0){
                        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                        accountVerificationUv.mobileNum = self.selectedPhoneCode + Utils.getText(textField: self.mobileTxtField.getTextField()!)
                        accountVerificationUv.isEditProfile = true
                        accountVerificationUv.requestType = "DO_PHONE_VERIFY"
                        self.pushToNavController(uv: accountVerificationUv)
                    }
                })
            }
        }else{
            updateProfile()
        }
    }
    
    func updateProfile(){
        
        if self.selectedWorkLoc == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SPECIFIED_LOCATION")
        {
            self.selectedWorkLoc = "Fixed"
        }
        else if self.selectedWorkLoc == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ANY_LOCATION")
        {
            self.selectedWorkLoc = "Dynamic"
        }
        
        let parameters = ["type":"updateUserProfileDetail","vName": Utils.getText(textField: self.fNameTxtField.getTextField()!), "vLastName": Utils.getText(textField: self.lNameTxtField.getTextField()!), "vEmail": Utils.getText(textField: self.emailTxtField.getTextField()!), "vPhone": Utils.getText(textField: self.mobileTxtField.getTextField()!), "vPhoneCode": self.selectedPhoneCode, "vCountry": self.selectedCountryCode, "vDeviceType": Utils.deviceType, "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "LanguageCode": selectedLngCode, "CurrencyCode": self.selectedCurrency, "tProfileDescription": Utils.getText(textField: self.serviceDescriptionTxtField.getTextField()!), "eSelectWorkLocation": self.selectedWorkLoc]
        
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
                    if self.manageProfileUv != nil {
                    if(self.manageProfileUv.isFromAccountVerifyScreen == true){
                        self.manageProfileUv!.performSegue(withIdentifier: "unwindToAccountVerificationScreen", sender: self.manageProfileUv)
                    }else{
                        self.manageProfileUv!.openViewProfileUv()
                    }
                    }else {
                        Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INFO_UPDATED_TXT"), uv: self)
                        super.closeCurrentScreen()
                    }
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    
    }
    
    @IBAction func unwindToEditProfile(_ segue:UIStoryboardSegue) {
        //        unwindToSignUp
        
        if(segue.source .isKind(of: CountryListUV.self))
        {
            
            let sourceViewController = segue.source as? CountryListUV
            let selectedPhoneCode:String = sourceViewController!.selectedCountryHolder!.vPhoneCode
            let selectedCountryCode = sourceViewController!.selectedCountryHolder!.vCountryCode
            
            self.selectedCountryCode = selectedCountryCode
            self.selectedPhoneCode = selectedPhoneCode
            self.countryPrefixImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl:sourceViewController!.selectedCountryHolder!.vSImage, width: Utils.getValueInPixel(value: 27), height: Utils.getValueInPixel(value: 19))), placeholderImage:nil)

            self.countryTxtField.setText(text: "+" + selectedPhoneCode)
            self.isCountrySelected = true
            self.countryTxtField.getTextField()!.sendActions(for: .editingChanged)
            
        }else if(segue.source.isKind(of: AccountVerificationUV.self)){
            let accountVerificationUv = segue.source as! AccountVerificationUV
            
            if(accountVerificationUv.mobileNumVerified == true){
                updateProfile()
            }
        }
        
    }
    
    func myLableTapped(sender: MyLabel) {
        
    }
}
