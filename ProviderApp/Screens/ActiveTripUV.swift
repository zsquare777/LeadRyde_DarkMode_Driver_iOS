//
//  ActiveTripUV.swift
//  DriverApp
//
//  Created by ADMIN on 29/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftExtensionData

class ActiveTripUV: UIViewController, GMSMapViewDelegate, OnLocationUpdateDelegate, AddressFoundDelegate, UITableViewDelegate, UITableViewDataSource, MyBtnClickDelegate, DispatchDemoLocationsProtocol, MySliderBtnClickDelegate, OnTaskRunCalledDelegate, OTPDelegate, MyTxtFieldOnTextChangeDelegate {

    var MENU_USER_OR_DELIVERY_DETAIL = "0"
    var MENU_USER_CALL = "1"
    var MENU_USER_MSG = "2"
    var MENU_EMERGENCY = "3"
    var MENU_CANCEL_TRIP = "4"
    var MENU_WAY_BILL = "5"
    var MENU_SPECIAL_INS = "6"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var googleMapContainerView: UIView!
    
//    @IBOutlet weak var topDataContainerStkView: UIStackView!
//    @IBOutlet weak var topDataContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tripBtn: MyButton!
    @IBOutlet weak var addDestinationView: UIView!
    @IBOutlet weak var addDestinationLbl: MyLabel!
    
    @IBOutlet weak var addDestView: UIView!
    @IBOutlet weak var addDestLbl: MyLabel!
    @IBOutlet weak var addDestDetailsView: UIView!
    
    @IBOutlet weak var btnIconBgView: UIView!
    @IBOutlet weak var btnIconImgView: UIImageView!
    @IBOutlet weak var rightArrowImgView: UIImageView!
    
//    @IBOutlet weak var tollNoteLbl: MyLabel!
    
    @IBOutlet weak var emeImgView: UIImageView!
    @IBOutlet weak var googleLogoImgView: UIImageView!
    
    /*TopHederView Related Create IBOutlet*/
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var adddestinationViewHeight: NSLayoutConstraint!
    
    /*BottomDetailsView Related Create IBOutlet*/
    @IBOutlet weak var bottomDetailsView: UIView!
    @IBOutlet weak var bottomDetailsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dropOffHLbl: MyLabel!
    @IBOutlet weak var dropOffHLblHeight: NSLayoutConstraint!
    @IBOutlet weak var receiverNameLbl: MyLabel!
    @IBOutlet weak var receiverHLbl: MyLabel!
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
    @IBOutlet weak var stopOverPointHLbl: MyLabel!
    @IBOutlet weak var mspCancelView: UIView!
    @IBOutlet weak var mspCancelImageView: UIImageView!
    @IBOutlet weak var mspCloseImageView: UIImageView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var tollNoteView: UIView!
    @IBOutlet weak var tollNoteViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tollNoteVLbl: MyLabel!
    
    /*SlideTripBtn Related Create IBOutlet*/
    @IBOutlet weak var slideTripBtn: MySliderButton!
    
    //UFX related OutLets
    @IBOutlet weak var detailBottomVIew: UIView!
    @IBOutlet weak var senderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var senderImgView: UIImageView!
    @IBOutlet weak var sourceAddLbl: MyLabel!
    @IBOutlet weak var senderNameLbl: MyLabel!
    @IBOutlet weak var bottomPointViewHeight: NSLayoutConstraint!
    @IBOutlet weak var senderDetailView: UIView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var jobStatusTitleLbl: MyLabel!
    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressStatusTitleLbl: MyLabel!
    @IBOutlet weak var progressBtn: MyButton!
    @IBOutlet weak var progressBtnView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hourVLbl: MyLabel!
    @IBOutlet weak var hourHLbl: MyLabel!
    @IBOutlet weak var minuteVLbl: MyLabel!
    @IBOutlet weak var minuteHLbl: MyLabel!
    @IBOutlet weak var secHLbl: MyLabel!
    @IBOutlet weak var secVLbl: MyLabel!
    @IBOutlet weak var ufxHeaderView: UIView!
    @IBOutlet weak var ufxHeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ufxBGHeaderViewBottom: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var headerBGView: UIView!
    
    // Surge Price OutLets
    @IBOutlet weak var surgePriceHLbl: MyLabel!
    @IBOutlet weak var surgePriceVLbl: MyLabel!
    @IBOutlet weak var surgePayAmtLbl: MyLabel!
    @IBOutlet weak var surgeAcceptBtn: MyButton!
    @IBOutlet weak var surgeLaterLbl: MyLabel!
    
    // MultiDelivery
    @IBOutlet weak var deliveryDetailsView: UIView!
    @IBOutlet weak var deliveryDetailsImgView: UIImageView!
    @IBOutlet weak var deliveryCallImgView: UIImageView!

    @IBOutlet weak var recHLbl: UILabel!
    @IBOutlet weak var recNameValLbl: UILabel!
    @IBOutlet weak var noOfPersonLbl: UILabel!
    @IBOutlet weak var deliveryView: UIView!
    
    /* In-Transit Shopping System*/
    @IBOutlet weak var waitingProgressBtn: MyButton!
    @IBOutlet weak var waitingTimeLbl: MyLabel!
    
    /* MSP Changes*/
    @IBOutlet weak var mspCancelLbl: UILabel!
    @IBOutlet weak var mspCancelImgView: UIImageView!
    @IBOutlet weak var mspCancelCloseImgView: UIImageView!
    
    // Safety Popup
    @IBOutlet weak var editItmeImgSelView: UIView!
    @IBOutlet weak var editItemBGView: UIView!
    @IBOutlet weak var editItemView: UIView!
    @IBOutlet weak var editItemTopBGView: UIView!
    @IBOutlet weak var editItemHLbl: MyLabel!
    @IBOutlet weak var personLimitNoteLbl: MyLabel!
    @IBOutlet weak var safetyProofNoteLbl: MyLabel!
    @IBOutlet weak var pageHLbl: MyLabel!
    @IBOutlet weak var takePhotoImgView: UIImageView!
    @IBOutlet weak var selectedImgBgView: UIView!
    @IBOutlet weak var selectedImgBgWhiteView: UIView!
    @IBOutlet weak var selectedCheckImgView: UIImageView!
    @IBOutlet weak var editItemSubmitBtn: MyButton!
    @IBOutlet weak var cancelPhotoImgView: UIImageView!
    @IBOutlet weak var editItemCancelImgView: UIImageView!
    @IBOutlet weak var editItemViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dialogueView: UIView!
    
    @IBOutlet weak var jobView: UIView!
    @IBOutlet weak var adminCallView: UIView!
    @IBOutlet weak var adminCallImgView: UIImageView!
    var surgePriceView:UIView!
    var surgePriceBGView:UIView!
    
    var dataArrList = [NSDictionary]()
    var loaderView:UIView!
    
    let generalFunc = GeneralFunctions()
    
    var isPageLoaded = false
    
    var currentLocation:CLLocation!
    var currentRotatedLocation:CLLocation!
    var currentHeading:Double = 0
    var isFirstHeadingCompleted = false
    
    var lastPublishedLoc:CLLocation!
    
    var gMapView:GMSMapView!
    
//    var navView:UIView!
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
    var updateTripLocationService:UpdateTripLocationService!
    
    let driverMarker: GMSMarker = GMSMarker()
    let destinationMarker: GMSMarker = GMSMarker()
    
    let btnPanGue = UIPanGestureRecognizer()
    
    var isTripStarted = false
    
    var isTripEndPressed = false
    
    var cancelReason = ""
   
    var getAddressFrmLocation:GetAddressFromLocation!
    
    var tripTaskExecuted = false
    
    var iCancelReasonId = ""
    
    var locationDialog:OpenLocationEnableView!
    
    var isDeliveryCodeEntered = false
    
    var ufxCntView:UIView!
    
    var iTripTimeId = ""
    
    var totalSecond:Double = 0
    
    var isResume = true
    
    var jobTimer:Timer!
    var latitudeList = [String]()
    var longitudeList = [String]()
    
//    var PHOTO_UPLOAD_SERVICE_ENABLE = "No"
    
//    var UFX_PHOTO_SELECT_TASK_COMPLETED = false
    var serviceImageData:Data!
    
    var headerViewHeight:CGFloat = 360
    
    var userProfileJson:NSDictionary!
    
    var destinationOnTripLatitude = ""
    var destinationOnTripLongitude = ""
    var destinationOnTripAddress = ""
    
    var isTollChecked = false
    
    var isSafeAreaSet = false
    var iphoneXBottomView:UIView!
    
    var ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP = ""
    
    var currentDestination:CLLocation!
    
    var PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT:Double = 5
    
    var dispatchDemoLocations:DispatchDemoLocations!
    
    /* MSP Changes*/
    var mspEndTimer:Timer!
    var isDropAll = false
    
    // Fly Changes
    var arcCreated = false
    var animTask:UpdateFreqTask!
    var animationPathOrig = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i_anim:Int = 0
    var poolpath = GMSPath()
    var animationPolylineOrig = GMSPolyline()
    var animationPolyline = GMSPolyline()
    let MAX_ROUTE_ANIM_INTERVAL:Double = 2500 // In Milliseconds
    var animLocationArr = [CLLocationCoordinate2D]()
    var animLocArrParts:[[CLLocationCoordinate2D]]!
    
    var slideBtnNeedRefresh = true
    
    let photoImgTapGue = UITapGestureRecognizer()
    let photoImgTapGueForPluseBtn = UITapGestureRecognizer()
    var openImgSelection:OpenImageSelectionOption!
    var isImageSelected = false
    var selectedFileData:Data!
    var selectedFileName = ""
    
    // SERVICE OTP CONFIRMATION
    var jobOTPVerificationView:JobOTPVerificationView!
    var bgView:UIView!
    var isKeyboardOpen = false
    var isOTPVerificationDone = false
    var otp_str = ""
    
    var distance_final:Double!
    
    var intransitWaitingTimer:Timer!
    
    var isStartIntransitWaitingTime = false
    
    var currentSpeed : Double!
    
    var isCheckIntransitWaitingTime = false
    
    var intransitStartLocation:CLLocation!
    
    var scheduledTask:UpdateFreqTask!
       
    var SCHEDULED_TASK_DEFAULT_TIME_INTERVAL:Double = 5
       
    var tStartLat = 0.0
    var tStartLong = 0.0
    
    var alertCode = ""
    
    var locationsPassed = [CLLocation]()
    
    var isCountDownStarted = false
    
    var isLoaderShow = true
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
        (UIApplication.shared.delegate as! AppDelegate).configureOnlineState(false)
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
        
        if(slideBtnNeedRefresh == true){
            self.slideTripBtn.Reset()
        }
        
        
        if(isSafeAreaSet == false){
            
            if(Configurations.isIponeXDevice() || UIDevice().typeApp == .iPhone12Pro || UIDevice().typeApp == .iPhone12ProMax ||  UIDevice().typeApp == .iPhone12 ||  UIDevice().typeApp == .iPhone12Mini || UIDevice().typeApp == .iPhone11 || UIDevice().typeApp == .iPhone11Pro || UIDevice().typeApp == .iPhone11ProMax || UIDevice.current.userInterfaceIdiom == .pad){
                
                if(iphoneXBottomView == nil){
                    iphoneXBottomView = UIView()
                    self.view.addSubview(iphoneXBottomView)
                }
                
                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.iphoneXBottomView.frame = CGRect(x: 0, y: self.contentView.frame.maxY - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: GeneralFunctions.getSafeAreaInsets().bottom)
                }
            }
            isSafeAreaSet = true
        }
        
        if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() || (tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") == "Regular")){
            
            NavigationSensor.getInstance().configSensor(activateDispatch: true)
            
            if(updateDirections != nil){
                updateDirections.startDirectionUpdate()
            }
            
        }
        
        if(isPageLoaded == false){
            
            isPageLoaded = true
            
            if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() || (tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") == "Regular")){
                
//                topNavView = navigationVIew(frame: CGRect(x:0, y:0, width: Application.screenSize.width, height: 95))
//                topNavView.backgroundColor = UIColor.clear
                
                /* Initializing for TopNavigationView */
                topNavigationView = NavigateView(frame: CGRect(x:0, y:0, width: Application.screenSize.width, height: 80))
                
                if (tripData.get("DestLocLatitude") != "" && tripData.get("DestLocLatitude") != "0"
                    && tripData.get("DestLocLongitude") != "" && tripData.get("DestLocLongitude") != "0" &&
                    tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() ) {
//                    || (tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") == "Regular"))
//                    topDataContainerStkView.addArrangedSubview(topNavView)
//                    topDataContainerViewHeight.constant = 95
                    
                    topNavigationView.backgroundColor = UIColor.clear
                    self.topContainerView.backgroundColor = UIColor.clear
                    self.topContainerView.addSubview(topNavigationView)
                    self.topContainerViewHeight.constant = 80

                }else if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased()){
                    
                    /*If Load to AdddestinationView*/
                    let addDestView = self.generalFunc.loadView(nibName: "AddDestinationView", uv: self, isWithOutSize: true)
                    addDestView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 50)
                    
                    let addDestStackView = UIStackView()
                    addDestStackView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 50)
                    addDestStackView.axis = .vertical
                    addDestStackView.distribution = .fill
                    addDestStackView.spacing = 0
                    addDestStackView.addArrangedSubview(addDestView)
                    self.topContainerView.addSubview(addDestStackView)

                    self.topContainerView.layoutSubviews()
                    self.topContainerView.layoutIfNeeded()

                    self.topContainerViewHeight.constant = 50
                    
//                    topDataContainerStkView.addArrangedSubview(addDestView)
//                    topDataContainerViewHeight.constant = 50
                }
                
                
                let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: 0.0, longitude: 0.0), zoomLevel:0.0, mapView:self.gMapView)
                gMapView = GMSMapView.map(withFrame: self.googleMapContainerView.frame, camera: camera)
                
                // Apply dark/light map style based on theme
                let themeManager = ThemeManager.shared
                if themeManager.isDarkModeActive {
                    self.gMapView.nightMapStyle()
                } else {
                    self.gMapView.mapStyle = nil
                }
                
                gMapView.settings.rotateGestures = true
                gMapView.settings.tiltGestures = true
                gMapView.delegate = self
//                gMapView.settings.allowScrollGesturesDuringRotateOrZoom = false
                self.googleMapContainerView.addSubview(gMapView)
                
                self.gMapView.bindFrameToSuperviewBounds()
            }else{
                let ufxCntView = self.generalFunc.loadView(nibName: "ActiveTripUFXScreenDesign", uv: self)
                ufxCntView.frame = self.googleMapContainerView.frame
                self.ufxCntView = ufxCntView
                self.hourVLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                self.minuteVLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                self.secVLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                headerBGView.backgroundColor = UIColor.UCAColor.AppThemeColor
                self.progressBtn.backgroundColor = .white
                self.progressBtn.borderColor = UIColor.UCAColor.AppThemeColor
                self.progressBtn.titleColor = UIColor.UCAColor.AppThemeColor
                self.googleMapContainerView.addSubview(ufxCntView)
            }
            
            setData()
        }else{
            if(self.slideTripBtn.button != nil){
                //self.slideTripBtn.setButtonTitle(buttonTitle: "SLIDE TO BEGIN DELIVERY")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                    self.slideTripBtn.button!.imageEdgeInsets.left = 25
                    self.slideTripBtn.button!.imageEdgeInsets.right = 25
                    
                    self.slideTripBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 85 : 95) : (Configurations.isRTLMode() ? 45 : 65)
                    self.slideTripBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 95 : 85) : (Configurations.isRTLMode() ? 65 : 45)
                }
                
                self.slideTripBtn.button!.titleLabel?.lineBreakMode = .byWordWrapping
                self.slideTripBtn.button!.titleLabel?.numberOfLines = 2
                self.slideTripBtn.button!.titleLabel?.adjustsFontSizeToFitWidth = true
                self.slideTripBtn.button!.titleLabel?.minimumScaleFactor = 0.6
                

                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        window = Application.window!
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "ActiveTripScreenDesign", uv: self, contentView: contentView))
        
        /** Used for configDriverTripStatus Type */
        GeneralFunctions.saveValue(key: "iTripId", value: self.tripData!.get("TripId") as AnyObject)
        /** Used for configDriverTripStatus Type */
        
        ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP = GeneralFunctions.getValue(key: Utils.ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP_KEY) as! String
        PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT = GeneralFunctions.parseDouble(origValue: 5, data: GeneralFunctions.getValue(key: Utils.PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT_KEY) as! String)
        
        Utils.driverMarkersPositionList.removeAll()
        Utils.driverMarkerAnimFinished = true
        
        self.btnIconBgView.backgroundColor = UIColor.UCAColor.AppThemeColor_1
        GeneralFunctions.setImgTintColor(imgView: self.btnIconImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        Utils.createRoundedView(view: self.btnIconBgView, borderColor: Color.clear, borderWidth: 0)
        
        if(Configurations.isRTLMode()){
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1);
            self.rightArrowImgView.transform = scalingTransform
        }
        
        self.emeImgView.isHidden = true
        
        self.contentView.isHidden = true
        
