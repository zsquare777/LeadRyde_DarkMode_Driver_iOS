//
//  RatingUV.swift
//  DriverApp
//
//  Created by ADMIN on 30/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import GoogleMaps

class RatingUV: UIViewController, OnLocationUpdateDelegate, MyBtnClickDelegate, UITextViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var googleMapContainerView: UIView!
    @IBOutlet weak var ratingBar: RatingView!
    @IBOutlet weak var rateHLbl: MyLabel!
    @IBOutlet weak var commentTextView: KMPlaceholderTextView!
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var nameLbl: MyLabel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var subImageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hLblTopSpace: NSLayoutConstraint!
    
    var tripData:NSDictionary!
    
    var window:UIWindow!
    
    let generalFunc = GeneralFunctions()
    
    var isPageLoaded = false
    
    var getLocation:GetLocation!
    
    var isFirstLocationUpdate = true
    
    var gMapView:GMSMapView!
    
    var rate = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    deinit {
        releaseAllTask()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavigationSensor.getInstance().configSensor(activateDispatch: false)

        window = Application.window!
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "RatingScreenDesign", uv: self, contentView: contentView))

        commentTextView.delegate = self
        backGroundView.backgroundColor = backGroundView.backgroundColor!.withAlphaComponent(0.8)
        imageContainerView.backgroundColor = UIColor(hex:0xE2E2E2).withAlphaComponent(0.7)
        subImageContainerView.backgroundColor = UIColor(hex:0xCBCBCB).withAlphaComponent(0.7)
        
        /** Used for configDriverTripStatus Type */
        GeneralFunctions.saveValue(key: "iTripId", value: "" as AnyObject)
        /** Used for configDriverTripStatus Type */
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.hLblTopSpace.constant = 50
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }

    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoaded == false){
            
            isPageLoaded = true
            
            
            let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: 0.0, longitude: 0.0), zoomLevel:Utils.defaultZoomLevel, mapView:self.gMapView)
            gMapView = GMSMapView.map(withFrame: self.googleMapContainerView.frame, camera: camera)
            if(GeneralFunctions.getDayNightForToday().uppercased() == "NIGHT"){
                self.gMapView.nightMapStyle()
            }else{
                self.gMapView.mapStyle = nil
            }
            //        googleMapContainerView = gMapView
            //        gMapView = GMSMapView()
            gMapView.isMyLocationEnabled = true
            //self.googleMapContainerView.addSubview(gMapView)
            
            setData()
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.imageContainerView.isHidden = false
//                self.imageContainerView.cornerRadius = self.imageContainerView.bounds.width / 2
//                self.subImageContainerView.cornerRadius = self.subImageContainerView.bounds.width / 2
//                self.imageView.cornerRadius = self.imageView.bounds.width / 2
//            })
        }
        UIApplication.shared.isStatusBarHidden = false
        
        
    }
    
//    override func viewDidLayoutSubviews() {
//        UIApplication.shared.isStatusBarHidden = false
//    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATING")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATING")
        
        self.rateHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DRIVER_RATING_TITLE")
        self.commentTextView.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_FEEDBACK")
        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT"))
        
        self.getLocation = GetLocation(uv: self, isContinuous: true)
        self.getLocation.buildLocManager(locationUpdateDelegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)

        self.submitBtn.clickDelegate = self
        self.nameLbl.text = self.tripData!.get("PName").capitalized
//        imageView.sd_setImage(with: URL(string: CommonUtils.user_image_url + GeneralFunctions.getMemberd() + "/" + self.tripData!.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
//        })
//
        imageView.sd_setImage(with: URL(string: "\(CommonUtils.passenger_image_url)\(tripData!.get("PassengerId"))/\(tripData!.get("vImage"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
    }
    
    func onLocationUpdate(location: CLLocation) {
        var currentZoomLevel:Float = self.gMapView.camera.zoom
        
        if(currentZoomLevel < Utils.defaultZoomLevel && isFirstLocationUpdate == true){
            currentZoomLevel = Utils.defaultZoomLevel
        }
        
        
        let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoomLevel:currentZoomLevel, mapView:self.gMapView)
        
        self.gMapView.animate(to: camera)
        
        isFirstLocationUpdate = false
    }
    
    @objc func releaseAllTask(isDismiss:Bool = true){
        
        if(gMapView != nil){
            gMapView!.removeFromSuperview()
            gMapView!.clear()
            gMapView!.delegate = nil
            gMapView = nil
        }
        
        if(self.getLocation != nil){
            self.getLocation!.locationUpdateDelegate = nil
            self.getLocation!.releaseLocationTask()
            self.getLocation = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
        
        
        if(isDismiss){
            self.dismiss(animated: false, completion: nil)
            self.navigationController?.dismiss(animated: false, completion: nil)
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.submitBtn){
            
            if(self.ratingBar.rating > 0.0){
                self.rate = "\(self.ratingBar.rating)"
                submitRating()
            }else{
                self.rate = "5.0"
                submitRating()
             //   Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ERROR_RATING_DIALOG_TXT"), uv: self)
            }
        }
    }
    
    func submitRating(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        var parameters = [String:String]()
        if (userProfileJson.get("eSystem") == "DeliverAll"){
            parameters = ["type":"submitRating","iGeneralUserId": GeneralFunctions.getMemberd(), "eFromUserType": Utils.appUserType, "tripID": tripData!.get("TripId"), "rating": self.rate, "message": "\(commentTextView.text!)" , "iOrderId" : self.tripData.get("iOrderId") , "eToUserType" : Utils.passengerAppType, "eSystem":"DeliverAll", "iMemberId": GeneralFunctions.getMemberd()]
        }else{
            parameters = ["type":"submitRating","iGeneralUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "tripID": tripData!.get("TripId"), "rating": self.rate, "message": "\(commentTextView.text!)"]
        }
       
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.loadTripFinishView(eType: dataDict.get("eType"))
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func loadTripFinishView(eType:String){
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
           var title = self.generalFunc.getLanguageLabel(origValue: "", key: self.tripData!.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_JOB_FINISHED" : (self.tripData!.get("eType").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || self.tripData.get("eType") == "Multi-Delivery" ? "LBL_DELIVERY_SUCCESS_FINISHED" : "LBL_SUCCESS_FINISHED"))
            var desc = self.generalFunc.getLanguageLabel(origValue: "", key: self.tripData!.get("eType").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || self.tripData.get("eType") == "Multi-Delivery" ? "LBL_DELIVERY_FINISHED_TXT" : (self.tripData!.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_JOB_FINISHED_TXT" : "LBL_TRIP_FINISHED_TXT"))
        
        if (userProfileJson.get("eSystem") == "DeliverAll"){
            title =   self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_SUCCESS_FINISHED_DRDL")
            desc = self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_FINISHED_DELIVERY_TXT")
        }
        
        let opnTripFinishView = OpenTripFinishView(uv: self)
        opnTripFinishView.isFromSuccessTrip = true
        opnTripFinishView.show(title: title, Desc: desc, handler: {
            self.tripFinishOkTapped()
        })
        
    }
    @objc  
    func tripFinishOkTapped(){
        
        releaseAllTask()
        
        let getUserData = GetUserData(uv: self, window: self.window!)
        getUserData.getdata()
    }

    //MARK:- TextView Delegate Method
    func textViewDidEndEditing(_ textView: UITextView) {
        UIApplication.shared.isStatusBarHidden = true
        UIApplication.shared.isStatusBarHidden = false
    }
}
