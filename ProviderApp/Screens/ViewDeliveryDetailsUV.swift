//
//  ViewDeliveryDetailsUV.swift
//  DriverApp
//
//  Created by ADMIN on 11/07/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class ViewDeliveryDetailsUV: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var senderProfilePicImg: UIImageView!
    @IBOutlet weak var senderHLbl: MyLabel!
    @IBOutlet weak var senderNameLbl: MyLabel!
    @IBOutlet weak var senderMobileLbl: MyLabel!
    @IBOutlet weak var senderCallLbl: MyLabel!
    @IBOutlet weak var senderMsgLbl: MyLabel!
    @IBOutlet weak var senderCallAreaView: UIView!
    @IBOutlet weak var senderMsgAreaView: UIView!
    @IBOutlet weak var senderDetailsAreaView: UIView!
    @IBOutlet weak var senderCallImgView: UIImageView!
    @IBOutlet weak var senderMsgImgView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var receiverHLbl: MyLabel!
    @IBOutlet weak var receiverNameLbl: MyLabel!
    @IBOutlet weak var receiverMobileLbl: MyLabel!
    @IBOutlet weak var receiverCallLbl: MyLabel!
    @IBOutlet weak var receiverMsgLbl: MyLabel!
    @IBOutlet weak var receiverCallAreaView: UIView!
    @IBOutlet weak var receiverMsgAreaView: UIView!
    @IBOutlet weak var receiverDetailsAreaView: UIView!
    @IBOutlet weak var receiverCallImgView: UIImageView!
    @IBOutlet weak var receiverMsgImgView: UIImageView!
    
    @IBOutlet weak var packageDetailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var packageTypeHLbl: MyLabel!
    @IBOutlet weak var packageTypeVLbl: MyLabel!
    @IBOutlet weak var packageDetailsHLbl: MyLabel!
    @IBOutlet weak var packageDetailsVLbl: MyLabel!
    @IBOutlet weak var pickUpInsHLbl: MyLabel!
    @IBOutlet weak var pickUpInsVLbl: MyLabel!
    @IBOutlet weak var deliveryInsHLbl: MyLabel!
    @IBOutlet weak var deliveryInsVLbl: MyLabel!
    @IBOutlet weak var deliveryDetailsAreaView: UIView!
    
    var tripData:NSDictionary!
    var deliveryDetails = NSMutableArray()
    var develiveyData = NSDictionary()
    var PAGE_HEIGHT:CGFloat = 610
    var receiverDetailsHeigh:CGFloat = 0
    var isFirstLaunch = true
    
    var loaderView:UIView!
    
    var cntView:UIView!
    
    let generalFunc = GeneralFunctions()
    
    var dataDict:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cntView = self.generalFunc.loadView(nibName: "ViewDeliveryDetailsScreenDesign", uv: self, contentView: contentView)

        self.scrollView.addSubview(cntView)
        self.scrollView.backgroundColor = UIColor(hex: 0xf2f2f4)
        scrollView.bounces = false
        self.addBackBarBtn()
        setData()
        scrollView.isHidden = true
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }

    override func viewDidAppear(_ animated: Bool) {
        if(isFirstLaunch == true){
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            isFirstLaunch = false
            loadData()
        }
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_DETAILS")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_DETAILS")
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        senderDetailsAreaView.backgroundColor = UIColor.UCAColor.AppThemeColor
        senderCallLbl.textColor = UIColor.UCAColor.AppThemeColor
        receiverCallLbl.textColor = UIColor.UCAColor.AppThemeColor
        receiverMsgLbl.textColor = UIColor.UCAColor.AppThemeColor

        GeneralFunctions.setImgTintColor(imgView: senderCallImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: senderMsgImgView, color: UIColor.UCAColor.AppThemeTxtColor_1)
        GeneralFunctions.setImgTintColor(imgView: receiverCallImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: receiverMsgImgView, color: UIColor.UCAColor.AppThemeColor)

        self.senderHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SENDER")
        self.senderCallLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_TXT")
        self.senderMsgLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MESSAGE_TXT")
        self.receiverHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECIPIENT")
        self.receiverCallLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_TXT")
        self.receiverMsgLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MESSAGE_TXT")
        self.packageTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PACKAGE_TYPE")
        self.packageDetailsHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PACKAGE_DETAILS")
        self.pickUpInsHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICK_UP_INS")
        self.deliveryInsHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_INS")
        if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S {
            senderCallLbl.font = UIFont(name: Fonts().regular, size: 12)!
            senderMsgLbl.font = UIFont(name: Fonts().regular, size: 12)!
        }else{
            senderCallLbl.font = UIFont(name: Fonts().regular, size: 15)!
            senderMsgLbl.font = UIFont(name: Fonts().regular, size: 15)!
        }
    }
    
    func loadData(){
        scrollView.isHidden = true
        if(loaderView != nil){
            loaderView.removeFromSuperview()
        }
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        
        
        let parameters = ["type":"loadDeliveryDetails","UserType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd(), "iTripId": self.tripData!.get("TripId"), "appType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                self.dataDict = dataDict
                if(dataDict.get("Action") == "1"){
                    self.senderProfilePicImg.sd_setImage(with: URL(string: self.dataDict.getObj(Utils.message_str).get("vImage")), placeholderImage:UIImage(named:"ic_no_pic_user"))
                    self.develiveyData = dataDict.getObj(Utils.message_str)
                    self.senderNameLbl.text = self.develiveyData.get("senderName")
                    self.senderMobileLbl.text = self.develiveyData.get("senderMobile")
                    self.receiverNameLbl.text = self.develiveyData.get("vReceiverName")
                    self.receiverMobileLbl.text = self.develiveyData.get("vReceiverMobile")

                    self.packageTypeVLbl.text = self.develiveyData.get("packageType")
                    self.packageTypeVLbl.fitText()
                    self.packageDetailsVLbl.text = self.develiveyData.get("tPackageDetails")
                    self.packageDetailsVLbl.fitText()
                    self.pickUpInsVLbl.text = self.develiveyData.get("tPickUpIns")
                    self.pickUpInsVLbl.fitText()
                    self.deliveryInsVLbl.text = self.develiveyData.get("tDeliveryIns")
                    self.deliveryInsVLbl.fitText()
                    
                    let currentPageHeight = self.PAGE_HEIGHT
                    
                    self.PAGE_HEIGHT = self.PAGE_HEIGHT + (dataDict.getObj(Utils.message_str).get("packageType").height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont(name: Fonts().light, size: 16)!)) - 20
                    
                    self.PAGE_HEIGHT = self.PAGE_HEIGHT + (dataDict.getObj(Utils.message_str).get("tPackageDetails").height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont(name: Fonts().light, size: 16)!)) - 20
                    self.PAGE_HEIGHT = self.PAGE_HEIGHT + (dataDict.getObj(Utils.message_str).get("tPickUpIns").height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont(name: Fonts().light, size: 16)!)) - 20
                    self.PAGE_HEIGHT = self.PAGE_HEIGHT + (dataDict.getObj(Utils.message_str).get("tDeliveryIns").height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont(name: Fonts().light, size: 16)!)) - 20