//        self.PHOTO_UPLOAD_SERVICE_ENABLE = GeneralFunctions.getValue(key: "PHOTO_UPLOAD_SERVICE_ENABLE") == nil ? "No" : (GeneralFunctions.getValue(key: "PHOTO_UPLOAD_SERVICE_ENABLE") as! String)
        
        /** If set to BottomDetailsView Height */
        self.dropOffHLbl.isHidden = true
        
        if(tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            self.bottomDetailsViewHeight.constant = 0
            self.bottomDetailsView.isHidden = true
            self.bottomStackView.isHidden = true
        }/** If set to BottomDetailsView Height */
        
        if(GeneralFunctions.getValue(key: "OPEN_MSG_SCREEN") != nil && (GeneralFunctions.getValue(key: "OPEN_MSG_SCREEN") as! String) == "true"){
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
        
        if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_Ride.uppercased()){
            self.btnIconImgView.isHidden = true
            self.btnIconBgView.isHidden = true
        }
        
        if(self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"){
            let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_active_waybill")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(wayBilltapped))
            self.navigationItem.rightBarButtonItem = rightButton
            
            self.deliveryDetailsView.isHidden = false
//            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.UCAColor.AppThemeColor_1)
            
            let detailsBtnTapGue = UITapGestureRecognizer()
            detailsBtnTapGue.addTarget(self, action: #selector(self.deliveryDetailsTapped))
            self.deliveryDetailsView.isUserInteractionEnabled = true
            self.deliveryDetailsView.addGestureRecognizer(detailsBtnTapGue)
            
            self.btnIconImgView.isHidden = true
            self.btnIconBgView.isHidden = true
            
            /* Hide DeliveryView */
            /*self.deliveryView.isHidden = true
            self.deliveryCallImgView.isHidden = false
            
            GeneralFunctions.setImgTintColor(imgView: self.deliveryCallImgView, color: UIColor.white)
            self.deliveryCallImgView.isUserInteractionEnabled = true
            let delCallTapGue = UITapGestureRecognizer()
            delCallTapGue.addTarget(self, action: #selector(self.deliveryCallTapped))
            self.deliveryCallImgView.addGestureRecognizer(delCallTapGue)
            
            self.recHLbl.text = tripData!.get("Running_Delivery_Txt")
            self.recNameValLbl.text = tripData!.get("vReceiverName")*/
            
            /** If set to BottomDetailsView Data */
            self.chatView.isHidden = true
            self.mspCancelView.isHidden = true
            self.userRatingView.isHidden = true
            self.userNameLbl.isHidden = false
            
            self.receiverHLbl.isHidden = false
            
            self.userNameLbl.text = tripData!.get("vReceiverName")
            self.receiverHLbl.text = tripData!.get("Running_Delivery_Txt")
            
            self.stopOverPointHLbl.isHidden = true /** If set to BottomDetailsView Data */

        }else if(self.tripData.get("ePoolRide").uppercased() == "YES") {  /* Pool Ride Bootom View*/

            self.btnIconImgView.isHidden = true
            self.btnIconBgView.isHidden = true
            self.deliveryCallImgView.isHidden = true
            
            self.mspCancelView.isHidden = true
            
            /* Hide DeliveryView */
            /*self.deliveryView.isHidden = true
            self.noOfPersonLbl.isHidden = false
            self.recHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADMIN_DROPOFF").uppercased()
            self.recNameValLbl.text = self.tripData.get("PName") + " " + self.tripData.get("vLastName")
            self.noOfPersonLbl.text = Configurations.convertNumToAppLocal(numStr:self.tripData.get("iPersonSize")) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSON")*/
            
            /** If set to BottomDetailsView Data */

            self.dropOffHLbl.isHidden = false
            self.stopOverPointHLbl.isHidden = false
            
            self.dropOffHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADMIN_DROPOFF").uppercased()
            self.stopOverPointHLbl.text = Configurations.convertNumToAppLocal(numStr:self.tripData.get("iPersonSize")) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSON") /** If set to BottomDetailsView Data */
                
        }else if(self.tripData.get("iStopId").uppercased() != ""){

            self.deliveryDetailsView.isHidden = false
            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.UCAColor.AppThemeColor_1)
            
            let detailsBtnTapGue = UITapGestureRecognizer()
            detailsBtnTapGue.addTarget(self, action: #selector(self.deliveryDetailsTapped))
            self.deliveryDetailsView.isUserInteractionEnabled = true
            self.deliveryDetailsView.addGestureRecognizer(detailsBtnTapGue)
 
            self.btnIconImgView.isHidden = true
            self.btnIconBgView.isHidden = true
            self.deliveryCallImgView.isHidden = true
            
            /* Hide DeliveryView */
            /*self.deliveryView.isHidden = true*/
            
            /** If set to BottomDetailsView Data */
            self.stopOverPointHLbl.isHidden = false
            self.stopOverPointHLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STOP_OVER_TITLE_TXT") + " " + Configurations.convertNumToAppLocal(numStr: self.tripData.get("currentStopOverPoint")) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STOP_OVER_OUT_OF") + " " + Configurations.convertNumToAppLocal(numStr: self.tripData.get("totalStopOverPoint")) /** If set to BottomDetailsView Data */
            
            if(isTripStarted){

            }
        }/* ........*/
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
        if(Configurations.isRTLMode() && btnIconImgView != nil){
                btnIconImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        self.observeTripDestionationAdd()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
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
    }

    @objc func wayBilltapped(){
        let wayMultibil = GeneralFunctions.instantiateViewController(pageName: "WayBillMultiUV") as! WayBillMultiUV
        self.navigationController?.pushViewController(wayMultibil, animated: true)
    }
    
    @objc func deliveryDetailsTapped(){
        /* MSP Changes*/
        if(self.tripData.get("iStopId").uppercased() != ""){
            
            let viewMSPDetailsUV = GeneralFunctions.instantiateViewController(pageName: "ViewMSPDetailsUV") as! ViewMSPDetailsUV
            viewMSPDetailsUV.tripData = self.tripData
            self.navigationController?.pushViewController(viewMSPDetailsUV, animated: true)
            return
        }/* ..........*/
        
        let viewMultiDeliveryDetailsUV = GeneralFunctions.instantiateViewController(pageName: "ViewMultiDeliveryDetailsUV") as! ViewMultiDeliveryDetailsUV
        viewMultiDeliveryDetailsUV.tripData = NSMutableDictionary(dictionary: self.tripData)
        
        self.navigationController?.pushViewController(viewMultiDeliveryDetailsUV, animated: true)
    }
    
    @objc func deliveryCallTapped(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
        if userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
            //if SinchCalling.getInstance().client.isStarted(){
                
                let selfDic = ["Id":"", "Name": "", "PImage": "", "type": ""]
                let assignedDic = ["Id":"", "Name": tripData!.get("vReceiverName"), "PImage": "", "type": ""]
                SinchCalling.getInstance().makeACall(IDString:"", assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:"+\(tripData!.get("vReceiverMobile"))")
                return
                
           // }
        }else{
            UIApplication.shared.openURL(NSURL(string:"telprompt:+" + tripData!.get("vReceiverMobile"))! as URL)
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
        self.contentView?.backgroundColor = themeManager.backgroundColor()
        self.googleMapContainerView?.backgroundColor = themeManager.backgroundColor()
        
        // 2. Apply map style based on theme (if map exists)
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
        self.dropOffHLbl?.textColor = themeManager.textColor()
        self.userNameLbl?.textColor = themeManager.textColor()
        self.receiverNameLbl?.textColor = themeManager.textColor()
        self.receiverHLbl?.textColor = themeManager.textColor()
        self.senderNameLbl?.textColor = themeManager.textColor()
        self.jobStatusTitleLbl?.textColor = themeManager.textColor()
        self.progressStatusTitleLbl?.textColor = themeManager.textColor()
        
        // 5. Text labels (secondary)
        self.timeLbl?.textColor = themeManager.secondaryTextColor()
        self.distanceLbl?.textColor = themeManager.secondaryTextColor()
        self.stopOverPointHLbl?.textColor = themeManager.secondaryTextColor()
        self.sourceAddLbl?.textColor = themeManager.secondaryTextColor()
        self.hourHLbl?.textColor = themeManager.secondaryTextColor()
        self.minuteHLbl?.textColor = themeManager.secondaryTextColor()
        self.secHLbl?.textColor = themeManager.secondaryTextColor()
        self.hourVLbl?.textColor = themeManager.textColor()
        self.minuteVLbl?.textColor = themeManager.textColor()
        self.secVLbl?.textColor = themeManager.textColor()
        self.waitingTimeLbl?.textColor = themeManager.secondaryTextColor()
        
        // 6. Multi-delivery related labels (UILabel outlets)
        self.recHLbl?.textColor = themeManager.textColor()
        self.recNameValLbl?.textColor = themeManager.textColor()
        self.noOfPersonLbl?.textColor = themeManager.secondaryTextColor()
        self.mspCancelLbl?.textColor = themeManager.textColor()
        self.surgePayAmtLbl?.textColor = themeManager.textColor()
        self.surgeLaterLbl?.textColor = themeManager.secondaryTextColor()
        
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
        
        // 8. Add destination view (if present)
        if self.addDestView != nil {
            self.addDestView?.backgroundColor = themeManager.isDarkModeActive ? 
                themeManager.cardBackgroundColor() : UIColor.white
            self.addDestLbl?.textColor = themeManager.textColor()
            self.addDestinationLbl?.textColor = themeManager.textColor()
            
            if themeManager.isDarkModeActive {
                self.addDestView?.layer.borderColor = themeManager.borderColor().cgColor
                self.addDestView?.layer.borderWidth = 0.5
            } else {
                self.addDestView?.layer.borderWidth = 0
            }
        }
        
        // 9. Toll note view (if present)
        if self.tollNoteView != nil && !self.tollNoteView.isHidden {
            self.tollNoteView?.backgroundColor = themeManager.isDarkModeActive ? 
                themeManager.cardBackgroundColor() : UIColor.white
            self.tollNoteVLbl?.textColor = themeManager.textColor()
            
            if themeManager.isDarkModeActive {
                self.tollNoteView?.layer.borderColor = themeManager.borderColor().cgColor
                self.tollNoteView?.layer.borderWidth = 0.5
            } else {
                self.tollNoteView?.layer.borderWidth = 0
            }
        }
        
        // 10. Update icon tint colors for better visibility
        if themeManager.isDarkModeActive {
            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.white)
        } else {
            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.UCAColor.AppThemeTxtColor_1)
        }
        
        // 11. OTP verification view if present
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
        
        // 12. Background view for OTP (semi-transparent overlay)
        if self.bgView != nil {
            self.bgView.backgroundColor = themeManager.isDarkModeActive ? 
                UIColor.black.withAlphaComponent(0.7) : 
                UIColor.black.withAlphaComponent(0.5)
        }
        
        // 13. Top navigation view (if present)
        if self.topNavigationView != nil {
            // Keep the app theme color but adjust shadow
            self.topNavigationView.navContaintView.layer.shadowColor = themeManager.isDarkModeActive ? 
                UIColor.black.cgColor : UIColor.lightGray.cgColor
            self.topNavigationView.navContaintView.layer.shadowOpacity = themeManager.isDarkModeActive ? 0.8 : 0.6
        }
        
        // 14. Top container background (if applicable)
        if self.topContainerView != nil {
            self.topContainerView.backgroundColor = UIColor.clear
        }
        
        // 15. Sender detail view (UFX)
        if self.senderDetailView != nil && !self.senderDetailView.isHidden {
            self.senderDetailView?.backgroundColor = themeManager.isDarkModeActive ? 
                themeManager.cardBackgroundColor() : UIColor.white
            
            if themeManager.isDarkModeActive {
                self.senderDetailView?.layer.borderColor = themeManager.borderColor().cgColor
                self.senderDetailView?.layer.borderWidth = 0.5
            } else {
                self.senderDetailView?.layer.borderWidth = 0
            }
        }
        
        // 15a. UFX detail bottom view (if present)
        if self.detailBottomVIew != nil && !self.detailBottomVIew.isHidden {
            self.detailBottomVIew?.backgroundColor = themeManager.isDarkModeActive ? 
                themeManager.cardBackgroundColor() : UIColor.white
            
            if themeManager.isDarkModeActive {
                self.detailBottomVIew?.layer.borderColor = themeManager.borderColor().cgColor
                self.detailBottomVIew?.layer.borderWidth = 0.5
            } else {
                self.detailBottomVIew?.layer.borderWidth = 0
            }
        }
        
        // 15b. Progress view (UFX timer view)
        if self.progressView != nil && !self.progressView.isHidden {
            self.progressView?.backgroundColor = themeManager.isDarkModeActive ? 
                themeManager.cardBackgroundColor() : UIColor.white
            
            if themeManager.isDarkModeActive {
                self.progressView?.layer.borderColor = themeManager.borderColor().cgColor
                self.progressView?.layer.borderWidth = 0.5
            } else {
                self.progressView?.layer.borderWidth = 0
            }
        }
        
        // 16. Safety/Edit item views (if present)
        if self.editItemView != nil {
            self.editItemView?.backgroundColor = themeManager.isDarkModeActive ? 
                themeManager.cardBackgroundColor() : UIColor.white
            self.personLimitNoteLbl?.textColor = themeManager.textColor()
            self.safetyProofNoteLbl?.textColor = themeManager.textColor()
            self.editItemHLbl?.textColor = themeManager.textColor()
            self.pageHLbl?.textColor = themeManager.textColor()
            
            if themeManager.isDarkModeActive {
                self.editItemView?.layer.borderColor = themeManager.borderColor().cgColor
                self.editItemView?.layer.borderWidth = 0.5
            } else {
                self.editItemView?.layer.borderWidth = 0
            }
        }
        
        // 16a. Edit item background overlay
        if self.editItemBGView != nil {
            self.editItemBGView?.backgroundColor = themeManager.isDarkModeActive ? 
                UIColor.black.withAlphaComponent(0.7) : 
                UIColor.black.withAlphaComponent(0.5)
        }
        
        // 17. Surge price view (if present)
        if self.surgePriceView != nil {
            self.surgePriceView?.backgroundColor = themeManager.isDarkModeActive ? 
                themeManager.cardBackgroundColor() : UIColor.white
            self.surgePriceHLbl?.textColor = themeManager.textColor()
            self.surgePriceVLbl?.textColor = themeManager.textColor()
            
            if themeManager.isDarkModeActive {
                self.surgePriceView?.layer.borderColor = themeManager.borderColor().cgColor
                self.surgePriceView?.layer.borderWidth = 0.5
            } else {
                self.surgePriceView?.layer.borderWidth = 0
            }
        }
        
        // 17a. Surge price background overlay
        if self.surgePriceBGView != nil {
            self.surgePriceBGView?.backgroundColor = themeManager.isDarkModeActive ? 
                UIColor.black.withAlphaComponent(0.7) : 
                UIColor.black.withAlphaComponent(0.5)
        }
        
        // 18. MSP cancel view (if present)
        if self.mspCancelView != nil && !self.mspCancelView.isHidden {
            // Keep the brand color but ensure proper visibility
            if themeManager.isDarkModeActive {
                GeneralFunctions.setImgTintColor(imgView: self.mspCancelImgView, color: UIColor.white)
                GeneralFunctions.setImgTintColor(imgView: self.mspCancelCloseImgView, color: UIColor.white)
            } else {
                GeneralFunctions.setImgTintColor(imgView: self.mspCancelImgView, color: UIColor.UCAColor.AppThemeTxtColor)
                GeneralFunctions.setImgTintColor(imgView: self.mspCancelCloseImgView, color: UIColor.UCAColor.AppThemeTxtColor)
            }
        }
        
        print("✅ ActiveTripUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
    }
    
    func closeEditItemView(){
        
        self.editItmeImgSelView.borderColor = UIColor.clear
        self.editItmeImgSelView.borderWidth = 0
        
        self.openImgSelection = nil
        self.editItemView.isHidden = true
        self.editItemBGView.isHidden = true
        self.clearSelectedItemImage()
    }
    func clearSelectedItemImage(){
           self.isImageSelected = false
           self.selectedFileData = nil
           self.selectedImgBgView.isHidden = true
           self.selectedImgBgWhiteView.isHidden = true
           self.selectedCheckImgView.isHidden = true
           self.takePhotoImgView.image = UIImage(named: "ic_cam")
           self.selectedCheckImgView.image = UIImage(named: "ic_add_plus")
           GeneralFunctions.setImgTintColor(imgView: self.selectedCheckImgView, color: UIColor.UCAColor.AppThemeTxtColor)
           self.selectedImgBgView.isHidden = false
           self.selectedImgBgWhiteView.isHidden = false
           self.selectedCheckImgView.isHidden = false
           
           self.cancelPhotoImgView.isHidden = true
    }
    
    @objc func photoImgTapped(){
        
        self.openImgSelection = OpenImageSelectionOption(uv: self)
        self.openImgSelection.isGenie = false
        self.openImgSelection.isUFXServicePhotoChoose = true
        self.openImgSelection.isChooseCategory = false
        self.openImgSelection.setImageSelectionHandler { (isImageSelected) in
            if(isImageSelected){
                
                self.editItmeImgSelView.borderColor = UIColor.clear
                self.editItmeImgSelView.borderWidth = 0
                
                self.isImageSelected = true
                self.selectedFileData = self.openImgSelection.selectedFileData
                self.selectedImgBgView.isHidden = false
                self.selectedImgBgWhiteView.isHidden = false
                self.selectedCheckImgView.isHidden = false
                self.takePhotoImgView.image = UIImage(data: self.selectedFileData)
                
                //self.selectedImage//UIImage(named: "ic_cam")
                self.selectedFileName = self.openImgSelection.fileName as String
                self.selectedCheckImgView.image = UIImage(named: "ic_edit")
                self.selectedImgBgView.isHidden = true
                self.selectedImgBgWhiteView.isHidden = true
                self.selectedCheckImgView.isHidden = true
                
                self.cancelPhotoImgView.isHidden = false
            }
        }
        self.openImgSelection.show { (isImageUpload) in
            if(isImageUpload == true){
                
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Your document is uploaded successfully", key: "LBL_UPLOAD_DOC_SUCCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    //self.performSegue(withIdentifier: "unwindToActiveTrip", sender: self)
                    
                })
            }
        }
    }
    
    func openEditItemView(){
        
        self.slideTripBtn.Reset()
        
        // Apply theme before showing
        let themeManager = ThemeManager.shared
        self.editItemView.backgroundColor = themeManager.isDarkModeActive ? themeManager.cardBackgroundColor() : UIColor.white
        self.editItemBGView.backgroundColor = themeManager.isDarkModeActive ? UIColor.black.withAlphaComponent(0.7) : UIColor.black.withAlphaComponent(0.5)
        
        if themeManager.isDarkModeActive {
            self.editItemView.layer.borderColor = themeManager.borderColor().cgColor
            self.editItemView.layer.borderWidth = 0.5
        } else {
            self.editItemView.layer.borderWidth = 0
        }
        
        self.editItemView.isHidden = false
        self.editItemBGView.isHidden = false

    }
    
    func setSafetyData(){
        self.editItemHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SAFETY_ESSENTIAL_VERIFICATION_TXT")
        self.personLimitNoteLbl.text = self.tripData.get("RESTRICT_PASSENGER_LIMIT_NOTE")
        
        
        self.safetyProofNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MASK_VERIFICATION_UPLOAD_PHOTO_TXT")
        
        
        
        if(self.userProfileJson.get("ENABLE_SAFETY_FEATURE_RIDE").uppercased() == "YES" || self.userProfileJson.get("ENABLE_SAFETY_FEATURE_DELIVERY").uppercased() == "YES" || self.userProfileJson.get("ENABLE_SAFETY_FEATURE_UFX").uppercased() == "YES"){
            
            if(tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
                if(self.userProfileJson.get("ENABLE_FACE_MASK_VERIFICATION").uppercased() != "YES" && self.userProfileJson.get("ENABLE_RESTRICT_PASSENGER_LIMIT").uppercased() == "YES"){
                    
                    self.editItmeImgSelView.isHidden = true
                    self.editItemViewHeight.constant = 240 + self.generalFunc.getLanguageLabel(origValue: "", key: "RESTRICT_PASSENGER_LIMIT_NOTE").height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont.init(name: Fonts().regular, size: 14)!)
                    self.editItemSubmitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"))
                    self.editItemSubmitBtn.btnType = "Ok"
                    
                }else if(self.userProfileJson.get("ENABLE_FACE_MASK_VERIFICATION").uppercased() == "YES" && self.userProfileJson.get("ENABLE_RESTRICT_PASSENGER_LIMIT").uppercased() != "YES"){
                    
                    self.personLimitNoteLbl.isHidden = true
                    self.editItemViewHeight.constant = 430 + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MASK_VERIFICATION_UPLOAD_PHOTO_TXT").height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont.init(name: Fonts().regular, size: 14)!)
                    self.editItemSubmitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT"))
                    self.editItemSubmitBtn.btnType = "Submit"
                    
                }else{
                    
                    self.personLimitNoteLbl.textColor = UIColor.UCAColor.red
                    
                    self.editItemViewHeight.constant = 430 + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MASK_VERIFICATION_UPLOAD_PHOTO_TXT").height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont.init(name: Fonts().regular, size: 14)!)
                    self.editItemSubmitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT"))
                    self.editItemSubmitBtn.btnType = "Submit"
                }
            }else{
                self.personLimitNoteLbl.isHidden = true
                self.editItemViewHeight.constant = 430 + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MASK_VERIFICATION_UPLOAD_PHOTO_TXT").height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont.init(name: Fonts().regular, size: 14)!)
                self.editItemSubmitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT"))
                self.editItemSubmitBtn.btnType = "Submit"
            }
        }
        
        self.editItemSubmitBtn.clickDelegate = self
        
        self.pageHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPLOAD_PHOTO")
        self.editItemTopBGView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        GeneralFunctions.setImgTintColor(imgView: self.cancelPhotoImgView, color: UIColor.black)
        GeneralFunctions.setImgTintColor(imgView: self.editItemCancelImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        GeneralFunctions.setImgTintColor(imgView: selectedCheckImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.selectedImgBgView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        photoImgTapGueForPluseBtn.addTarget(self, action: #selector(self.photoImgTapped))
        selectedImgBgView.isUserInteractionEnabled = true
        selectedImgBgView.addGestureRecognizer(photoImgTapGueForPluseBtn)
        
        self.editItemCancelImgView.setOnClickListener { (instance) in
            self.closeEditItemView()
        }
        
        self.cancelPhotoImgView.setOnClickListener { (instance) in
            self.clearSelectedItemImage()
        }
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EN_ROUTE_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EN_ROUTE_TXT")
        print("iTripId\(tripData.get("TripId"))")
        if(self.userProfileJson.getObj("TripDetails").get("eType") != "Multi-Delivery"){
            let rightButton = UIBarButtonItem(image: UIImage(named: "ic_menu")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openPopUpMenu))
            self.navigationItem.rightBarButtonItem = rightButton
        }

        self.contentView.isHidden = false

        self.btnIconImgView.isHidden = true
        self.tripBtn.clickDelegate = self
        
        
        // Safety
        self.setSafetyData()
        
        /* If set to Delegate SlideTripBtn */
        self.slideTripBtn.clickDelegate = self
        
        getAddressFrmLocation = GetAddressFromLocation(uv: self, addressFoundDelegate: self)
        
        btnPanGue.addTarget(self, action: #selector(self.btnPanning(sender:)))
        self.tripBtn.isUserInteractionEnabled = true
        self.tripBtn.addGestureRecognizer(btnPanGue)
        
//        if(self.getPubNubConfig().uppercased() == "YES"){
        
        ConfigPubNub.getInstance().buildPubNub()
        
//        }else{
//            self.updateDriverLoc = UpdateDriverLocations(uv: self)
//            self.updateDriverLoc.scheduleDriverLocUpdate()
//        }
        
        if(self.tripData.get("ePoolRide").uppercased() == "YES"){
            ConfigPubNub.getInstance().subscribeToCabReqChannel()
        }
        
        self.getLocation = GetLocation(uv: self, isContinuous: true)
        
        if((self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
            
            if(self.isTripStarted == true){
                self.getLocation.isAddLoc = true
            }
        }
        
        self.getLocation.buildLocManager(locationUpdateDelegate: self)
        
        if(userProfileJson.get("eEnableDemoLocDispatch").uppercased() == "YES"){
            dispatchDemoLocations = DispatchDemoLocations()
            dispatchDemoLocations.startDispatchingLocations(delegate: self)
        }
        
        
        SCHEDULED_TASK_DEFAULT_TIME_INTERVAL = (GeneralFunctions.parseDouble(origValue: 5.0, data: userProfileJson.get("SCHEDULED_TASK_DEFAULT_TIME_INTERVAL")) / 1000)
        
        self.tStartLat = GeneralFunctions.parseDouble(origValue: 0.0, data: self.tripData.get("sourceLatitude"))
        self.tStartLong = GeneralFunctions.parseDouble(origValue: 0.0, data: self.tripData.get("sourceLongitude"))
        
        if((self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
            
            if(isTripStarted){
                self.scheduledTask = UpdateFreqTask(interval: SCHEDULED_TASK_DEFAULT_TIME_INTERVAL)
                self.scheduledTask.currInst = self.scheduledTask
                self.scheduledTask.setTaskRunListener(onTaskRunCalled: self)
                self.scheduledTask.isAvoidFirstRun = true
                self.scheduledTask.startRepeatingTask()
            }
        }
        
//        if(self.topNavView != nil){
//            self.topNavView.navigateLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NAVIGATE")
//            self.topNavView.navOptionView.backgroundColor = UIColor.UCAColor.AppThemeColor_1
//            GeneralFunctions.setImgTintColor(imgView: self.topNavView.navImgView, color: UIColor.UCAColor.AppThemeTxtColor_1)
//            self.topNavView.navigateLbl.textColor = UIColor.UCAColor.AppThemeTxtColor_1
//
//            let navViewTapGue = UITapGestureRecognizer()
//            navViewTapGue.addTarget(self, action: #selector(self.navViewTapped))
//            self.topNavView.navOptionView.isUserInteractionEnabled = true
//            self.topNavView.navOptionView.addGestureRecognizer(navViewTapGue)
//        }
        
        /* If set to BackgroundColor for TopNavigationView */
        if(self.topNavigationView != nil){
            let themeManager = ThemeManager.shared
            self.topNavigationView.topHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
            self.topNavigationView.navContaintView.layer.shadowOpacity = 0.6
            self.topNavigationView.navContaintView.layer.shadowOffset = CGSize.zero
            self.topNavigationView.navContaintView.layer.shadowColor = themeManager.isDarkModeActive ? UIColor.black.cgColor : UIColor.lightGray.cgColor
        }
        
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
        self.mspCancelView.backgroundColor = UIColor.UCAColor.MSPCancelImageBGColor
        self.dialogueView.backgroundColor = UIColor.UCAColor.noteView
        self.jobView.backgroundColor = UIColor.UCAColor.jobView
        self.adminCallView.backgroundColor = UIColor.UCAColor.callToAdminView
        
        // Apply theme-aware icon tints (always white as they're on colored backgrounds)
        GeneralFunctions.setImgTintColor(imgView: self.callImgView, color: UIColor.white)
        GeneralFunctions.setImgTintColor(imgView: self.chatImgView, color: UIColor.white)
        GeneralFunctions.setImgTintColor(imgView: self.navigationImgView, color: UIColor.white)
        
        GeneralFunctions.setImgTintColor(imgView: self.mspCancelImageView, color: UIColor.UCAColor.AppThemeTxtColor)
        GeneralFunctions.setImgTintColor(imgView: self.mspCloseImageView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        if(self.tripData!.get("eHailTrip").uppercased() == "YES"){
            self.userNameLbl.text = self.tripData.get("PName")
        }else if(self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"){
            self.userNameLbl.text = self.tripData.get("vReceiverName")
        }else{
            self.userNameLbl.text = self.tripData.get("PName") //+ " " + self.tripData.get("vLastName")
        }
        
        self.userRatingView.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.tripData!.get("PRating"))
        
        let callTapGue = UITapGestureRecognizer()
        
        if(self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"){
            callTapGue.addTarget(self, action: #selector(self.deliveryCallTapped))
        }else{
            callTapGue.addTarget(self, action: #selector(self.getMaskedNumber))
        }
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
        
        initializeMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
        if(isTripStarted){
            if(tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                /* Hide TripBtn & RightArrowImgView */
                self.tripBtn.isHidden = true
                self.rightArrowImgView.isHidden = true
 
                self.slideTripBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_SLIDE_END_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_BTN_SLIDE_END_JOB_TXT" : "LBL_BTN_SLIDE_END_TRIP_TXT")))
                self.slideTripBtn.setBoldTitle(true)
                
                if(self.slideTripBtn.button != nil){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                        self.slideTripBtn.button!.imageEdgeInsets.left = 25
                        self.slideTripBtn.button!.imageEdgeInsets.right = 25
                        
                        self.slideTripBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 85 : 95) : (Configurations.isRTLMode() ? 45 : 65)
                        self.slideTripBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 95 : 85) : (Configurations.isRTLMode() ? 65 : 45)
                    }
                    
                    self.slideTripBtn.button!.titleLabel?.lineBreakMode = .byWordWrapping
                    self.slideTripBtn.button!.titleLabel?.numberOfLines = 2
                    self.slideTripBtn.button!.titleLabel?.adjustsFontSizeToFitWidth = true
                    self.slideTripBtn.button!.titleLabel?.minimumScaleFactor = 0.6
                    self.slideTripBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeTxtColor, bgColor: UIColor.UCAColor.TripEndButtonColor, pulseColor: UIColor.UCAColor.TripEndButtonColor)
                }
            }else{
                /* Hide TripBtn & RightArrowImgView */
                self.rightArrowImgView.isHidden = true
                self.tripBtn.isHidden = true
                
                /* If set to ButtonTitle for SlideTripBtn */
                self.slideTripBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_SLIDE_END_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_BTN_SLIDE_END_JOB_TXT" : "LBL_BTN_SLIDE_END_TRIP_TXT")))
                self.slideTripBtn.setBoldTitle(true)
                
                if(self.slideTripBtn.button != nil){
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        /* If set to ButtonImageEdgeInsets for SlideTripBtn */
                        self.slideTripBtn.button!.imageEdgeInsets.left = 25
                        self.slideTripBtn.button!.imageEdgeInsets.right = 25
                        
                        /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                        self.slideTripBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 75 : 85) : (Configurations.isRTLMode() ? 45 : 65)
                        self.slideTripBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 85 : 75) : (Configurations.isRTLMode() ? 65 : 45)
                        
                        if(self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
                            /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                            self.slideTripBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 85 : 95) : (Configurations.isRTLMode() ? 45 : 65)
                            self.slideTripBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 95 : 85) : (Configurations.isRTLMode() ? 75 : 45)
                        }
                        
                        if(self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" || self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver){
                            /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                            self.slideTripBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 25 : 75) : (Configurations.isRTLMode() ? 25 : 45)
                            self.slideTripBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 75 : 25) : (Configurations.isRTLMode() ? 65 : 25)
                        }
                    }
                    
                    self.slideTripBtn.button!.titleLabel?.lineBreakMode = .byWordWrapping
                    self.slideTripBtn.button!.titleLabel?.numberOfLines = 2
                    self.slideTripBtn.button!.titleLabel?.adjustsFontSizeToFitWidth = true
                    self.slideTripBtn.button!.titleLabel?.minimumScaleFactor = 0.6
                    self.slideTripBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeTxtColor, bgColor: UIColor.UCAColor.TripEndButtonColor, pulseColor: UIColor.UCAColor.TripEndButtonColor)
                }
            }
            
            if(iphoneXBottomView != nil){
                iphoneXBottomView.backgroundColor = UIColor.UCAColor.TripEndButtonColor
            }
            
            /* In Transist Shopping System. */
            if((tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.tripData.get("eRental").uppercased() != "YES") || (self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){

                if(self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS"){
                    self.waitingProgressBtn.isHidden = true
                }else{
                    self.waitingProgressBtn.isHidden = false
                }
                
                self.waitingProgressBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeColor, bgColor: UIColor.white, pulseColor: UIColor.UCAColor.AppThemeColor, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 2, cornerRadius: 5)
                self.waitingProgressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Wait", key: "LBL_WAIT"))
                self.waitingProgressBtn.clickDelegate = self
                self.waitingTimeLbl.isHidden = false
                self.waitingTimeLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                self.waitingTimeLbl.text = "00:00:00"
                self.manageWaitTime()
            }
            
            updateTripLocationService = UpdateTripLocationService(uv: self)
            updateTripLocationService.tripId = tripData.get("TripId")
            updateTripLocationService.scheduleDriverLocUpdate()
            self.btnIconImgView.image = UIImage(named: "ic_btn_trip_end")

        }else{
            if(tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                /* Hide TripBtn & RightArrowImgView */
                self.tripBtn.isHidden = true
                self.rightArrowImgView.isHidden = true
                
                self.slideTripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_SLIDE_BEGIN_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_BTN_SLIDE_BEGIN_JOB_TXT" : "LBL_BTN_SLIDE_BEGIN_TRIP_TXT")))
                self.slideTripBtn.setBoldTitle(true)
                
                if(self.slideTripBtn.button != nil){
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        /* If set to ButtonImageEdgeInsets for SlideTripBtn */
                        self.slideTripBtn.button!.imageEdgeInsets.left = 25
                        self.slideTripBtn.button!.imageEdgeInsets.right = 25
                        
                        /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                        
                        self.slideTripBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 25 : 75) : (Configurations.isRTLMode() ? 25 : 45)
                        self.slideTripBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 75 : 25) : (Configurations.isRTLMode() ? 65 : 25)

                    }
                    
                    self.slideTripBtn.button!.titleLabel?.lineBreakMode = .byWordWrapping
                    self.slideTripBtn.button!.titleLabel?.numberOfLines = 2
                    self.slideTripBtn.button!.titleLabel?.adjustsFontSizeToFitWidth = true
                    self.slideTripBtn.button!.titleLabel?.minimumScaleFactor = 0.6
                    self.slideTripBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeTxtColor, bgColor: UIColor.UCAColor.AppThemeColor, pulseColor: UIColor.UCAColor.AppThemeColor)
                }
            }else{
                /* Hide TripBtn & RightArrowImgView */
                self.tripBtn.isHidden = true
                self.rightArrowImgView.isHidden = true
                
                /* If set to ButtonTitle for SlideTripBtn */
                self.slideTripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_SLIDE_BEGIN_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_BTN_SLIDE_BEGIN_JOB_TXT" : "LBL_BTN_SLIDE_BEGIN_TRIP_TXT")))
                self.slideTripBtn.setBoldTitle(true)
                
                if(self.slideTripBtn.button != nil){
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        /* If set to ButtonImageEdgeInsets for SlideTripBtn */
                        self.slideTripBtn.button!.imageEdgeInsets.left = 25
                        self.slideTripBtn.button!.imageEdgeInsets.right = 25
                        
                        /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                        
                        self.slideTripBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 75 : 85) : (Configurations.isRTLMode() ? 45 : 65)
                        self.slideTripBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 85 : 75) : (Configurations.isRTLMode() ? 65 : 45)
                        
                        if(self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
                            /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                            self.slideTripBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 105 : 80) : (Configurations.isRTLMode() ? 45 : 65)
                            self.slideTripBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 105 : 80) : (Configurations.isRTLMode() ? 75 : 45)
                        }
                        
                        if(self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" || self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver){
                            /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                            self.slideTripBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 25 : 75) : (Configurations.isRTLMode() ? 25 : 45)
                            self.slideTripBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 75 : 25) : (Configurations.isRTLMode() ? 65 : 25)
                        }
                    }
                    
                    
                    self.slideTripBtn.button!.titleLabel?.lineBreakMode = .byWordWrapping
                    self.slideTripBtn.button!.titleLabel?.numberOfLines = 2
                    self.slideTripBtn.button!.titleLabel?.adjustsFontSizeToFitWidth = true
                    self.slideTripBtn.button!.titleLabel?.minimumScaleFactor = 0.6
                    self.slideTripBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeTxtColor, bgColor: UIColor.UCAColor.AppThemeColor, pulseColor: UIColor.UCAColor.AppThemeColor)
                }
            }
            
            if(iphoneXBottomView != nil){
                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
            }
            self.btnIconImgView.image = UIImage(named: "ic_btn_trip_start")
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.btnIconImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        self.addDestinationLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
        
        self.tollNoteViewHeight.constant = 0
        self.tollNoteView.isHidden = true
        self.tollNoteVLbl.isHidden = true
        
        /* Hide TollNoteLbl */
        if(tripData.get("eTollSkipped").uppercased() == "YES" && tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Ride){
            self.tollNoteView.isHidden = false
            self.tollNoteVLbl.isHidden = false
            
            let text = self.generalFunc.getLanguageLabel(origValue: "Passenger selected to skip the toll route. Please ignore toll route.", key: "LBL_TOLL_SKIP_HELP")
            self.tollNoteVLbl.text = text
            
            let height = text.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().semibold, size: 13)!)

            self.tollNoteViewHeight.constant = 10 + height
            
            self.tollNoteVLbl.numberOfLines = 0
        }
        
        let destLocLatitude = tripData.get("DestLocLatitude")
        let destLocLongitude = tripData.get("DestLocLongitude")
        let reqType = tripData.get("REQUEST_TYPE").uppercased()
        
        if (destLocLatitude != "" && destLocLatitude != "0"
            && tripData.get("DestLocLongitude") != "" && destLocLongitude != "0" && (reqType != Utils.cabGeneralType_UberX.uppercased() || (reqType == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") == "Regular"))) {
            
            let destLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: destLocLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: destLocLongitude))
            
//            updateDirections = UpdateDirections(uv: self, gMap: gMapView, destinationLocation: destLocation, navigateView: topNavView)
            
            
            
            self.timeLbl.isHidden = false
            self.distanceLbl.isHidden = false
            
            if(self.tripData.get("ePoolRide").uppercased() == "YES") {
                self.bottomDetailsViewHeight.constant = 128
            }else{
                self.bottomDetailsViewHeight.constant = 118
            }
            
            updateDirections = UpdateDirections(uv: self, gMap: gMapView, destinationLocation: destLocation, navigateView: topNavigationView)
            updateDirections.scheduleDirectionUpdate(eTollSkipped: tripData.get("eTollSkipped"))

//            self.topNavView.isHidden = false
            
            self.topNavigationView.isHidden = false
            self.addDestinationView.isHidden = false
            
            if(self.addDestView != nil){
                self.addDestLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
                self.addDestView.isHidden = true
            }
            addDestMarker(location: destLocation)
            
        }else{
            self.bottomDetailsViewHeight.constant = 80
            
            self.timeLbl.isHidden = true
            self.distanceLbl.isHidden = true
            
//            self.navigateView.isHidden = true
            self.addDestinationView.isHidden = false
            
            let addDestTapGue = UITapGestureRecognizer()
            addDestTapGue.addTarget(self, action: #selector(self.addDestinationTapped))
            
            self.addDestinationView.isUserInteractionEnabled = true
            self.addDestinationView.addGestureRecognizer(addDestTapGue)
            
            if(self.addDestView != nil){
                self.addDestLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
                self.addDestView.isUserInteractionEnabled = true
                self.addDestView.addGestureRecognizer(addDestTapGue)
            }
        }
        
        if(reqType == Utils.cabGeneralType_UberX.uppercased() && (destLocLatitude == "" || destLocLongitude == "" || tripData.get("eFareType") != "Regular")){
            
//            if(self.topNavView != nil){
//                self.topNavView.isHidden = true
//            }
            
            if(self.topNavigationView != nil){
                self.topNavigationView.isHidden = true
                self.timeLbl.isHidden = true
                self.distanceLbl.isHidden = true
            }
            
            if(self.addDestinationView != nil){
                self.addDestinationView.isHidden = true
            }
        }
        
        self.emeImgView.isHidden = false
        self.emeImgView.isUserInteractionEnabled = true
        let emeTapGue = UITapGestureRecognizer()
        emeTapGue.addTarget(self, action: #selector(self.emeImgViewTapped))
        self.emeImgView.addGestureRecognizer(emeTapGue)
            
        if(reqType == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") != "Regular"){
            self.emeImgView.isHidden = true
            self.googleLogoImgView.isHidden = true
            
            if(tripData.get("eFareType") == "Fixed"){
                self.progressViewHeight.constant = 0
                self.progressView.isHidden = true
                self.progressBtnView.isHidden = true
                ufxBGHeaderViewBottom.constant = 0
                headerViewHeight = headerViewHeight - 220
            }else if(tripData.get("eFareType") != "Fixed"){
                if(isTripStarted == false){
                    self.progressViewHeight.constant = 160
                    headerBGView.isHidden = false
                    self.progressBtnView.isHidden = true
                    headerViewHeight = headerViewHeight - 60
                }
            }
            
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.btnIconImgView.bounds.height + 10, right: 0)

            setUFXHeaderViewHeight()
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.tableFooterView = UIView()
            
            if #available(iOS 15.0, *) {
                self.tableView.sectionHeaderTopPadding = 0
            } else {}

            
            self.tableView.register(UINib(nibName: "MyOnGoingTripDetailsTVCell", bundle: nil), forCellReuseIdentifier: "MyOnGoingTripDetailsTVCell")
//            self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            
            self.jobStatusTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROGRESS_HINT")
            self.progressStatusTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_JOB_TIMER_HINT")
            
            self.hourHLbl.text = self.generalFunc.getLanguageLabel(origValue: "HOURS", key: "LBL_HOUR_TXT").uppercased()
            self.minuteHLbl.text = self.generalFunc.getLanguageLabel(origValue: "MINUTES", key: "LBL_MINUTES_TXT").uppercased()
            self.secHLbl.text = self.generalFunc.getLanguageLabel(origValue: "SECONDS", key: "LBL_SECONDS_TXT").uppercased()
            
            self.progressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Resume", key: "LBL_RESUME"))
            self.progressBtn.clickDelegate = self
            
            self.hourVLbl.text = "00"
            self.minuteVLbl.text = "00"
            self.secVLbl.text = "00"
            
            Utils.createRoundedView(view: self.hourVLbl, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
            Utils.createRoundedView(view: self.minuteVLbl, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
            Utils.createRoundedView(view: self.secVLbl, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
            
            let bottomPointImg = UIImage(named: "ic_bottom_anchor_point", in: Bundle(for: ActiveTripUV.self), compatibleWith: self.traitCollection)
            
            let iv = UIImageView(image: bottomPointImg)
            
            detailBottomVIew.backgroundColor = UIColor(patternImage: UIImage(named: "ic_bottom_anchor_point")!)
            bottomPointViewHeight.constant = iv.frame.height
            
            self.contentView.isHidden = true
            self.getData()
        }
        
        /* MSP Changes*/
        if(self.tripData.get("iStopId").uppercased() != ""){
        
            if(isTripStarted){
                
                if(self.tripData.get("totalStopOverPoint") != self.tripData.get("currentStopOverPoint")){
                    /* Bottom MSP Releted Changes*/
                    self.mspCancelView.isHidden = false

                    /* If set to ButtonTitle for SlideArrivedBtn */
                    self.slideTripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_STOPOVER_1") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_STOPOVER_2") + " " + Configurations.convertNumToAppLocal(numStr: self.tripData.get("currentStopOverPoint")))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                        self.slideTripBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 80 : 90) : (Configurations.isRTLMode() ? 45 : 65)
                        self.slideTripBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 90 : 80) : (Configurations.isRTLMode() ? 75 : 45)
                    }
                    
                    self.mspCancelView.setOnClickListener { (Instance) in
                        if(self.mspCloseImageView.isHidden == true){
                            self.mspCloseImageView.isHidden = false
                            self.mspCancelImageView.isHidden = true
                            
                            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_DROP_ALL_CONFIRM_TXT"), uv: self)
                            self.isDropAll = true
                            self.slideTripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SLIDE_END_TRIP_TXT"))
                            self.slideTripBtn.setBoldTitle(true)
                            self.mspEndTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.startBlinking), userInfo: nil, repeats: true)
                            self.mspEndTimer.fire()
                            
                        }else{
                            self.isDropAll = false
                            self.mspEndTimer.invalidate()
                            self.mspEndTimer = nil
                            self.mspCloseImageView.isHidden = true
                            self.mspCancelImageView.isHidden = false
                            self.slideTripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_STOPOVER_1") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_STOPOVER_2") + " " + Configurations.convertNumToAppLocal(numStr: self.tripData.get("currentStopOverPoint")))
                        }
                    }
                }
            }
        }/* ........*/
        
        // Fly Changes
        if(self.tripData.get("eFly").uppercased() == "YES"){
            self.navigationView.isHidden = true
            self.navigationView.isUserInteractionEnabled = false
        }
        
        checkLocationEnabled()
        addBackgroundObserver()
        
        if self.userProfileJson.get("ENABLE_ETA_AT_DRIVER_SIDE").uppercased() == "NO"{
            self.distanceLbl.isHidden = true
            self.timeLbl.isHidden = true
        }
        
        self.vehicleBaseTime()
    }
    
    func vehicleBaseTime(){
        let date = Calendar.current.date(byAdding: .second, value: Int(self.tripData.get("vBaseTime"))!, to: Date())
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from:date!)
        self.dateString = dateString
        
        Utils.printLog(msgData: "DateString::\(self.dateString)")
    }
    
    /* MSP Changes*/
    @objc func startBlinking(){
        
        if(self.tripBtn.buttonTitle != ""){
            self.tripBtn.setButtonTitle(buttonTitle:  "")
        }else{
            self.tripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SLIDE_END_TRIP_TXT"))
        }
        
        if(self.slideTripBtn.buttonTitle != ""){
            self.slideTripBtn.setButtonTitle(buttonTitle:  "")
        }else{
            self.slideTripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SLIDE_END_TRIP_TXT"))
            self.slideTripBtn.setBoldTitle(true)
        }
    }/* .........*/
    
    /* In-Transist Shopping System*/
    func manageWaitTime(){
        
        self.iTripTimeId = self.tripData.get("iTripTimeId")
        let totalSecond = GeneralFunctions.parseDouble(origValue: 0.0, data: self.tripData.get("TotalSeconds"))
        self.totalSecond = totalSecond
        
        let hours = Int(totalSecond / 3600)
        let minutes = Int(totalSecond.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(totalSecond.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
        
        self.waitingTimeLbl.text = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        Utils.printLog(msgData: "WT:MT: \(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(Int(totalSecond.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)))")
        
        if(self.tripData.get("TimeState") == "Resume"){
            self.isResume = true
            self.waitingProgressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Stop", key: "LBL_STOP"))
            self.runJobTimer()
        }else{
            self.isResume = false
            self.waitingProgressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Wait", key: "LBL_WAIT"))
            
        }
        
        if self.isResume{
            self.isResume = false
        }else{
            self.isResume = true
        }
    }/* In-Transist Shopping System*/
    
    func onDemoLocationDispatch(latitude: Double, longitude: Double) {
        
        if(updateTripLocationService != nil){
                    updateTripLocationService.onLocationUpdate(location: CLLocation(latitude: latitude, longitude: longitude))
                }
        
        onLocationUpdate(location: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = nil
        return true
    }
    func setUFXHeaderViewHeight(){
        
        self.tableView.parallaxHeader.view = self.ufxHeaderView
        self.tableView.parallaxHeader.height = headerViewHeight
        self.tableView.parallaxHeader.mode = .bottom
    }
    
    func addBackgroundObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)

    }
    
    func checkLocationEnabled(){
        if(locationDialog != nil){
            locationDialog.removeView()
            locationDialog = nil
        }
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied, .authorizedWhenInUse:
                    //                print("No access")
                    self.locationDialog = OpenLocationEnableView(uv: self, containerView: self.contentView, gMapView: self.gMapView, isMapLocEnabled: false)
                    self.locationDialog.show()
                    return
                case .authorizedAlways: break
                    
                default:
                    self.locationDialog = OpenLocationEnableView(uv: self, containerView: self.contentView, gMapView: self.gMapView, isMapLocEnabled: false)
                    self.locationDialog.show()
                    return
                }
            } else {
                //            print("Location services are not enabled")
                self.locationDialog = OpenLocationEnableView(uv: self, containerView: self.contentView, gMapView: self.gMapView, isMapLocEnabled: false)
                self.locationDialog.show()
                return
            }
        }
        
        
        if(InternetConnection.isConnectedToNetwork() == false){
            locationDialog = OpenLocationEnableView(uv: self, containerView: self.contentView, gMapView: self.gMapView, isMapLocEnabled: false)
            locationDialog.show()
            return
        }
    }
    
    @objc func appInBackground(){
        if(updateDirections != nil){
            updateDirections.pauseDirectionUpdate()
        }
    }
    
    @objc func appInForground(){
        checkLocationEnabled()
        
        ConfigPubNub.getInstance().unSubscribeToPrivateChannel()
        ConfigPubNub.getInstance().subscribeToPrivateChannel()
        
        if(updateDirections != nil){
            updateDirections.startDirectionUpdate()
        }
    }
    
    @objc func emeImgViewTapped(){
        let confirmEmergencyTapUV = GeneralFunctions.instantiateViewController(pageName: "ConfirmEmergencyTapUV") as! ConfirmEmergencyTapUV
        confirmEmergencyTapUV.iTripId = tripData.get("TripId")
        self.pushToNavController(uv: confirmEmergencyTapUV)
    }
    
    @objc func addDestinationTapped(){
       
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2" && tripData.get("vTripPaymentMode").uppercased() == "CARD" && tripData.get("ePayWallet").uppercased() == "YES"){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_ADD_DEST_FROM_DRIVER"))
            return
        }/* ............ */
        
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
//        addDestinationUv.centerLocation = self.currentLocation
        self.pushToNavController(uv: addDestinationUv)
    }
    
    @objc func navViewTapped(){
        if(isTripStarted == false){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_NAVIGATION_ALERT" : (tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"  ? "LBL_NAVIGATION_DELIVERY_ALERT" : "LBL_NAVIGATION_BOOKING_ALERT")))
           return
        }
        
        
        let openNavOption = OpenNavOption(uv: self, containerView: self.view, placeLatitude: tripData!.get("DestLocLatitude"), placeLongitude: tripData!.get("DestLocLongitude"))
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
    
    @objc func releaseAllTask(isDismiss:Bool = true){
        if(gMapView != nil){
            gMapView!.removeFromSuperview()
            gMapView!.clear()
            gMapView!.delegate = nil
            gMapView = nil
        }
        
        if(self.dispatchDemoLocations != nil){
            self.dispatchDemoLocations.stopDispatchingDemoLocations()
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
            self.updateDirections = nil
        }
        
        if(updateTripLocationService != nil){
            self.updateTripLocationService.releaseTask()
            self.updateTripLocationService = nil
        }
        
        if(self.scheduledTask != nil){
            self.scheduledTask.stopRepeatingTask()
            self.scheduledTask.onTaskRunCalled = nil
            self.scheduledTask = nil
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
    
    var isForSpeed = false
    var isForSpeed1 = false
    var distanceTraveled:Double = 0.0
    var distance_str = ""
    var dateString = ""
    var isStillCheckWaitingTime = true
    
    func onLocationUpdate(location: CLLocation) {
        
//        if(self.isTripStarted == true){
//            if((self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
//                if (self.getLocation.locationsPassed != nil && self.getLocation.locationsPassed.count > 0){
//
//                    self.distanceTraveled = self.getLocation.calculateAndDisplayDistance() //GeneralFunctions.parseDouble(origValue: 0.0, data: String(distanceTraveled))
//
//                    if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
//                        self.distanceTraveled = self.distanceTraveled * 0.000621371
//                    }else{
//                        self.distanceTraveled = self.distanceTraveled * 0.00099999969062399994
//                    }
//
//        //            self.distanceTraveled = self.distanceTraveled.roundTo(places: 2)
//
//                    self.distance_str = "\(String(format: "%.02f", self.distanceTraveled))"
//
//                    self.distanceTraveled = GeneralFunctions.parseDouble(origValue: 0.0, data: self.distance_str)
//
//                    Utils.printLog(msgData: "DistanceTraveled::\(String(describing: self.distanceTraveled))")
//
//
//                }
//            }
//        }
        
        self.intransitStartLocation = location
        self.currentLocation = location
        
        self.locationsPassed.append(self.currentLocation)
        
        if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() || (tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") == "Regular")){
            if(gMapView == nil){
                releaseAllTask()
                return
            }
            
            if(ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP.uppercased() == "YES" || tripData.get("DestLocLatitude") == "" || tripData.get("DestLocLatitude") == "0"
                && tripData.get("DestLocLongitude") == "" || tripData.get("DestLocLongitude") == "0"){
                var currentZoomLevel:Float = self.gMapView.camera.zoom
                
                if(currentZoomLevel < Utils.defaultZoomLevel && isFirstLocationUpdate == true){
                    currentZoomLevel = Utils.defaultZoomLevel
                }
                
                let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoomLevel:currentZoomLevel, mapView:self.gMapView)
                self.gMapView.animate(to: camera)
            }else{
                
                if(isFirstLocationUpdate && tripData != nil){
                    if(currentDestination == nil){
                        currentDestination = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLongitude")))
                    }
                    
                    var bounds = GMSCoordinateBounds()
                    bounds = bounds.includingCoordinate(location.coordinate)
                    bounds = bounds.includingCoordinate(currentDestination!.coordinate)
                    
                    /* Pool Ride. */
                    var addExtraPddingForPoolAndMultiDelivery:CGFloat = 0.0
                    if(self.tripData.get("ePoolRide").uppercased() == "YES" || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery") {
                        addExtraPddingForPoolAndMultiDelivery = 40.0
                    }
                    
//                    let edgeInsets = UIEdgeInsets.init(top: 125 + self.topNavView.tripIntervalLbl.frame.height, left: 20, bottom: 120 + addExtraPddingForPoolAndMultiDelivery + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 20)
                    
                    let edgeInsets = UIEdgeInsets.init(top: 125, left: 20, bottom: 120 + addExtraPddingForPoolAndMultiDelivery + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 20)
                    let update = GMSCameraUpdate.fit(bounds, with: edgeInsets)
                    self.gMapView.animate(with: update)
                }
            }
            
            isFirstLocationUpdate = false
            
//            if(self.isTripStarted == true){
//                if((self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
//
//                    var currentSpeed : Double = Double(location.speed) //String(format: "%.0f km/h", location.speed * 3.6)
//
//                    if(userProfileJson != nil && userProfileJson.get("eUnit") != "KMs"){
//                        currentSpeed = (currentSpeed * Double(2.23694)) //(Speed * Double(2.23693629))
//                    }else{
//                        currentSpeed = (currentSpeed * Double(3.6))
//                    }
//
//                    self.currentSpeed = currentSpeed
//
//                    Utils.printLog(msgData: "currentSpeed::\(currentSpeed)")
//
//                    let crossOverSpeed = GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("fCrossOverSpeed"))
//                    let vVehicleBookingDistance = GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("vVehicleBookingDistance"))
//                    if(self.distanceTraveled != nil){
////                        if((vVehicleBookingDistance < self.distanceTraveled && self.checkTime() == true) || (vVehicleBookingDistance > self.distanceTraveled && self.checkTime() == true)){
//                        if((vVehicleBookingDistance < self.distanceTraveled && self.checkTime() == true || vVehicleBookingDistance < self.distanceTraveled && self.checkTime() == false) || (vVehicleBookingDistance > self.distanceTraveled && self.checkTime() == true)){
//                            self.stopIntransitWaitingTime()
//                            if(currentSpeed > -1 || currentSpeed > 0){
//                                if(self.isForSpeed == false){
//        //                            if(currentSpeed < 0 || curentSpeed < crossOverSpeed) {
//                                    if(currentSpeed < crossOverSpeed){
//                                        Utils.printLog(msgData: "Speed Low")
//                                        if(self.isStartIntransitWaitingTime == false){
//                                            self.setJobTimeStatus()
//                                        }
//
//                                        self.isForSpeed1 = false
//                                        self.isForSpeed = true
//
//                                        self.isStillCheckWaitingTime = false
//                                    }
//                                }else{
//                                    if(self.isForSpeed == true && currentSpeed > crossOverSpeed){
//                                        if(self.isForSpeed1 == false){
//
//                                            self.isStartIntransitWaitingTime = false
//
//                                            Utils.printLog(msgData: "Speed High")
//                                            self.setJobTimeStatus()
//
//                                            self.isForSpeed1 = true
//                                            self.isForSpeed = false
//
//                                            self.isStillCheckWaitingTime = true
//                                        }
//                                    }
//                                }
//                            }else{
//                                self.isCheckIntransitWaitingTime = true
//                                self.startIntransitWaitingTime()
//                            }
//                        }else{
//                            self.isCheckIntransitWaitingTime = true
//                            self.startIntransitWaitingTime()
//                        }
//                    }else{
////                        Utils.printLog(msgData: "Distance is Not Travelled")
//                    }
//
//                }
//            }
            
            updateDriverMarker()
            updateLocationToPubNub()
        }
    }
    
    func setJobTimeStatus(){
        var parameters = ["type":"SetTimeForTrips", "iTripId": tripData!.get("TripId"), "UserType": Utils.appUserType, "iUserId": tripData!.get("PassengerId"), "eType":self.userProfileJson.getObj("TripDetails").get("eType")]
        
        if((self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
            
            parameters["iTripTimeId"] = self.iTripTimeId
            
        }else{
            if(!self.isResume){
                parameters["iTripTimeId"] = self.iTripTimeId
            }
        }
        
        if((self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
            
            parameters["intransitWaitingLat"] = "\(self.intransitStartLocation!.coordinate.latitude)"
            parameters["intransitWaitingLong"] = "\(self.intransitStartLocation!.coordinate.longitude)"
            parameters["eFareCalculation"] = "GPS"
        }
        
        Utils.printLog(msgData: "Parameters::\(parameters)")
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: self.isLoaderShow == true ? true : false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    let totalSecond = GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("totalTime"))
                    
                    self.totalSecond = totalSecond
                    self.alertCode = dataDict.get("alertMsgCode")
                        
                    let hours = Int(totalSecond / 3600)
                    let minutes = Int(totalSecond.truncatingRemainder(dividingBy: 3600) / 60)
                    let seconds = Int(totalSecond.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
                    
                    /* In-Transist Shopping Sytem*/
                    if((self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES") || (self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
                        self.waitingTimeLbl.text = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
                    }else{
                        self.hourVLbl.text = String(format: "%02d", hours)
                        self.minuteVLbl.text = String(format: "%02d", minutes)
                        self.secVLbl.text = String(format: "%02d", seconds)
                    }
                    
                    if((self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
                        
                        if(dataDict.get(Utils.message_str) != ""){
                            self.iTripTimeId = dataDict.get(Utils.message_str)
                        }
                        
                        if(self.alertCode == "1"){
                            self.runJobTimer()
                            self.isResume = true
                            self.isCountDownStarted = true
                            
                        }else if(self.alertCode == "2"){
                            self.stopJobTimer()
                            self.isResume = false
                            self.isCountDownStarted = false
                            self.iTripTimeId = ""
                        }
                        
                    }else{
                        if(!self.isResume){
                            self.stopJobTimer()
                            if(self.progressBtn != nil){
                                self.progressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Resume", key: "LBL_RESUME"))
                            }
                            
                            self.waitingProgressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Wait", key: "LBL_WAIT"))
                        }else{
                            
                            self.iTripTimeId = dataDict.get(Utils.message_str)
                            
                            if(self.progressBtn != nil){
                                self.progressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Pause", key: "LBL_PAUSE"))
                            }
                            
                            self.waitingProgressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Stop", key: "LBL_STOP"))
                            
                            
                            self.runJobTimer()
                        }
                        
                        if self.isResume{
                            self.isResume = false
                        }else{
                            self.isResume = true
                        }
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            self.tripTaskExecuted = false
        })
    }
    
    func onTaskRun(currInst: UpdateFreqTask) {
        if(currInst == self.animTask){
            
            if (self.i_anim < self.poolpath.count()) {
                
                self.animationPath.add(self.poolpath.coordinate(at: UInt(self.i_anim)))
                self.animationPolyline.path = self.animationPath
                
                self.animationPolyline.strokeColor = UIColor.gray
                self.animationPolyline.strokeWidth = 5
                
                self.animationPolyline.map = self.gMapView
                
                self.i_anim += 1
            }else{
                self.i_anim = 0
                self.animationPath = GMSMutablePath()
                self.animationPolyline.map = nil
            }

            return
        }else if(currInst == self.scheduledTask){
            
            if(self.locationsPassed.count == 0){
                return
            }
            
            let location = self.locationsPassed[self.locationsPassed.count - 1]
            
            if((self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
                
                if(self.isTripStarted){
                    
                    if((self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
                        
                        var currentSpeed : Double = Double(location.speed) //String(format: "%.0f km/h", location.speed * 3.6)
                        
                        if(userProfileJson != nil && userProfileJson.get("eUnit") != "KMs"){
                            currentSpeed = (currentSpeed * Double(2.23694)) //(Speed * Double(2.23693629))
                        }else{
                            currentSpeed = (currentSpeed * Double(3.6))
                        }
                        
                        self.currentSpeed = currentSpeed
                        
                        Utils.printLog(msgData: "currentSpeed::\(String(describing: self.currentSpeed))")
                        
                        self.distanceTraveled = 0.0
                        
//                        let loc = CLLocation(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
                        
                        let loc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                       
                        self.distanceTraveled =  loc.distance(from: CLLocation(latitude: self.tStartLat, longitude: self.tStartLong)) //0.008311075207568295
                        
                        if(self.distanceTraveled < 1.0){
                            self.distanceTraveled = 0.0
                        }
                        
                        if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
                            self.distanceTraveled = (self.distanceTraveled / 1609)
                        }else{
                            self.distanceTraveled = (self.distanceTraveled / 1000.0)
                        }
                        
                        Utils.printLog(msgData: "distanceTraveled::\(self.distanceTraveled)")
                        
                        let crossOverSpeed = GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("fCrossOverSpeed"))
                        let vVehicleBookingDistance = GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("vVehicleBookingDistance"))
                        
                        if((self.checkTime() || distanceTraveled > vVehicleBookingDistance) && (self.currentSpeed < crossOverSpeed) && !self.isCountDownStarted){
                            self.setJobTimeStatus()
                            self.isResume = true
                            self.isLoaderShow = false
                            
                        }else if((self.checkTime() || distanceTraveled > vVehicleBookingDistance) && (self.currentSpeed > crossOverSpeed) && self.isCountDownStarted){
                            self.setJobTimeStatus()
                            self.isResume = false
                            self.isLoaderShow = false
                        }
                    }
                }
            }
        }
        
    }
    
    func startIntransitWaitingTime(){
        if(intransitWaitingTimer != nil){
            intransitWaitingTimer!.invalidate()
        }
        
        intransitWaitingTimer =  Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.intransitWaitingTimeValue), userInfo: nil, repeats: true)
        
        intransitWaitingTimer.fire()
    }
    
    func stopIntransitWaitingTime(){
        if(intransitWaitingTimer != nil){
            intransitWaitingTimer!.invalidate()
        }
    }
    
    @objc func intransitWaitingTimeValue(){
        if(self.currentSpeed < 0 && self.checkTime() == true && self.isStillCheckWaitingTime == true){
            self.isStartIntransitWaitingTime = true
            if(self.isCheckIntransitWaitingTime){
                self.setJobTimeStatus()
                self.isCheckIntransitWaitingTime = false
            }
        }
    }
    
    func checkTime() -> Bool {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        let datecomponents = dateFormatter.date(from: self.dateString)
        
        let now = Date()
        
//        Utils.printLog(msgData: "Date1::\(now)")
//        Utils.printLog(msgData: "Date2::\(datecomponents)")
        
        if (now >= datecomponents!) {
            return true
        } else {
            return false
        }
        
//        if (datecomponents! >= now) {
//            return true
//        } else {
//            return false
//        }
        
    }
    
//    func checkTime() -> Bool {
//        let dateFormatter: DateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let date = Date()
//
//        let date2: Date = dateFormatter.date(from: self.dateString)!
//
//        let currentTime = 60*Calendar.current.component(.hour, from: date) + Calendar.current.component(.minute, from: date) + (Calendar.current.component(.second, from: date)/60) // in minutes
//        let time2 =  60*Calendar.current.component(.hour, from: date2) + Calendar.current.component(.minute, from: date2) + (Calendar.current.component(.second, from: date2)/60) // in minutes
//
//        Utils.printLog(msgData: "Currenttime::\(currentTime)")
//        Utils.printLog(msgData: "CurrenttimeAfter::\(time2)")
//
//        if(currentTime > time2 || (Int(self.tripData.get("vBaseTime")) == 0 && currentTime == time2)) {
//            return true
//        } else {
//            return false
//        }
//    }
    
    
    func totalDistance(of locations: [CLLocation]) -> CLLocationDistance {
        var distance: CLLocationDistance = 0.0
        var previousLocation: CLLocation?
        
        locations.forEach { location in
            if let previousLocation = previousLocation {
                distance += location.distance(from: previousLocation)
            }
            previousLocation = location
        }
        
        return distance
    }

    func updateDriverMarker(){
        if(currentLocation == nil || gMapView == nil){
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
        
        let previousItemOfMarker = Utils.getLastLocationDataOfMarker(marker: driverMarker)
        
        var tempData = [String:String]()
        tempData["vLatitude"] = "\(currentLocation.coordinate.latitude)"
        tempData["vLongitude"] = "\(currentLocation.coordinate.longitude)"
        tempData["iDriverId"] = "\(GeneralFunctions.getMemberd())"
        tempData["RotationAngle"] = "\(rotationAngle)"
        tempData["LocTime"] = "\(Utils.currentTimeMillis())"
        
        let tempDataDict = tempData as NSDictionary
        let locTimeData = tempDataDict.get("LocTime")
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
                Utils.driverMarkersPositionList.append(tempDataDict)
            }else{
                Utils.updateMarkerOnTrip(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 0.8, iDriverId: GeneralFunctions.getMemberd(), LocTime: locTimeData)
            }
            
        }else if(Utils.driverMarkerAnimFinished == false){
            Utils.driverMarkersPositionList.append(tempDataDict)
        }else{
            Utils.updateMarkerOnTrip(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 0.8, iDriverId: GeneralFunctions.getMemberd(), LocTime: locTimeData)
        }

        
//        driverMarker.position = self.currentLocation.coordinate
        
        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            let providerView = self.getProviderMarkerView(providerImage: UIImage(named: "ic_no_pic_user")!)
            driverMarker.icon = UIImage(view: providerView)
            (providerView.subviews[1] as! UIImageView).sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                self.driverMarker.icon = UIImage(view: providerView)
            })
            driverMarker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        }else{
           // driverMarker.icon = UIImage(named: "ic_driver_car_pin")

            let eIconType = tripData.get("eIconType")
            var iconId = "ic_driver_car_pin"
            
            if(eIconType == "Bike"){
                iconId = "ic_bike"
            }else if(eIconType == "Cycle"){
                iconId = "ic_cycle"
            }else if(eIconType == "Truck"){
                iconId = "ic_truck"
            }else if(eIconType == "Fly"){
                iconId = "ic_fly"
            }
            
            driverMarker.icon = UIImage(named: iconId)
            driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        }
