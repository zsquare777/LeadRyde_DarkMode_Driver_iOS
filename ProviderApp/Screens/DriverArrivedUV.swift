//
//  DriverArrivedUV.swift
//  DriverApp
//
//  Created by ADMIN on 26/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class DriverArrivedUV: UIViewController, GMSMapViewDelegate, OnLocationUpdateDelegate, MyBtnClickDelegate, DispatchDemoLocationsProtocol, MySliderBtnClickDelegate, OTPDelegate, MyTxtFieldOnTextChangeDelegate {
    
    var MENU_USER_OR_DELIVERY_DETAIL = "0"
    var MENU_CANCEL_TRIP_OR_DELIVERY = "1"
    var MENU_WAY_BILL = "2"
    var MENU_SPECIAL_INS = "3"
    var MENU_USER_NOTE = "4"
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var googleMapContainerView: UIView!

    @IBOutlet weak var topDataContainerStkView: UIStackView!
    @IBOutlet weak var topDataContainerViewHeight: NSLayoutConstraint!
    
    /*TopHederView Related Create IBOutlet*/
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topContainerViewHeight: NSLayoutConstraint!
    
    /*BottomView Related Create IBOutlet*/
    @IBOutlet weak var bottomDetailsView: UIView!
    @IBOutlet weak var bottomDetailsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pickUpHLbl: MyLabel!
    @IBOutlet weak var pickUpHLblHeight: NSLayoutConstraint!
    @IBOutlet weak var userNameLbl: MyLabel!
    @IBOutlet weak var userRatingView: RatingView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var callImgView: UIImageView!
    @IBOutlet weak var chatImgView: UIImageView!
    @IBOutlet weak var navigationImgView: UIImageView!
    @IBOutlet weak var timeLbl: MyLabel!
    @IBOutlet weak var distanceLbl: MyLabel!
    @IBOutlet weak var numberOfPersonLbl: MyLabel!
    
    /*SlideArrivedBtn Related Create IBOutlet*/
    @IBOutlet weak var slideArrivedBtn: MySliderButton!
    
    @IBOutlet weak var arrivedBtn: MyButton!
    @IBOutlet weak var emeImgView: UIImageView!
    
    // Multi-Delivery
    @IBOutlet weak var deliveryDetailsView: UIView!
    @IBOutlet weak var deliveryDetailsImgView: UIImageView!
    @IBOutlet weak var recHLbl: UILabel!
    @IBOutlet weak var recNameValLbl: UILabel!
    @IBOutlet weak var noOfPersonLbl: UILabel!
    @IBOutlet weak var deliveryView: UIView!
    
    @IBOutlet weak var dialogueView: UIView!
    
    @IBOutlet weak var jobView: UIView!
    
    @IBOutlet weak var adminCallView: UIView!
    @IBOutlet weak var adminCallImgView: UIView!
    
    let generalFunc = GeneralFunctions()
    
    var isPageLoaded = false
    
    var currentLocation:CLLocation!
    var currentRotatedLocation:CLLocation!
    var currentHeading:Double = 0
    var isFirstHeadingCompleted = false
    
    var gMapView:GMSMapView!
    
    var topNavView:navigationVIew!
    
    /* Instance of TopHeaderView set for TopNavigationView */
    var topNavigationView:NavigateView!
    
    var window:UIWindow!
    
    var getLocation:GetLocation!
    
    var isFirstLocationUpdate = true
    
    var tripData:NSDictionary!
    
    var menu:BTNavigationDropdownMenu!
    
    var updateDriverLoc:UpdateDriverLocations!
    
    var updateDirections:UpdateDirections!
    
    let driverMarker: GMSMarker = GMSMarker()
    let passengerMarker: GMSMarker = GMSMarker()
    
    var locationDialog:OpenLocationEnableView!
    
    var userProfileJson:NSDictionary!
//    var locationArr = [CLLocation]()
    
    var iphoneXBottomView:UIView!
    var isSafeAreaSet = false
    
    var ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP = ""
    
    var currentDestination:CLLocation!
    
    var PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT:Double = 5
    
    var lastPublishedLoc:CLLocation!
    
    var dispatchDemoLocations:DispatchDemoLocations!
    
    // SERVICE OTP CONFIRMATION
    var jobOTPVerificationView:JobOTPVerificationView!
    var bgViewForOTP:UIView!
    var isKeyboardOpen = false
    var isOTPVerificationDone = false
    var otp_str = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
       // (UIApplication.shared.delegate as! AppDelegate).configureOnlineState(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(updateDirections != nil){
            updateDirections.pauseDirectionUpdate()
        }
        
        NavigationSensor.getInstance().configSensor(activateDispatch: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as? AppDelegate)?.startPIPMode()
        
        self.navigationController?.navigationBar.layer.zPosition = -1
        
        NavigationSensor.getInstance().configSensor(activateDispatch: true)
        
        if(updateDirections != nil){
            updateDirections.startDirectionUpdate()
        }
        
        if(isPageLoaded == false){
            
            isPageLoaded = true
            
            
            let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: 0.0, longitude: 0.0), zoomLevel:0.0, mapView:self.gMapView)
            gMapView = GMSMapView.map(withFrame: self.googleMapContainerView.frame, camera: camera)
            
            // Apply dark/light map style based on theme
            let themeManager = ThemeManager.shared
            if themeManager.isDarkModeActive {
                self.gMapView.nightMapStyle()
            } else {
                self.gMapView.mapStyle = nil
            }
            //        googleMapContainerView = gMapView
            //        gMapView = GMSMapView()
