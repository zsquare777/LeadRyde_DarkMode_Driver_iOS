//
//  WithdrawRequestUV.swift
//  DriverApp
//
//  Created by Admin on 27/07/20.
//  Copyright © 2020 @. All rights reserved.
//

import UIKit
import SwiftExtensionData

class WithdrawRequestUV: UIViewController,MXParallaxHeaderDelegate,MyBtnClickDelegate,UITextFieldDelegate {
    
    //MARK: Outlets -
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parallexHView: UIView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceTitleLbl: MyLabel!
    @IBOutlet weak var balanceValueLbl: MyLabel!
    @IBOutlet weak var withdrawAmtView: UIView!
    @IBOutlet weak var withdrawAmtTitleLbl: MyLabel!
    @IBOutlet weak var withdrawAmtTextField: UITextField!
    @IBOutlet weak var withdrawBalView: UIView!
    @IBOutlet weak var withdrawAmtBalTitelLbl: MyLabel!
    @IBOutlet weak var withdrawAmtBalLbl: MyLabel!
    @IBOutlet weak var nonWithdrawBalView: UIView!
    @IBOutlet weak var nonWithdrawAmtBalTitelLbl: MyLabel!
    @IBOutlet weak var nonWithdrawAmtBalLbl: MyLabel!
    @IBOutlet weak var withdrawbalQueImgView: UIImageView!
    @IBOutlet weak var withdrawBalQueView: UIView!
    @IBOutlet weak var nonWitdrawbalQueImgView: UIImageView!
    @IBOutlet weak var nonWithdrawBalQueView: UIView!
    @IBOutlet weak var accountNumberView: UIView!
    @IBOutlet weak var accountNumberTitelLbl: MyLabel!
    @IBOutlet weak var accountNumberLbl: MyLabel!
    @IBOutlet weak var bankImgView: UIImageView!
    @IBOutlet weak var bankAddImgView: UIImageView!
    @IBOutlet weak var bankContainerView: UIView!
    @IBOutlet weak var needHelpView: UIView!
    @IBOutlet weak var needHelpLbl: MyLabel!
    @IBOutlet weak var sendReqBtn: MyButton!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var faqView: UIView!
    @IBOutlet weak var contactImgView: UIImageView!
    @IBOutlet weak var faqImgView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnAreaBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var withdrawViewHight: NSLayoutConstraint!
    @IBOutlet weak var nonWithdrawViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var accountNuberTitlelblTop: NSLayoutConstraint!
    
    //MARK: Variables -
    var userProfileJson:NSDictionary!
    let generalFunc = GeneralFunctions()
    var cntView:UIView!
    var iphoneXBottomView:UIView!
    var isSafeAreaSet = false
    
    var withdrawableAmt = ""
    var nonWithdrawableAmt = ""
    var memberBalance = ""
    var accountNo = ""
    var origWithdrawableAmt = ""
    var accountDetailsAdded = false
    