//        driverMarker.icon = UIImage(named: "ic_driver_car_pin")
        driverMarker.map = self.gMapView
        driverMarker.title = GeneralFunctions.getMemberd()
        driverMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        driverMarker.isFlat = true
        
        if(ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP.uppercased() != "YES" && tripData.get("DestLocLatitude") != "" && tripData.get("DestLocLatitude") != "0"
            && tripData.get("DestLocLongitude") != "" && tripData.get("DestLocLongitude") != "0"){
            
            if(currentDestination == nil){
                currentDestination = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLongitude")))
            }
            
            var bounds = GMSCoordinateBounds()
            bounds = bounds.includingCoordinate(self.currentLocation.coordinate)
            bounds = bounds.includingCoordinate(self.currentDestination.coordinate)
//            let edgeInsets = UIEdgeInsets.init(top: 125 + self.topNavView.tripIntervalLbl.frame.height, left: 10, bottom: 120 + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 10)
            let edgeInsets = UIEdgeInsets.init(top: 150, left: 10, bottom: 250 + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 10)
            let update = GMSCameraUpdate.fit(bounds, with: edgeInsets)
            self.gMapView.animate(with: update)
        }else{
            var currentZoomLevel:Float = gMapView.camera.zoom
            
            if(currentZoomLevel < Utils.defaultZoomLevel){
                currentZoomLevel = Utils.defaultZoomLevel
            }
            
            
            let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude), zoomLevel:currentZoomLevel, mapView:self.gMapView)
            
            self.gMapView.animate(to: camera)
        }
        
        // FLy Changes
        if(self.currentLocation != nil && self.tripData!.get("eFly").uppercased() == "YES" && arcCreated == false){
            let destination = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLongitude")))
            self.buildArcPath(fromLoc: self.currentLocation, toLoc: destination, arcCurvature: 0.40)
            arcCreated = true
        }
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
        
        
        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() &&  tripData.get("eFareType") != "Regular"){
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_TXT"),"ID" : MENU_USER_CALL] as NSDictionary)
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MESSAGE_TXT"),"ID" : MENU_USER_MSG] as NSDictionary)
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "SOS", key: "LBL_EMERGENCY_SOS_TXT"),"ID" : MENU_EMERGENCY] as NSDictionary)
            
        }else if(self.tripData!.get("eHailTrip").uppercased() != "YES"){
//            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver ? "LBL_VIEW_DELIVERY_DETAILS" : "LBL_VIEW_PASSENGER_DETAIL"),"ID" : MENU_USER_OR_DELIVERY_DETAIL] as NSDictionary)
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_VIEW_DELIVERY_DETAILS" : (self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_VIEW_USER_DETAIL" : "LBL_VIEW_PASSENGER_DETAIL")),"ID" : MENU_USER_OR_DELIVERY_DETAIL] as NSDictionary)
        }
        
        
        if(tripData!.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() && userProfileJson.get("WAYBILL_ENABLE").uppercased() == "YES" && self.tripData!.get("eFly").uppercased() != "YES"){
//             ||  (tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() && self.tripData.get("eFareType") == "Regular")
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Way Bill", key: "LBL_MENU_WAY_BILL"),"ID" : MENU_WAY_BILL] as NSDictionary)
        }
        
        
        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            
            if(tripData!.get("moreServices").uppercased() == "YES"){
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TITLE_REQUESTED_SERVICES"),"ID" : MENU_SPECIAL_INS] as NSDictionary)
            }else{
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Special Instruction", key: "LBL_SPECIAL_INSTRUCTION_TXT"),"ID" : MENU_SPECIAL_INS] as NSDictionary)
            }
          
        }
        
        