//            gMapView.isMyLocationEnabled = true
            gMapView.settings.rotateGestures = true
            gMapView.settings.tiltGestures = true
            gMapView.delegate = self
            self.googleMapContainerView.addSubview(gMapView)
            
            self.gMapView.bindFrameToSuperviewBounds()
            
            if(self.tripData.get("eServiceLocation").uppercased() != "DRIVER"){
//                topNavView = navigationVIew(frame: CGRect(x:0, y:0, width: Application.screenSize.width, height: 95))
//                topNavView.backgroundColor = UIColor.clear
//
//                topDataContainerStkView.addArrangedSubview(topNavView)
//                topDataContainerViewHeight.constant = 95
               
                /* Initializing for TopNavigationView */
                
                topNavigationView = NavigateView(frame: CGRect(x:0, y:0, width: Application.screenSize.width, height: 90))
                topNavigationView.backgroundColor = UIColor.clear
                self.topContainerView.addSubview(topNavigationView)
                self.topContainerView.backgroundColor = UIColor.clear
                self.topContainerViewHeight.constant = 80
            }
            setData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        window = Application.window!
        
        Utils.driverMarkersPositionList.removeAll()
        Utils.driverMarkerAnimFinished = true
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "DriverArrivedScreenDesign", uv: self, contentView: contentView))
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        /** Used for configDriverTripStatus Type */
        GeneralFunctions.saveValue(key: "iTripId", value: self.tripData!.get("TripId") as AnyObject)
        /** Used for configDriverTripStatus Type */
        
        self.emeImgView.isHidden = true
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT = GeneralFunctions.parseDouble(origValue: 5, data: GeneralFunctions.getValue(key: Utils.PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT_KEY) as! String)

        ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP = GeneralFunctions.getValue(key: Utils.ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP_KEY) as! String
        
        /** If set to BottomDetailsView Height */
            self.pickUpHLbl.isHidden = true
        /** If set to BottomDetailsView Height */
        
        if(GeneralFunctions.getValue(key: "OPEN_MSG_SCREEN") != nil && (GeneralFunctions.getValue(key: "OPEN_MSG_SCREEN") as! String) == "true") {
            
            GeneralFunctions.removeValue(key: "OPEN_MSG_SCREEN")
            
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
            
        }
        
        if(self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery") {
            self.deliveryDetailsView.isHidden = false
            
//            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.UCAColor.AppThemeColor)
            self.deliveryDetailsView.isUserInteractionEnabled = true
            let detailsBtnTapGue = UITapGestureRecognizer()
            detailsBtnTapGue.addTarget(self, action: #selector(self.deliveryDetailsTapped))
            self.deliveryDetailsView.addGestureRecognizer(detailsBtnTapGue)

            let testUIBarButtonItem = UIBarButtonItem.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_CANCEL_TXT"), style: .plain, target: self, action: #selector(self.cancelDeliveryTapped))
            self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        }
        
        /* Pool Ride Bootom View*/
        if(self.tripData.get("ePoolRide").uppercased() == "YES") {
            
            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.UCAColor.AppThemeTxtColor)
            self.deliveryDetailsView.isUserInteractionEnabled = true
            let detailsBtnTapGue = UITapGestureRecognizer()
            detailsBtnTapGue.addTarget(self, action: #selector(self.deliveryDetailsTapped))
            self.deliveryDetailsView.addGestureRecognizer(detailsBtnTapGue)
            
            /* Hide DeliveryView View */
            self.deliveryView.isHidden = true
            self.recHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICKUP").uppercased()
            self.recNameValLbl.text = self.tripData.get("PName") + " " + self.tripData.get("vLastName")
            self.noOfPersonLbl.text = Configurations.convertNumToAppLocal(numStr:self.tripData.get("iPersonSize")) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSON")

            self.bottomDetailsViewHeight.constant = 120
            
            self.pickUpHLbl.isHidden = false
            self.numberOfPersonLbl.isHidden = false

            self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICKUP").uppercased()
            self.pickUpHLbl.fontFamilyWeight = "Bold"
            self.pickUpHLbl.setFontFamily()
            
            self.numberOfPersonLbl.text = Configurations.convertNumToAppLocal(numStr:self.tripData.get("iPersonSize")) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSON")
        }
        /* Pool Request Setup*/
        
        
//        /* MSP Changes*/
//        if(self.tripData.get("iStopId").uppercased() != ""){
//
//            self.deliveryDetailsImgView.isHidden = false
//            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.white)
//            self.deliveryDetailsImgView.isUserInteractionEnabled = true
//            let detailsBtnTapGue = UITapGestureRecognizer()
//            detailsBtnTapGue.addTarget(self, action: #selector(self.deliveryDetailsTapped))
//            self.deliveryDetailsImgView.addGestureRecognizer(detailsBtnTapGue)
//
//        }/* ........*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
        // Apply initial theme
        applyTheme()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if(self.isKeyboardOpen == false){
                self.isKeyboardOpen = true
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if(self.isKeyboardOpen == true){
                self.isKeyboardOpen = false
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            
            if(Configurations.isIponeXDevice() || UIDevice().typeApp == .iPhone12Pro || UIDevice().typeApp == .iPhone12ProMax ||  UIDevice().typeApp == .iPhone12 ||  UIDevice().typeApp == .iPhone12Mini || UIDevice().typeApp == .iPhone11 || UIDevice().typeApp == .iPhone11Pro || UIDevice().typeApp == .iPhone11ProMax || UIDevice.current.userInterfaceIdiom == .pad){
                
                if(iphoneXBottomView == nil) {
                    iphoneXBottomView = UIView()
                    self.view.addSubview(iphoneXBottomView)
                }
                
                // Keep theme color for bottom view (branded)
                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.iphoneXBottomView.frame = CGRect(x: 0, y: self.contentView.frame.maxY - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: GeneralFunctions.getSafeAreaInsets().bottom)
                }
            }
            
            isSafeAreaSet = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ThemeManager.themeDidChangeNotification, object: nil)
        releaseAllTask()
    }
    
    @objc func themeDidChange() {
        applyTheme()
    }
    
    func applyTheme() {
        let themeManager = ThemeManager.shared
        
        // 1. Main backgrounds
        self.view.backgroundColor = themeManager.backgroundColor()
        self.contentView.backgroundColor = themeManager.backgroundColor()
        self.googleMapContainerView.backgroundColor = themeManager.backgroundColor()
        
        // 2. Apply map style based on theme
        if self.gMapView != nil {
            if themeManager.isDarkModeActive {
                self.gMapView.nightMapStyle()
            } else {
                self.gMapView.mapStyle = nil
            }
        }
        
        // 3. Bottom details view - Google Wallet-inspired dark styling
        if themeManager.isDarkModeActive {
            // Dark mode: Use dark card background with subtle border
            self.bottomDetailsView?.backgroundColor = themeManager.cardBackgroundColor()
            self.bottomDetailsView?.layer.shadowColor = UIColor.black.cgColor
            self.bottomDetailsView?.layer.shadowOpacity = 0.6
            self.bottomDetailsView?.layer.shadowRadius = 8
            self.bottomDetailsView?.layer.shadowOffset = CGSize(width: 0, height: -2)
            
            // Add subtle border for depth
            self.bottomDetailsView?.layer.borderColor = themeManager.borderColor().cgColor
            self.bottomDetailsView?.layer.borderWidth = 0.5
        } else {
            // Light mode: Keep white background with light shadow
            self.bottomDetailsView?.backgroundColor = UIColor.white
            self.bottomDetailsView?.layer.shadowColor = UIColor.lightGray.cgColor
            self.bottomDetailsView?.layer.shadowOpacity = 0.9
            self.bottomDetailsView?.layer.shadowRadius = 3
            self.bottomDetailsView?.layer.shadowOffset = CGSize.zero
            
            // Remove border in light mode
            self.bottomDetailsView?.layer.borderWidth = 0
        }
        
        // 4. Text labels (primary)
        self.pickUpHLbl?.textColor = themeManager.textColor()
        self.userNameLbl?.textColor = themeManager.textColor()
        self.timeLbl?.textColor = themeManager.secondaryTextColor()
        self.distanceLbl?.textColor = themeManager.secondaryTextColor()
        self.numberOfPersonLbl?.textColor = themeManager.secondaryTextColor()
        
        // 5. Multi-delivery related labels (UILabel outlets)
        self.recHLbl?.textColor = themeManager.textColor()
        self.recNameValLbl?.textColor = themeManager.textColor()
        self.noOfPersonLbl?.textColor = themeManager.secondaryTextColor()
        
        // 6. Action button containers (keep their existing colors - don't theme)
        // These use brand colors and should remain consistent
        // self.callView, self.chatView, self.navigationView already set
        
        // 7. Delivery details view background (card-style)
        if self.deliveryDetailsView != nil && !self.deliveryDetailsView.isHidden {
            self.deliveryDetailsView?.backgroundColor = themeManager.isDarkModeActive ? 
                themeManager.cardBackgroundColor() : UIColor.white
            
            // Add subtle border in dark mode
            if themeManager.isDarkModeActive {
                self.deliveryDetailsView?.layer.borderColor = themeManager.borderColor().cgColor
                self.deliveryDetailsView?.layer.borderWidth = 0.5
            } else {
                self.deliveryDetailsView?.layer.borderWidth = 0
            }
        }
        
        // 8. Dialogue and job views (keep their existing background colors)
        // self.dialogueView and self.jobView use brand colors - don't theme
        
        // 9. Update icon tint colors for better visibility
        if themeManager.isDarkModeActive {
            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.white)
        } else {
            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }
        
        // 10. OTP verification view if present
        if self.jobOTPVerificationView != nil {
            self.jobOTPVerificationView.backgroundColor = themeManager.isDarkModeActive ? 
                themeManager.cardBackgroundColor() : UIColor.white
            
            // Add border in dark mode for better definition
            if themeManager.isDarkModeActive {
                self.jobOTPVerificationView.layer.borderColor = themeManager.borderColor().cgColor
                self.jobOTPVerificationView.layer.borderWidth = 0.5
            } else {
                self.jobOTPVerificationView.layer.borderWidth = 0
            }
        }
        
        // 11. Background view for OTP (semi-transparent overlay)
        if self.bgViewForOTP != nil {
            self.bgViewForOTP.backgroundColor = themeManager.isDarkModeActive ? 
                UIColor.black.withAlphaComponent(0.7) : 
                UIColor.black.withAlphaComponent(0.5)
        }
        
        // 12. Top navigation view (if present)
        if self.topNavigationView != nil {
            // Keep the app theme color but adjust shadow
            self.topNavigationView.navContaintView.layer.shadowColor = themeManager.isDarkModeActive ? 
                UIColor.black.cgColor : UIColor.lightGray.cgColor
            self.topNavigationView.navContaintView.layer.shadowOpacity = themeManager.isDarkModeActive ? 0.8 : 0.6
        }
        
        // 13. Top container background (if applicable)
        if self.topContainerView != nil {
            self.topContainerView.backgroundColor = UIColor.clear
        }
        
        print("✅ DriverArrivedUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
    }

    func setData(){
        if(self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery") {
//            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICKUP_DELIVERY")
//            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICKUP_DELIVERY")
            let customTitle = UILabel()
                customTitle.text = self.generalFunc.getLanguageLabel(
                    origValue: "",
                    key: "LBL_PICKUP_DELIVERY"
                ).uppercased()
                
                customTitle.font = UIFont.boldSystemFont(ofSize: 19)
                customTitle.textColor = .white
                customTitle.sizeToFit()
                
                self.navigationItem.titleView = customTitle
        }else if(self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX) {
//            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_JOB_LOCATION_TXT")
//            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_JOB_LOCATION_TXT")
            let customTitle = UILabel()
                customTitle.text = self.generalFunc.getLanguageLabel(
                    origValue: "",
                    key: "LBL_JOB_LOCATION_TXT"
                ).uppercased()
                
                customTitle.font = UIFont.boldSystemFont(ofSize: 19)
                customTitle.textColor = .white
                customTitle.sizeToFit()
                
                self.navigationItem.titleView = customTitle
        }else{
//            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICK_UP_PASSENGER")
//            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICK_UP_PASSENGER")
            let customTitle = UILabel()
                customTitle.text = self.generalFunc.getLanguageLabel(
                    origValue: "",
                    key: "LBL_PICK_UP_PASSENGER"
                ).uppercased()
                
                customTitle.font = UIFont.boldSystemFont(ofSize: 19)
                customTitle.textColor = .white
                customTitle.sizeToFit()
                
                self.navigationItem.titleView = customTitle

        }
        
        if(self.userProfileJson.getObj("TripDetails").get("eType") != "Multi-Delivery"){
            let rightButton = UIBarButtonItem(image: UIImage(named: "ic_menu")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openPopUpMenu))
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        /* Hide ArrivedBtn */
        self.arrivedBtn.isHidden = true
        self.arrivedBtn.clickDelegate = self
        
        /* If set to Delegate SlideArrivedBtn */
        self.slideArrivedBtn.clickDelegate = self
        
        if(ConfigPubNub.getInstance(isCheck: true) != nil) {
            ConfigPubNub.getInstance().unSubscribeToCabReqChannel()
        }
        
        ConfigPubNub.getInstance().buildPubNub()
        
        
        if(self.tripData.get("ePoolRide").uppercased() == "YES") {
            /* If set to ButtonTitle for SlideArrivedBtn */
            self.slideArrivedBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_POOL_MARK_AS_PICKUP"))
           
            if(self.slideArrivedBtn.button != nil) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    /* If set to ButtonImageEdgeInsets for SlideArrivedBtn */
                    self.slideArrivedBtn.button!.imageEdgeInsets.left = 25
                    self.slideArrivedBtn.button!.imageEdgeInsets.right = 25
                    
                    /* If set to ButtonTitleEdgeInsets for SlideArrivedBtn */
                    self.slideArrivedBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 100 : 100) : (Configurations.isRTLMode() ? 45 : 85)
                    self.slideArrivedBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 100 : 100) : (Configurations.isRTLMode() ? 85 : 45)
                }
                
                self.slideArrivedBtn.button!.titleLabel?.lineBreakMode = .byWordWrapping
                self.slideArrivedBtn.button!.titleLabel?.numberOfLines = 2
                self.slideArrivedBtn.button!.titleLabel?.adjustsFontSizeToFitWidth = true
                self.slideArrivedBtn.button!.titleLabel?.minimumScaleFactor = 0.6
                self.slideArrivedBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeTxtColor, bgColor: UIColor.UCAColor.AppThemeColor, pulseColor: UIColor.UCAColor.AppThemeColor)
                
                if(iphoneXBottomView != nil){
                    iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
                }
            }
            
            ConfigPubNub.getInstance().subscribeToCabReqChannel()
        }else{
            /* If set to ButtonTitle for SlideArrivedBtn */
            
            self.slideArrivedBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: self.tripData.get("eServiceLocation").uppercased() != "DRIVER" ? "LBL_SLIDE_TO_ARRIVE" : "LBL_MARK_USER_ARRIVED_BTN_TITLE"))
            self.slideArrivedBtn.setBoldTitle(true)
           
            if(self.tripData!.get("eFly").uppercased() == "YES"){
                self.slideArrivedBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_ARRIVED"))
            }
            
            if(self.slideArrivedBtn.button != nil) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    /* If set to ButtonImageEdgeInsets for SlideArrivedBtn */
                    self.slideArrivedBtn.button!.imageEdgeInsets.left = 25
                    self.slideArrivedBtn.button!.imageEdgeInsets.right = 25
                    
                    self.slideArrivedBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 100 : 100) : (Configurations.isRTLMode() ? 45 : 75)
                    self.slideArrivedBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 100 : 100) : (Configurations.isRTLMode() ? 75 : 45)
                }
 
                self.slideArrivedBtn.button!.titleLabel?.lineBreakMode = .byWordWrapping
                self.slideArrivedBtn.button!.titleLabel?.numberOfLines = 2
                self.slideArrivedBtn.button!.titleLabel?.adjustsFontSizeToFitWidth = true
                self.slideArrivedBtn.button!.titleLabel?.minimumScaleFactor = 0.6