//                    self.deliveryDetailsAreaView.frame.size = CGSize(width: self.deliveryDetailsAreaView.frame.width, height: self.deliveryDetailsAreaView.frame.height + (self.PAGE_HEIGHT - currentPageHeight))
//                    self.receiverDetailsAreaView.frame.size = CGSize(width: self.receiverDetailsAreaView.frame.width, height: self.receiverDetailsAreaView.frame.height + (self.PAGE_HEIGHT - currentPageHeight))
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
                    self.packageDetailViewHeight.constant = self.deliveryDetailsAreaView.frame.height + (self.PAGE_HEIGHT - currentPageHeight)
                    self.scrollView.isHidden = false
                    let senderCallTapGue = UITapGestureRecognizer()
                    let senderMsgTapGue = UITapGestureRecognizer()
                    let receiverCallTapGue = UITapGestureRecognizer()
                    let receiverMsgTapGue = UITapGestureRecognizer()
                    
                    senderCallTapGue.addTarget(self, action: #selector(self.getMaskedNumber))
                    receiverCallTapGue.addTarget(self, action: #selector(self.callTapped(sender:)))
                    
                    senderMsgTapGue.addTarget(self, action: #selector(self.msgTapped(sender:)))
                    receiverMsgTapGue.addTarget(self, action: #selector(self.msgTapped(sender:)))
                    
                    self.senderCallAreaView.tag = 0
                    self.senderMsgAreaView.tag = 0
                    self.receiverCallAreaView.tag = 1
                    self.receiverMsgAreaView.tag = 1
                    
                    self.senderCallAreaView.isUserInteractionEnabled = true
                    self.senderMsgAreaView.isUserInteractionEnabled = true
                    self.receiverCallAreaView.isUserInteractionEnabled = true
                    self.receiverMsgAreaView.isUserInteractionEnabled = true
                    
                    self.senderCallAreaView.addGestureRecognizer(senderCallTapGue)
                    self.senderMsgAreaView.addGestureRecognizer(senderMsgTapGue)
                    self.receiverCallAreaView.addGestureRecognizer(receiverCallTapGue)
                    self.receiverMsgAreaView.addGestureRecognizer(receiverMsgTapGue)
                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.loadData()
                    })
                }
                
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.loadData()
                })
            }
            
            self.loaderView.isHidden = true
        })
    }

    func callToSender(phoneNumber:String){
        UIApplication.shared.openURL(NSURL(string: ("telprompt:\(phoneNumber)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
    }
    
    @objc func callTapped(sender:UITapGestureRecognizer){
        
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
        if userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
           // if SinchCalling.getInstance().client.isStarted(){
                
                let selfDic = ["Id":"", "Name": "", "PImage": "", "type": ""]
                let assignedDic = ["Id":"", "Name": self.receiverNameLbl.text, "PImage": "", "type": ""]
                SinchCalling.getInstance().makeACall(IDString:"", assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:self.dataDict.getObj(Utils.message_str).get("vReceiverMobileOriginal"))
                return
                
          //  }
        }
        
        var number = ""
        
        if(sender.view!.tag == 0){
            number = self.dataDict.getObj(Utils.message_str).get("senderMobile")
        }else if(sender.view!.tag == 1){
            number = self.dataDict.getObj(Utils.message_str).get("vReceiverMobileOriginal")
        }
        
        UIApplication.shared.openURL(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)

    }
    
    @objc func getMaskedNumber(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
        if userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
                let selfDic = ["Id":userProfileJson.get("iDriverId"), "Name": userProfileJson.get("vName"), "PImage": userProfileJson.get("vImage"), "type": Utils.appUserType]
                let assignedDic = ["Id":self.tripData.get("PassengerId"), "Name": self.tripData.get("PName"), "PImage": self.tripData.get("PPicName"), "type": "Passenger"]
                SinchCalling.getInstance().makeACall(IDString:"Passenger" + "_" + self.tripData.get("PassengerId"), assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:"")
                return
                
            }

        let parameters = ["type":"getCallMaskNumber","iTripid": self.tripData!.get("TripId"), "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.cntView, isOpenLoader: true)
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.callToSender(phoneNumber: dataDict.get(Utils.message_str))
                    }else{
                        self.callToSender(phoneNumber: self.dataDict.getObj(Utils.message_str).get("senderMobile"))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
            })
    }
    
    @objc func msgTapped(sender:UITapGestureRecognizer){
        var number = ""
        if(sender.view!.tag == 0){
            number = self.dataDict.getObj(Utils.message_str).get("senderMobile")
            
            let chatUV = GeneralFunctions.instantiateViewController(pageName: "MessagesViewController") as! MessagesViewController
            chatUV.receiverId = tripData!.get("PassengerId")
            chatUV.receiverDisplayName = self.tripData!.get("PName")
            chatUV.assignedtripId = self.tripData!.get("TripId")
            chatUV.pPicName = self.tripData!.get("PPicName")
//            chatUV.serviceTripType = self.tripData!.get("vServiceTitle")
            chatUV.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.tripData!.get("PRating"))
               chatUV.bookingNo = self.tripData!.get("vRideNo")
            chatUV.assignedtripDate  = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.tripData!.get("tTripRequestDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
            self.pushToNavController(uv:chatUV, isDirect: true)
            
        }else if(sender.view!.tag == 1){
            number = self.dataDict.getObj(Utils.message_str).get("vReceiverMobile")
            UIApplication.shared.openURL(NSURL(string:"sms:\(number)")! as URL)
        }
    }
}