//        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver ? "LBL_CANCEL_DELIVERY" : "LBL_CANCEL_TRIP"),"ID" : MENU_CANCEL_TRIP] as NSDictionary)
        if(self.tripData.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver){
            if(self.tripData.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver && !self.isTripStarted){
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_CANCEL_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_CANCEL_JOB" : "LBL_CANCEL_TRIP")),"ID" : MENU_CANCEL_TRIP] as NSDictionary)
            }
        }else{
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_CANCEL_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_CANCEL_JOB" : "LBL_CANCEL_TRIP")),"ID" : MENU_CANCEL_TRIP] as NSDictionary)
        }
        
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
                //            self.selectedCellLabel.text = items[indexPath]
                
                switch indexID {
                case self.MENU_USER_CALL:
                    self.getMaskedNumber()
                    break
                case self.MENU_USER_MSG:
                    let chatUV = GeneralFunctions.instantiateViewController(pageName: "MessagesViewController") as! MessagesViewController
                    chatUV.receiverId = self.tripData.get("PassengerId")
                    chatUV.receiverDisplayName = self.tripData.get("PName")
                    chatUV.assignedtripId = self.tripData.get("TripId")
                    chatUV.pPicName = self.tripData.get("PPicName")
//                    chatUV.serviceTripType = self.tripData.get("vServiceTitle")
                    chatUV.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.tripData.get("PRating"))
                       chatUV.bookingNo = self.tripData!.get("vRideNo")
                    chatUV.assignedtripDate  = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.tripData!.get("tTripRequestDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
                    self.pushToNavController(uv:chatUV, isDirect: true)
                    break
                case self.MENU_EMERGENCY:
                    self.emeImgViewTapped()
                    break
                case self.MENU_USER_OR_DELIVERY_DETAIL:
                    if(self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver){
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
                case self.MENU_WAY_BILL:
                    let wayBillUV = GeneralFunctions.instantiateViewController(pageName: "WayBillUV") as! WayBillUV
                    self.pushToNavController(uv: wayBillUV)
                    break
                case self.MENU_SPECIAL_INS:
                    if(self.tripData!.get("moreServices").uppercased() == "YES"){
                        
                    }else{
                        self.generalFunc.setError(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "Special Instruction", key: "LBL_SPECIAL_INSTRUCTION_TXT"), content: self.tripData!.get("tUserComment") == "" ? (self.generalFunc.getLanguageLabel(origValue: "There is a No Special Instruction", key: "LBL_NO_SPECIAL_INSTRUCTION")) : self.tripData!.get("tUserComment") )
                    }
                    
                    break
                case self.MENU_CANCEL_TRIP:
//                    let openCancelBooking = OpenCancelBooking(uv: self)
//                    openCancelBooking.cancelTrip(eTripType: self.tripData!.get("REQUEST_TYPE"), PAGE_TYPE: "", iTripId: self.tripData!.get("TripId"), iCabBookingId: "") { (iCancelReasonId, reason) in
//                        self.onTripCanceled(iCancelReasonId: iCancelReasonId, reason: reason)
//                    }
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
                    
                default:
                    break
                }
            }
        }else{
            menu.updateItems(items)
        }
    }
    
    @objc func getMaskedNumber(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
        if userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
           // if SinchCalling.getInstance().client.isStarted(){
                
                
                let selfDic = ["Id":userProfileJson.get("iDriverId"), "Name": userProfileJson.get("vName"), "PImage": userProfileJson.get("vImage"), "type": Utils.appUserType]
                let assignedDic = ["Id":self.tripData.get("PassengerId"), "Name": self.tripData.get("PName"), "PImage": self.tripData.get("PPicName"), "type": "Passenger"]
                SinchCalling.getInstance().makeACall(IDString:"Passenger" + "_" + self.tripData.get("PassengerId"), assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:"")
                return
                
           // }
        }
        
        //if(userProfileJson.get("CALLMASKING_ENABLED").uppercased() == "YES"){
            let parameters = ["type":"getCallMaskNumber","iTripid": self.tripData!.get("TripId"), "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.contentView, isOpenLoader: true)
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
//                        let number = "\(dataDict.get(Utils.message_str))"
//                        UIApplication.shared.openURL(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
                        if let number = "\(dataDict.get(Utils.message_str))" as? String,
                           let encodedNumber = "tel://\(number)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                           let url = URL(string: encodedNumber) {

                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    }else{
//                        let number = "\(self.tripData!.get("PPhone"))"
//                        
//                        UIApplication.shared.openURL(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
                        
                        if let number = "\(self.tripData!.get("PPhone"))" as? String,
                           let encodedNumber = "tel://\(number)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                           let url = URL(string: encodedNumber) {

                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
            })
      //  }else{
      //      let number = "\(self.tripData!.get("PPhone"))"
            
      //      UIApplication.shared.openURL(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
      //  }
        
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
        self.cancelReason = reason
        self.iCancelReasonId = iCancelReasonId
        
        isTripEndPressed = false
        
        if(isTripStarted == true){
            getAddressFrmLocation.setLocation(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
            getAddressFrmLocation.executeProcess(isOpenLoader: true, isAlertShow:true)
            return
        }
        
        let parameters = ["type":"cancelTrip","iDriverId": GeneralFunctions.getMemberd(), "iUserId": tripData!.get("PassengerId"), "iTripId": tripData!.get("TripId"), "UserType": Utils.appUserType, "Reason": reason, "iCancelReasonId": iCancelReasonId,"vLatitude" : "\(currentLocation!.coordinate.latitude)","vLongitude" : "\(currentLocation!.coordinate.longitude)"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.stopIntransitWaitingTime()
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
    
    func addDestination(latitude: String, longitude: String, address:String, eConfirmByUser:String, tollPrice:String, tollPriceCurrencyCode:String, isTollSkipped:String, eTollConfirmByUser:String) {
        if(self.userProfileJson.get("ENABLE_TOLL_COST").uppercased() == "YES" && isTollChecked == false){
            self.destinationOnTripLatitude = latitude
            self.destinationOnTripLongitude = longitude
            self.destinationOnTripAddress = address
            
            if(self.currentLocation != nil && GeneralFunctions.parseDouble(origValue: 0.0, data: latitude) != 0.0 && GeneralFunctions.parseDouble(origValue: 0.0, data: longitude) != 0.0){
                
                checkTollPrice(fromLocation: self.currentLocation, toLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: latitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: longitude)), eConfirmByUser: eConfirmByUser)
            }
            return
        }
        
        let parameters = ["type":"addDestination","iMemberId": GeneralFunctions.getMemberd(), "Latitude": latitude, "Longitude": longitude, "Address": address, "UserType": Utils.appUserType, "TripId": tripData!.get("TripId"), "eConfirmByUser": eConfirmByUser, "fTollPrice": tollPrice, "vTollPriceCurrencyCode": tollPriceCurrencyCode, "eTollSkipped": isTollSkipped, "eTollConfirmByUser": eTollConfirmByUser == "" ? "No" : "\(eTollConfirmByUser)"]
        
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
                    if(dataDict.get("eTollExist").uppercased() == "YES"){
                        let openTollBox = OpenTollBox(uv: self, containerView: self.contentView)
                        openTollBox.setViewHandler(handler: { (isContinueBtnTapped, isTollSkipped) in
                            if(isContinueBtnTapped){
                                
                                self.addDestination(latitude: latitude, longitude: longitude, address: address, eConfirmByUser: eConfirmByUser, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped == true ? "Yes" : "No", eTollConfirmByUser: "Yes")
                                
                            }else{
                                self.isTollChecked = false
                            }
                        })
                        
                        
                        openTollBox.show(tollPrice: "\(tollPriceCurrencyCode) \(tollPrice)", currentFare: "")
                        return
                    }
                    
                    if(dataDict.get("message").uppercased() == "YES"){
                        self.isTollChecked = false
                        self.destinationOnTripLatitude = latitude
                        self.destinationOnTripLongitude = longitude
                        self.destinationOnTripAddress = address
                        
                        self.openSurgeConfirmDialog(dataDict: dataDict)
                        return
                    }
                    self.isTollChecked = false
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.isTollChecked = false
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
        func checkTollPrice(fromLocation:CLLocation, toLocation:CLLocation, eConfirmByUser:String){
              
              let vCurrencyDriver = self.userProfileJson.get("vCurrencyDriver")
              
              let tollURL = "https://fleet.api.here.com/2/calculateroute.json?app_id=\(self.userProfileJson.get("TOLL_COST_APP_ID"))&app_code=\(self.userProfileJson.get("TOLL_COST_APP_CODE"))&waypoint0=\(fromLocation.coordinate.latitude),\(fromLocation.coordinate.longitude)&waypoint1=\(toLocation.coordinate.latitude),\(toLocation.coordinate.longitude)&mode=fastest;car&tollVehicleType=car&currency=\(vCurrencyDriver)"
              
              Utils.printLog(msgData: "tollURL::\(tollURL)")
              
              let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: true)
              
              exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
                  
                  if(response != ""){
                      let dataDict = response.getJsonDataDict()
                      
                      let routeArr = dataDict.getObj("response").getArrObj("route")
                      
                      if routeArr.count > 0 {
                          
                          let routeObj = (routeArr[0] as! NSDictionary)
                          let onError = routeObj.getObj("tollCost").get("onError")
                          
                          if(onError.uppercased() == "FALSE" || onError == "0"){
                              self.isTollChecked = true
                              
                              let totalCost = routeObj.getObj("cost").get("totalCost")
                              let currency = routeObj.getObj("cost").get("currency")
                              
                              if(totalCost != "0.0"){
                                  self.addDestination(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: eConfirmByUser, tollPrice: totalCost, tollPriceCurrencyCode: currency, isTollSkipped: "No", eTollConfirmByUser: "")
                              }else{
                                  self.addDestination(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: eConfirmByUser, tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "")
                              }
                          }else{
                              self.isTollChecked = true
                              
                              self.addDestination(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: eConfirmByUser, tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "")
                          }
                      }else{
                          self.isTollChecked = true
                          
                          self.addDestination(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: eConfirmByUser, tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "")
                      }
                  }else{
                      self.generalFunc.setError(uv: self)
                  }
              }, url: tollURL)
          }
    
    func openSurgeConfirmDialog(dataDict:NSDictionary){
        
        surgePriceView = self.generalFunc.loadView(nibName: "SurgePriceView", uv: self, isWithOutSize: true)
        
        let width = Application.screenSize.width  > 390 ? 375 : Application.screenSize.width - 50
        
        var defaultHeight:CGFloat = 154
        surgePriceView.frame.size = CGSize(width: width, height: defaultHeight)
        
        surgePriceView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY)
        
        // Apply theme to surge price view
        let themeManager = ThemeManager.shared
        surgePriceView.backgroundColor = themeManager.isDarkModeActive ? themeManager.cardBackgroundColor() : UIColor.white
        
        if themeManager.isDarkModeActive {
            surgePriceView.layer.borderColor = themeManager.borderColor().cgColor
            surgePriceView.layer.borderWidth = 0.5
        } else {
            surgePriceView.layer.borderWidth = 0
        }
        
        surgePriceBGView = UIView()
        surgePriceBGView.backgroundColor = themeManager.isDarkModeActive ? UIColor.black : UIColor.black
        self.surgePriceBGView.alpha = 0
        surgePriceBGView.isUserInteractionEnabled = true
        
        let bgViewTapGue = UITapGestureRecognizer()
        surgePriceBGView.frame = self.contentView.frame
        
        surgePriceBGView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY)
        
        bgViewTapGue.addTarget(self, action: #selector(self.cancelSurgeView))
        
        surgePriceBGView.addGestureRecognizer(bgViewTapGue)
        
        surgePriceView.layer.shadowOpacity = 0.5
        surgePriceView.layer.shadowOffset = CGSize(width: 0, height: 3)
        surgePriceView.layer.shadowColor = UIColor.black.cgColor
        
        surgePriceView.alpha = 0
        self.view.addSubview(surgePriceBGView)
        self.view.addSubview(surgePriceView)
        
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.surgePriceBGView.alpha = 0.4
                        self.surgePriceView.alpha = 1
        },  completion: { finished in
            self.surgePriceBGView.alpha = 0.4
            self.surgePriceView.alpha = 1
        })
        
        let cancelSurgeTapGue = UITapGestureRecognizer()
        cancelSurgeTapGue.addTarget(self, action: #selector(self.cancelSurgeView))
        
        surgeLaterLbl.isUserInteractionEnabled = true
        surgeLaterLbl.addGestureRecognizer(cancelSurgeTapGue)
        
        self.surgeLaterLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRY_LATER")
        
        if(dataDict.get("eFlatTrip").uppercased() == "YES"){
            self.surgePayAmtLbl.isHidden = true
            self.surgePayAmtLbl.text = ""
            defaultHeight = defaultHeight - 20
            self.surgePriceVLbl.text = (dataDict.get("Action") == "1" || dataDict.get("SurgePrice") == "") ? dataDict.get("fFlatTripPricewithsymbol") : "\(Configurations.convertNumToAppLocal(numStr: dataDict.get("fFlatTripPricewithsymbol"))) (\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AT_TXT")) \(Configurations.convertNumToAppLocal(numStr: dataDict.get("SurgePrice"))))"
            self.surgePriceHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FIX_FARE_HEADER")
            self.surgeAcceptBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPT_TXT"))
        }else{
            self.surgePriceVLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("SurgePrice"))
            self.surgePriceHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str))
            self.surgeAcceptBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPT_SURGE"))
        }
        
        let headerTxtHeight = self.surgePriceHLbl.text!.height(withConstrainedWidth: width - 20, font: UIFont(name: Fonts().light, size: 17)!)
        let priceTxtHeight = self.surgePriceVLbl.text!.height(withConstrainedWidth: width - 20, font: UIFont(name: Fonts().light, size: 26)!)
        let payAmtTxtHeight = self.surgePayAmtLbl.text!.height(withConstrainedWidth: width - 20, font: UIFont(name: Fonts().light, size: 16)!)
        
        self.surgePriceHLbl.fitText()
        self.surgePayAmtLbl.fitText()
        self.surgePriceVLbl.fitText()
        
        defaultHeight = defaultHeight + headerTxtHeight + priceTxtHeight + payAmtTxtHeight
        surgePriceView.frame.size = CGSize(width: width, height: defaultHeight)
        surgePriceView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY)
        
        self.surgeAcceptBtn.clickDelegate = self
        
    }
    
    @objc func cancelSurgeView(){
        if(surgePriceView != nil){
            surgePriceView.removeFromSuperview()
        }
        
        if(surgePriceBGView != nil){
            surgePriceBGView.removeFromSuperview()
        }
    }

    func addDestMarker(location:CLLocation){
    
        destinationMarker.position = location.coordinate
        
        destinationMarker.icon = UIImage(named: "ic_destination_place_image")
        destinationMarker.map = self.gMapView
        destinationMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
    }
    
    func startTrip(isFromServicePhoto:Bool){
        
    
        if(self.currentLocation == nil){
            UIView.animate(withDuration: 0.95) {
                if(self.slideTripBtn != nil){
                    self.slideTripBtn.Reset()
                }
            }
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
            return
        }
        
        if(tripData.get("eBeforeUpload").uppercased() == "YES" && isFromServicePhoto == false){
            return
        }
        
        var parameters = ["type":"StartTrip","iDriverId": GeneralFunctions.getMemberd(), "TripID": tripData!.get("TripId"), "iUserId": tripData!.get("PassengerId"), "UserType": Utils.appUserType,"vLatitude" : "\(currentLocation.coordinate.latitude)","vLongitude" : "\(currentLocation.coordinate.longitude)","iTripDeliveryLocationId":tripData!.get("iTripDeliveryLocationId")]

        
        if(self.userProfileJson.get("ENABLE_SAFETY_FEATURE_RIDE").uppercased() == "YES" || self.userProfileJson.get("ENABLE_SAFETY_FEATURE_DELIVERY").uppercased() == "YES" || self.userProfileJson.get("ENABLE_SAFETY_FEATURE_UFX").uppercased() == "YES"){
            
            if(tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
                
                if(self.userProfileJson.get("ENABLE_FACE_MASK_VERIFICATION").uppercased() == "YES" || self.userProfileJson.get("ENABLE_RESTRICT_PASSENGER_LIMIT").uppercased() == "YES"){
                    
                    if(self.userProfileJson.get("ENABLE_FACE_MASK_VERIFICATION").uppercased() != "YES" && self.userProfileJson.get("ENABLE_RESTRICT_PASSENGER_LIMIT").uppercased() == "YES"){
                        
                        self.serviceImageData = nil
                        
                    }else{
                        
                        self.selectedFileName = "FaceMask_Img.png"
                        parameters["vFaceMaskVerifyImage"] = "FaceMask_Img.png"
                        
                        if(self.selectedFileData != nil){
                            self.serviceImageData = self.selectedFileData
                            
                        }
                    }
                }
                
            }else{
                if(self.userProfileJson.get("ENABLE_FACE_MASK_VERIFICATION").uppercased() == "YES"){
                    self.selectedFileName = "FaceMask_Img.png"
                    parameters["vFaceMaskVerifyImage"] = "FaceMask_Img.png"
                    
                    if(self.selectedFileData != nil){
                        self.serviceImageData = self.selectedFileData
                        
                    }
                }else{
                    self.selectedFileName = "UserService.png"
                }
                
            }
        }
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        
        if(self.serviceImageData != nil){
            exeWebServerUrl.uploadImage(fileData: self.serviceImageData,fileName: self.selectedFileName, completionHandler: { (response) -> Void in
                
                if(response != ""){
                    
                    print(response)
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
                    }else if (dataDict.get(Utils.message_str)) == "" {
                         self.generalFunc.setError(uv: self)
                    }
                    else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                        
                        UIView.animate(withDuration: 0.95) {

                            /* If Reset to SlideTripBtn */
                            if(self.slideTripBtn != nil){
                                self.slideTripBtn.Reset()
                            }
                        }
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                    
                    /* If Reset to SlideTripBtn */
                    UIView.animate(withDuration: 0.95) {
                        if(self.slideTripBtn != nil){
                            self.slideTripBtn.Reset()
                        }
                    }
                }
                self.tripTaskExecuted = false
            })
        }else{
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.releaseAllTask()
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                    }else if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        
                        self.releaseAllTask()
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                        
                        UIView.animate(withDuration: 0.95) {
                            
                            /* If Reset to SlideTripBtn */
                            if(self.slideTripBtn != nil){
                                self.slideTripBtn.Reset()
                            }
                        }
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                    
                    /* If Reset to SlideTripBtn */
                    UIView.animate(withDuration: 0.95) {
                        if(self.slideTripBtn != nil){
                            self.slideTripBtn.Reset()
                        }
                    }
                }
                self.tripTaskExecuted = false
            })
        }
        
    }
    
    func endTrip(dAddress:String, dest_lat:String, dest_lon:String, isTripCancelled:Bool, iCancelReasonId:String, reason:String, isFromServicePhoto:Bool, isFromAdditionalCharges:Bool, materialFee:String, miscFee:String, providerDiscount:String){
        if(self.currentLocation == nil){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
            return
        }
        if(tripData.get("eAfterUpload").uppercased() == "YES" && isFromServicePhoto == false){
            return
        }
        
        var latitudeList = ""
        var longitudeList = ""
        
        if(updateTripLocationService != nil){
            if(self.latitudeList.count == 0 || self.longitudeList.count == 0){
                self.latitudeList.removeAll()
                self.longitudeList.removeAll()
                
            }
            
             latitudeList = updateTripLocationService.latitudeList.joined(separator:",")
             longitudeList = updateTripLocationService.longitudeList.joined(separator:",")
        
        }else{
             latitudeList = ""
             longitudeList = ""
        }
        
        var parameters = ["type":"ProcessEndTrip", "TripId": tripData!.get("TripId"), "latList": "\(latitudeList)", "lonList": "\(longitudeList)", "PassengerId": tripData!.get("PassengerId"),"DriverId": GeneralFunctions.getMemberd(), "dAddress": dAddress, "dest_lat": dest_lat, "dest_lon": dest_lon, "UserType": Utils.appUserType, "isTripCanceled": isTripCancelled == true ? "true" : "", "iCancelReasonId": isTripCancelled == true ? iCancelReasonId : "", "Reason": isTripCancelled == true ? reason : "", "fMaterialFee": materialFee, "fMiscFee": miscFee, "fDriverDiscount": providerDiscount, "iTripDeliveryLocationId":tripData!.get("iTripDeliveryLocationId")]
        
        /* MSP Changes */
        if(self.tripData.get("iStopId") != ""){
            parameters["iStopId"] = self.tripData.get("iStopId")
            parameters["isDropAll"] = "\(self.isDropAll)"
        }/* ........ */
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        
        if(self.serviceImageData != nil){
            exeWebServerUrl.uploadImage(fileData: self.serviceImageData, fileName: "UserService.png", completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.stopIntransitWaitingTime()
                        self.releaseAllTask()
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                    }else if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        self.stopIntransitWaitingTime()
                        self.releaseAllTask()
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                        
                        /* If Reset to SlideTripBtn */
                        UIView.animate(withDuration: 0.95) {
                            if(self.slideTripBtn != nil){
                                self.slideTripBtn.Reset()
                            }
                        }
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                    
                    /* If Reset to SlideTripBtn */
                    UIView.animate(withDuration: 0.95) {
                        if(self.slideTripBtn != nil){
                            self.slideTripBtn.Reset()
                        }
                    }
                }
                self.tripTaskExecuted = false
            })
        }else{
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.stopIntransitWaitingTime()
                        self.releaseAllTask()
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                    }else if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        self.stopIntransitWaitingTime()
                        self.releaseAllTask()
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                        
                        /* If Reset to SlideTripBtn */
                        UIView.animate(withDuration: 0.95) {
                            if(self.slideTripBtn != nil){
                                self.slideTripBtn.Reset()
                            }
                        }
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                    
                    /* If Reset to SlideTripBtn */
                    UIView.animate(withDuration: 0.95) {
                        if(self.slideTripBtn != nil){
                            self.slideTripBtn.Reset()
                        }
                    }
                }
                self.tripTaskExecuted = false
            })
        }
        
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesMoved(touches, with: event)
//
//        let touch: UITouch = touches.first as! UITouch
//
//        if (touch.view == self.tripBtn){
//            print("touchesMoved | This is an ImageView")
//
//            let point = touch.location(in: self.view)
//
//            let pointX = point.x
//            let pointY = point.y
//
//            print("PointX:\(pointX)")
//        }else{
//            print("touchesMoved | This is not an ImageView")
//        }
//    }
    