//                self.slideArrivedBtn.Reset()
            }
        }
        
        self.getLocation = GetLocation(uv: self, isContinuous: true)
        self.getLocation.buildLocManager(locationUpdateDelegate: self)
        
        if(userProfileJson.get("eEnableDemoLocDispatch").uppercased() == "YES") {
            dispatchDemoLocations = DispatchDemoLocations()
            dispatchDemoLocations.startDispatchingLocations(delegate: self)
        }
        
//        if(self.topNavView != nil){
//            self.topNavView.navigateLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NAVIGATE")
//            self.topNavView.navOptionView.backgroundColor = UIColor.UCAColor.AppThemeColor_1
//            //        self.navView.subviews[0].subviews[1].subviews[0].backgroundColor = UIColor(hex: 0xFFFFFF)
//            GeneralFunctions.setImgTintColor(imgView: self.topNavView.navImgView, color: UIColor.UCAColor.AppThemeTxtColor_1)
//            self.topNavView.navigateLbl.textColor = UIColor.UCAColor.AppThemeTxtColor_1
//
//            let navViewTapGue = UITapGestureRecognizer()
//            navViewTapGue.addTarget(self, action: #selector(self.navViewTapped))
//            self.topNavView.navOptionView.isUserInteractionEnabled = true
//            self.topNavView.navOptionView.addGestureRecognizer(navViewTapGue)
//        }
        
        /* If set to BackgroundColor for TopNavigationView */
        if(self.topNavigationView != nil) {
            let themeManager = ThemeManager.shared
            self.topNavigationView.topHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
            self.topNavigationView.navContaintView.layer.shadowOpacity = 0.6
            self.topNavigationView.navContaintView.layer.shadowOffset = CGSize.zero
            self.topNavigationView.navContaintView.layer.shadowColor = themeManager.isDarkModeActive ? UIColor.black.cgColor : UIColor.lightGray.cgColor
        }
        
        initializeMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
        let passengerLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("sourceLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("sourceLongitude")))
        
        if(self.tripData.get("eServiceLocation").uppercased() != "DRIVER") {
//            updateDirections = UpdateDirections(uv: self, gMap: gMapView, destinationLocation: passengerLocation, navigateView: topNavView)
            
            updateDirections = UpdateDirections(uv: self, gMap: gMapView, destinationLocation: passengerLocation, navigateView: topNavigationView)
            updateDirections.scheduleDirectionUpdate(eTollSkipped: "")
        }
        
        self.addPassengerMarker(location: passengerLocation)
        
        self.emeImgView.isUserInteractionEnabled = true
        
        self.emeImgView.isHidden = false
        let emeTapGue = UITapGestureRecognizer()
        emeTapGue.addTarget(self, action: #selector(self.emeImgViewTapped))
        self.emeImgView.addGestureRecognizer(emeTapGue)
        
        /* If set to Data in BottomDetailsView */
        let themeManager = ThemeManager.shared
        
        // Apply theme-aware shadow styling
        if themeManager.isDarkModeActive {
            self.bottomDetailsView.layer.addShadow(opacity: 0.6, radius: 8, UIColor.black)
            self.bottomDetailsView.layer.borderColor = themeManager.borderColor().cgColor
            self.bottomDetailsView.layer.borderWidth = 0.5
        } else {
            self.bottomDetailsView.layer.addShadow(opacity: 0.9, radius: 3, UIColor.lightGray)
            self.bottomDetailsView.layer.borderWidth = 0
        }
        self.bottomDetailsView.layer.roundCorners(radius: 15)

        self.callView.backgroundColor = UIColor.UCAColor.CallImageBGColor
        self.chatView.backgroundColor = UIColor.UCAColor.ChatImageBGColor
        self.navigationView.backgroundColor = UIColor.UCAColor.NavigateImageBGColor
        self.dialogueView.backgroundColor = UIColor.UCAColor.noteView
        self.jobView.backgroundColor = UIColor.UCAColor.jobView
        self.adminCallView.backgroundColor = UIColor.UCAColor.callToAdminView
        
        // Apply theme-aware icon tints (always white as they're on colored backgrounds)
        GeneralFunctions.setImgTintColor(imgView: self.callImgView, color: UIColor.white)
        GeneralFunctions.setImgTintColor(imgView: self.chatImgView, color: UIColor.white)
        GeneralFunctions.setImgTintColor(imgView: self.navigationImgView, color: UIColor.white)
        
        if(self.tripData!.get("eHailTrip").uppercased() == "YES"){
            self.userNameLbl.text = self.tripData.get("PName")
        }else{
            self.userNameLbl.text = self.tripData.get("PName") //+ " " + self.tripData.get("vLastName")
        }

        self.userRatingView.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.tripData!.get("PRating"))
        
        let callTapGue = UITapGestureRecognizer()
        callTapGue.addTarget(self, action: #selector(self.getMaskedNumber))
        self.callView.isUserInteractionEnabled = true
        self.callView.addGestureRecognizer(callTapGue)
        
        let chatTapGue = UITapGestureRecognizer()
        chatTapGue.addTarget(self, action: #selector(self.chatTapped))
        self.chatView.isUserInteractionEnabled = true
        self.chatView.addGestureRecognizer(chatTapGue)
        
        let navViewTapGue = UITapGestureRecognizer()
        navViewTapGue.addTarget(self, action: #selector(self.navViewTapped))
        self.navigationView.isUserInteractionEnabled = true
        self.navigationView.addGestureRecognizer(navViewTapGue) /* If set to Data in BottomDetailsView */
        
        let jobViewTapGue = UITapGestureRecognizer()
        jobViewTapGue.addTarget(self, action: #selector(self.jobViewTapped))
        self.jobView.isUserInteractionEnabled = true
        self.jobView.addGestureRecognizer(jobViewTapGue)
        
        let dialogueViewTapGue = UITapGestureRecognizer()
        dialogueViewTapGue.addTarget(self, action: #selector(self.dialogueViewTapped))
        self.dialogueView.isUserInteractionEnabled = true
        self.dialogueView.addGestureRecognizer(dialogueViewTapGue)
        
        let adminCallViewTapGue = UITapGestureRecognizer()
        adminCallViewTapGue.addTarget(self, action: #selector(self.adminCallViewTapped))
        self.adminCallView.isUserInteractionEnabled = true
        self.adminCallView.addGestureRecognizer(adminCallViewTapGue)
        
        if(self.tripData!.get("eHailTrip").uppercased() == "YES"){
            self.callView.isHidden = true
            self.chatView.isHidden = true
            self.userRatingView.isHidden = true
        }
        
        checkLocationEnabled()
        
        addBackgroundObserver()
        
        if self.userProfileJson.get("ENABLE_ETA_AT_DRIVER_SIDE").uppercased() == "NO"{
            self.distanceLbl.isHidden = true
            self.timeLbl.isHidden = true
        }
    }
    
    func onDemoLocationDispatch(latitude: Double, longitude: Double) {
        onLocationUpdate(location: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = nil
        return true
    }
    
    func addBackgroundObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
    }
    
    func checkLocationEnabled() {
        if(locationDialog != nil){
            locationDialog.removeView()
            locationDialog = nil
        }
        
        if(GeneralFunctions.hasLocationEnabled() == false || InternetConnection.isConnectedToNetwork() == false) {
            
            locationDialog = OpenLocationEnableView(uv: self, containerView: self.contentView, gMapView: self.gMapView, isMapLocEnabled: false)
            locationDialog.show()
            
            return
        }
    }
    
    @objc func cancelDeliveryTapped() {
       
        let openCancelBooking = OpenCancelBooking(uv: self)
        openCancelBooking.cancelTrip(eTripType: self.tripData!.get("REQUEST_TYPE"), PAGE_TYPE: "", iTripId: self.tripData!.get("TripId"), iCabBookingId: "") { (iCancelReasonId, reason) in
            self.onTripCanceled(iCancelReasonId: iCancelReasonId, reason: reason)
        }
        
    }
    
    @objc func deliveryDetailsTapped() {
        
//        /* MSP Changes*/
//        if(self.tripData.get("iStopId").uppercased() != ""){
//
//            let viewMSPDetailsUV = GeneralFunctions.instantiateViewController(pageName: "ViewMSPDetailsUV") as! ViewMSPDetailsUV
//            viewMSPDetailsUV.tripData = self.tripData
//            self.navigationController?.pushViewController(viewMSPDetailsUV, animated: true)
//            return
//        }/* ..........*/
        
        let viewMultiDeliveryDetailsUV = GeneralFunctions.instantiateViewController(pageName: "ViewMultiDeliveryDetailsUV") as! ViewMultiDeliveryDetailsUV
        viewMultiDeliveryDetailsUV.tripData = NSMutableDictionary(dictionary: self.tripData)
       
        self.navigationController?.pushViewController(viewMultiDeliveryDetailsUV, animated: true)
    }
    
    @objc func appInBackground() {
        if(updateDirections != nil){
            updateDirections.pauseDirectionUpdate()
        }
    }
    
    @objc func appInForground() {
        checkLocationEnabled()
        
        ConfigPubNub.getInstance().unSubscribeToPrivateChannel()
        ConfigPubNub.getInstance().subscribeToPrivateChannel()
        
        if(updateDirections != nil){
            updateDirections.startDirectionUpdate()
        }
    }
    
    @objc func emeImgViewTapped() {
        let confirmEmergencyTapUV = GeneralFunctions.instantiateViewController(pageName: "ConfirmEmergencyTapUV") as! ConfirmEmergencyTapUV
        confirmEmergencyTapUV.iTripId = tripData.get("TripId")
        self.pushToNavController(uv: confirmEmergencyTapUV)
    }
    
    @objc func navViewTapped() {
        let openNavOption = OpenNavOption(uv: self, containerView: self.view, placeLatitude: tripData!.get("sourceLatitude"), placeLongitude: tripData!.get("sourceLongitude"))
        openNavOption.chooseOption()
    }
    
    @objc func jobViewTapped() {
        let wayBillUV = GeneralFunctions.instantiateViewController(pageName: "WayBillUV") as! WayBillUV
        self.pushToNavController(uv: wayBillUV)
    }
    
    @objc func showCustomAlert() {
        
        let customAlertView = UIView()
        customAlertView.backgroundColor = .white
        customAlertView.layer.cornerRadius = 10
        customAlertView.layer.shadowOpacity = 0.3
        customAlertView.layer.shadowRadius = 10
        customAlertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        let alertWidth: CGFloat = self.view.bounds.width - 100
        let alertHeight: CGFloat = 200
        customAlertView.frame = CGRect(x: (self.view.bounds.width - alertWidth) / 2,
                                       y: (self.view.bounds.height - alertHeight) / 3,
                                       width: alertWidth, height: alertHeight)
        
        let imageView = UIImageView(image: UIImage(named: "ic_cancel_forgotpass"))
        imageView.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
        customAlertView.addSubview(imageView)
        
        let label = UILabel()
        label.text = "This is to test the note"
        label.numberOfLines = 0
        label.frame = CGRect(x: 70, y: 30, width: customAlertView.frame.width - 90, height: 100)
        customAlertView.addSubview(label)
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.frame = CGRect(x: customAlertView.frame.width / 2 - 40, y: customAlertView.frame.height - 50, width: 80, height: 40)
        closeButton.addTarget(self, action: #selector(dismissCustomAlert), for: .touchUpInside)
        customAlertView.addSubview(closeButton)
        
        self.view.addSubview(customAlertView)
    }
    
    @objc func dismissCustomAlert() {
        
        for subview in self.view.subviews {
            if subview is UIView && subview.layer.cornerRadius == 10 {
                subview.removeFromSuperview()
            }
        }
    }

    
    @objc func dialogueViewTapped() {
        print("self.tripData\(self.tripData!.get("tNoteByUser"))")
        if (self.tripData!.get("tNoteByUser") != ""){
            GeneralFunctions.showNote(txt: self.tripData!.get("tNoteByUser"))
        }else{
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_NOT_AVALIABLE"))
        }
        //showCustomAlert()
    }
    
    @objc func adminCallViewTapped() {
//        let number = self.userProfileJson.get("CALL_LINK")
//        UIApplication.shared.openURL(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
        
        if let number = self.userProfileJson.get("CALL_LINK") as? String,
           let encodedNumber = "tel://\(number)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedNumber) {

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.arrivedBtn) {
            if(self.currentLocation == nil) {
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
                return
            }
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_ARRIVED_CONFIRM_DIALOG_DELIVERY" : (self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? (self.tripData.get("eServiceLocation").uppercased() != "DRIVER" ? "LBL_ARRIVED_CONFIRM_DIALOG_SERVICES" : "LBL_CONFIRM_NOTE_USER_ARRIVED") : "LBL_ARRIVED_CONFIRM_DIALOG_TXT")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedId) in
                
                if(btnClickedId == 0){
                    self.setDriverStatusToArrived()
                }
            })
        }else if(self.jobOTPVerificationView != nil && sender == self.jobOTPVerificationView.submitOTPBtn){
            
            if(GeneralFunctions.getRandomSecCode(code: self.otp_str) == self.tripData.get("vText"))
            {
                self.closeOTPView()
                self.isOTPVerificationDone = true
                self.setDriverStatusToArrived()
                self.jobOTPVerificationView.otpStackView.setAllFieldColor(color: UIColor.UCAColor.AppThemeColor)
                
            }else{
                self.jobOTPVerificationView.otpStackView.setAllFieldColor(color: UIColor.UCAColor.red)
                self.jobOTPVerificationView.errorLbl.isHidden = false
            }
        }
    }
    
    /* If set to SlideButtonAction Action*/
    
    func myBtnSlided(sender: MySliderButton) {
        if(sender == self.slideArrivedBtn) {
            if(self.currentLocation == nil) {
                UIView.animate(withDuration: 0.95) {
                    if(self.slideArrivedBtn != nil){
                        self.slideArrivedBtn.Reset()
                    }
                }
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
                return
            }
            
//            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_ARRIVED_CONFIRM_DIALOG_DELIVERY" : (self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? (self.tripData.get("eServiceLocation").uppercased() != "DRIVER" ? "LBL_ARRIVED_CONFIRM_DIALOG_SERVICES" : "LBL_CONFIRM_NOTE_USER_ARRIVED") : "LBL_ARRIVED_CONFIRM_DIALOG_TXT")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedId) in
//
//                if(btnClickedId == 0){
//                    self.setDriverStatusToArrived()
//                }else{
//                    /* If Reset to SlideArrivedBtn */
//                    UIView.animate(withDuration: 0.95) {
//                        self.slideArrivedBtn.Reset()
//                    }
//                }
//            })
            
            if(self.tripData.get("ePoolRide").uppercased() == "YES" && tripData.get("eAskCodeToUser").uppercased() == "YES" && self.isOTPVerificationDone == false){
                
                self.openOTPConfView()
                return
                
            }
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ARRIVAL_CONFIRM_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedId) in

                if(btnClickedId == 0){
                    self.setDriverStatusToArrived()
                }else{
                    UIView.animate(withDuration: 0.95) {
                        self.slideArrivedBtn.Reset()
                    }
                }
            })
            
//            self.setDriverStatusToArrived()
        }
    }
    
    
    func openOTPConfView(){
        
        let viewHeight = 350
        self.jobOTPVerificationView = JobOTPVerificationView.init(frame: CGRect(x: 0, y: Int(self.view.frame.height) - viewHeight + 10, width: Int(self.view.frame.width), height: viewHeight), numberOfFileds: GeneralFunctions.parseInt(origValue: 4, data: self.tripData.get("vRandomCode")))
        
        
        jobOTPVerificationView.layer.cornerRadius = 10
        
        // Apply theme to OTP view
        let themeManager = ThemeManager.shared
        jobOTPVerificationView.backgroundColor = themeManager.isDarkModeActive ? themeManager.cardBackgroundColor() : UIColor.white
        
        // Add border in dark mode for better definition
        if themeManager.isDarkModeActive {
            jobOTPVerificationView.layer.borderColor = themeManager.borderColor().cgColor
            jobOTPVerificationView.layer.borderWidth = 0.5
        } else {
            jobOTPVerificationView.layer.borderWidth = 0
        }
        
        self.bgViewForOTP = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)))
        self.bgViewForOTP.backgroundColor = themeManager.isDarkModeActive ? UIColor.black.withAlphaComponent(0.7) : UIColor.black.withAlphaComponent(0.5)
        
        self.view.addSubview(self.bgViewForOTP)
        self.view.addSubview(jobOTPVerificationView)
        
        self.jobOTPVerificationView.closeOTPLbl.setOnClickListener { (instance) in
            self.closeOTPView()
        }
        
        
        self.jobOTPVerificationView.otpStackView.delegate = self
        
        self.jobOTPVerificationView.submitOTPBtn.clickDelegate = self
        self.jobOTPVerificationView.submitOTPBtn.setButtonEnabled(isBtnEnabled: false)
        self.jobOTPVerificationView.otpTextFiled.onTextChangedDelegate = self
        self.jobOTPVerificationView.otpTextFiled.getTextField()!.keyboardType = .numberPad
        
    }
    
    func closeOTPView(){
        self.slideArrivedBtn.Reset()
        self.jobOTPVerificationView.removeFromSuperview()
        self.bgViewForOTP.removeFromSuperview()
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

    func setDriverStatusToArrived(){
        let parameters = ["type":"DriverArrived","iTripId":self.tripData!.get("TripId"),"iDriverId": GeneralFunctions.getMemberd(),"vLatitude":"\(self.currentLocation != nil ? "\(currentLocation.coordinate.latitude)" : "")","vLongitude":"\(self.currentLocation != nil ? "\(currentLocation.coordinate.longitude)" : "")"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.releaseAllTask()
                    
                    let window = Application.window
                    
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                    
                }else if(dataDict.get(Utils.message_str) == "DO_RESTART" || dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                    
                    self.releaseAllTask()
                    
                    let window = Application.window
                    
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                   
                    /* If Reset to SlideArrivedBtn */
                    UIView.animate(withDuration: 0.95) {
                        if(self.slideArrivedBtn != nil){
                            self.slideArrivedBtn.Reset()
                        }
                    }
                }
            }else{
                self.generalFunc.setError(uv: self)
                
                /* If Reset to SlideArrivedBtn */
                UIView.animate(withDuration: 0.95) {
                    if(self.slideArrivedBtn != nil){
                        self.slideArrivedBtn.Reset()
                    }
                }
            }
        })
    }
    
    @objc func releaseAllTask(isDismiss:Bool = true){
        
        if(self.dispatchDemoLocations != nil){
            self.dispatchDemoLocations.stopDispatchingDemoLocations()
        }
        
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
        
        if(updateDriverLoc != nil){
            self.updateDriverLoc.releaseTask()
            self.updateDriverLoc = nil
        }
        
        if(updateDirections != nil){
            self.updateDirections.releaseTask()
            if(self.updateDirections.gMap != nil){
                self.updateDirections.gMap!.removeFromSuperview()
                self.updateDirections.gMap!.clear()
                self.updateDirections.gMap!.delegate = nil
                self.updateDirections.gMap = nil
            }
            
            
            if(updateDirections.navigateView != nil){
                updateDirections.navigateView = nil
            }
            
            if(updateDirections.navigationView != nil){
                updateDirections.navigationView = nil
            }
            
            self.updateDirections = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
        
        
        if(isDismiss){
            self.dismiss(animated: false, completion: nil)
            self.navigationController?.dismiss(animated: false, completion: nil)
        }
    }
    
    
    func onHeadingUpdate(heading: Double) {
//        driverMarker.isFlat = true
//        driverMarker.rotation = heading
//       
//        self.gMapView.animate(toBearing: heading - 20)
        currentHeading = heading
        
        if(isFirstHeadingCompleted == false){
            updateDriverMarker()
            isFirstHeadingCompleted = true
        }
    }
    
    
    func onLocationUpdate(location: CLLocation) {
        
        if(gMapView == nil){
            releaseAllTask()
            return
        }
        self.currentLocation = location
        
        if(ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP.uppercased() == "YES"){
            var currentZoomLevel:Float = self.gMapView.camera.zoom
            
            if(currentZoomLevel < Utils.defaultZoomLevel && isFirstLocationUpdate == true){
                currentZoomLevel = Utils.defaultZoomLevel
            }
            
            let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoomLevel:currentZoomLevel, mapView:self.gMapView)
            
            self.gMapView.animate(to: camera)
        }else{
            if(isFirstLocationUpdate && tripData != nil){
                if(currentDestination == nil){
                    currentDestination = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("sourceLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("sourceLongitude")))
                }
                
                var bounds = GMSCoordinateBounds()
                bounds = bounds.includingCoordinate(location.coordinate)
                bounds = bounds.includingCoordinate(currentDestination!.coordinate)
                
                /*let edgeInsets = UIEdgeInsets.init(top: 125 + self.topNavView.tripIntervalLbl.frame.height, left: 10, bottom: 120 + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 10)*/
                
                let edgeInsets = UIEdgeInsets.init(top: 125, left: 10, bottom: 120 + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 10)
                let update = GMSCameraUpdate.fit(bounds, with: edgeInsets)
                self.gMapView.animate(with: update)
            }
        }
        
        
        isFirstLocationUpdate = false
        
        updateLocationToPubNub()
        
        updateDriverMarker()
        
    }
    
    func updateDriverMarker(){
//        driverMarker.position = self.currentLocation.coordinate
        if(currentLocation == nil){
            return
        }
        driverMarker.title = GeneralFunctions.getMemberd()
        
        var rotationAngle:Double = 0
        if(currentRotatedLocation == nil){
            rotationAngle = currentHeading
            
            if(currentHeading > 1 || UIDevice().type == .simulator){
                currentRotatedLocation = currentLocation
            }
        }else{
            rotationAngle = currentRotatedLocation.bearingToLocationDegrees(destinationLocation: currentLocation, currentRotation: driverMarker.rotation)
            if(rotationAngle == -1){
                rotationAngle = currentHeading
            }else{
                currentRotatedLocation = currentLocation
            }
        }
        
        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            rotationAngle = 0
        }
        
//        Utils.updateMarker(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 1.0)
        
//        if(dataDict != nil && self.driverMarker != nil){
        
            let previousItemOfMarker = Utils.getLastLocationDataOfMarker(marker: driverMarker)
            
            var tempData = [String:String]()
            tempData["vLatitude"] = "\(currentLocation.coordinate.latitude)"
            tempData["vLongitude"] = "\(currentLocation.coordinate.longitude)"
            tempData["iDriverId"] = "\(GeneralFunctions.getMemberd())"
            tempData["RotationAngle"] = "\(rotationAngle)"
            tempData["LocTime"] = "\(Utils.currentTimeMillis())"
        
            let temDataDict = tempData as NSDictionary
            let locTimeData = temDataDict.get("LocTime")
            if(previousItemOfMarker.get("LocTime") != "" && locTimeData != ""){
                
                let locTime = Int64(previousItemOfMarker.get("LocTime"))
                let newLocTime = Int64(locTimeData)
                
                if(locTime != nil && newLocTime != nil){
                    
                    if((newLocTime! - locTime!) > Int64(0) && Utils.driverMarkerAnimFinished == false){
                        Utils.driverMarkersPositionList.append(tempData as NSDictionary)
                    }else if((newLocTime! - locTime!) > Int64(0)){
                        Utils.updateMarkerOnTrip(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 0.8, iDriverId: GeneralFunctions.getMemberd(), LocTime: locTimeData)
                    }
                    
                }else if((locTime == nil || newLocTime == nil) && Utils.driverMarkerAnimFinished == false){
                    Utils.driverMarkersPositionList.append(temDataDict)
                }else{
                    Utils.updateMarkerOnTrip(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 0.8, iDriverId: GeneralFunctions.getMemberd(), LocTime: locTimeData)
                }
                
            }else if(Utils.driverMarkerAnimFinished == false){
                Utils.driverMarkersPositionList.append(temDataDict)
            }else{
                Utils.updateMarkerOnTrip(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 0.8, iDriverId: GeneralFunctions.getMemberd(), LocTime: locTimeData)
            }
            
//        }else{
//            Utils.updateMarkerOnTrip(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 1.0, iDriverId: GeneralFunctions.getMemberd(), LocTime: "")
//        }

        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            let providerView = self.getProviderMarkerView(providerImage: UIImage(named: "ic_no_pic_user")!)
            driverMarker.icon = UIImage(view: providerView)
            
            (providerView.subviews[1] as! UIImageView).sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                self.driverMarker.icon = UIImage(view: providerView)
            })
            driverMarker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        }else{
	
            let eIconType = tripData.get("eIconType")
               // driverMarker.icon = UIImage(named: "ic_driver_car_pin")
            var iconId = "ic_driver_car_pin"
            
            if(eIconType == "Bike"){
                iconId = "ic_bike"
            }else if(eIconType == "Cycle"){
                iconId = "ic_cycle"
            }else if(eIconType == "Truck"){
                iconId = "ic_truck"
            }
            
            driverMarker.icon = UIImage(named: iconId)
            driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        }
        driverMarker.map = self.gMapView
        driverMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        driverMarker.isFlat = true
        driverMarker.title = GeneralFunctions.getMemberd()
        
        if(ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP.uppercased() != "YES"){
            
            if(currentDestination == nil){
                currentDestination = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLongitude")))
            }
            
            let passengerLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("sourceLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("sourceLongitude")))
            var bounds = GMSCoordinateBounds()
            bounds = bounds.includingCoordinate(self.currentLocation.coordinate)
            bounds = bounds.includingCoordinate(passengerLocation.coordinate)
            
            /* Pool Ride. */
            var addExtraPddingForPoolAndMultiDelivery:CGFloat = 0.0
            if(self.tripData.get("ePoolRide").uppercased() == "YES" || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery") {
                addExtraPddingForPoolAndMultiDelivery = 40.0
            }
            
            let edgeInsets = UIEdgeInsets.init(top: 150, left: 20, bottom: 250 + addExtraPddingForPoolAndMultiDelivery + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 20)
            let update = GMSCameraUpdate.fit(bounds, with: edgeInsets)
            self.gMapView.animate(with: update)
            
        }else{
            var currentZoomLevel:Float = gMapView.camera.zoom
            
            if(currentZoomLevel < Utils.defaultZoomLevel){
                currentZoomLevel = Utils.defaultZoomLevel
            }
            let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude), zoomLevel:currentZoomLevel, mapView:self.gMapView)
            
            
                    //    let camera = GMSCameraPosition.camera(withTarget: self.currentLocation.coordinate, zoom: currentZoomLevel, bearing: rotationAngle, viewingAngle: 0)

            CATransaction.begin()
            CATransaction.setValue(1.5, forKey: kCATransactionAnimationDuration)
            self.gMapView.animate(to: camera)
            CATransaction.commit()
        }
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func addPassengerMarker(location: CLLocation){
        
        passengerMarker.position = location.coordinate
        var markerImageName = "ic_passenger"
        if(self.tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"){
            markerImageName = "ic_sender"
//            passengerMarker.icon = UIImage(named: "ic_sender")
        }else if(self.tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
           // passengerMarker.icon = UIImage(named: "ic_user")
            markerImageName = "ic_user"
        }else{
            markerImageName = "ic_passenger"
         //   passengerMarker.icon = UIImage(named: "ic_pickup_location")//ic_passenger
        }
        
        if let originalImage = UIImage(named: markerImageName) {
            let resizedImage = resizeImage(image: originalImage, targetSize: CGSize(width: 64, height: 64))//14
            passengerMarker.icon = resizedImage
        }
        
//        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
//            passengerMarker.icon = UIImage(named: "ic_user")
//        }else{
//            passengerMarker.icon = UIImage(named: "ic_passenger")
//        }
        passengerMarker.map = self.gMapView
        passengerMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        passengerMarker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        
    }
    
    func updateLocationToPubNub(){
        if(currentLocation != nil){
            if(lastPublishedLoc != nil){
                
                if(currentLocation!.distance(from: lastPublishedLoc) < PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT){
                    return
                }else{
                    lastPublishedLoc = currentLocation
                }
                
            }else{
                lastPublishedLoc = currentLocation
            }
            ConfigPubNub.getInstance().publishMsg(channelName: GeneralFunctions.getLocationUpdateChannel(), content: GeneralFunctions.buildLocationJson(location: currentLocation!, msgType: "LocationUpdateOnTrip"))
        }
    }
    
    func initializeMenu(){
        
        var items = [NSDictionary]()
        
        if(self.tripData!.get("eHailTrip").uppercased() != "YES"){
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_VIEW_DELIVERY_DETAILS" : (self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_VIEW_USER_DETAIL" : "LBL_VIEW_PASSENGER_DETAIL")),"ID" : MENU_USER_OR_DELIVERY_DETAIL] as NSDictionary)
        }
        
        if(tripData!.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() && userProfileJson.get("WAYBILL_ENABLE").uppercased() == "YES" && self.tripData!.get("eFly").uppercased() != "YES"){
//             ||  (tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() && self.tripData.get("eFareType") == "Regular")
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Way Bill", key: "LBL_MENU_WAY_BILL"),"ID" : MENU_WAY_BILL] as NSDictionary)
        }
        
        if(tripData!.get("tNoteByUser") != ""){
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_NOTE"),"ID" : MENU_USER_NOTE] as NSDictionary)
        }
        
        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            
            if(tripData!.get("moreServices").uppercased() == "YES"){
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TITLE_REQUESTED_SERVICES"),"ID" : MENU_SPECIAL_INS] as NSDictionary)
            }else{
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Special Instruction", key: "LBL_SPECIAL_INSTRUCTION_TXT"),"ID" : MENU_SPECIAL_INS] as NSDictionary)
            }
            
        }
        
        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_CANCEL_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_CANCEL_JOB" : "LBL_CANCEL_TRIP")),"ID" : MENU_CANCEL_TRIP_OR_DELIVERY] as NSDictionary)
        
        if(self.menu == nil){
            menu = BTNavigationDropdownMenu(navigationController: self.navigationController, title: "", items: items)
            
            menu.cellHeight = 65
            menu.cellBackgroundColor = UIColor.UCAColor.AppThemeColor
            menu.cellSelectionColor = UIColor.UCAColor.AppThemeColor
            menu.cellTextLabelColor = UIColor.UCAColor.AppThemeTxtColor
            menu.cellTextLabelFont = UIFont(name: Fonts().light, size: 20)
            menu.cellSeparatorColor = UIColor.UCAColor.AppThemeColor
            
            if(Configurations.isRTLMode()){
                menu.cellTextLabelAlignment = NSTextAlignment.right
            }else{
                menu.cellTextLabelAlignment = NSTextAlignment.left
            }
            menu.arrowPadding = 15
            menu.animationDuration = 0.5
            menu.maskBackgroundColor = UIColor.black
            menu.maskBackgroundOpacity = 0.5
            menu.menuStateHandler = { (isMenuOpen: Bool) -> () in
                
                //                if(isMenuOpen){
                //                    self.rightButton.setBackgroundImage(nil, for: .normal, barMetrics: .default)
                //
                //                }else{
                //                    self.rightButton.setBackgroundImage(UIImage(color : UIColor.UCAColor.AppThemeColor.lighter(by: 10)!), for: .normal, barMetrics: .default)
                //                }
                
            }
            menu.didSelectItemAtIndexHandler = {(indexID: String) -> () in
                
                switch indexID {
                    
                case self.MENU_USER_OR_DELIVERY_DETAIL:
                    if(self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"){
                        let viewDeliveryDetailsUv = GeneralFunctions.instantiateViewController(pageName: "ViewDeliveryDetailsUV") as! ViewDeliveryDetailsUV
                        viewDeliveryDetailsUv.tripData = self.tripData
                        self.pushToNavController(uv: viewDeliveryDetailsUv)
                    }else{
                        let openPassengerDetail = OpenPassengerDetail(uv:self, containerView: self.contentView)
                        openPassengerDetail.tripData = self.tripData
                        openPassengerDetail.currInst = openPassengerDetail
                        openPassengerDetail.showDetail()
                    }
                    break
                case self.MENU_CANCEL_TRIP_OR_DELIVERY:
//                    let openCancelBooking = OpenCancelBooking(uv: self)
//                    openCancelBooking.cancelTrip(eTripType: self.tripData!.get("REQUEST_TYPE"), PAGE_TYPE: "", iTripId: self.tripData!.get("TripId"), iCabBookingId: "") { (iCancelReasonId, reason) in
//                        self.onTripCanceled(iCancelReasonId: iCancelReasonId, reason: reason)
//                    }
                    print(self.userProfileJson.get("ENABLE_DRIVER_CANCELLATION_CHARGE"))
                    if(self.userProfileJson.get("ENABLE_DRIVER_CANCELLATION_CHARGE").uppercased() == "YES") {
                        let title = self.generalFunc.getLanguageLabel(origValue: "Cancel this booking?", key: "LBL_DIALOGUE_CANCEL_DRIVER_TITLE")
                        let message = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DIALOGUE_CANCEL_DRIVER")
                        
                        self.generalFunc.setAlertMessage(uv: self, title: title, content: message, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Proceed to cancel", key: "LBL_PROCEED_CANCEL"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "Do not cancel", key: "LBL_DONOT_CANCEL"), completionHandler: { (btnClickedId) in
                            
                            if(btnClickedId == 0) {
                                let openCancelBooking = OpenCancelBooking(uv: self)
                                openCancelBooking.cancelTrip(eTripType: self.tripData!.get("REQUEST_TYPE"), PAGE_TYPE: "", iTripId: self.tripData!.get("TripId"), iCabBookingId: "") { (iCancelReasonId, reason) in
                                    self.onTripCanceled(iCancelReasonId: iCancelReasonId, reason: reason)
                                }
                            }
                        })
                        
                    } else {
                        let openCancelBooking = OpenCancelBooking(uv: self)
                        openCancelBooking.cancelTrip(eTripType: self.tripData!.get("REQUEST_TYPE"), PAGE_TYPE: "", iTripId: self.tripData!.get("TripId"), iCabBookingId: "") { (iCancelReasonId, reason) in
                            self.onTripCanceled(iCancelReasonId: iCancelReasonId, reason: reason)
                        }
                    }
                    break
                case self.MENU_WAY_BILL:
                    let wayBillUV = GeneralFunctions.instantiateViewController(pageName: "WayBillUV") as! WayBillUV
                    self.pushToNavController(uv: wayBillUV)
                    break
                case self.MENU_USER_NOTE:
                    GeneralFunctions.showNote(txt: self.tripData!.get("tNoteByUser"))
                    break
                case self.MENU_SPECIAL_INS:
                    
                    if(self.tripData!.get("moreServices").uppercased() == "YES"){
                        
                    }else{
                        self.generalFunc.setError(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "Special Instruction", key: "LBL_SPECIAL_INSTRUCTION_TXT"), content: self.tripData!.get("tUserComment") == "" ? (self.generalFunc.getLanguageLabel(origValue: "There is a No Special Instruction", key: "LBL_NO_SPECIAL_INSTRUCTION")) : self.tripData!.get("tUserComment") )
                    }
                    
                    break
                default:
                    break
                }
                
            }
        }else{
            menu.updateItems(items)
        }
    }
    
    @objc func openPopUpMenu(){
        
        initializeMenu()
        
        if(menu.isShown){
            menu.hideMenu()
            return
        }else{
            menu.showMenu()
        }
    }
    
    func onTripCanceled(iCancelReasonId:String, reason: String) {
       
        
        let parameters = ["type":"cancelTrip","iDriverId": GeneralFunctions.getMemberd(), "iUserId": tripData!.get("PassengerId"), "iTripId": tripData!.get("TripId"), "UserType": Utils.appUserType, "Reason": reason, "iCancelReasonId": iCancelReasonId,"vLatitude" : "\(currentLocation!.coordinate.latitude)","vLongitude" : "\(currentLocation!.coordinate.longitude)"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
           
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.releaseAllTask()
                    
                    let window = Application.window
                    
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func getProviderMarkerView(providerImage:UIImage) -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProviderMapMarkerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame.size = CGSize(width: 64, height: 100)
        
        GeneralFunctions.setImgTintColor(imgView: view.subviews[0] as! UIImageView, color: UIColor.UCAColor.AppThemeColor)
        
        view.subviews[1].layer.cornerRadius = view.subviews[1].frame.width / 2
        view.subviews[1].layer.masksToBounds = true
        let providerImgView = view.subviews[1] as! UIImageView
        providerImgView.image = providerImage
        
        return view
    }
    
    @objc func getMaskedNumber(){
        
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
        }
        
        //if(userProfileJson.get("CALLMASKING_ENABLED").uppercased() == "YES"){
        let parameters = ["type":"getCallMaskNumber","iTripid": self.tripData!.get("TripId"), "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.callTapped(phoneNumber: dataDict.get(Utils.message_str))
                }else{
                    self.callTapped(phoneNumber: "\(self.tripData!.get("PPhone"))")
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        // }else{
        //     self.callTapped(phoneNumber: "\(self.tripData!.get("PPhone"))")
        // }
    }
    
    func callTapped(phoneNumber:String){
//        let number = "\(phoneNumber)"
//        UIApplication.shared.openURL(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
        
        if let number = "\(phoneNumber)" as? String,
           let encodedNumber = "tel://\(number)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedNumber) {

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func chatTapped(){
        
        let chatUV = GeneralFunctions.instantiateViewController(pageName: "MessagesViewController") as! MessagesViewController
        chatUV.receiverId = tripData!.get("PassengerId")
        chatUV.receiverDisplayName = self.tripData!.get("PName")
        chatUV.assignedtripId = self.tripData!.get("TripId")
        chatUV.pPicName = self.tripData!.get("PPicName")
//        chatUV.serviceTripType = self.tripData!.get("vServiceTitle")
        chatUV.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.tripData!.get("PRating"))
           chatUV.bookingNo = self.tripData!.get("vRideNo")
         chatUV.assignedtripDate  = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.tripData!.get("tTripRequestDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
        self.pushToNavController(uv:chatUV, isDirect: true)
    }
}
