//
//  ViewDeliveryDetailsUV.swift
//  DriverApp
//
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class ViewMultiDeliveryDetailsUV: UIViewController, UITableViewDataSource, UITableViewDelegate,OnLocationUpdateDelegate,OnTripCanceledDelegate,YPSignatureDelegate,MyBtnClickDelegate, OTPDelegate, MyTxtFieldOnTextChangeDelegate
{
    
    @IBOutlet weak var profileChatImgView: UIImageView!
    @IBOutlet weak var profileCallImgView: UIImageView!
    @IBOutlet weak var profileCallLbl: MyLabel!
    @IBOutlet weak var profileChatLbl: MyLabel!
    
    @IBOutlet weak var profileMobVLbl: UILabel!
    @IBOutlet weak var profileSenderVLbl: UILabel!
    @IBOutlet weak var usrProfileImgView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    @IBOutlet weak var tableViewTopSpacePriority: NSLayoutConstraint!
    @IBOutlet weak var headerPIcAreaView: UIView!
    @IBOutlet weak var packageTypeHLbl: MyLabel!
    @IBOutlet weak var packageTypeVLbl: MyLabel!
    @IBOutlet weak var packageDetailsHLbl: MyLabel!
    @IBOutlet weak var packageDetailsVLbl: MyLabel!
    @IBOutlet weak var pickUpInsHLbl: MyLabel!
    @IBOutlet weak var pickUpInsVLbl: MyLabel!
    @IBOutlet weak var deliveryInsHLbl: MyLabel!
    @IBOutlet weak var deliveryInsVLbl: MyLabel!
    @IBOutlet weak var deliveryDetailsAreaView: UIView!
    
    @IBOutlet weak var paymentAreaView: UIView!
    @IBOutlet weak var picsAreaView: UIView!
    @IBOutlet weak var paymenTypeHLbl: MyLabel!
    @IBOutlet weak var paymentTypeVLbl: MyLabel!
    @IBOutlet weak var paymenByHLbl: MyLabel!
    @IBOutlet weak var paymentByVLbl: MyLabel!
    @IBOutlet weak var totalHLbl: MyLabel!
    @IBOutlet weak var totalVLbl: MyLabel!
    @IBOutlet weak var profilaAeaBottom: NSLayoutConstraint!
    
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var fareTotalView: UIView!
    @IBOutlet weak var payableAountView: UIView!
    @IBOutlet weak var payableHLbl: MyLabel!
    @IBOutlet weak var payableVLbl: MyLabel!
    @IBOutlet weak var fareDetailImg: UIImageView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    
    var moreVideHideStatusList = [Bool]()
    var endTripStatusList = [Bool]()
    
    var signatureDisplayView:UIView!
    var signatureDisplayBGView:UIView!
    
    var tripData = NSMutableDictionary()
    var memberData = NSMutableDictionary()
    
    var PAGE_HEIGHT:CGFloat = 610
    
    var isFirstLaunch = true
    
    var loaderView:UIView!
    
    var cntView:UIView!
    
    let generalFunc = GeneralFunctions()
    
    var dataDict:NSDictionary!
    
    var deliveryDetails = NSMutableArray()
    var paymnetBySender = false
    var count = 0
    
    var loadFromDriverArrived = false
    var loadAsMainView = false
    var activeTripUV:ActiveTripUV!
    var getLocation:GetLocation!
    var currentLocation:CLLocation!
    
    var currentRunningTripId:String!
    var driverArrivedUV:DriverArrivedUV!
    var iTripDeliveryLocationId = ""
    var vCode = ""
    var payResName = ""
    var fare = ""
    var cabBookingReqId = ""
    var isLoadFromEndTRip = false
    var endTripVerMethod = "Signature"
    var serviceImage:UIImage!
    var checkProofFor = "Sender"
    var rowCount = 0
    var receiverDetailsHeight = [Double]()
    var receiverDetailsFinalHeight = [Double]()
    var payType = ""
    var indivFare = ""
    var vehType = ""
    var isFromCabRequest = false
    var fareDetailsArray = [NSDictionary]()
    var fareDetailsViewForMulti:FareDetailsViewForMulti!
    var bgView:UIView!
    
    // SERVICE OTP CONFIRMATION
    var jobOTPVerificationView:JobOTPVerificationView!
    var bgViewOTP:UIView!
    var isKeyboardOpen = false
    var isOTPVerificationDone = false
    var otp_str = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "ViewMultiDeliveryDetailsScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        picsAreaView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: profileCallImgView    , color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: profileChatImgView    , color: UIColor.white)
        profileChatLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MESSAGE_TXT").uppercased()
        profileCallLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_TXT").uppercased()
        self.contentView.isHidden = true
        for _ in 0..<5
        {
            self.moreVideHideStatusList.append(false)
            self.endTripStatusList.append(false)
        }
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        vCode = userProfileJson.get("vCode")
        if cabBookingReqId != "" {
            self.tableViewTopSpacePriority.constant = (-self.headerPIcAreaView.bounds.size.height) + 5
            self.headerPIcAreaView.isHidden = true
        }
        setData()
        
        
        //        senderDetailsAreaView.layer.shadowOpacity = 0.5
        //        senderDetailsAreaView.layer.shadowOffset = CGSize(width: 0, height: 3)
        //        senderDetailsAreaView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        //
        //        receiverDetailsAreaView.layer.shadowOpacity = 0.5
        //        receiverDetailsAreaView.layer.shadowOffset = CGSize(width: 0, height: 3)
        //        receiverDetailsAreaView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        //
        //        deliveryDetailsAreaView.layer.shadowOpacity = 0.5
        //        deliveryDetailsAreaView.layer.shadowOffset = CGSize(width: 0, height: 3)
        //        deliveryDetailsAreaView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        //
        //        GeneralFunctions.setImgTintColor(imgView: senderCallImgView, color: UIColor(hex: 0x272727))
        //        GeneralFunctions.setImgTintColor(imgView: senderMsgImgView, color: UIColor(hex: 0x272727))
        //        GeneralFunctions.setImgTintColor(imgView: receiverCallImgView, color: UIColor(hex: 0x272727))
        //        GeneralFunctions.setImgTintColor(imgView: receiverMsgImgView, color: UIColor(hex: 0x272727))
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {}
        
        self.tableView.register(UINib(nibName: "ViewDeliveryDetailCell", bundle: nil), forCellReuseIdentifier: "ViewDeliveryDetailCell")
        
        self.getLocation = GetLocation(uv: self, isContinuous: true)
        self.getLocation.buildLocManager(locationUpdateDelegate: self)
        if self.isLoadFromEndTRip == true
        {
            
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFICATION_PAGE_HEADER")
            self.tableView.isScrollEnabled = false
        }
        self.scrollView.isScrollEnabled = true
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(isFirstLaunch == true){
            
            isFirstLaunch = false
            chatView.isHidden = true
            callView.isHidden = true
            profileMobVLbl.isHidden = true
            if cabBookingReqId == "" || self.isLoadFromEndTRip == true
            {
                    chatView.isHidden = false
                    callView.isHidden = false
                    profileMobVLbl.isHidden = false
            }
            
            loadDeliveryData()
            callView.setOnClickListener { (view) in
                self.profileCallTapped()
            }
            
            chatView.setOnClickListener { (view) in
                self.profileChatTapped()
            }
        }
    }
    
    func getMaskedNumber(number:String){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
        if userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
            //if SinchCalling.getInstance().client.isStarted(){
            
            let selfDic = ["Id":userProfileJson.get("iDriverId"), "Name": userProfileJson.get("vName"), "PImage": userProfileJson.get("vImage"), "type": Utils.appUserType]
            let assignedDic = ["Id":self.tripData.get("PassengerId"), "Name": self.tripData.get("PName"), "PImage": self.tripData.get("PPicName"), "type":"Passenger"]
            SinchCalling.getInstance().makeACall(IDString:"Passenger" + "_" + self.tripData.get("PassengerId"), assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:"")
            return
            
            // }
        }
        
        //if(userProfileJson.get("CALLMASKING_ENABLED").uppercased() == "YES"){
        let parameters = ["type":"getCallMaskNumber","iTripid": self.tripData.get("TripId"), "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    UIApplication.shared.openURL(NSURL(string:"telprompt:" + dataDict.get(Utils.message_str))! as URL)
                    
                }else{
                    
                    UIApplication.shared.openURL(NSURL(string:"telprompt:+" + number)! as URL)
                    
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        // }else{
        //      UIApplication.shared.openURL(NSURL(string:"telprompt:+" + number)! as URL)
        //  }
        
    }
    
    @objc func profileCallTapped() {
        
        self.getMaskedNumber(number:self.memberData.get("vCode") + self.memberData.get("vOrgMobile"))
    }
    
    @objc func profileChatTapped() {
        
        let chatUV = GeneralFunctions.instantiateViewController(pageName: "MessagesViewController") as! MessagesViewController
        chatUV.receiverId = tripData.get("PassengerId")
        chatUV.receiverDisplayName = self.tripData.get("PName")
        chatUV.assignedtripId = self.tripData.get("TripId")
        chatUV.pPicName = self.tripData.get("PPicName")
//        chatUV.serviceTripType = self.tripData.get("vServiceTitle")
        chatUV.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.tripData.get("PRating"))
           chatUV.bookingNo = self.tripData.get("vRideNo")
        chatUV.assignedtripDate  = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.tripData.get("tTripRequestDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
        self.pushToNavController(uv:chatUV, isDirect: true)
        
    }
    
    func onLocationUpdate(location: CLLocation) {
        
        self.currentLocation = location
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_DETAILS")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_DETAILS")
        
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
            senderMsgLbl.font = UIFont(name: Fonts().regular, size: 13)!
        }
        
    }
    
    func LoadPaymenDetail () {
        if self.fareDetailsArray.count > 0
        {
            fareDetailImg.isHidden = false
        }else
        {
            fareDetailImg.isHidden = true
        }
        
        fareDetailImg.image = UIImage(named:"ic_Lmenu_help")
        GeneralFunctions.setImgTintColor(imgView: fareDetailImg, color: .black)
       fareDetailImg.isUserInteractionEnabled = true
        fareDetailImg.setOnClickListener { (imgView) in
                self.fareDetailTapped()
        }
        
        if(Configurations.isRTLMode()){
            self.paymenTypeHLbl.text  = ":" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT_TYPE_TXT")
            self.paymenByHLbl.text = ":" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_PAY_BY_TXT")
            self.totalHLbl.text = ":" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Total_Fare")
            self.payableHLbl.text = ":" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_PAYBALE_AMOUNT")
        }else{
            self.paymenTypeHLbl.text  = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT_TYPE_TXT") + ":"
            self.paymenByHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_PAY_BY_TXT") + ":"
            self.totalHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Total_Fare") + ":"
            self.payableHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_PAYBALE_AMOUNT") + ":"
        }
        
        if cabBookingReqId == ""
        {
            paymentTypeVLbl.text = self.memberData.get("vTripPaymentMode")
        }
        else
        {
            paymentTypeVLbl.text = self.memberData.get("ePayType")
        }
        
        paymentByVLbl.text = self.payResName
        totalVLbl.text = self.fare
        profilaAeaBottom.constant = -(paymentAreaView.bounds.height/2)
        
    }
    
    func loadDeliveryData(){
        
        let parameters = ["type":"getTripDeliveryDetails","iCabBookingId": "", "iTripId": self.tripData.get("TripId"),"userType": Utils.appUserType, "iCabRequestId":cabBookingReqId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.contentView.alpha = 0
            self.contentView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.contentView.alpha = 1
            }, completion: {
                finished in
                self.contentView.isHidden = false
            })
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    if dataDict.object(forKey: "FareDetailsNewArr") != nil
                    {
                        self.fareDetailsArray = dataDict.getArrObj("FareDetailsNewArr") as! [NSDictionary]
                        self.vehType =  dataDict.get("carTypeName")
                        print(self.fareDetailsArray)
                    }
                    
                    if dataDict.get("ePaymentBySender") == "Yes"
                    {
                        self.paymnetBySender = true
                    }
                    
                    if self.checkProofFor == "Sender"
                    {
                        
                        self.endTripVerMethod = "Signature"
                    }
                    else
                    {
                        self.rowCount = 2
                        self.endTripVerMethod = dataDict.get("DELIVERY_VERIFICATION_METHOD")
                    }
                    
                    self.payType = dataDict.get("ePaymentBy")
                    self.indivFare = dataDict.get("Fare_Payable")
                    
                    self.payResName = dataDict.get("PaymentPerson")
                    
                    self.fare = dataDict.get("DriverPaymentAmount")
                    self.payableVLbl.text = dataDict.get("Fare_Payable")
                    
                    self.deliveryDetails = (dataDict.value(forKey: "message") as! NSDictionary).getArrObj("Deliveries") as! NSMutableArray
                    
                    self.memberData = (dataDict.value(forKey: "message") as! NSDictionary).getObj("MemberDetails") as! NSMutableDictionary
                    self.currentRunningTripId = (dataDict.value(forKey: "message") as! NSDictionary).get("onGoingTripLocationId")
                    if dataDict.get("ePaymentBy") == "Individual" {
                        self.payableAountView.isHidden = false
                    }
                    