//    var btnPanTaskComplete = false
    
    @objc func btnPanning(sender:UIPanGestureRecognizer){
        
        if (Configurations.isRTLMode() ? sender.isLeft() : sender.isRight()) {
            let center = sender.view?.center
            let translation = sender.translation(in: sender.view)
//            center = CGPoint(center!.x + translation.x, center!.y + translation.y)
//            sender.view?.center = center!
//            sender .setTranslation(CGPoint.zero, in: sender.view)
            

            if((Configurations.isRTLMode() ? (translation.x + center!.x < 0) : (translation.x > center!.x)) && tripTaskExecuted == false){
//                btnPanTaskComplete = true
//                self.tripBtn.removeGestureRecognizer(btnPanGue)
                
                tripTaskExecuted = true
                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//                    self.tripBtn.addGestureRecognizer(self.btnPanGue)
//                    self.btnPanTaskComplete = false
//                })
                
                if(self.isTripStarted){
                    
                    if(self.tripData.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver && self.isTripStarted && self.userProfileJson.getObj("TripDetails").get("eType") != "Multi-Delivery"){
                        
                        let openDeliveryConfirmCodeView = OpenEnterDeliveryCode(uv: self, containerView: self.contentView, deliveryCode: self.tripData!.get("vDeliveryConfirmCode"))
                        openDeliveryConfirmCodeView.show()
                        
                        
//                        tripTaskExecuted = false
                        return
                    }
                    
                    continueEndTrip()
                    
//                    self.endTrip()
                }else{
                    self.startTrip(isFromServicePhoto: false)
                }
            }
        }
    }
    
    /* If set to SlideButtonAction Action*/
    
    func myBtnSlided(sender: MySliderButton) {
        if(sender == self.slideTripBtn){

            tripTaskExecuted = true

            if(self.isTripStarted){

                if(self.tripData.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver && self.isTripStarted && self.userProfileJson.getObj("TripDetails").get("eType") != "Multi-Delivery"){

                    
                    let openDeliveryConfirmCodeView = OpenEnterDeliveryCode(uv: self, containerView: self.contentView, deliveryCode: self.tripData!.get("vDeliveryConfirmCode"))
                    openDeliveryConfirmCodeView.show()
                    return
                }
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_CONFIRM_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedId) in

                    if(btnClickedId == 0){
                        //self.setDriverStatusToArrived()
                        self.continueEndTrip()
                    }else{
                        UIView.animate(withDuration: 0.95) {
                            self.slideTripBtn.Reset()
                        }
                    }
                })
