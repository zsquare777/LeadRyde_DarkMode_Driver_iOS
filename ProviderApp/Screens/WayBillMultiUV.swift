//
//  WayBillUV.swift
//  DriverApp
//
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class WayBillMultiUV: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var driverNameLbl: MyLabel!
    
    @IBOutlet weak var tripView: UIView!
    @IBOutlet weak var tripViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tripLbl: MyLabel!
    @IBOutlet weak var tripNoLbl: MyLabel!
    @IBOutlet weak var tripNoVLbl: MyLabel!
    @IBOutlet weak var tripTimeLbl: MyLabel!
    @IBOutlet weak var tripTimeVLbl: MyLabel!
   
    @IBOutlet weak var passengerNameLbl: MyLabel!
    @IBOutlet weak var passengerNameVLbl: MyLabel!
    @IBOutlet weak var viaLbl: MyLabel!
    @IBOutlet weak var viaVLbl: MyLabel!
    
    @IBOutlet weak var tripAreaBottomView: UIView!
    
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var driverViewHeight: NSLayoutConstraint!
    @IBOutlet weak var driverLbl: MyLabel!
    @IBOutlet weak var driverNameHLbl: MyLabel!
    @IBOutlet weak var driverNameVLbl: MyLabel!
    @IBOutlet weak var carLicPlateLbl: MyLabel!
    @IBOutlet weak var carLicPlateVLbl: MyLabel!
    @IBOutlet weak var passengerCapLbl: MyLabel!
    @IBOutlet weak var passengerCapVLbl: MyLabel!
    @IBOutlet weak var driverAreaBottomView: UIView!
    
    @IBOutlet weak var paymentTypeHLbl: MyLabel!
    @IBOutlet weak var paymentTypeVLbl: MyLabel!
    
    var PAGE_HEIGHT:CGFloat = 500
    
    @IBOutlet weak var deliveryDetailsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deliveryDetailsview: UIView!
    @IBOutlet weak var delievryDetailHLbl: MyLabel!
    let generalFunc = GeneralFunctions()
    
    var cntView:UIView!
    var loaderView:UIView!
    
    var isFirstLaunch = true
      let borderColor = UIColor.lightGray.withAlphaComponent(0.5)
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "WayBillMultiScreenDesign", uv: self, contentView: contentView)
        
        self.scrollView.addSubview(cntView)
        self.scrollView.backgroundColor = UIColor(hex: 0xf2f2f4)
        
        scrollView.bounces = false
        scrollView.isHidden = true
        
        self.addBackBarBtn()
        
        setData()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = -1
        if(isFirstLaunch == true){
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
            
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            isFirstLaunch = false
            
            loadData()
        }
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Way Bill", key: "LBL_MENU_WAY_BILL")
        self.title = self.generalFunc.getLanguageLabel(origValue: "Way Bill", key: "LBL_MENU_WAY_BILL")
        
        self.paymentTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT_TYPE_TXT")
        self.tripLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_TXT")
        self.tripNoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_TXT") + "# "
        self.tripTimeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TIME_TXT")
      //  self.tripRateLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATE")
        self.passengerNameLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SENDER_NAME")
        self.viaLbl.text = self.generalFunc.getLanguageLabel(origValue: "Via", key: "LBL_VIA_TXT")
        //self.fromLocLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_From")
       // self.toLocLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_To")
        
        self.driverLbl.text = self.generalFunc.getLanguageLabel(origValue: "Driver", key: "LBL_DIVER")
        self.driverNameHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Name", key: "LBL_NAME_TXT")
        self.carLicPlateLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LICENCE_PLATE_TXT") + "# "
        self.passengerCapLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PASSENGER_TXT") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CAPACITY")
        
        self.delievryDetailHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE_SHIPMENT_DETAIL_TXT")
        
       //  self.recnameStackView.isHidden = true
        //self.packageNameStackView.isHidden = true
        //self.packageDetailsStackView.isHidden = true
        
        self.topHeaderView.layer.shadowOpacity = 0.5
        self.topHeaderView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.topHeaderView.layer.shadowColor = UIColor(hex: 0xc0c0c1).cgColor
        self.topHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        tripView.layer.shadowOpacity = 0.6
        tripView.layer.shadowOffset = CGSize.zero
        tripView.layer.shadowColor = UIColor.lightGray.cgColor
        
        deliveryDetailsview.layer.shadowOpacity = 0.6
        deliveryDetailsview.layer.shadowOffset = CGSize.zero
        deliveryDetailsview.layer.shadowColor = UIColor.lightGray.cgColor
        
        driverView.layer.shadowOpacity = 0.6
        driverView.layer.shadowOffset = CGSize.zero
        driverView.layer.shadowColor = UIColor.lightGray.cgColor

    }
    
    func loadData(){
        scrollView.isHidden = true
        
        if(loaderView != nil){
            loaderView.removeFromSuperview()
        }
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"displayWayBill","UserType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let msgData = dataDict.getObj(Utils.message_str)
                    
                    self.paymentTypeVLbl.text = msgData.get("vDisplayPaymentMode")
                    self.driverNameLbl.text = msgData.get("DriverName")
                    self.tripNoVLbl.text = Configurations.convertNumToAppLocal(numStr: msgData.get("vRideNo"))
                    self.tripTimeVLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: msgData.get("tTripRequestDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateWithTime).uppercased()
                    //self.tripRateVLbl.text = Configurations.convertNumToAppLocal(numStr: msgData.get("Rate"))
                    
                    self.passengerNameVLbl.text = msgData.get("PassengerName")
                    self.viaVLbl.text = msgData.get("ProjectName")
                   // self.fromLocVLbl.text = msgData.get("tSaddress")
                   // self.toLocVLbl.text = msgData.get("tDaddress") == "" ? "--" : msgData.get("tDaddress")
                    
                    self.driverNameVLbl.text = msgData.get("DriverName")
                    self.carLicPlateVLbl.text =  msgData.get("eType") == Utils.cabGeneralType_UberX ? "--" : msgData.get("Licence_Plate")
                    
                    if (msgData.get("eType") == "Multi-Delivery" || msgData.get("eType") == Utils.cabGeneralType_UberX){
                        self.passengerCapVLbl.text = "--"
                        
                        if(msgData.get("eType") == Utils.cabGeneralType_UberX){
                        //    self.recNameStackViewTop.constant = -20.5
                        }
                    }else{
                        self.passengerCapVLbl.text = Configurations.convertNumToAppLocal(numStr: msgData.get("PassengerCapacity"))
                        
                      //  self.recNameStackViewTop.constant = -20.5
                      //  self.recnameStackView.isHidden = true
                    }
                    
                    if(msgData.get("eType") == "Multi-Delivery")
                    {
                        //self.recnameHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIVER_NAME")
                       // self.recnameVLbl.text = msgData.get("vReceiverName")
                       // self.pacNameHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PACKAGE_TYPE")
                       // self.pacDetailsHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PACKAGE_DETAILS")
                        
                       // self.passengerNameLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SENDER_NAME")
                       // self.toLocLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIVER_LOCATION")
                        
                       // self.pacNameVLbl.text = msgData.get("PackageName")
                       // self.pacDetailsVLbl.text = msgData.get("tPackageDetails")

                    }
                    self.viaVLbl.fitText()
                    if(msgData.get("eType") == Utils.cabGeneralType_Deliver) || (msgData.get("eType") == Utils.cabGeneralType_Multi_Delivery) || (msgData.get("eType").uppercased() == "DELIVER") {
                        self.driverLbl.text = self.generalFunc.getLanguageLabel(origValue: "Carrier", key: "LBL_CARRIER")
                    }else{
                        self.driverLbl.text = self.generalFunc.getLanguageLabel(origValue: "Driver", key: "LBL_DIVER")
                    }
                   // self.fromLocVLbl.fitText()
                  //  self.recnameVLbl.fitText()
                   // self.toLocVLbl.fitText()
                   /// self.tripRateVLbl.fitText()
                   // self.tripTimeVLbl.fitText()
                  //  self.pacNameVLbl.fitText()
                   // self.pacDetailsVLbl.fitText()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                        for views in self.tripView.subviews {
                            if views.tag != 10 {
                                if self.tripView.subviews.last != views {
                                    views.layer.addDashedBorder(edge: UIRectEdge.bottom, color: self.borderColor, thickness: 0.7, true)
                                }
                            }
                        }
                        for views in self.driverView.subviews {
                            if views.tag == 10 {
                                views.layer.addDashedBorder(edge: UIRectEdge.bottom, color: self.borderColor, thickness: 0.7, true)
                                
                            }
                        }
                    })
                        
                        var recName = ""
                        var recMob = ""
                        var picAdd = ""
                        var desAdd = ""
                    var recHName = ""
                    var recHMob = ""
                  
                    let deliveryObj = msgData.getArrObj("Deliveries")
                   
                    var height:CGFloat = self.delievryDetailHLbl.isHidden == false ?  (self.delievryDetailHLbl.bounds.size.height + 20) : 0
                    for j in 0..<deliveryObj.count
                    {
                        let width = ((self.deliveryDetailsview.frame.size.width * 35) / 100) + 20
                        var heigh = recHName.height(withConstrainedWidth: width, font: self.viaVLbl.font)
                        
                        if heigh < 40
                        {
                            heigh = 40
                        }
                        
                        let y:CGFloat = 0
//                        if j == 0
//                        {
//                            y = 50
//                        }else{
//                            y = 15
//                        }
                        
                        if  deliveryObj.count > 1 {
                            let delObj7 = MultiDelDetailsView.init(frame: CGRect(x:10, y: height, width:self.deliveryDetailsview.frame.size.width - 20, height:heigh))
                            delObj7.tag = 10
                            delObj7.hLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECIPIENT") + " " + Configurations.convertNumToAppLocal(numStr: "\(j + 1)")
                            delObj7.hLbl.textColor = UIColor.UCAColor.AppThemeColor
                            delObj7.hLbl.fitText()
                            self.deliveryDetailsview.addSubview(delObj7)
                            delObj7.valLbl.text = ""
                            height = height + heigh + y
                        }
                        
                        let getArrayObj = deliveryObj[j] as! NSArray
                        for i in 0..<getArrayObj.count - 1
                        {
                            if i == 0
                            {
                                let item = getArrayObj[getArrayObj.count - 1] as! NSDictionary
                                picAdd = item.get("tSaddress")
                                desAdd = item.get("tDaddress")
                            }
                            let item = getArrayObj[i] as! NSDictionary
                            print(item)
                            if item.get("iDeliveryFieldId") == "3" || item.get("iDeliveryFieldId") == "2"
                            {
                                if item.get("iDeliveryFieldId") == "2"
                                {
                                    recName = item.get("vValue")
                                    recHName = item.get("vFieldName")
                                }else if item.get("iDeliveryFieldId") == "3"
                                {
                                    recMob = item.get("vValue")
                                    recHMob = item.get("vFieldName")
                                }
                            }
                        }
                        
                        var height0 = recHName.height(withConstrainedWidth: width - 40, font: self.viaVLbl.font)
                        if height0 < 40
                        {
                            height0 = 40
                        }
                        let delObj = MultiDelDetailsView.init(frame: CGRect(x:10, y: height, width:self.deliveryDetailsview.frame.size.width - 20, height:height0))
                        delObj.hLbl.text = recHName
                        delObj.valLbl.text = recName
                        delObj.hLbl.fitText()
                        delObj.valLbl.fitText()
                        height = height + heigh
                        delObj.layer.addDashedBorder(edge: UIRectEdge.bottom, color: self.borderColor, thickness: 0.7, true)
                        self.deliveryDetailsview.addSubview(delObj)
                        
                        
                        var height1 = recHMob.height(withConstrainedWidth: width-40, font: self.viaVLbl.font)
                        if height1 < 40
                        {
                            height1 = 40
                        }
                        let delObj1 = MultiDelDetailsView.init(frame: CGRect(x:10, y: height, width:self.deliveryDetailsview.frame.size.width - 20, height:height1))
                     
                        delObj1.hLbl.text = recHMob
                        delObj1.valLbl.text = recMob
                        delObj1.hLbl.fitText()
                        delObj1.valLbl.fitText()
                        
                        height = height + height1
                        self.deliveryDetailsview.addSubview(delObj1)
                        delObj1.layer.addDashedBorder(edge: UIRectEdge.bottom, color: self.borderColor, thickness: 0.7, true)
                        var height2 = picAdd.height(withConstrainedWidth: width, font: self.viaVLbl.font)
                        if height2 < 40
                        {
                            height2 = 40
                        }
                        let delObj2 = MultiDelDetailsView.init(frame: CGRect(x:10, y: height, width:self.deliveryDetailsview.frame.size.width - 20, height:height2))
                     
                        delObj2.hLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_From")
                        delObj2.valLbl.text = picAdd
                        delObj2.hLbl.fitText()
                        delObj2.valLbl.fitText()
                        
                        height = height + height2
                        self.deliveryDetailsview.addSubview(delObj2)
                        delObj2.layer.addDashedBorder(edge: UIRectEdge.bottom, color: self.borderColor, thickness: 0.7, true)
                        var height3 = desAdd.height(withConstrainedWidth: width, font: self.viaVLbl.font)
                        if height3 < 40
                        {
                            height3 = 40
                        }
                        let delObj3 = MultiDelDetailsView.init(frame: CGRect(x:10, y: height, width:self.deliveryDetailsview.frame.size.width - 20, height:height3))
                     
                        delObj3.hLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_To")
                        delObj3.valLbl.text = desAdd
                        
                        delObj3.hLbl.fitText()
                        delObj3.valLbl.fitText()
                        
                        height = height + height3
                        self.deliveryDetailsview.addSubview(delObj3)
                        delObj3.layer.addDashedBorder(edge: UIRectEdge.bottom, color: self.borderColor, thickness: 0.7, true)
                        for i in 0..<getArrayObj.count - 1
                        {
                            let item = getArrayObj[i] as! NSDictionary
                            if item.get("iDeliveryFieldId") != "3" && item.get("iDeliveryFieldId") != "2" && item.get("eRequired") != "No"
                            {
                                let width = ((self.deliveryDetailsview.frame.size.width * 35) / 100)
                                var heigh = item.get("vValue").height(withConstrainedWidth: width, font: self.viaVLbl.font)
                                if heigh < 40
                                {
                                    heigh = 40
                                }
                                let delObj = MultiDelDetailsView.init(frame: CGRect(x:10, y: height, width:self.deliveryDetailsview.frame.size.width - 20, height:heigh))
                                delObj.hLbl.text = item.get("vFieldName")
                                if item.get("vValue") == ""
                                {
                                    delObj.valLbl.text = "---"
                                }else
                                {
                                    delObj.valLbl.text = item.get("vValue")
                                }
                                delObj.valLbl.fitText()
                                delObj.hLbl.fitText()
                                
                                height = height + heigh + 15
                                if item.get("iDeliveryFieldId") == "1" || item.get("iDeliveryFieldId") == "7" {
                                    delObj.hLbl.font = UIFont(name: Fonts().semibold, size: 15)
                                    delObj.hLbl.textColor = UIColor.darkText
                                }
                                self.deliveryDetailsview.addSubview(delObj)
                                if i != getArrayObj.count - 2 {
                                    delObj.layer.addDashedBorder(edge: UIRectEdge.bottom, color: self.borderColor, thickness: 0.7, true)
                                }
                            }
                        }
                        if j != deliveryObj.count - 1
                        {
                            let view = UIView.init(frame: CGRect(x:10, y:height, width: self.deliveryDetailsview.frame.size.width - 20, height:1))
                            view.backgroundColor = UIColor.lightGray
                            self.deliveryDetailsview.addSubview(view)
                        }
                    }
                    
                    self.deliveryDetailsViewHeight.constant = height
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                        if msgData.get("eType") == "Multi-Delivery"
                        {
                            
                            //self.pacNameVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: UIColor.gray, thickness: 0.7)
                           // self.pacDetailsVLbl.layer.addDashedBorder(edge: UIRectEdge.bottom, color: UIColor.gray, thickness: 0.7)
                            self.tripViewHeight.constant = self.tripAreaBottomView.frame.maxY + 10
                        }
                        else
                        {
                            self.tripViewHeight.constant = self.tripAreaBottomView.frame.maxY + 10 - 60
                            
                        }
                        
                        self.driverViewHeight.constant = self.driverAreaBottomView.frame.maxY + 10
                        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.tripViewHeight.constant + self.driverViewHeight.constant + 90 + self.deliveryDetailsViewHeight.constant)
                        self.loaderView.isHidden = true
                        self.scrollView.isHidden = false
                    })
                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        self.closeCurrentScreen()
                    })
                    self.loaderView.isHidden = true
                }
                
            }else{
                //                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                //
                //                    self.loadData()
                //                })
                
                //                self.generalFunc.setError(uv: self)
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Please try again later" : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    //                        self.loadData()
                    self.closeCurrentScreen()
                })
                
                self.loaderView.isHidden = true
            }
        })
    }
    
   

}
