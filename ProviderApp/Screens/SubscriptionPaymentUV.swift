//
//  SubscriptionPaymentUV.swift
//  DriverApp
//
//  Created by Apple on 27/05/19.
//  Copyright © 2019 @. All rights reserved.
//

import UIKit
import SwiftExtensionData

class SubscriptionPaymentUV: UIViewController, MyBtnClickDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var cntView:UIView!
    
    var generalFunc = GeneralFunctions()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var headerDetailLbl: MyLabel!
    @IBOutlet weak var headerViewheight: NSLayoutConstraint!
    @IBOutlet weak var planDetailsH1Lbl: MyLabel!
    @IBOutlet weak var planDetailsH2Lbl: MyLabel!
    @IBOutlet weak var planDetailsSH1Lbl: MyLabel!
    @IBOutlet weak var planDetailsSH2Lbl: MyLabel!
    
    @IBOutlet weak var walletSelectionView: UIView!
    @IBOutlet weak var walletSelCheckBox: BEMCheckBox!
    @IBOutlet weak var walletHLbl: MyLabel!
    @IBOutlet weak var walletAmountLbl: MyLabel!
    @IBOutlet weak var cardSelectionView: UIView!
    @IBOutlet weak var cardSelImgView: UIImageView!
    @IBOutlet weak var cardSelHLbl: MyLabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var subscribeButton: MyButton!
    
    @IBOutlet weak var sCompletedView: UIView!
    @IBOutlet weak var scThanksView: UIView!
    @IBOutlet weak var scTopHLbl: MyLabel!
    @IBOutlet weak var scThanksImgView: UIImageView!
    @IBOutlet weak var scThanksLbl: MyLabel!
    @IBOutlet weak var scDetailsTxt: MyLabel!
    
    var userProfileJson:NSDictionary!
    var planDetails:NSDictionary!
    
    var isCardSelected = false
    var isCardValidate = false
    var isWalletSelected = false
    
    var PAGE_HEIGHT:CGFloat = 400

    var isPageSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackBarBtn()
        
        cntView = self.generalFunc.loadView(nibName: "SubscriptionPaymentScreenDesign", uv: self, contentView: scrollView)
        scrollView.addSubview(cntView)
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clear
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_PAYMENT_METHOD_TXT")
      
        self.contentView.isHidden = true
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        if(isPageSet == false){
            self.setHeaderView()
            self.contentView.isHidden = false
            isPageSet = false
        }
        
    }
    
    func setHeaderView(){
        
        
        let headerDetailLbltxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_PAYMENT_METHOD_DESC_TXT")
        
        GeneralFunctions.setImgTintColor(imgView: self.headerImgView, color: UIColor.UCAColor.AppThemeColor)

        self.headerDetailLbl.text = headerDetailLbltxt
       
        self.headerViewheight.constant = 120 + headerDetailLbltxt.height(withConstrainedWidth: Application.screenSize.width - 40, font:UIFont.init(name: Fonts().regular, size: 17)!)
        
        if(Configurations.isRTLMode()){
            self.planDetailsH1Lbl.text = ":" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_PLAN_NAME")
            self.planDetailsH2Lbl.text = ":" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_PLAN_PRICE_TXT")
        }else{
            self.planDetailsH1Lbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_PLAN_NAME") + ":"
            self.planDetailsH2Lbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_PLAN_PRICE_TXT") + ":"
        }
        
        
        self.planDetailsSH1Lbl.text = self.planDetails.get("vPlanName")
        self.planDetailsSH2Lbl.text = Configurations.convertNumToAppLocal(numStr: self.planDetails.get("fPlanPrice"))
        
        self.walletSelCheckBox.boxType = .square
        self.walletSelCheckBox.offAnimationType = .bounce
        self.walletSelCheckBox.onAnimationType = .bounce
        self.walletSelCheckBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
        self.walletSelCheckBox.onFillColor = UIColor.UCAColor.AppThemeColor
        self.walletSelCheckBox.onTintColor = UIColor.UCAColor.AppThemeColor
        self.walletSelCheckBox.tintColor = UIColor.UCAColor.AppThemeColor
        self.walletSelCheckBox.isUserInteractionEnabled = false
        
        self.walletHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USE_WALLET_BALANCE")
        self.cardSelHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CARD")
        
        self.subscribeButton.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIBE"))
        self.subscribeButton.clickDelegate = self
        self.subscribeButton.bgColor = UIColor.UCAColor.AppThemeColor.lighter()
        self.subscribeButton.backgroundColor = UIColor.UCAColor.AppThemeColor.lighter()
        
        GeneralFunctions.setImgTintColor(imgView: self.cardSelImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.walletAmountLbl.text = Configurations.convertNumToAppLocal(numStr: GeneralFunctions.getValue(key: "user_available_balance") as! String)
        
        
        self.cardSelectionView.setOnClickListener { (Instance) in
            
            if(self.isCardSelected == false){
                self.isCardSelected = true
                self.cardSelImgView.image = UIImage(named:"ic_select_true")
                GeneralFunctions.setImgTintColor(imgView: self.cardSelImgView, color: UIColor.UCAColor.AppThemeColor)
                
            }else{
                self.isCardSelected = false
                self.cardSelImgView.image = UIImage(named:"ic_select_false")
                GeneralFunctions.setImgTintColor(imgView: self.cardSelImgView, color: UIColor.UCAColor.AppThemeColor)
            }
        }
        
        self.walletSelectionView.setOnClickListener { (Instance) in
            
            if(self.isWalletSelected == false){
                self.isWalletSelected = true
                self.walletSelCheckBox.on = true
            }else{
                self.isWalletSelected = false
                self.walletSelCheckBox.on = false
            }
        }
        
        let noteTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_NOTE_TXT") + ": " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPGRADE_NOTE_TXT")
        let attributedText = NSMutableAttributedString(string: noteTxt)
        
        attributedText.addAttributes([ NSAttributedString.Key.font: UIFont(name: Fonts().semibold, size: 15)!], range: self.generalFunc.getRangeOfSubString(subString: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_NOTE_TXT"), fromString: noteTxt))
        let range = (noteTxt as NSString).range(of: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_NOTE_TXT"))
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
        attributedText.addAttributes([ NSAttributedString.Key.font: UIFont(name: Fonts().light, size: 15)!], range: self.generalFunc.getRangeOfSubString(subString: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPGRADE_NOTE_TXT"), fromString: noteTxt))
        
        
        let height = noteTxt.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 15)!)
        self.noteLbl.attributedText = attributedText
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT + height + 50)
        
        self.checkPaymentFlow()
       
    }

    func setSubCompletedView() {
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        
        self.scrollView.scrollToTop()
        self.scrollView.isScrollEnabled = false
        
        self.contentViewBottomSpace.constant = 0 - GeneralFunctions.getSafeAreaInsets().bottom
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIBED_TXT")
        self.sCompletedView.isHidden = false
        
        let colorTop =  UIColor.UCAColor.AppThemeColor.lighter()
        let colorBottom = UIColor.UCAColor.AppThemeColor.darker()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop!.cgColor, colorBottom!.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.sCompletedView.bounds
        
        self.sCompletedView.backgroundColor = colorBottom
        self.sCompletedView.layer.insertSublayer(gradientLayer, at:0)
        
        let gradientLayer2:CAGradientLayer = CAGradientLayer()
        gradientLayer2.frame.size = self.scThanksView.frame.size
        gradientLayer2.cornerRadius = 130
        gradientLayer2.zPosition = -1
        gradientLayer2.colors = [colorBottom!.cgColor, colorTop!.cgColor]
        gradientLayer2.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer2.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.scThanksView.backgroundColor = colorBottom
        scThanksView.layer.addSublayer(gradientLayer2)
        self.scThanksView.clipsToBounds = true
        
        GeneralFunctions.setImgTintColor(imgView: self.scThanksImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.scTopHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.scThanksLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.scDetailsTxt.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.scTopHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TAP_TO_GOBACK_TXT")
        self.scThanksLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIBED_THANK_YOU_TXT")
        self.scDetailsTxt.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIBED_DESCRIPTION_TXT")
        
        self.sCompletedView.setOnClickListener { (Instance) in
            GeneralFunctions.saveValue(key: Utils.IS_WALLET_AMOUNT_UPDATE_KEY, value: "true" as AnyObject)
            self.performSegue(withIdentifier: "unwindToSubscriptionUV", sender: self)
        }
        
        self.perform(#selector(setSubCompletedGesture), with: self, afterDelay: 10.0)
        
    }
    
    @objc func setSubCompletedGesture(){
        GeneralFunctions.saveValue(key: Utils.IS_WALLET_AMOUNT_UPDATE_KEY, value: "true" as AnyObject)
        self.performSegue(withIdentifier: "unwindToSubscriptionUV", sender: self)
    }
    
    func checkPaymentFlow(){
        
        if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "1"){
            
            if (userProfileJson.get("APP_PAYMENT_MODE") == "Cash-Card" || userProfileJson.get("APP_PAYMENT_MODE") == "Card"){
                self.cardSelectionView.isHidden = false
            }else{
                self.cardSelectionView.isHidden = true
            }
        }else if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2"){
            self.cardSelectionView.isHidden = true
        }
    }
    
    func callSubscribe(_ isUpgrade:Bool = false){
        
        var parameters = ["type": "SubscribePlan", "UserType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd(), "isCard": self.isCardSelected ? "Yes" : "No", "isWallet": self.isWalletSelected ? "Yes" : "No", "iDriverSubscriptionPlanId":self.planDetails.get("iDriverSubscriptionPlanId")]
        
        if(isUpgrade == true){
            parameters["isUpgrade"] = isUpgrade == true ? "Yes" : "No"
        }
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    if(dataDict.get("isUpgrade").uppercased() == "YES"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPGRADE_PLANS"), positiveBtn:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: {(btnClickedId) in
                            
                            if(btnClickedId == 0){
                                self.callSubscribe(true)
                            }
                        })
                        return
                    }
                   
                    if(dataDict.get("message") == "LBL_SUBSCRIBED_SUCCESFULLY_TXT"){
                        
                        self.updateWalletAmount()
                        
                    }
                    
                }else{
                    
                    if(dataDict.get("message") == "LBL_LOW_WALLET_BAL_NOTE"){
                        
                        let openMinAmountReqView = OpenMinAmountReqView(uv: self, containerView: self.contentView)
                        openMinAmountReqView.fromSubscriptionPay = true
                        openMinAmountReqView.setHandler(handler: { (isSkipped, isOpenWallet, view, bgView) in
                            if(isOpenWallet == true){
                                if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() == "CASH"){
                                    let contactUsUV = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                    self.pushToNavController(uv: contactUsUV)
                                }else{
                                    let manageWalletUv = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    self.pushToNavController(uv: manageWalletUv)
                                }
                            }
                        })
                        openMinAmountReqView.show(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BAL_NOTE"))
                        return
                    }
                    
                    if dataDict.get("message") != ""{
                        self.generalFunc.setError(uv: self, title: "", content: dataDict.get("message"))
                        return
                    }
                    
                    self.generalFunc.setError(uv: self)
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
        })
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
                    self.setSubCompletedView()
                }else{
                   self.setSubCompletedView()
                }
                
            }else{
                
               self.setSubCompletedView()
               //self.updateWalletAmount()
            }
        })
    }
    
    
    func checkCardConfig(){
        if(GeneralFunctions.isUserCardExist(userProfileJson: self.userProfileJson)){
            showPaymentBox()
        }else{
            let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
            self.pushToNavController(uv: paymentUV)
        }
    }
    
    func showPaymentBox(){
        
        
        let openConfirmCardView = OpenConfirmCardView(uv: self, containerView: self.view)
        
        openConfirmCardView.iUserProfileId = ""
        openConfirmCardView.iOrganizationId = ""
        openConfirmCardView.vProfileEmail = ""
        openConfirmCardView.ePaymentBy = ""
        
        openConfirmCardView.show(checkCardMode: "") { (isCheckCardSuccess, dataDict) in
            self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            
            self.isCardValidate = true
            self.myBtnTapped(sender: self.subscribeButton)
        }
        
    }
    
    func myBtnTapped(sender: MyButton) {
        
        if(self.isWalletSelected == false && self.isCardSelected == false){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_SELECT_PAYMENT_METHOD_DESC_TXT"))
            return
        }
        
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "1" && self.isCardSelected == true && self.isCardValidate == false){
            
            self.checkCardConfig()
        }else{
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENABLE_SUBSCRIPTION_NOTE"), positiveBtn:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: {(btnClickedId) in
                
                if(btnClickedId == 0){
                     self.callSubscribe()
                }
            })
           
        }
      
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