//                    if self.cabBookingReqId == ""
//                    {
                        self.usrProfileImgView.sd_setImage(with: URL(string: CommonUtils.passenger_image_url + self.memberData.get("iUserId") + "/" + self.memberData.get("vImage")), placeholderImage:UIImage(named:"ic_no_pic_user"))

                        Utils.createRoundedView(view: self.usrProfileImgView, borderColor: .white, borderWidth: 2)
                        self.profileSenderVLbl.text = self.memberData.get("vName")
                        self.profileMobVLbl.text = "+" + self.memberData.get("vCode") + self.memberData.get("vMobile")
//                    }
                    if self.isLoadFromEndTRip == true
                    {
                        self.navigationItem.setHidesBackButton(true, animated: false)
                    }
                    else
                    {
                        if self.loadAsMainView == false || self.currentRunningTripId != ""
                        {
                            self.navigationItem.setHidesBackButton(false, animated: false)
                            UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
                            UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
                            
                            let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nav_bar_back")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.closeViewDeatilScreen))
                            self.navigationItem.leftBarButtonItem = leftButton;
                        }
                        else
                        {
                            self.navigationItem.setHidesBackButton(true, animated: false)
                        }
                    }
                    
                    print(self.deliveryDetails)
                    // self.loadData()
                    
                    for _ in 0..<self.deliveryDetails.count
                    {
                        self.moreVideHideStatusList.append(false)
                        self.endTripStatusList.append(false)
                    }
                    
                    var tripPending = true
                    for i in 0..<self.deliveryDetails.count
                    {
                        let array = self.deliveryDetails[i] as! NSMutableArray
                        let item = array[array.count - 1] as! NSDictionary
                        let iActive = item.get("iActive")
                        
                        if (iActive == "Finished" || iActive == "Canceled")
                        {
                            tripPending = false
                        }
                        else{
                            tripPending = true
                            break
                        }
                    }
                    self.LoadPaymenDetail ()
                    self.tableView.reloadData()
                    if self.cabBookingReqId != "" {
                        self.tableViewTopSpacePriority.constant = (-self.headerPIcAreaView.bounds.size.height) + 5
                        self.headerPIcAreaView.isHidden = true
                    }
                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                        
                        if btnClickedIndex == 0
                        {
                            self.loadDeliveryData()
                        }else
                        {
                            self.closeCurrentScreen()
                        }
                    })
                }
                
            }else{
                self.loadDeliveryData()
            }
        })
    }
    
    @objc func closeViewDeatilScreen()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func fareDetailTapped()
    {
        if fareDetailsViewForMulti == nil
        {
            let width = Application.screenSize.width - 40
            fareDetailsViewForMulti = FareDetailsViewForMulti(frame: CGRect(x:(self.contentView.frame.size.width - 300)/2, y:(self.contentView.frame.size.height - 340) / 2, width: width, height: 320))
            fareDetailsViewForMulti.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)

            bgView = UIView()
            bgView.frame = self.contentView.frame
            fareDetailsViewForMulti.backgroundColor = UIColor.white
            fareDetailsViewForMulti.cornerRadius = 20
            fareDetailsViewForMulti.masksToBounds = true
            bgView.backgroundColor = UIColor.black
            
            self.contentView.addSubview(bgView)
            self.contentView.addSubview(fareDetailsViewForMulti)
            
            bgView.alpha = 0
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self.bgView.alpha = 0.4
            })
            
            fareDetailsViewForMulti.headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FARE_DETAILS")
            fareDetailsViewForMulti.cancelBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OK"))
            
            var currentYposition:CGFloat = 0
            
            var totalSeperatorViews = 0
            _ = 1
            for i in 0..<self.fareDetailsArray.count + 1 {
                
                if(i == 0)
                {
                    let lbl = UILabel.init(frame: CGRect(x:0, y:currentYposition, width: width, height: 40))
                    
                    lbl.textAlignment = .center
                    lbl.font = UIFont.boldSystemFont(ofSize: 16)
                    lbl.textColor = UIColor.UCAColor.blackColor
                    lbl.text = self.vehType
                    fareDetailsViewForMulti.scrollView.backgroundColor = .clear
                    fareDetailsViewForMulti.scrollView.addSubview(lbl)
                    
                    currentYposition = currentYposition + 40
                    
                    
                }else{
                    let dict_temp = self.fareDetailsArray[i - 1]
                    for (key, value) in dict_temp {
                        
                        _ = self.fareDetailsViewForMulti.scrollView.subviews.count
                        
                        if((key as! String) == "eDisplaySeperator"){
                            let viewWidth = width
                            let viewCus = UIView(frame: CGRect(x:0, y: CGFloat(currentYposition), width: viewWidth, height: 0.7))
                            viewCus.backgroundColor = UIColor(hex: 0xdedede).withAlphaComponent(0.7)
                            self.fareDetailsViewForMulti.scrollView.addSubview(viewCus)
                            
                            totalSeperatorViews = totalSeperatorViews + 1
                            currentYposition = currentYposition + 1
                        }else{
                            let viewWidth = width
                            let viewCus = UIView(frame: CGRect(x: 0, y: CGFloat(currentYposition), width: viewWidth, height: 40))
                            let titleStr = Configurations.convertNumToAppLocal(numStr: key as! String)
                            let valueStr = Configurations.convertNumToAppLocal(numStr: value as! String)
                            let font = UIFont(name: Fonts().light, size: 16)!
                            var widthOfTitle = titleStr.width(withConstrainedHeight: 40, font: font) + 15
                            var widthOfvalue = valueStr.width(withConstrainedHeight: 40, font: font) + 15
                            if(widthOfTitle > ((viewWidth * 20) / 100) && widthOfvalue > ((viewWidth * 80) / 100)){
                                widthOfvalue = ((viewWidth * 80) / 100)
                                widthOfTitle = ((viewWidth * 20) / 100)
                            }else if(widthOfTitle < ((viewWidth * 20) / 100) && widthOfvalue > ((viewWidth * 80) / 100) && (viewWidth - widthOfTitle - widthOfvalue) < 0){
                                widthOfvalue = viewWidth - widthOfTitle
                            }
                            
                            let widthOfParentView = viewWidth - widthOfvalue
                            
                            var lblTitle = MyLabel(frame: CGRect(x: 0, y: 0, width: widthOfParentView - 5, height: 40))
                            var lblValue = MyLabel(frame: CGRect(x: widthOfParentView, y: 0, width: widthOfvalue, height: 40))
                            
                            if(Configurations.isRTLMode()){
                                lblTitle = MyLabel(frame: CGRect(x: widthOfvalue + 5, y: 0, width: widthOfParentView, height: 40))
                                lblValue = MyLabel(frame: CGRect(x: 0, y: 0, width: widthOfvalue, height: 40))
                                
                                lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
                                lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                            }else{
                                lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                                lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
                            }
                            
                            lblTitle.textColor = UIColor(hex: 0x272727)
                            lblValue.textColor = UIColor(hex: 0x272727)

                            if i == self.fareDetailsArray.count {
                                let fonts = UIFont.boldSystemFont(ofSize: 15)
                                lblTitle.font = fonts
                                lblValue.font = fonts
                                lblTitle.textColor = UIColor.UCAColor.blackColor
                                lblValue.textColor = UIColor.UCAColor.AppThemeColor
                            }else {
                                lblTitle.font = font
                                lblValue.font = font
                            }
                            lblTitle.numberOfLines = 2
                            lblValue.numberOfLines = 2
                            
                            lblTitle.minimumScaleFactor = 0.5
                            lblValue.minimumScaleFactor = 0.5
                            
                            lblTitle.text = titleStr
                            lblValue.text = valueStr
                            
                            viewCus.addSubview(lblTitle)
                            viewCus.addSubview(lblValue)
                            
                            self.fareDetailsViewForMulti.scrollView.addSubview(viewCus)
                            currentYposition = currentYposition + 40
                            if(Configurations.isRTLMode()){
                                lblValue.textAlignment = .left
                            }else{
                                lblValue.textAlignment = .right
                            }
                        }
                    }
                }
                
            }
            
            fareDetailsViewForMulti.scrollView.contentSize = CGSize(fareDetailsViewForMulti.scrollView.frame.width,  currentYposition)
            //        chargesContainerView.frame.size = CGSize(width: chargesContainerView.frame.width, height: CGFloat((55 * HistoryFareDetailsNewArr.count)))
            
            //        self.chargesParentView.frame.size = CGSize(width: chargesParentView.frame.width, height: chargesParentView.frame.height + chargesContainerView.frame.height - 50)
            
            fareDetailsViewForMulti.cancelBtn.clickDelegate = self
        }else
        {
            fareDetailsViewForMulti.isHidden = false
            bgView.isHidden = false
        }
        
    }
    
    func myBtnTapped(sender:MyButton)
    {
        if(self.fareDetailsViewForMulti != nil){
            fareDetailsViewForMulti.isHidden = true
            bgView.isHidden = true
        }
        
        if(self.jobOTPVerificationView != nil && sender == self.jobOTPVerificationView.submitOTPBtn){
      
            if(GeneralFunctions.getRandomSecCode(code: self.otp_str) == self.tripData.get("vText"))
            {
                self.closeOTPView()
                self.isOTPVerificationDone = true
                self.submitProofOfDataForSignature(tag: self.jobOTPVerificationView.tag)
                self.jobOTPVerificationView.otpStackView.setAllFieldColor(color: UIColor.UCAColor.AppThemeColor)
            }else{
                self.jobOTPVerificationView.otpStackView.setAllFieldColor(color: UIColor.UCAColor.red)
                self.jobOTPVerificationView.errorLbl.isHidden = false
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if self.loadFromDriverArrived == true
        {
            return 1
        }
        else
        {
            if self.rowCount != 0
            {
                return 1
            }else  if self.isLoadFromEndTRip == true &&   self.deliveryDetails.count > 0{
                return 1
            }
            else{
                return self.deliveryDetails.count
            }
            //  + 1 for sender view
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDeliveryDetailCell") as! ViewDeliveryDetailCell
        
        cell.callLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_TXT").uppercased()
        cell.messageLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MESSAGE_TXT").uppercased()
        cell.callLbl.textColor = UIColor.UCAColor.AppThemeColor
        cell.messageLbl.textColor = UIColor.UCAColor.AppThemeColor
        cell.finishedStatusLbl.isHidden = false
        cell.viewSignatureLabel.isHidden = true
        cell.callView.backgroundColor = UIColor.white
        cell.messageView.backgroundColor = UIColor.white
        cell.viewSignatureLabel.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_SIGN_TXT")
        GeneralFunctions.setImgTintColor(imgView: cell.ic_messageImgView, color: UIColor.black)
        if indexPath.row > 1 && self.isLoadFromEndTRip == true
        {
            
            cell.leadingSpace.constant = 15
            cell.trailingSpace.constant = 15
            cell.ypSignatureImgView.delegate = self
            cell.mainStackView.isHidden = true
            cell.mainCallMessView.isHidden = true
            cell.respForPayReci.isHidden = true
            cell.tripLineView.isHidden = true
            cell.checkImgView.isHidden = true
            cell.deliveryCountLbl.isHidden = true
            cell.receiverHeaderLbl.isHidden = true
            cell.cardView.layer.borderWidth = 0
            cell.cardView.backgroundColor = UIColor.clear
        }
        else
        {
            if self.isLoadFromEndTRip == true{
                
                cell.deliveryCodehLbl.isHidden = true
                cell.deliveryCodeTxtFiled.isHidden = true
                cell.topSpace.constant = 0
                cell.leadingSpace.constant = 15
                cell.trailingSpace.constant = 15
                cell.ypSignatureImgView.delegate = self
                cell.signatureView.isHidden = false
                cell.mainStackView.isHidden = true
                cell.mainCallMessView.isHidden = true
                cell.respForPayReci.isHidden = true
                cell.tripLineView.isHidden = true
                cell.checkImgView.isHidden = true
                cell.receiverHeaderLbl.isHidden = true
                
                cell.deliveryCountLbl.isHidden = true
                cell.cardView.layer.borderWidth = 0
                cell.cardView.backgroundColor = UIColor.clear

                cell.signatureViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_ABOVE")
                cell.clearSigLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_CLEAR_TXT").uppercased()
                cell.subSigLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT").uppercased()
  
                let clearImageGesture = UITapGestureRecognizer()
                clearImageGesture.addTarget(self, action: #selector(self.clearImgTapped(sender:)))
                cell.sigClearBtnView.tag = indexPath.row
                cell.sigClearBtnView.isUserInteractionEnabled = true
                cell.sigClearBtnView.addGestureRecognizer(clearImageGesture)

                let subImgTapGesture = UITapGestureRecognizer()
                subImgTapGesture.addTarget(self, action: #selector(self.subSigTapped(sender:)))
                cell.sigSubBtnView.tag = indexPath.row
                cell.sigSubBtnView.isUserInteractionEnabled = true
                cell.sigSubBtnView.addGestureRecognizer(subImgTapGesture)
                
                cell.sigSubBtnView.backgroundColor = UIColor.UCAColor.AppThemeColor
                cell.sigClearBtnView.backgroundColor = UIColor.clear
                cell.sigClearBtnView.borderColor = UIColor.UCAColor.AppThemeColor
                cell.sigClearBtnView.borderWidth = 2
                cell.clearSigLbl.textColor = UIColor.UCAColor.AppThemeColor
                
                if self.endTripVerMethod != "Signature"
                {
                    cell.ypSignatureImgView.isHidden = true
                    cell.sigatureBGView.isHidden = true
                    cell.deliveryCodehLbl.isHidden = false
                    cell.deliveryCodeTxtFiled.isHidden = false
                    cell.deliveryCodehLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_VERIFICATION_CODE_MSG_TXT")
                    cell.deliveryCodehLbl.textColor = UIColor.UCAColor.AppThemeColor
                    cell.deliveryCodeTxtFiled.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRMATION_CODE"))
                    cell.sigClearBtnView.isHidden = true
                }
            }
            else{
                let getArrayObj = self.deliveryDetails[indexPath.row] as! NSMutableArray
                let getLastObj = getArrayObj[getArrayObj.count-1] as! NSDictionary
                
                if (getLastObj.get("iActive") == "Finished")   {
                    cell.callMessageStackView.isHidden = true
                    cell.callMessageStackView.isUserInteractionEnabled = false
                    if getLastObj.get("Receipent_Signature") != ""{
                    cell.viewSignatureLabel.isHidden = false
                    }else{
                        cell.viewSignatureLabel.isHidden = true
                    }
                    cell.viewSignatureLabel.setClickHandler { (label) in
                        self.loadSignatureDisplayView(index: indexPath.row)
                    }
                    cell.finishedStatusLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Status").uppercased() + ": " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINISHED_TXT").uppercased()
                    cell.tripLineView.backgroundColor = UIColor.UCAColor.AppThemeColor
                    cell.finishedStatusLbl.isHidden = false
                    cell.deliveryCountLbl.cornerRadius = cell.deliveryCountLbl.bounds.width / 2
                    cell.deliveryCountLbl.text = String(indexPath.row+1)
                    cell.deliveryCountLbl.isHidden = false
                    cell.deliveryCountLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                    cell.deliveryCountLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                }  else{
                    cell.viewSignatureLabel.isHidden = true

                    cell.callMessageStackView.isUserInteractionEnabled = true
                    cell.tripLineView.backgroundColor = UIColor(hex: 0xe0e0e0)
                    cell.callMessageStackView.isHidden = false
                    cell.finishedStatusLbl.isHidden = true
                    cell.checkImgView.image = UIImage.init(named:"" )
                    cell.deliveryCountLbl.cornerRadius = cell.deliveryCountLbl.bounds.width / 2
                    cell.deliveryCountLbl.text = String(indexPath.row+1)
                    cell.deliveryCountLbl.isHidden = false
                    cell.deliveryCountLbl.backgroundColor = UIColor(hex: 0xe0e0e0)
                    cell.deliveryCountLbl.textColor = UIColor.UCAColor.blackColor
                }
                cell.checkImgView.isHidden = false
                cell.respForPayReci.isHidden = false
                cell.receiverHeaderLbl.isHidden = false
                //cell.locImgView.set
                GeneralFunctions.setImgTintColor(imgView: cell.locImgView, color: UIColor(hex: 0x00906c))
                
                if (getLastObj.get("ePaymentByReceiver") == "Yes") || self.payType == "Individual"    {
                    
                    cell.respForPayReci.isHidden = false
                    cell.respForPayReci.text = self.generalFunc.getLanguageLabel(origValue: "Sender", key: "LBL_MULTI_RESPONSIBLE_FOR_PAYMENT_TXT").uppercased()
                    if self.payType == "Individual"
                    {
                        cell.respForPayReci.text = cell.respForPayReci.text! + "\n" + self.generalFunc.getLanguageLabel(origValue: "Sender", key: "LBL_MULTI_AMOUNT_COLLECT_TXT").uppercased() + self.indivFare
                    }
                }
                else   {
                    
                    cell.respForPayReci.isHidden = true
                    cell.respForPayReci.text  = "--"
                }
                var headerY = 10.0
                for subview in cell.receiverDetailView.subviews
                {
                    subview.removeFromSuperview()
                }
                
                for i in 0..<getArrayObj.count - 1
                {
                    let item = getArrayObj[i] as! NSDictionary
                    print(item)
                    if item.get("iDeliveryFieldId") == "3" || item.get("iDeliveryFieldId") == "2"
                    {
                        if item.get("iDeliveryFieldId") == "2"
                        {
                            cell.receiverNameLbl.text = item.get("vValue")
                        }else if item.get("iDeliveryFieldId") == "3"
                        {
                            if item.get("vMaskValue") == "" || item.get("vMaskValue") == "<null>"
                            {
                                cell.receiverMobLbl.text = "---"
                            }else
                            {
                                cell.receiverMobLbl.text = item.get("vMaskValue")
                            }
                        }
                        
                    }else
                    {
                        let headerLbl = UILabel.init(frame: CGRect(x: 10, y: Int(headerY), width: Int(Application.screenSize.width - 60), height: 20))
                        headerLbl.textColor = UIColor.lightGray
                        headerLbl.font = UIFont(name: Fonts().regular, size: 17)
                        headerLbl.text = item.get("vFieldName").uppercased()
                        cell.receiverDetailView.addSubview(headerLbl)
                        headerY = headerY + 30.0
                        
                        let valueHeight = item.get("vValue").height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont(name: Fonts().light, size: 16)!)
                        let valueLbl = UILabel.init(frame: CGRect(x: 10, y: Int(headerY), width: Int(Application.screenSize.width - 60), height: Int(valueHeight)))
                        valueLbl.numberOfLines = 100
                        valueLbl.font = UIFont(name: Fonts().light, size: 16)
                        valueLbl.textColor = UIColor.black
                        
                        if item.get("vValue") == "" || item.get("vValue") == "<null>"
                        {
                            valueLbl.text = "---"
                        }else
                        {
                            valueLbl.text = item.get("vValue")
                        }
                        
                        valueLbl.sizeToFit()
                        cell.receiverDetailView.addSubview(valueLbl)
                        
                        headerY = Double(Int(headerY) + Int(valueHeight) + 10)
                        print(headerY)
                        
                    }
                }
                
                cell.recDetailviewHeight.constant = CGFloat(headerY)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    let sepratorView = UIView(frame: CGRect(10, 0, cell.receiverDetailView.bounds.width - 20, 0.7))
                    sepratorView.backgroundColor = .lightGray
                    cell.receiverDetailView.addSubview(sepratorView)
                    
                    let sepratorView1 = UIView(frame: CGRect(10, CGFloat(headerY-1), cell.receiverDetailView.bounds.width - 20, 0.7))
                    sepratorView1.backgroundColor = .lightGray
                    cell.receiverDetailView.addSubview(sepratorView1)
                })
                
                receiverDetailsHeight.append(headerY)
                cell.vAddressLbl.text = getLastObj.get("tDaddress")
                cell.receiverHeaderLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECIPIENT") + " " + Configurations.convertNumToAppLocal(numStr: "\(indexPath.row+1)")
                cell.receiverHeaderLbl.textColor = UIColor.UCAColor.blackColor
                cell.receiverMobLbl.isHidden = false
                cell.viewUpDownImgView.isHidden = false
                let intTotalrow = tableView.numberOfRows(inSection:indexPath.section)//first get total rows in that section by current indexPath.
                if indexPath.row == intTotalrow - 1{
                    cell.tripLineView.isHidden = true
                }else {
                    cell.tripLineView.isHidden = false
                }
            }
            
            if self.cabBookingReqId != ""
            {
                cell.receiverMobLbl.isHidden = true
                cell.mainCallMessView.isHidden = true
                cell.respForPayReci.isHidden = true
                cell.receiverHeaderViewHeight.constant = 120 - 20
            }
        }
        
        let arrowImageGesture = UITapGestureRecognizer()
        arrowImageGesture.addTarget(self, action: #selector(self.arrowImgTapped(sender:)))
        cell.viewUpDownImgView.tag = indexPath.row
        cell.viewUpDownImgView.isUserInteractionEnabled = true
        cell.viewUpDownImgView.addGestureRecognizer(arrowImageGesture)
        
        let callTapGesture = UITapGestureRecognizer()
        callTapGesture.addTarget(self, action: #selector(self.callTapped(sender:)))
        cell.callView.tag = indexPath.row
        cell.callView.isUserInteractionEnabled = true
        cell.callView.addGestureRecognizer(callTapGesture)
        
        GeneralFunctions.setImgTintColor(imgView: cell.recMsgImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: cell.recCallImgView, color: UIColor.UCAColor.AppThemeColor)
        
        let messageTapGesture = UITapGestureRecognizer()
        messageTapGesture.addTarget(self, action: #selector(self.msgTapped(sender:)))
        cell.messageView.tag = indexPath.row
        cell.messageView.isUserInteractionEnabled = true
        cell.messageView.addGestureRecognizer(messageTapGesture)
        
        cell.callMessageStackView.isHidden = false
        
        if moreVideHideStatusList[indexPath.row] == true
        {
            cell.viewUpDownImgView.transform = CGAffineTransform.identity
            cell.viewUpDownImgView.transform = cell.viewUpDownImgView.transform.rotated(by: CGFloat(Double.pi))
            cell.mainCallMessgeViewHeight.constant = 50
            cell.receiverDetailView.isHidden = false
            cell.mainCallMessView.isHidden = false
            cell.messageView.isHidden = false
             cell.respForPayReci.isHidden = false
        }
        else
        {
            cell.respForPayReci.isHidden = true
            cell.mainCallMessgeViewHeight.constant = 0
            cell.viewUpDownImgView.transform = CGAffineTransform.identity
            cell.receiverDetailView.isHidden = true
            cell.mainCallMessView.isHidden = true
        }
        cell.senderHeaderView.isHidden = true
        cell.receiverHeaderView.isHidden = false
        if isFromCabRequest == true{
            cell.mainCallMessView.isHidden = true
        }
        return cell
    }
    
    
    @objc func arrowImgTapped(sender:UITapGestureRecognizer)
    {
        
        if(moreVideHideStatusList[sender.view!.tag] == true){
            moreVideHideStatusList[sender.view!.tag] = false
            
        }else{
            moreVideHideStatusList[sender.view!.tag] = true
            
        }
        self.tableView.reloadRows(at: [IndexPath(row: sender.view!.tag, section: 0)], with: UITableView.RowAnimation.fade)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if(indexPath.item == 0){
        //            if self.payType == "Individual" && self.isLoadFromEndTRip == true
        //            {
        //                return 165
        //            }else
        //            {
        //                return 130
        //            }
        //
        //        }else{
        let getArrayObj = self.deliveryDetails[indexPath.row ] as! NSMutableArray
        let getLastObj = getArrayObj[getArrayObj.count-1] as! NSDictionary
        if(moreVideHideStatusList[indexPath.item] == true){
            if self.cabBookingReqId != ""
            {
                return 220 + CGFloat(receiverDetailsHeight[indexPath.row])
            }
            else
            {
                if (getLastObj.get("ePaymentByReceiver") == "Yes") || self.payType == "Individual"
                {
                    return 515 - 210 + CGFloat(receiverDetailsHeight[indexPath.row])
                }
                else
                {
                    return 470 - 230 + CGFloat(receiverDetailsHeight[indexPath.row])
                }
                
            }
            
        }else{
            if self.cabBookingReqId != ""
            {
                return 160
            }
            else
            {
                if (getLastObj.get("ePaymentByReceiver") == "Yes") || self.payType == "Individual"
                {
                    if self.isLoadFromEndTRip == true {
                        return 300
                    }
                    return 222
                }
                else
                {
                    let iActive = getLastObj.get("iActive")
                    if (iActive == "Finished" || iActive == "Canceled") {
                        return 260
                    }else if  self.isLoadFromEndTRip == true {
                        return 300
                    }
                    return 200
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableViewHeight.constant  = tableView.contentSize.height
    }
    
    @objc func callTapped(sender:UITapGestureRecognizer){
        
        var number = ""
        
        if(sender.view!.tag == 0){
            number = self.tripData.get("PPhone")
        }else
        {
            var name = ""
            let getArrayObj = self.deliveryDetails[sender.view!.tag - 1] as! NSMutableArray
            for i in 0..<getArrayObj.count - 1
            {
                let item = getArrayObj[i] as! NSDictionary
                print(item)
                if item.get("iDeliveryFieldId") == "3"
                {
                    number = item.get("vValue")
                    
                }
                if item.get("iDeliveryFieldId") == "2"
                {
                    name = item.get("vValue")
                    
                }
            }
            
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
            if userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
                //if SinchCalling.getInstance().client.isStarted(){
                
                let selfDic = ["Id":"", "Name": "", "PImage": "", "type": ""]
                let assignedDic = ["Id":"", "Name": name, "PImage": "", "type": ""]
                SinchCalling.getInstance().makeACall(IDString:"", assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:number)
                return
                
                // }
            }
        }
        
        UIApplication.shared.openURL(NSURL(string:"telprompt:" + number)! as URL)
    }
    
    @objc func msgTapped(sender:UITapGestureRecognizer){
        
        var number = ""
        
    /*    if(sender.view!.tag == 0){
            //  number = self.dataDict.getObj(Utils.message_str).get("senderMobile")
            
            let chatUV = GeneralFunctions.instantiateViewController(pageName: "MessagesViewController") as! MessagesViewController
            chatUV.receiverId = tripData.get("PassengerId")
            chatUV.receiverDisplayName = self.tripData.get("PName")
            chatUV.assignedtripId = self.tripData.get("TripId")
            chatUV.pPicName = self.tripData.get("PPicName")
//            chatUV.serviceTripType = self.tripData.get("vServiceTitle")
            chatUV.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.tripData.get("PRating"))
               chatUV.bookingNo = self.tripData.get("vRideNo")
            chatUV.assignedtripDate  = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.tripData.get("tTripRequestDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
            self.pushToNavController(uv:chatUV, isDirect: true)
        }else {*/
            let getArrayObj = self.deliveryDetails[sender.view!.tag] as! NSMutableArray
            for i in 0..<getArrayObj.count - 1
            {
                let item = getArrayObj[i] as! NSDictionary
                print(item)
                if item.get("iDeliveryFieldId") == "3"
                {
                    number = item.get("vValue")
                }
            }
            // number = "+" + (self.deliveryDetails[sender.view!.tag - 1] as AnyObject).get("vReceiverMobile")
            UIApplication.shared.openURL(NSURL(string:"sms:" + number)! as URL)
//        }
    }
    
    func onTripViewClosed(openCancelTrip:OpenCancelTrip) {
        openCancelTrip.setDelegate(onTripCanceledDelegate: nil)
    }
    
    func onTripCanceled(reason: String, comment: String, openCancelTrip:OpenCancelTrip) {
        
        
        openCancelTrip.setDelegate(onTripCanceledDelegate: nil)
        
        let parameters = ["type":"cancelTrip","iDriverId": GeneralFunctions.getMemberd(), "iUserId": tripData.get("PassengerId"), "iTripId": tripData.get("TripId"), "UserType": Utils.appUserType, "Reason": reason, "Comment": comment, "iTripDeliveryLocationId":iTripDeliveryLocationId,"vLatitude" : "\(currentLocation!.coordinate.latitude)","vLongitude" : "\(currentLocation!.coordinate.longitude)"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.loadDeliveryData()
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @objc func clearImgTapped(sender:UITapGestureRecognizer)
    {
        let cell = self.tableView.cellForRow(at: IndexPath(row: (sender.view?.tag)!, section: 0)) as! ViewDeliveryDetailCell
        cell.ypSignatureImgView.clear()
        
    }
    
    @objc func subSigTapped(sender:UITapGestureRecognizer)
    {
        let cell = self.tableView.cellForRow(at: IndexPath(row: (sender.view?.tag)!, section: 0)) as! ViewDeliveryDetailCell
        if self.checkProofFor == "Receipent"
        {
            if self.endTripVerMethod == "Signature"
            {
                if let signatureImage = cell.ypSignatureImgView.getSignature(scale: 1) {
                    
                    // Saving signatureImage from the line above to the Photo Roll.
                    // The first time you do this, the app asks for access to your pictures.
                    print(signatureImage)
                    self.serviceImage = signatureImage
                    self.submitProofOfDataForSignature(tag:(sender.view?.tag)!)
                    // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
                    cell.ypSignatureImgView.clear()
                }
            }
            else
            {
                submitProofOfDataForCode(tag:(sender.view?.tag)!)
            }
        }
        else
        {
            
            if let signatureImage = cell.ypSignatureImgView.getSignature(scale: 1) {
                
                // Saving signatureImage from the line above to the Photo Roll.
                // The first time you do this, the app asks for access to your pictures.
                print(signatureImage)
                self.serviceImage = signatureImage
                self.submitProofOfDataForSignature(tag:(sender.view?.tag)!)
                // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
                cell.ypSignatureImgView.clear()
            }
        }
    }
    
    // Signature View Deligate Methods
    func didStart() {
        scrollView.isScrollEnabled = false
        print("Started Drawing")
    }
    
    // didFinish() is called rigth after the last touch of a gesture is registered in the view.
    // Can be used to enabe scrolling in a scroll view if it has previous been disabled.
    func didFinish() {
        scrollView.isScrollEnabled = true
        print("Finished Drawing")
    }
    
    func openOTPConfView(tag:Int){
        
        let viewHeight = 350
        self.jobOTPVerificationView = JobOTPVerificationView.init(frame: CGRect(x: 0, y: Int(self.view.frame.height) - viewHeight + 10, width: Int(self.view.frame.width), height: viewHeight), numberOfFileds: GeneralFunctions.parseInt(origValue: 4, data: self.tripData.get("vRandomCode")))
        
        
        jobOTPVerificationView.layer.cornerRadius = 10
        
        self.bgViewOTP = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)))
        self.bgViewOTP.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        self.view.addSubview(self.bgViewOTP)
        self.view.addSubview(jobOTPVerificationView)
        
        self.jobOTPVerificationView.closeOTPLbl.setOnClickListener { (instance) in
            self.closeOTPView()
        }
        
        self.jobOTPVerificationView.tag = tag
        self.jobOTPVerificationView.otpStackView.delegate = self
        
        self.jobOTPVerificationView.submitOTPBtn.clickDelegate = self
        self.jobOTPVerificationView.submitOTPBtn.setButtonEnabled(isBtnEnabled: false)
        self.jobOTPVerificationView.otpTextFiled.onTextChangedDelegate = self
        self.jobOTPVerificationView.otpTextFiled.getTextField()!.keyboardType = .numberPad
        
    }
    
    func closeOTPView(){
       
        self.jobOTPVerificationView.removeFromSuperview()
        self.bgViewOTP.removeFromSuperview()
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
        if(self.jobOTPVerificationView != nil && sender == self.jobOTPVerificationView.otpTextFiled){
            if(text != ""){
                self.otp_str = text
                self.jobOTPVerificationView.submitOTPBtn.setButtonEnabled(isBtnEnabled: true)
            }else{
                self.jobOTPVerificationView.submitOTPBtn.setButtonEnabled(isBtnEnabled: false)
            }
        
        }
    }
    func didChangeValidity(isValid: Bool) {
        if isValid {
            self.jobOTPVerificationView.submitOTPBtn.setButtonEnabled(isBtnEnabled: true)
            self.otp_str = self.jobOTPVerificationView.otpStackView.getOTP()
        }else{
            
        }
    }
    
    func submitProofOfDataForSignature(tag:Int){
        
        if(self.tripData.get("eAskCodeToUser").uppercased() == "YES" && self.isOTPVerificationDone == false){
            
            self.openOTPConfView(tag:tag)
            return
            
        }
        
        if(loaderView != nil){
            loaderView.removeFromSuperview()
        }
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"ConfirmDelivery","UserType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd(), "iTripId": self.tripData.get("TripId"), "appType": Utils.appUserType, "vDeliveryConfirmCode":"", "CheckFor":self.checkProofFor]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        
        let fileData = self.serviceImage.correctlyOrientedImage().cropTo(size: CGSize(width: Utils.ImageUpload_DESIREDWIDTH, height: Utils.ImageUpload_DESIREDHEIGHT)).jpegData(compressionQuality: 1.0)!
        if(self.serviceImage != nil){
            exeWebServerUrl.uploadImage(fileData: fileData, fileName: "vImage.png", completionHandler: { (response) -> Void in
                //exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                let dataDict = response.getJsonDataDict()
                if(response != ""){
                    self.dataDict = dataDict
                    
                    if(dataDict.get("Action") == "1"){
                        let window = Application.window
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                    }else{
                        if self.checkProofFor == "Receipent"
                        {
                            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            })
                        }
                        else
                        {
                            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COLLECT_CASH"), completionHandler: { (btnClickedId) in
                                
                                if(btnClickedId == 0){
                                    self.submitProofOfDataForSignature(tag:tag)
                                }else{
                                    self.collectPayment(isCollectCash: "true")
                                }
                            })
                            
                        }
                    }
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        self.submitProofOfDataForSignature(tag:tag)
                    })
                }
                self.loaderView.isHidden = true
            })
        }
    }
    
    func submitProofOfDataForCode(tag:Int){
        
        if(loaderView != nil){
            loaderView.removeFromSuperview()
        }
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! ViewDeliveryDetailCell
        var deliveryCode = ""
        if self.endTripVerMethod != "Signature"
        {
            deliveryCode = Utils.getText(textField: cell.deliveryCodeTxtFiled.getTextField()!)
        }
        if deliveryCode == ""
        {
            _  = Utils.checkText(textField: cell.deliveryCodeTxtFiled.getTextField()!) ? true : Utils.setErrorFields(textField: cell.deliveryCodeTxtFiled.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD"))
            return
        }
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"ConfirmDelivery","UserType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd(), "iTripId": self.tripData.get("TripId"), "appType": Utils.appUserType, "vDeliveryConfirmCode":deliveryCode, "CheckFor":self.checkProofFor, "vImage":""]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            let dataDict = response.getJsonDataDict()
            if(response != ""){
                
                self.dataDict = dataDict
                
                if(dataDict.get("Action") == "1"){
                    let window = Application.window
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                }else{
                    if self.checkProofFor == "Receipent"
                    {
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVALID_DELIVERY_CONFIRM_CODE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        })
                    }
                    else
                    {
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COLLECT_CASH"), completionHandler: { (btnClickedId) in
                            
                            if(btnClickedId == 0){
                                self.submitProofOfDataForCode(tag:tag)
                            }else{
                                self.collectPayment(isCollectCash: "true")
                            }
                        })
                    }
                }
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                })
            }
            self.loaderView.isHidden = true
        })
        
    }
    
    func collectPayment(isCollectCash:String){
        
        let parameters = ["type":"CollectPayment", "iTripId": tripData.get("TripId"), "isCollectCash": isCollectCash]
        
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
                            self.collectPayment(isCollectCash: "true")
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
    
    @objc func loadSignatureDisplayView(index:Int){
        let getArrayObj = self.deliveryDetails[index] as! NSMutableArray
        let getLastObj = getArrayObj[getArrayObj.count - 1] as! NSDictionary
        
        let signatureDisplayView = self.generalFunc.loadView(nibName: "SignatureDisplayView", uv: self, isWithOutSize: true)
        
        self.signatureDisplayView = signatureDisplayView
        
        let width = Application.screenSize.width  > 380 ? 370 : Application.screenSize.width - 50
        
        signatureDisplayView.frame.size = CGSize(width: width, height: 235)
        
        signatureDisplayView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        let bgView = UIView()
        self.signatureDisplayBGView = bgView
        
        bgView.frame = CGRect(x:0, y:0, width:Application.screenSize.width, height: Application.screenSize.height)
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.4
        bgView.isUserInteractionEnabled = true
        
        signatureDisplayView.layer.shadowOpacity = 0.5
        signatureDisplayView.layer.shadowOffset = CGSize(width: 0, height: 3)
        signatureDisplayView.layer.shadowColor = UIColor.black.cgColor
        
        let currentWindow = Application.window
        
        if(currentWindow != nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(signatureDisplayView)
        }else if(self.navigationController != nil){
            self.navigationController?.view.addSubview(bgView)
            self.navigationController?.view.addSubview(signatureDisplayView)
        }else{
            self.view.addSubview(bgView)
            self.view.addSubview(signatureDisplayView)
        }
        
        bgView.alpha = 0
        signatureDisplayView.alpha = 0
        
        UIView.animate(withDuration: 0.5,delay: 0, options: .curveEaseInOut, animations: {
            bgView.alpha = 0.4
            signatureDisplayView.alpha = 1
        })
        
        Utils.createRoundedView(view: signatureDisplayView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        (signatureDisplayView.subviews[2]).backgroundColor = UIColor(hex: 0xe6e6e6)
        (signatureDisplayView.subviews[2]).cornerRadius = 10.0
        (signatureDisplayView.subviews[2]).borderWidth = 0.5
        (signatureDisplayView.subviews[2]).borderColor = UIColor(hex: 0xd9d9da)
        
        (signatureDisplayView.subviews[0] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIVER_SIGN")
        
        (signatureDisplayView.subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECIPIENT_NAME_HEADER_TXT") + " " + ":" + " " + getLastObj.get("vReceiverName")
        
        ((signatureDisplayView.subviews[2]).subviews[0]).borderWidth = 0.5
        ((signatureDisplayView.subviews[2]).subviews[0]).borderColor = UIColor(hex: 0xd9d9da)
        ((signatureDisplayView.subviews[2]).subviews[0].subviews[0] as! UIImageView).sd_setImage(with: URL(string: getLastObj.get("Receipent_Signature")), placeholderImage:UIImage(named:""))
        
        let closeSignTapGue = UITapGestureRecognizer()
        closeSignTapGue.addTarget(self, action: #selector(self.closeSignViewTapped))
        (signatureDisplayView.subviews[3] as! UIImageView).isUserInteractionEnabled = true
        (signatureDisplayView.subviews[3] as! UIImageView).addGestureRecognizer(closeSignTapGue)
        
        GeneralFunctions.setImgTintColor(imgView: (signatureDisplayView.subviews[3] as! UIImageView), color: UIColor.black)
    }
    
    @objc func closeSignViewTapped(){
        if(signatureDisplayBGView != nil){
            signatureDisplayBGView.removeFromSuperview()
        }
        
        if(signatureDisplayView != nil){
            signatureDisplayView.removeFromSuperview()
        }
    }
}