    //MARK: View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "WithDrawRequestScreenDesign", uv: self, contentView: contentView)
        self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.cntView.frame.height)
        self.contentView.addSubview(cntView)
        
        self.addBackBarBtn()
        self.setData()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            if(Configurations.isIponeXDevice() || UIDevice().typeApp == .iPhone12Pro || UIDevice().typeApp == .iPhone12ProMax ||  UIDevice().typeApp == .iPhone12 ||  UIDevice().typeApp == .iPhone12Mini || UIDevice().typeApp == .iPhone11 || UIDevice().typeApp == .iPhone11Pro || UIDevice().typeApp == .iPhone11ProMax){
                if(iphoneXBottomView == nil){
                    iphoneXBottomView = UIView()
                    self.view.addSubview(iphoneXBottomView)
                }
                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
                
                self.iphoneXBottomView.frame = CGRect(x: 0, y: self.contentView.frame.maxY - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: GeneralFunctions.getSafeAreaInsets().bottom)
                
                btnAreaBottomMargin.constant = GeneralFunctions.getSafeAreaInsets().bottom
            }
            isSafeAreaSet = true
        }
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WITHDRAW_REQUEST")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WITHDRAW_REQUEST")
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.scrollView.parallaxHeader.delegate = self
        self.scrollView.parallaxHeader.view = self.parallexHView
        self.scrollView.parallaxHeader.mode = .bottom
        self.scrollView.parallaxHeader.height = 220
        self.scrollView.parallaxHeader.minimumHeight = 120
        self.scrollView.bounces = false
        
        self.balanceView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.balanceTitleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.balanceValueLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.withdrawAmtTitleLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.withdrawAmtBalLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.nonWithdrawAmtBalLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.accountNumberLbl.textColor = UIColor.lightGray
        self.bankContainerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.faqView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        self.balanceValueLbl.text = Configurations.convertNumToAppLocal(numStr: self.memberBalance )//self.memberBalance
        self.balanceTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BALANCE")
        self.withdrawAmtTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WITHDRAW_AMT")
        self.nonWithdrawAmtBalTitelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NON_WITHDRAWABLE_BAL")
        self.withdrawAmtBalTitelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WITHDRAWABLE_BAL")
        self.accountNumberTitelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_NUMBER")
        self.needHelpLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NEED_HELP")
        self.sendReqBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_REQUEST"))
        
        self.nonWithdrawBalQueView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.withdrawBalQueView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.withdrawbalQueImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        GeneralFunctions.setImgTintColor(imgView: self.nonWitdrawbalQueImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        
        self.sendReqBtn.clickDelegate = self
        
        self.withdrawAmtView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.withdrawAmtView.layer.roundCorners(radius: 10)
        
        self.withdrawBalView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.withdrawBalView.layer.roundCorners(radius: 10)
        
        self.nonWithdrawBalView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.nonWithdrawBalView.layer.roundCorners(radius: 10)
        
        self.accountNumberView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.accountNumberView.layer.roundCorners(radius: 10)
        
        self.needHelpView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.needHelpView.layer.roundCorners(radius: 12)
        
        self.withdrawBalQueView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.withdrawBalQueView.layer.roundCorners(radius: 10.5)
        
        self.nonWithdrawBalQueView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.nonWithdrawBalQueView.layer.roundCorners(radius: 10.5)
        
        self.bankContainerView.layer.roundCorners(radius: 15)
        GeneralFunctions.setImgTintColor(imgView: bankImgView, color: UIColor.gray)
        GeneralFunctions.setImgTintColor(imgView: contactImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        GeneralFunctions.setImgTintColor(imgView: faqImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        withdrawAmtTextField.layer.cornerRadius = 3.0
        withdrawAmtTextField.masksToBounds = true
        withdrawAmtTextField.delegate = self
        withdrawAmtTextField.borderColor = UIColor.UCAColor.Grey
        
        self.withdrawAmtBalLbl.text = Configurations.convertNumToAppLocal(numStr: self.withdrawableAmt )//self.withdrawableAmt
        self.nonWithdrawAmtBalLbl.text = Configurations.convertNumToAppLocal(numStr: self.nonWithdrawableAmt )////self.nonWithdrawableAmt
        self.accountNumberLbl.text = self.accountNo
        
        if (self.accountNo != "XXXXXXX"){
            self.bankAddImgView.image = UIImage(named: "ic_pf_edit")
            self.accountDetailsAdded = true
        }
        
        GeneralFunctions.setImgTintColor(imgView: bankAddImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        let contactViewTapGue = UITapGestureRecognizer()
        contactViewTapGue.addTarget(self, action: #selector(self.contactViewTapped))
        self.contactView.addGestureRecognizer(contactViewTapGue)
        
        let faqViewTapGue = UITapGestureRecognizer()
        faqViewTapGue.addTarget(self, action: #selector(self.faqViewTapped))
        self.faqView.addGestureRecognizer(faqViewTapGue)
        
        let bankTapGue = UITapGestureRecognizer()
        bankTapGue.addTarget(self, action: #selector(self.bankViewTapped))
        self.bankContainerView.addGestureRecognizer(bankTapGue)
        
        let needHelpViewTapGue = UITapGestureRecognizer()
        needHelpViewTapGue.addTarget(self, action: #selector(self.faqViewTapped))
        self.needHelpView.addGestureRecognizer(needHelpViewTapGue)
        
        let withdrawableHelpViewTapGue = UITapGestureRecognizer()
        withdrawableHelpViewTapGue.addTarget(self, action: #selector(self.withdrawHelpViewTapped))
        self.withdrawBalQueView.addGestureRecognizer(withdrawableHelpViewTapGue)
        
        let nonWithdrawableHelpViewTapGue = UITapGestureRecognizer()
        nonWithdrawableHelpViewTapGue.addTarget(self, action: #selector(self.nonWithdrawHelpViewTapped))
        self.nonWithdrawBalQueView.addGestureRecognizer(nonWithdrawableHelpViewTapGue)
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: 370)
        
        if userProfileJson.get("ENABLE_WALLET_WITHDRAWAL_REQUEST_RESTRICTION").uppercased() == "NO" {
            self.withdrawBalView.isHidden = true
            self.nonWithdrawBalView.isHidden = true
            self.withdrawBalQueView.isHidden = true
            self.nonWithdrawBalQueView.isHidden = true
            self.withdrawAmtBalTitelLbl.isHidden = true
            self.nonWithdrawAmtBalTitelLbl.isHidden = true
            self.nonWithdrawViewHight.constant = 0
            self.withdrawViewHight.constant = 0
            self.scrollView.isScrollEnabled = false
        }else{
            self.accountNuberTitlelblTop.constant = 15
            self.scrollView.isScrollEnabled = true
        }
    }
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        self.parallexHView.layer.borderColor = UIColor.clear.cgColor
        
        if parallaxHeader.progress > 1{
            self.scrollView.scrollToTop()
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.sendReqBtn){
            self.validateData()
        }
    }
    
    @objc func contactViewTapped(){
        let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
        self.pushToNavController(uv: contactUsUv)
    }
    
    @objc func faqViewTapped(){
        let helpUv = GeneralFunctions.instantiateViewController(pageName: "HelpUV") as! HelpUV
        self.pushToNavController(uv: helpUv)
    }
    
    @objc func bankViewTapped(){
        let bankDetailsUV = GeneralFunctions.instantiateViewController(pageName: "BankDetailsUV") as! BankDetailsUV
        bankDetailsUV.isFromWithDrawReq = true
        self.pushToNavController(uv: bankDetailsUV)
    }
    
    @objc func withdrawHelpViewTapped(){
        let openUserPreferences = OpenUserPreferences(uv: self, containerView: Application.window!)
        openUserPreferences.isWithdrawable = true
        openUserPreferences.show(preferenceDescription: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_WITHDRAWABLE_BAL"))
    }
    
    @objc func nonWithdrawHelpViewTapped(){
        let openUserPreferences = OpenUserPreferences(uv: self, containerView: Application.window!)
        openUserPreferences.isNonWithdrawable = true
        openUserPreferences.show(preferenceDescription: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_NON_WITHDRAWABLE_BAL"))
    }
    
    func validateData(){
        let userAvailableBalance = GeneralFunctions.parseDouble(origValue: 0.00, data: self.origWithdrawableAmt)
        let userEnteredAmt = GeneralFunctions.parseDouble(origValue: 0.00, data: withdrawAmtTextField.text!)
        if let text = withdrawAmtTextField.text, text.isEmpty{
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WITHDRAW_AMT_MSG"), uv: self)
            self.withdrawAmtTextField.borderColor = UIColor.UCAColor.red
        }else if userEnteredAmt <= 0{
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WITHDRAW_AMT_ERROR"), uv: self)
        }
        else if (userEnteredAmt > userAvailableBalance){
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTRICT_WITHDRAW_AMT_NOTE"), uv: self)
            self.withdrawAmtTextField.borderColor = UIColor.UCAColor.red
        }
        else if !accountDetailsAdded{
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_NUM_MSG"), uv: self)
        }
        else{
            //api call
            self.sendDetailsToServer()
        }
    }
    
    func sendDetailsToServer(){
        
        let parameters = ["type":"createWithdrawlRequest","iMemberId": GeneralFunctions.getMemberd(), "UserType":Utils.appUserType,"iServiceId":"0","amount":self.withdrawAmtTextField.text!] as [String : String]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.contentView, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    let msgData = dataDict.getObj(Utils.message_str)
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: msgData.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        self.closeCurrentScreen()
                    })
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @IBAction func unwindToWithdrawReq(_ segue:UIStoryboardSegue) {
        if(segue.source.isKind(of: BankDetailsUV.self)){
            let BankDetailsUV = segue.source as! BankDetailsUV
            let accountNo = Utils.getText(textField: BankDetailsUV.accountNumberField.getTextField()!)
            if accountNo != ""{
                self.accountNumberLbl.text = accountNo
                self.bankAddImgView.image = UIImage(named: "ic_pf_edit")
                self.accountDetailsAdded = true
                GeneralFunctions.setImgTintColor(imgView: bankAddImgView, color: UIColor.UCAColor.AppThemeTxtColor)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.withdrawAmtTextField.borderColor = UIColor.UCAColor.Grey
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