//                continueEndTrip()
            }else{
                
                if(tripData.get("eAskCodeToUser").uppercased() == "YES" && self.isOTPVerificationDone == false){
                    
                    self.openOTPConfView()
                    return
                    
                }
                
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_START_TRIP_CONFIRM_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedId) in

                    if(btnClickedId == 0){
                        //self.setDriverStatusToArrived()
                        self.continueStartTrip()
                    }else{
                        UIView.animate(withDuration: 0.95) {
                            self.slideTripBtn.Reset()
                        }
                    }
                })
              //  self.continueStartTrip()
            }
        }
    }
    
    func continueStartTrip(){
        if(self.userProfileJson.get("ENABLE_SAFETY_FEATURE_RIDE").uppercased() == "YES" || self.userProfileJson.get("ENABLE_SAFETY_FEATURE_DELIVERY").uppercased() == "YES" || self.userProfileJson.get("ENABLE_SAFETY_FEATURE_UFX").uppercased() == "YES"){
            
            if((self.userProfileJson.get("ENABLE_FACE_MASK_VERIFICATION").uppercased() == "YES" || self.userProfileJson.get("ENABLE_RESTRICT_PASSENGER_LIMIT").uppercased() == "YES") && self.userProfileJson.get("ONLYDELIVERALL") != "Yes"){
                
                self.openEditItemView()
                return
            }
        }
        
        self.startTrip(isFromServicePhoto: false)
    }
    
    func continueEndTrip(){
        if(currentLocation != nil){
            
            self.isTripEndPressed = true
            
            getAddressFrmLocation.setLocation(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
            getAddressFrmLocation.executeProcess(isOpenLoader: true, isAlertShow: true)
        }else{
            
            tripTaskExecuted = false
        }
    }
    
    func onAddressFound(address: String, location: CLLocation, isPickUpMode:Bool, dataResult:String) {
        if(address == ""){
            tripTaskExecuted = false
            return
        }
        print(self.tripData.get("PaymentPerson"))
        if(isTripEndPressed == true){
            
            if self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" && (self.tripData.get("ePaymentByReceiverForDelivery") == "Yes" || self.tripData.get("PaymentPerson") == "Each Recipient"){
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_PAYMENT_COLLECTED_MSG_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if btnClickedIndex == 0
                    {
                        self.endTrip(dAddress: address, dest_lat: "\(location.coordinate.latitude)", dest_lon: "\(location.coordinate.longitude)", isTripCancelled: false, iCancelReasonId: "", reason: "", isFromServicePhoto: false, isFromAdditionalCharges: false, materialFee: "", miscFee: "", providerDiscount: "")
                    }else
                    {
                        self.isTripEndPressed = true
                        self.tripTaskExecuted = false
                        self.slideTripBtn.Reset()
                    }
                    
                })
            }else{
                self.endTrip(dAddress: address, dest_lat: "\(location.coordinate.latitude)", dest_lon: "\(location.coordinate.longitude)", isTripCancelled: false, iCancelReasonId: "", reason: "", isFromServicePhoto: false, isFromAdditionalCharges: false, materialFee: "", miscFee: "", providerDiscount: "")
            }
            
        }else{
            
            if self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" &&  (self.tripData.get("ePaymentByReceiverForDelivery") == "Yes" || self.tripData.get("PaymentPerson") == "Each Recipient"){
                
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_PAYMENT_COLLECTED_MSG_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if btnClickedIndex == 0
                    {
                        self.endTrip(dAddress: address, dest_lat: "\(location.coordinate.latitude)", dest_lon: "\(location.coordinate.longitude)", isTripCancelled: true, iCancelReasonId: self.iCancelReasonId, reason: self.cancelReason, isFromServicePhoto: false, isFromAdditionalCharges: false, materialFee: "", miscFee: "", providerDiscount: "")
                    }else
                    {
                        self.isTripEndPressed = true
                        self.tripTaskExecuted = false
                        self.slideTripBtn.Reset()
                    }
                    
                })
                
            }else{
                self.endTrip(dAddress: address, dest_lat: "\(location.coordinate.latitude)", dest_lon: "\(location.coordinate.longitude)", isTripCancelled: true, iCancelReasonId: self.iCancelReasonId, reason: self.cancelReason, isFromServicePhoto: false, isFromAdditionalCharges: false, materialFee: "", miscFee: "", providerDiscount: "")
            }
            
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
        
        self.bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)))
        self.bgView.backgroundColor = themeManager.isDarkModeActive ? UIColor.black.withAlphaComponent(0.7) : UIColor.black.withAlphaComponent(0.5)
        
        self.view.addSubview(self.bgView)
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
        self.slideTripBtn.Reset()
        self.jobOTPVerificationView.removeFromSuperview()
        self.bgView.removeFromSuperview()
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
    
    func getData(){
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        self.ufxCntView.isHidden = true
        let parameters = ["type":"getTripDeliveryLocations", "iTripId": tripData.get("TripId"), "userType": Utils.appUserType,"iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            //            print("Response:\(response)")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let driverDetails = dataDict.getObj(Utils.message_str).getObj("driverDetails")
                    Utils.createRoundedView(view: self.senderImgView, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1)
                    
                    self.senderImgView.sd_setImage(with: URL(string: "\(CommonUtils.passenger_image_url)\(driverDetails.get("iUserId"))/\(driverDetails.get("riderImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        
                    })
                    
//                    self.senderNameLbl.textColor = UIColor.UCAColor.AppThemeColor
                    self.senderNameLbl.text = driverDetails.get("riderName").capitalized
                    self.ratingView.rating = GeneralFunctions.parseFloat(origValue: 0, data: driverDetails.get("riderRating"))
                   
                    self.ratingView.fullStarColor = UIColor.UCAColor.selected_rate_color
                    self.ratingView.emptyStarColor = UIColor.UCAColor.unSelected_rate_color
                    self.sourceAddLbl.text = driverDetails.get("tSaddress").trim()
                    self.sourceAddLbl.fitText()
                    
                    let extraHeight = self.sourceAddLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 106, font: UIFont(name: Fonts().light, size: 14)!) - 17

                    self.senderViewHeight.constant = 90 + extraHeight
                    self.headerViewHeight = self.headerViewHeight + extraHeight + 40
                    self.setUFXHeaderViewHeight()
                    
                    let dataArr = dataDict.getObj(Utils.message_str).getArrObj("States")
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        self.dataArrList += [dataTemp]
                        
                    }
                    
                    self.tableView.reloadData()
                    
                    self.iTripTimeId = self.tripData.get("iTripTimeId")
                    
                    let totalSecond = GeneralFunctions.parseDouble(origValue: 0.0, data: self.tripData.get("TotalSeconds"))
                    self.totalSecond = totalSecond
                    
                    let hours = Int(totalSecond / 3600)
                    let minutes = Int(totalSecond.truncatingRemainder(dividingBy: 3600) / 60)
                    let seconds = Int(totalSecond.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
                    
                    self.hourVLbl.text = String(format: "%02d", hours)
                    self.minuteVLbl.text = String(format: "%02d", minutes)
                    self.secVLbl.text = String(format: "%02d", seconds)
                    
                    if(self.tripData.get("TimeState") == "Resume"){
                        self.isResume = true
                        self.progressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Pause", key: "LBL_PAUSE"))
                        self.runJobTimer()
                    }else{
                        self.isResume = false
                        self.progressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Resume", key: "LBL_RESUME"))
                    }
                    
                    if self.isResume{
                        self.isResume = false
                    }else{
                        self.isResume = true
                    }
                    
                }else{
//                    _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
                self.contentView.isHidden = false
                
                self.ufxCntView.isHidden = false
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            self.loaderView.isHidden = true
        })
    }
    
    func runJobTimer(){
        if(jobTimer != nil){
            jobTimer!.invalidate()
        }
        
        jobTimer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateJobTimerValue), userInfo: nil, repeats: true)
        
        jobTimer.fire()
    }
    
    func stopJobTimer(){
        if(jobTimer != nil){
            jobTimer!.invalidate()
        }
    }
    
    @objc func updateJobTimerValue(){
        
        self.totalSecond = self.totalSecond + 1
        
        let hours = Int(totalSecond / 3600)
        let minutes = Int(totalSecond.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(totalSecond.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
        
        /* In-Transist Shopping Sytem*/
        if((tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()  && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES") || (tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.userProfileJson.get("ENABLE_GPS_MODEL").uppercased() == "YES" && self.tripData.get("eFareCalcModel").uppercased() == "GPS")){
            
            self.waitingTimeLbl.text = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
            
        }else{
            self.hourVLbl.text = String(format: "%02d", hours)
            self.minuteVLbl.text = String(format: "%02d", minutes)
            self.secVLbl.text = String(format: "%02d", seconds)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOnGoingTripDetailsTVCell", for: indexPath) as! MyOnGoingTripDetailsTVCell
        let formattedString = NSMutableAttributedString()

        let item = self.dataArrList[indexPath.item]
        cell.progressMsgLbl.text = item.get("text")
        let last  = String(item.get("time").suffix(2))
        let first = String(item.get("time").prefix(5))
        let atributedText = formattedString.bold(first).normal("\n\(last)")
        
        cell.progressPastTimeLbl.attributedText = atributedText //item.get("timediff")
        cell.progressPastTimeLbl.textAlignment = .center
        cell.noLbl.text = "\(indexPath.item + 1)"
        Utils.createRoundedView(view: cell.noView, borderColor: UIColor.clear, borderWidth: 0)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        if (self.dataArrList.count-1) == indexPath.row {
            cell.noView.backgroundColor = UIColor.UCAColor.AppThemeColor
            cell.noLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            cell.progressMsgLbl.textColor = UIColor.UCAColor.AppThemeColor
            cell.progressPastTimeLbl.textColor = UIColor.UCAColor.AppThemeColor
            cell.bottomPipeView.isHidden = true
        }else {
            cell.noView.backgroundColor = UIColor(hex:0xe1e1e1)
            cell.bottomPipeView.backgroundColor = UIColor(hex:0xe1e1e1)
            cell.noLbl.textColor = UIColor.black
            cell.progressMsgLbl.textColor = UIColor.black
            cell.progressPastTimeLbl.textColor = UIColor.black
            Utils.createRoundedView(view: cell.noView, borderColor: UIColor(hex:0xe0e0e0), borderWidth: 0.5)
            cell.bottomPipeView.isHidden = false
        }
        
        return cell
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
    
    
    func myBtnTapped(sender: MyButton) {
        if(self.progressBtn != nil && sender == self.progressBtn || self.waitingProgressBtn != nil && sender == self.waitingProgressBtn){
            self.setJobTimeStatus()
        }else if(surgeAcceptBtn != nil && sender == surgeAcceptBtn){
            self.cancelSurgeView()
           
            self.addDestination(latitude: self.destinationOnTripLatitude, longitude: self.destinationOnTripLongitude, address: self.destinationOnTripAddress, eConfirmByUser: "Yes", tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "")
        }else if(sender == self.editItemSubmitBtn){
            
            if(self.isImageSelected == false && sender.btnType == "Submit"){
                self.editItmeImgSelView.borderColor = UIColor.red
                self.editItmeImgSelView.borderWidth = 1
                
                return
            }
            self.startTrip(isFromServicePhoto: false)
            
        }else if(self.jobOTPVerificationView != nil && sender == self.jobOTPVerificationView.submitOTPBtn){
      
            if(GeneralFunctions.getRandomSecCode(code: self.otp_str) == self.tripData.get("vText"))
            {
                self.closeOTPView()
                self.isOTPVerificationDone = true
                self.continueStartTrip()
                self.jobOTPVerificationView.otpStackView.setAllFieldColor(color: UIColor.UCAColor.AppThemeColor)
            }else{
                self.jobOTPVerificationView.otpStackView.setAllFieldColor(color: UIColor.UCAColor.red)
                self.jobOTPVerificationView.errorLbl.isHidden = false
            }
        }
    }
    
    @IBAction func unwindToActiveTrip(_ segue:UIStoryboardSegue) {
        
        if(segue.source.isKind(of: AddDestinationUV.self)){
            
            let addDestUv = segue.source as! AddDestinationUV
            
            addDestination(latitude: "\(addDestUv.selectedLocation.coordinate.latitude)", longitude: "\(addDestUv.selectedLocation.coordinate.longitude)", address: "\(addDestUv.selectedAddress)", eConfirmByUser: "No", tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "")
        }
        
    }
    
    /* For Fly Animation Pickup to destination */
    func buildArcPath(fromLoc:CLLocation, toLoc:CLLocation, arcCurvature:Double){
        if self.gMapView == nil
        {
            return
        }
        var fromLocation = fromLoc
        var toLocation = toLoc
        let maxZoomLevel = 6
        self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: 6)
        
        
        var distance = SphericalUtil.computeDistanceBetween(from: fromLocation, to: toLocation)
        var heading = SphericalUtil.computeHeading(from: fromLocation, to: toLocation)
        
        if(heading < 0){
            let tmpFromLoc = fromLocation
            fromLocation = toLocation
            toLocation = tmpFromLoc
            
            distance = SphericalUtil.computeDistanceBetween(from: fromLocation, to: toLocation)
            heading = SphericalUtil.computeHeading(from: fromLocation, to: toLocation)
        }
        
        let midPointLnt = SphericalUtil.computeOffset(from: fromLocation, distance: distance * 0.5, heading: heading)
        
        let x:Double = ((1 - (arcCurvature * arcCurvature)) * (distance * 0.5)) / (2 * arcCurvature)
        let r:Double = ((1 + (arcCurvature * arcCurvature)) * (distance * 0.5)) / (2 * arcCurvature)
        
        let centerLnt = SphericalUtil.computeOffset(from: midPointLnt, distance: x, heading: heading + 90.0)
        
        let heading1 = SphericalUtil.computeHeading(from: centerLnt, to: fromLocation)
        let heading2 = SphericalUtil.computeHeading(from: centerLnt, to: toLocation)
        
        let numPoints = 100.0
        let step = (heading2 - heading1) / numPoints
        
        let path = GMSMutablePath()
        var bounds = GMSCoordinateBounds()
        
        for i in 0 ..< Int(numPoints) {
            let tempLoc = SphericalUtil.computeOffset(from: centerLnt, distance: r, heading: heading1 + (Double(i) * step))
            Utils.printLog(msgData: "TempLocation::\(tempLoc)")
            path.addLatitude(tempLoc.coordinate.latitude, longitude: tempLoc.coordinate.longitude)
            bounds =  bounds.includingCoordinate(tempLoc.coordinate)
        }
        poolpath = path
        let update = GMSCameraUpdate.fit(bounds, withPadding: 45)
        let polylineForPool = GMSPolyline(path: path)
        polylineForPool.strokeWidth = 4.0
        polylineForPool.strokeColor = UIColor(hex: 0x373737)
        polylineForPool.geodesic = true
        let destLocLatitude = tripData.get("DestLocLatitude")
        let destLocLongitude = tripData.get("DestLocLongitude")
        let destLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: destLocLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: destLocLongitude))
        let dist  = self.currentLocation?.distance(from: destLocation)
        //        let dist  = self.currentLocation1.distance(from: self.destLocation)
        let _: [Any] = [GMSStrokeStyle.solidColor(UIColor.black), GMSStrokeStyle.solidColor(UIColor.clear)]
        let _: [Any] = [dist!/40,dist!/65]
        //polylineForPool.spans = GMSStyleSpans(polylineForPool.path!, styles as! [GMSStrokeStyle], lengths as! [NSNumber], GMSLengthKind.rhumb)
        polylineForPool.map = self.gMapView
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: 14)
        }
        
        //        self.gMapView.animate(with: update)
        self.gMapView.moveCamera(update)
        CATransaction.commit()
        
        //self.i_anim = 0
        
        //self.animatePolyLine()
    }
    
    func animatePolyLine(_ isForPool:Bool = false){
        self.stopAnimatePolyLine()
        
        animationPathOrig.removeAllCoordinates()
        
        animationPolylineOrig.map = nil
        
        var i_anim:Int = 0
        
        while(i_anim < self.animLocationArr.count){
            self.animationPathOrig.add(self.animLocationArr[i_anim])
            self.animationPolylineOrig.path = self.animationPathOrig
            self.animationPolylineOrig.strokeColor = UIColor.black
            self.animationPolylineOrig.strokeWidth = 5
            self.animationPolylineOrig.map = self.gMapView
            i_anim += 1
        }
        
        
        //        if self.animLocationArr.count < 40
        //        {
        //            self.createMultipleLocations()
        //        }
        
        //        var totalParts = Double(self.animLocationArr.count) / Utils.MAX_ROUTE_ANIM_INTERVAL
        //        totalParts = totalParts > 1 ? totalParts : 1
        //        let animLocArrParts = self.animLocationArr.chunked(by: Int(totalParts))
        //        self.animLocArrParts = animLocArrParts
        //
        //        let subSec = 1.0 / CGFloat((totalParts > 0 ? self.animLocArrParts[0].count : 1))
        
        var interValForPathArayCount:Double = Double(self.animLocationArr.count)
        interValForPathArayCount = Double(self.poolpath.count())
        
        let interval = self.MAX_ROUTE_ANIM_INTERVAL / interValForPathArayCount
        animTask = UpdateFreqTask(interval: interval / 1000)
        animTask.currInst = animTask
        animTask.setTaskRunListener(onTaskRunCalled: self)
        
        animTask.startRepeatingTask()
    }
    func stopAnimatePolyLine(){
        
        if(animTask != nil){
            animTask.stopRepeatingTask()
        }
        
        self.animationPath.removeAllCoordinates()
        self.animationPath = GMSMutablePath()
        self.animationPolyline.map = nil
        
        animationPathOrig.removeAllCoordinates()
        animationPathOrig = GMSMutablePath()
        
        animationPolylineOrig.map = nil
        
        
    }
}

extension Date {

  func isEqualTo(_ date: Date) -> Bool {
    return self == date
  }
  
  func isGreaterThan(_ date: Date) -> Bool {
     return self > date
  }
  
  func isSmallerThan(_ date: Date) -> Bool {
     return self < date
  }
}
