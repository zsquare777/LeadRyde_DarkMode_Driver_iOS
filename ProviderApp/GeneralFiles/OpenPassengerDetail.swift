//
//  OpenPassengerDetail.swift
//  DriverApp
//
//  Created by ADMIN on 27/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class OpenPassengerDetail: NSObject {
    
    var uv:UIViewController!
    
    let generalFunc = GeneralFunctions()
    
    var tripData:NSDictionary!
    
    var bgView:UIView!
    var passengerDetailView:UIView!
    
    var currInst:OpenPassengerDetail!
    var containerView:UIView!
    var navZposition:CGFloat = 0

    init(uv:UIViewController, containerView:UIView){
        self.uv = uv
        self.containerView = containerView
        super.init()
    }
    
    func showDetail(){
    
        let passengerDetailView = self.generalFunc.loadView(nibName: "OpenPassengerDetailView", uv: self.uv, isWithOutSize: true)
        
        let width = Application.screenSize.width  > 385 ? 365 : Application.screenSize.width - 50
        passengerDetailView.frame.size = CGSize(width: width, height: 310)
        passengerDetailView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.7
        bgView.isUserInteractionEnabled = true
        let bgViewTapGue = UITapGestureRecognizer()
        bgView.frame = CGRect(x:0, y:0, width:Application.screenSize.width, height: Application.screenSize.height)
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        bgViewTapGue.addTarget(currInst, action: #selector(currInst.closeView))
        self.bgView = bgView
        bgView.addGestureRecognizer(bgViewTapGue)
        
        self.passengerDetailView = passengerDetailView
        passengerDetailView.layer.shadowOpacity = 0.5
        passengerDetailView.layer.shadowOffset = CGSize(width: 0, height: 3)
        passengerDetailView.layer.shadowColor = UIColor.black.cgColor

        
        let currentWindow = Application.window
        
        if(self.uv == nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(passengerDetailView)
        }else if(self.uv.navigationController != nil){
            self.uv.navigationController?.view.addSubview(bgView)
            self.uv.navigationController?.view.addSubview(passengerDetailView)
            
            navZposition = self.uv.navigationController!.navigationBar.layer.zPosition
            self.uv.navigationController?.navigationBar.layer.zPosition = -1
            
            passengerDetailView.tag = Utils.ALERT_DIALOG_CONTENT_TAG
            bgView.tag = Utils.ALERT_DIALOG_BG_TAG
        }else{
            self.uv.view.addSubview(bgView)
            self.uv.view.addSubview(passengerDetailView)
        }
        
        let bgCornerView = passengerDetailView.viewWithTag(10) as! UIView
        let imgBGView = passengerDetailView.viewWithTag(110) as! UIView
        let callView = passengerDetailView.viewWithTag(40) as! UIView
        let messageView = passengerDetailView.viewWithTag(50) as! UIView
        let nameLable = passengerDetailView.viewWithTag(20) as! MyLabel
        let totalRatingLable = passengerDetailView.viewWithTag(31) as! MyLabel
        let callLable = passengerDetailView.viewWithTag(42) as! MyLabel
        let MessageLable = passengerDetailView.viewWithTag(52) as! MyLabel
        let profileImageView = passengerDetailView.viewWithTag(100) as! UIImageView
        let callImageView = passengerDetailView.viewWithTag(41) as! UIImageView
        let messageImageView = passengerDetailView.viewWithTag(51) as! UIImageView
        let cancel = passengerDetailView.viewWithTag(5) as! UIImageView

        cancel.image = UIImage(named:"ic_cancel_forgotpass")!.resize(toHeight: 20)?.resize(toWidth: 20)
        let ratingView = passengerDetailView.viewWithTag(30) as! RatingView
        callView.backgroundColor =  UIColor.UCAColor.AppThemeColor
        messageView.borderColor =  UIColor.UCAColor.AppThemeColor
        messageView.borderWidth = 1
        
        Utils.createRoundedView(view: bgCornerView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        callLable.textColor =  UIColor.UCAColor.AppThemeTxtColor
        
        nameLable.text = self.tripData!.get("PName").capitalized
        totalRatingLable.text = Configurations.convertNumToAppLocal(numStr: self.tripData!.get("PRating"))
        callLable.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_TXT").uppercased()
        MessageLable.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MESSAGE_TXT").uppercased()

        imgBGView.addShadowWithCornerRadius(cornerRadius: imgBGView.bounds.width/2, .black, 0.9, fillColor: .clear)
        imgBGView.backgroundColor = .clear
        
        profileImageView.sd_setImage(with: URL(string: "\(CommonUtils.passenger_image_url)\(tripData!.get("PassengerId"))/\(tripData!.get("PPicName"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        ratingView.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.tripData!.get("PRating"))
        
        GeneralFunctions.setImgTintColor(imgView: callImageView, color: .white)
        GeneralFunctions.setImgTintColor(imgView: messageImageView, color: UIColor.UCAColor.AppThemeColor)
        
        cancel.setOnClickListener { (view) in
            self.closeView()
        }
        
        callView.setOnClickListener { (view) in
            self.getMaskedNumber()
        }
        
        messageView.setOnClickListener { (view) in
            self.msgTapped()
        }
        
        if (self.tripData!.get("eBookingFrom").uppercased() == "KIOSK"){
            //(passengerDetailView.subviews[7].subviews[1]).isHidden = true
            
        }
    }

    @objc func closeView(){
    
        bgView.removeFromSuperview()
        passengerDetailView.removeFromSuperview()
        
        if(self.uv != nil){
            self.uv.navigationController?.navigationBar.layer.zPosition = navZposition
        }
    }
    
    func callTapped(phoneNumber:String){
        let number = "\(phoneNumber)"
        //UIApplication.shared.openURL(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
        UIApplication.shared.open(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL, options: [:], completionHandler: nil)
    }
    
    @objc func getMaskedNumber(){
        
        if (self.tripData!.get("eBookingFrom").uppercased() == "KIOSK"){
            self.callTapped(phoneNumber: "\(self.tripData!.get("PPhone"))")
            return
        }
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
        if userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
            //if SinchCalling.getInstance().client.isStarted(){
                
                let selfDic = ["Id":userProfileJson.get("iDriverId"), "Name": userProfileJson.get("vName"), "PImage": userProfileJson.get("vImage"), "type": Utils.appUserType]
                let assignedDic = ["Id":self.tripData.get("PassengerId"), "Name": self.tripData.get("PName"), "PImage": self.tripData.get("PPicName"), "type": "Passenger"]
            
            var phone = ""
            if(self.tripData.get("iGcmRegId") == ""){
                phone = self.tripData.get("vPhone")
            }
                SinchCalling.getInstance().makeACall(IDString:"Passenger" + "_" + self.tripData.get("PassengerId"), assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:phone)
                return
                
                
            //}
        }
        
        var loaderContainerView = passengerDetailView
        if(self.uv.navigationController != nil){
            loaderContainerView = self.uv.navigationController!.view
        }
        
        //if(userProfileJson.get("CALLMASKING_ENABLED").uppercased() == "YES"){
            let parameters = ["type":"getCallMaskNumber","iTripid": self.tripData!.get("TripId"), "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: loaderContainerView!, isOpenLoader: true)
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.callTapped(phoneNumber: dataDict.get(Utils.message_str))
                    }else{
                        self.callTapped(phoneNumber: "\(self.tripData!.get("PPhone"))")
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self.uv)
                }
            })
       // }else{
       //     self.callTapped(phoneNumber: "\(self.tripData!.get("PPhone"))")
       // }
        
    }
    
    @objc func msgTapped(){

        if (self.tripData!.get("eBookingFrom").uppercased() == "KIOSK"){
            UIApplication.shared.openURL(NSURL(string:"sms:" + "\(self.tripData!.get("PPhone"))")! as URL)
            return
        }
        closeView()
        
        let chatUV = GeneralFunctions.instantiateViewController(pageName: "MessagesViewController") as! MessagesViewController
        chatUV.receiverId = tripData!.get("PassengerId")
        chatUV.receiverDisplayName = self.tripData!.get("PName")
        chatUV.assignedtripId = self.tripData!.get("TripId")
        chatUV.pPicName = self.tripData!.get("PPicName")
//        chatUV.serviceTripType = self.tripData!.get("vServiceTitle")
        chatUV.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.tripData!.get("PRating"))
        chatUV.bookingNo = self.tripData!.get("vRideNo")
        chatUV.assignedtripDate  = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.tripData!.get("tTripRequestDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
        self.uv.pushToNavController(uv:chatUV, isDirect: true)
        
    }
}
