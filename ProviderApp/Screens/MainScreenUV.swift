//
//  MainScreenUV.swift
//  DriverApp
//
//  Created by ADMIN on 11/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import SwiftExtensionData
import SafariServices

var onlineOrOffline:String = ""
var fdTap = false
var notificationCounter = ""
var isZoneTap = false
var isTncAcceptedThisSession = false
class MainScreenUV: UIViewController, OnLocationUpdateDelegate, OnTaskRunCalledDelegate, GMSMapViewDelegate, MyLabelClickDelegate, UITableViewDelegate, UITableViewDataSource, AddressFoundDelegate, MyBtnClickDelegate, FABMenuDelegate, CMSwitchViewWithLabelDelegate, MySliderBtnClickDelegate {
    
    @IBOutlet weak var typeWithZoneName: NSLayoutConstraint!
    @IBOutlet weak var typeWithFB: NSLayoutConstraint!
    @IBOutlet weak var uc45: UILabel!
    @IBOutlet weak var zoneLeading: NSLayoutConstraint!
    @IBOutlet weak var typeTxt: UILabel!
    @IBOutlet weak var paxTxt: UILabel!
    
    
    @IBOutlet weak var vtForBid: UILabel!
    @IBOutlet weak var uc30: UILabel!
    @IBOutlet weak var uc30minTxt: UILabel!
    @IBOutlet weak var uc15: UILabel!
    @IBOutlet weak var uc15minTxt: UILabel!
    @IBOutlet weak var nowTxt: UILabel!
    @IBOutlet weak var carsTxt: UILabel!
    @IBOutlet weak var zoneTxt: UILabel!
    @IBOutlet weak var typeWithPaxLeading: NSLayoutConstraint!
    @IBOutlet weak var zoneOrBidTableView: UITableView!
    @IBOutlet weak var zoneTapView: UIView!
    @IBOutlet weak var bidTapView: UIView!
    @IBOutlet weak var zoneView: UIView!
    @IBOutlet weak var zoneViewImg: UIImageView!
    @IBOutlet weak var bidViewImg: UIImageView!
    @IBOutlet weak var zoneLbl: MyLabel!
    @IBOutlet weak var bidLbl: MyLabel!
    @IBOutlet weak var bidCountLbl: UILabel!
    
    @IBOutlet weak var zonesDetailView: UIView!
    @IBOutlet weak var callToAdminView: UIView!
    @IBOutlet weak var callToAdminViewImg: UIImageView!
    @IBOutlet weak var callToAdminLbl: MyLabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var googleMapContainerView: UIView!
    @IBOutlet weak var changeCarLbl: MyLabel!
    @IBOutlet weak var carNameLBl: MyLabel!
    @IBOutlet weak var carNumLbl: MyLabel!
    @IBOutlet weak var driverCarImgView: UIImageView!
    @IBOutlet weak var myLocImgView: UIImageView!
    @IBOutlet weak var heatMapImgView: UIImageView!
    @IBOutlet weak var taxiHailImgView: UIImageView!
    @IBOutlet weak var ufxScrollView: UIScrollView!
    @IBOutlet weak var ufxSwitchCntView: UIView!
    @IBOutlet weak var ufxAddressContainerView: UIView!
    @IBOutlet weak var driverDetailBottomCOntainerViewHeight: NSLayoutConstraint!
    
    //WorkLocation Outlets
    @IBOutlet weak var workLocArea: UIView!
    @IBOutlet weak var workLocAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var workLocLbl: MyLabel!
    @IBOutlet weak var workLocImgView: UIImageView!
    @IBOutlet weak var editWorkLocBtn: MyButton!
    
    // UFXMain screen OutLets
    @IBOutlet weak var ufxHeaderView: UIView!
    @IBOutlet weak var jobLocHLbl: MyLabel!
    @IBOutlet weak var jobLocAddLbl: MyLabel!
    @IBOutlet weak var availabilityRadiusLbl: MyLabel!
    @IBOutlet weak var availRadiusLblWidth: NSLayoutConstraint!
    @IBOutlet weak var editAvailRadiusImgView: UIImageView!
    @IBOutlet weak var upcomingJobCountLbl: MyLabel!
    @IBOutlet weak var jobAreaSeperatorView: UIView!
    @IBOutlet weak var pendingJobAreaView: UIView!
    @IBOutlet weak var upcomingJobAreaView: UIView!
    @IBOutlet weak var pendingJobCountLbl: MyLabel!
    @IBOutlet weak var pendingJobLbl: MyLabel!
    @IBOutlet weak var upcomingJobLbl: MyLabel!
    @IBOutlet weak var ufxUserNameLbl: MyLabel!
    @IBOutlet weak var ufxJobLocAreaHeight: NSLayoutConstraint!
    
    // Select Car Design Outlets
    @IBOutlet weak var closeCarImgView: UIImageView!
    @IBOutlet weak var selectCarHImgView: UIImageView!
    @IBOutlet weak var selectCarHLbl: MyLabel!
    @IBOutlet weak var selectCarTableView: UITableView!
    @IBOutlet weak var addNewVehicleLbl: MyLabel!
    @IBOutlet weak var manageVehiclesLbl: MyLabel!
    
    // DRIVER DESTINATION MODE //
    @IBOutlet weak var driverDestiImgView: UIImageView!
    @IBOutlet weak var hailImgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var driverDestinationModeView: UIView!
    @IBOutlet weak var destAddressLbl: MyLabel!
    @IBOutlet weak var destAddressSHLbl: MyLabel!
    @IBOutlet weak var cancelimgView: UIImageView!
    @IBOutlet weak var startDestModeBtn: MySliderButton!
    @IBOutlet weak var noteLbl: MyLabel!
    @IBOutlet weak var destModeViewHeight: NSLayoutConstraint!
    
    let linearBar: LinearProgressBar = LinearProgressBar()
    @IBOutlet weak var driverDestTopHeight: NSLayoutConstraint!
    @IBOutlet weak var driverDestTopCloseView: UIImageView!
    @IBOutlet weak var driverDestTopView: UIView!
    @IBOutlet weak var destAddressTopLbl: MyLabel!
    @IBOutlet weak var destAddressTopAnimatedView: UIView!
    @IBOutlet weak var destModeOnTopLbl: MyLabel!
    @IBOutlet weak var destAddressBGView: UIView!
    @IBOutlet weak var destAddressLeftBGView: UIView!
    
    // SubScription
    @IBOutlet var subscriptionView: UIView!
    @IBOutlet weak var subscriptionBgView: UIView!
    @IBOutlet weak var subscriptionDialogView: UIView!
    @IBOutlet weak var subscriptionSHLbl: MyLabel!
    @IBOutlet weak var subscriptionImgView: UIImageView!
    @IBOutlet weak var subscriptionHLbl: MyLabel!
    @IBOutlet weak var subscriptionDoneBtn: MyButton!
    @IBOutlet weak var subscriptionCancelBtn: MyButton!
    
    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var topDriverDetailView: UIView!
    @IBOutlet weak var changeCarImgView: UIImageView!
    @IBOutlet weak var cntBGVIew: UIView!
    
    @IBOutlet weak var headerStackView: UIStackView!
    
    @IBOutlet weak var hailTapView: UIView!
    
    @IBOutlet weak var noDataAvailZoneView: MyLabel!
    @IBOutlet weak var hailMenuLbl: MyLabel!
   
    @IBOutlet weak var hailIcon: UIImageView!
    var onOffSwitch:CMSwitchViewWithLabel!
    
    var userProfileJson:NSDictionary!
    
    var navItem:UINavigationItem!
    
    var rightView:UIView!
    var getAddressFromLocation:GetAddressFromLocation!
    
    var gMapView:GMSMapView!
    
    let generalFunc = GeneralFunctions()
    
    var getLocation:GetLocation!
    
    var isDriverOnline:Bool = false
    
    var currentLocation:CLLocation?
    
    var isHeatMapEnabled = false
    
    var task_update_heatMapData: ExeServerUrl?
    
    var historyData = [String]()
    var onlineData = [String]()
    
    var currentRadius = 0.0
    var dtaCircleHeatMap = [GMSMarker]()
    
    var updateCurrentReqFreqTask:UpdateFreqTask!
    var currentReqTaskPosition = 0
    var isFirstLocationUpdate = true
    
    var window:UIWindow!
    
    var isDataSet = false
    
    var updateDriverStatus:UpdateDriverStatus!
    
    var carListDataArrList = [NSDictionary]()
    
    var selectCarView:UIView!
    var selectCarBGView:UIView!
    
    let userLocTapGue = UITapGestureRecognizer()
    
    var locationDialog:OpenLocationEnableView!
    
    var isMyLocationEnabled = true
    
    private var gradientColors = [UIColor.red , UIColor.white]
    private var gradientStartPoints = [0.005,1.0]
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var onlineHeatmapLayer: GMUHeatmapTileLayer!
    private var onlineGradientColors = [UIColor.green]
    private var onlineGradientStartPoints = [0.2]
    
    var isCameraUpdateIgnore = false
    
    var ufxPAGE_HEIGHT:CGFloat = 550
    var ufxCntView:UIView!
    var cntView:UIView!
    
    var isSafeAreaSet = false
    
    var PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT:Double = 5
    
    var lastPublishedLoc:CLLocation!
    
    var APPSTORE_MODE_IOS:AnyObject?
    
    
    // DRIVER DESTINATION MODE //
    var driverDestinationModeLat = ""
    var driverDestinationModeLong = ""
    var driverDestinationAddress = ""
    var directionFailedDialog:MTDialog!
    var driverRoutesLat = ""
    var driverRoutesLong = ""
    var listOfPoints = [String()]
    var listOfPaths = [GMSPolyline]()
    var DRIVER_DESTINATION_AVAILABLE = "NO"
    
    var homeTabBar:HomeScreenTabBarUV!
    var fabMenu:FABMenu!
    
    var isHailEnabled = false
    var isDestinationEnabled = false
    var isLocationEnable = false
    
    var isTabNavigationPerformed = false
    
    var passType = ""
    
    private var backgroundTimer: Timer?
    private var isInBackground = false
    
    //zones View
    var modalView: UIView!
    var zoneTableView: UITableView!
    var closeButton: UIButton!
    var changeCell = ""
    var dataArrList = [NSDictionary]()
    var bidArrList = [NSDictionary]()
    var vehicleDetailsList = [Any]()
    
    var isZoneShow = "yes"
    var isBidShow = "yes"
    var selectedZoneData: NSDictionary?
    
    var timer: Timer?
    var currentIndex = 0
    var activeZone = ""
    var refreshTimer: Timer?
    var isFirstLoad = true
    var vehicle_type: [String] = []
    
    //change vehicle_type or passenger
    var zoneDisplayTimer: Timer?
    var currentDisplayIndex = 0

    
    var isFetchingZones = false
    var lastFetchTime: Date?
    var fetchTimer: Timer?
    var isFrom = ""
    
    var lastFetchTimes: [String: Date] = [:]
    
    var zoneLabel: UILabel?
    var isShowingBids: Bool = false
    var availability = ""
    var isFetchingBids = false
    
    var shouldSuppressSnackBar: Bool = false
    private var didShowUpdateAlert = false
    var isFdREnabled = "no"
    var hailTapCount = 0
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        if(self.userProfileJson != nil){
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            self.userProfileJson = userProfileJson
            
            
            if(userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
                self.navigationController?.navigationBar.layer.zPosition = -1
                
                self.userProfileImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImage"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
                if(self.ufxUserNameLbl != nil){
                    self.ufxUserNameLbl.text = "\(userProfileJson.get("vName").uppercased()) \(userProfileJson.get("vLastName").uppercased())"
                    getProviderStates()
                }
            }
        }
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
        GeneralFunctions.saveValue(key: "IS_LIVE_TASK_AVAILABLE", value: "false" as AnyObject)
        if(isTncAcceptedThisSession == true){ return }
        if (userProfileJson.get("TNC_POPUP_ENABLE_DRIVER").lowercased() == "yes"){
            if (userProfileJson.get("eTncAccepted").lowercased() == "no"){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let tncUrl = self.userProfileJson.get("TNC_POPUP_URL")
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.userProfileJson.get("TNC_POPUP_MESSAGE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Terms & Conditions", key: "LBL_TERMS_CONDITIONS_TEXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        if(btnClickedIndex == 0){
                            let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
                            staticPageUV.STATIC_PAGE_ID = "63"
                            staticPageUV.fromDialog = "yes"
                            self.pushToNavController(uv: staticPageUV)
                        }
                        
                    })
                }
            }
        }
        
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.UCAColor.AppThemeColor
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        
        self.refreshData()
    }
    
    
    @objc func refreshData() {
        if  self.changeCell == "zone"{
            //  self.getZones()
        }else{
            // self.getBids()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavigationSensor.getInstance().configSensor(activateDispatch: false)
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        notificationCounter = (userProfileJson.get("iUnreadNotificationCount").uppercased())
        
        
        // DRIVER DESTINATION MODE //
        DRIVER_DESTINATION_AVAILABLE = self.userProfileJson.get("DRIVER_DESTINATION_AVAILABLE").uppercased()
        
        APPSTORE_MODE_IOS = GeneralFunctions.getValue(key: Utils.APPSTORE_MODE_IOS_KEY)
        
        /** Used for configDriverTripStatus Type */
        GeneralFunctions.saveValue(key: "iTripId", value: "" as AnyObject)
        /** Used for configDriverTripStatus Type */
        
        PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT = GeneralFunctions.parseDouble(origValue: 5, data: GeneralFunctions.getValue(key: Utils.PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT_KEY) as! String)
        
        if(userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
            cntView = self.generalFunc.loadView(nibName: "MainScreenDesign", uv: self, contentView: contentView)
            self.contentView.addSubview(cntView)
            
            
            
            Utils.driverMarkersPositionList.removeAll()
            Utils.driverMarkerAnimFinished = true
            
            window = Application.window!
            
            if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("ONLYDELIVERALL") == "Yes"){
                heatMapImgView.isHidden = true
            }
            
            taxiHailImgView.backgroundColor = UIColor.UCAColor.AppThemeColor
            GeneralFunctions.setImgTintColor(imgView: taxiHailImgView, color: UIColor.UCAColor.AppThemeTxtColor)
            
            let taxiHailTapGue = UITapGestureRecognizer()
            taxiHailTapGue.addTarget(self, action: #selector(self.openTaxiHail))
            taxiHailImgView.isUserInteractionEnabled = true
            
            taxiHailImgView.addGestureRecognizer(taxiHailTapGue)
            
            
            GeneralFunctions.removeValue(key: "OPEN_MSG_SCREEN")
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
            
            self.setWorkLocationArea(isHide: true)
            
            self.myLocImgView.layer.addShadow(opacity: 0.9, radius: 2.5, UIColor.gray)
            self.myLocImgView.layer.roundCorners(radius: 25)
            self.myLocImgView.image = UIImage(named:"ic_my_location_view")!.addImagePadding(x: 25, y: 25)
            
            self.topDriverDetailView.layer.addShadow(opacity: 0.9, radius: 2.5, UIColor.gray)
            GeneralFunctions.setImgTintColor(imgView: self.changeCarImgView, color: UIColor.UCAColor.AppThemeColor)
            GeneralFunctions.setImgTintColor(imgView: self.driverCarImgView, color: UIColor.UCAColor.AppThemeColor)
            
        }else{
            
            
            ufxCntView = self.generalFunc.loadView(nibName: "UFXMainScreenDesign", uv: self, contentView: self.ufxScrollView)
            ufxCntView.frame.size = CGSize(width: ufxCntView.frame.width, height: ufxPAGE_HEIGHT)
            
            self.ufxHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES" && self.pendingJobAreaView != nil && self.jobAreaSeperatorView != nil){
                self.pendingJobAreaView.isHidden = true
                self.jobAreaSeperatorView.isHidden = true
                self.upcomingJobAreaView.isHidden = true
                ufxPAGE_HEIGHT = ufxPAGE_HEIGHT - 150
            }
            
            self.ufxScrollView.contentSize = CGSize(width: self.ufxScrollView.frame.size.width, height: ufxPAGE_HEIGHT)
            self.ufxScrollView.isHidden = false
            self.ufxScrollView.addSubview(ufxCntView)
            self.ufxScrollView.bounces = false
            
            self.ufxScrollView.backgroundColor = UIColor(hex: 0xF1F1F1)
            GeneralFunctions.setImgTintColor(imgView: self.editAvailRadiusImgView, color: UIColor(hex: 0x4c4c4c))
        }
        if (self.pendingJobAreaView != nil && self.upcomingJobAreaView != nil &&  self.upcomingJobCountLbl != nil && self.pendingJobCountLbl != nil ){
            self.pendingJobAreaView.setOnClickListener { (view) in
                self.passType = "pending"
                self.openBooking()
            }
            self.upcomingJobAreaView.setOnClickListener { (view) in
                self.passType = "upcoming"
                self.openBooking()
            }
            
            self.upcomingJobCountLbl.setClickDelegate(clickDelegate: self)
            self.pendingJobCountLbl.setClickDelegate(clickDelegate: self)
        }
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        self.zoneOrBidTableView.separatorColor = .clear
        self.zoneOrBidTableView.separatorStyle = .none
        self.zoneOrBidTableView.dataSource = self
        self.zoneOrBidTableView.delegate = self
        self.zoneOrBidTableView.register(UINib(nibName: "ZonesTableViewCell", bundle: nil), forCellReuseIdentifier: "ZonesTableViewCell")
        self.zoneOrBidTableView.register(UINib(nibName: "BidTableViewCell", bundle: nil), forCellReuseIdentifier: "BidTableViewCell")
        // self.getZones()
        // self.getBids()
        zoneOrBidTableView.refreshControl = self.refreshControl
        startFetchTimer()
        refreshControl.addTarget(self, action: #selector(userDidPullToRefresh), for: .valueChanged)
       /// startRefreshingData()
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowBidNotification), name: NSNotification.Name("SHOW_BID_VIEW"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showBidView), name: NSNotification.Name("SHOW_BID_VIEW"), object: nil)
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        // Apply initial theme
        applyTheme()
    }
    
    func acceptTermsAndCondtion(){
        let parameters = ["type":"acceptTnC", "iMemberId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                   
                }else{
                    
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @objc func handleShowBidNotification() {
      //  self.getBids(suppressSnackBar: true)
    }

    
    @objc func showBidView() {
        self.isBidShow = "no"
        self.getBids()
        self.isZoneShow = "yes"
        self.zonesDetailView.isHidden = false
        self.vtForBid.isHidden = false
      //  self.zoneTxt.font = self.zoneTxt.font.withSize(14)
       // self.typeTxt.font = self.zoneTxt.font.withSize(14)
        self.myLocImgView.isHidden = true
        self.fabMenu.isHidden = true
        self.changeCell = "bid"
        self.carsTxt.isHidden = true
        self.nowTxt.isHidden = true
        self.uc15minTxt.isHidden = true
        self.uc30minTxt.isHidden = true
        self.paxTxt.isHidden = true
        self.uc15.isHidden = true
        self.uc30.isHidden = true
       // self.typeWithPaxLeading.priority = UILayoutPriority.defaultLow
        self.zoneLeading.constant = 15
      //  self.typeWithPaxLeading.constant = -15
        self.typeTxt.text = "JOBS"
        self.zoneTxt.text = "DATE/TIME"
        if self.isBidShow == "yes"{
            self.zonesDetailView.isHidden = false
            self.isBidShow = "no"
        }else{
            self.zonesDetailView.isHidden = true
            self.myLocImgView.isHidden = false
            self.fabMenu.isHidden = false
            self.isBidShow = "yes"
        }
        self.zoneOrBidTableView.reloadData()
    }
//    @objc func userDidPullToRefresh() {
//        let now = Date()
//        print("Pull-to-refresh triggered")
//
//        if let lastFetch = lastFetchTime, now.timeIntervalSince(lastFetch) < 5 {
//            
//            self.refreshControl.endRefreshing()
//            return
//        }
//        if self.changeCell == "bid" {
//            getBids()
//        }else{
//            getZones()
//        }
//    }
    
    @objc func userDidPullToRefresh() {
        let now = Date()
        print("Pull-to-refresh triggered")

        let key = self.changeCell ?? "default"

        if let lastFetch = lastFetchTimes[key] {
            let diff = now.timeIntervalSince(lastFetch)
            print("Time since last fetch for \(key): \(diff) seconds")

            if diff < 5 {
                print("Refresh blocked to avoid rapid repeat for \(key)")
                self.refreshControl.endRefreshing()
                return
            }
        }

        if key == "bid" {
            print("Fetching Bids...")
            getBids()
        } else {
            print("Fetching Zones...")
            getZones()
        }
    }

    
    func startFetchTimer() {
        fetchTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.getZones()
        }
    }
    
    func startRefreshingData() {
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.getZones), userInfo: nil, repeats: true)
        RunLoop.main.add(refreshTimer!, forMode: .common)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        releaseAllTask()
    }
    
    // MARK: - Theme Support
    @objc func themeDidChange() {
        // Use main thread to avoid race conditions
        DispatchQueue.main.async { [weak self] in
            self?.applyTheme()
        }
    }
    
    func applyTheme() {
        let themeManager = ThemeManager.shared
        
        // Update main backgrounds
        self.view.backgroundColor = themeManager.backgroundColor()
        self.contentView?.backgroundColor = themeManager.backgroundColor()
        
        // Update UFX scroll view for UberX mode
        if self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX {
            self.ufxScrollView?.backgroundColor = themeManager.backgroundColor()
            self.ufxCntView?.backgroundColor = themeManager.backgroundColor()
            
            // UFX Header stays branded (like headerTopBgView in ViewProfileUV)
            // self.ufxHeaderView keeps its AppThemeColor
            
            // Update job location labels
            self.jobLocHLbl?.textColor = themeManager.textColor()
            self.jobLocAddLbl?.textColor = themeManager.secondaryTextColor()
            self.availabilityRadiusLbl?.textColor = themeManager.textColor()
            self.ufxUserNameLbl?.textColor = themeManager.textColor()
            
            // Update job count labels
            self.upcomingJobCountLbl?.textColor = themeManager.textColor()
            self.pendingJobCountLbl?.textColor = themeManager.textColor()
            self.pendingJobLbl?.textColor = themeManager.secondaryTextColor()
            self.upcomingJobLbl?.textColor = themeManager.secondaryTextColor()
        } else {
            // Standard mode
            self.cntView?.backgroundColor = themeManager.backgroundColor()
            self.cntBGVIew?.backgroundColor = themeManager.backgroundColor()
            
            // Update card backgrounds
            self.topDriverDetailView?.backgroundColor = themeManager.cardBackgroundColor()
            
            // Update labels
            self.carNameLBl?.textColor = themeManager.textColor()
            self.carNumLbl?.textColor = themeManager.secondaryTextColor()
            self.changeCarLbl?.textColor = themeManager.textColor()
            self.workLocLbl?.textColor = themeManager.textColor()
        }
        
        // Update zones/bid view
        self.zonesDetailView?.backgroundColor = themeManager.cardBackgroundColor()
        self.zoneView?.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update tap view containers (inside stack view)
        self.zoneTapView?.backgroundColor = themeManager.cardBackgroundColor()
        self.bidTapView?.backgroundColor = themeManager.cardBackgroundColor()
        self.callToAdminView?.backgroundColor = themeManager.cardBackgroundColor()
        self.hailTapView?.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update zone/bid table view
        self.zoneOrBidTableView?.backgroundColor = themeManager.backgroundColor()
        self.zoneOrBidTableView?.separatorColor = themeManager.separatorColor()
        
        // Update zone/bid labels
        self.zoneLbl?.textColor = themeManager.textColor()
        self.bidLbl?.textColor = themeManager.textColor()
        self.bidCountLbl?.textColor = themeManager.textColor()
        self.zoneTxt?.textColor = themeManager.textColor()
        self.typeTxt?.textColor = themeManager.textColor()
        self.paxTxt?.textColor = themeManager.textColor()
        self.carsTxt?.textColor = themeManager.textColor()
        self.nowTxt?.textColor = themeManager.textColor()
        self.uc15minTxt?.textColor = themeManager.textColor()
        self.uc30minTxt?.textColor = themeManager.textColor()
        self.uc15?.textColor = themeManager.textColor()
        self.uc30?.textColor = themeManager.textColor()
        self.uc45?.textColor = themeManager.textColor()
        self.vtForBid?.textColor = themeManager.textColor()
        self.noDataAvailZoneView?.textColor = themeManager.secondaryTextColor()
        
        // Update labels inside tap views
        self.callToAdminLbl?.textColor = themeManager.textColor()
        self.hailMenuLbl?.textColor = themeManager.textColor()
        
        // Update zone/bid images tint colors for dark mode
        if let zoneViewImg = self.zoneViewImg {
            GeneralFunctions.setImgTintColor(imgView: zoneViewImg, color: themeManager.textColor())
        }
        if let bidViewImg = self.bidViewImg {
            GeneralFunctions.setImgTintColor(imgView: bidViewImg, color: themeManager.textColor())
        }
        if let callToAdminViewImg = self.callToAdminViewImg {
            GeneralFunctions.setImgTintColor(imgView: callToAdminViewImg, color: themeManager.textColor())
        }
        if let hailIcon = self.hailIcon {
            GeneralFunctions.setImgTintColor(imgView: hailIcon, color: themeManager.textColor())
        }
        
        // Update destination mode view
        self.driverDestinationModeView?.backgroundColor = themeManager.cardBackgroundColor()
        self.destAddressLbl?.textColor = themeManager.textColor()
        self.destAddressSHLbl?.textColor = themeManager.secondaryTextColor()
        self.noteLbl?.textColor = themeManager.secondaryTextColor()
        self.destAddressTopLbl?.textColor = themeManager.textColor()
        self.destModeOnTopLbl?.textColor = themeManager.secondaryTextColor()
        
        // Update select car view
        self.selectCarHLbl?.textColor = themeManager.textColor()
        self.addNewVehicleLbl?.textColor = themeManager.textColor()
        self.manageVehiclesLbl?.textColor = themeManager.textColor()
        self.selectCarTableView?.backgroundColor = themeManager.backgroundColor()
        self.selectCarTableView?.separatorColor = themeManager.separatorColor()
        
        // Reload table views to update cells - with safety check
        if self.zoneOrBidTableView?.window != nil {
            self.zoneOrBidTableView?.reloadData()
        }
        if self.selectCarTableView?.window != nil {
            self.selectCarTableView?.reloadData()
        }
        
        // Update Google Maps style based on theme
        if let gMapView = self.gMapView {
            if themeManager.isDarkModeActive {
                // Apply dark map style
                gMapView.nightMapStyle()
            } else {
                // Apply light/default map style
                gMapView.mapStyle = nil
            }
        }
        
        print("✅ MainScreenUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
    }
    
    @objc func closeModal() {
        modalView.removeFromSuperview()
    }
    
    @objc func showModal() {
        
        let screenWidth = UIScreen.main.bounds.width
        let modalWidth = screenWidth * 0.8
        
        let screenHeight = UIScreen.main.bounds.height
        let modalHeight = screenHeight * 0.30
        
        modalView = UIView(frame: CGRect(x: (screenWidth - modalWidth) / 2, y: 150, width: modalWidth, height: modalHeight))
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 10
        modalView.layer.shadowColor = UIColor.black.cgColor
        modalView.layer.shadowOpacity = 0.2
        modalView.layer.shadowOffset = CGSize(width: 0, height: 3)
        modalView.layer.shadowRadius = 5
        zoneTableView = UITableView(frame: CGRect(x: 0, y: 40, width: modalWidth, height: modalHeight - 40))
        zoneTableView.dataSource = self
        zoneTableView.delegate = self
        modalView.addSubview(zoneTableView)
        
        closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.frame = CGRect(x: modalWidth - 40, y: 10, width: 40, height: 40)
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        modalView.addSubview(closeButton)
        
        view.addSubview(modalView)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.zonesDetailView.isHidden = true
        self.myLocImgView.isHidden = false
        //        self.fabMenu.isHidden = false
        //        self.zoneView.isHidden = false
        self.isZoneShow = "yes"
        self.isBidShow = "yes"
        isFirstLoad = true
        refreshTimer?.invalidate()
        refreshTimer = nil
        if(self.userProfileJson != nil){
            
            if(userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
                self.navigationController?.navigationBar.layer.zPosition = 1
            }
        }
        
        self.removeTitleView()
        
        let isOddTap = self.hailTapCount % 2 != 0
        if isOddTap {
            self.hailMenuLbl.textColor = UIColor(hex: 0xFE9933)
            self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
            self.hailIcon.tintColor = UIColor(hex: 0xFE9933)
            self.setOnlineState(isAlertShown: true)
            self.onOffSwitch.onText = self.generalFunc.getLanguageLabel(origValue: "FLAG", key: "LBL_SWITCH_FLAG_TXT")
            self.onOffSwitch.dotColor = UIColor(hex: 0xFE9933)
            self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
            self.onOffSwitch.onTextColor = UIColor(hex: 0xFE9933)
            self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)//EEC8A3
        } else {
            // Use theme color instead of hardcoded black
            self.hailMenuLbl.textColor = ThemeManager.shared.textColor()
            self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
            self.hailIcon.tintColor = ThemeManager.shared.textColor()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        //        Utils.printLog(msgData: "MemoryWarningReceived")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // destAddressBGView.roundCorners([.bottomRight], radius: 20)
        if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
            destAddressLeftBGView.backgroundColor = UIColor.UCAColor.AppThemeColor
        }
        
        if Configurations.isRTLMode() {
            //self.destAddressTopLbl.textAlignment  = .right
            //self.destAddressBGView.roundCorners([.bottomLeft], radius: 20)
            if(userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                self.destAddressTopLbl.textAlignment  = .right
            }else{
                self.availabilityRadiusLbl.textAlignment = .right
            }
        }
        if((self.isTabNavigationPerformed == true || isDataSet == false) && self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
//            self.addTitleView()
            self.isTabNavigationPerformed = false
        }
        self.addTitleView()
        if(isDataSet == false){
            DispatchQueue.main.async {
                
                if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                    //                    if(GeneralFunctions.getSafeAreaInsets().bottom == 0){
                    //                        self.cntView.frame.size.height = self.cntView.frame.size.height - self.homeTabBar.tabBar.height + 50
                    //                    }else{
                    //                        self.cntView.frame.size.height = self.cntView.frame.size.height - self.homeTabBar.tabBar.height + 85
                    //                    }
                    ////                    self.googleMapContainerView.frame = self.cntView.bounds
                    //
                    //                    self.googleMapContainerView.frame = CGRect(x: 0, y: 0, width: self.cntView.frame.size.width, height: Application.screenSize.height - self.topbarHeight + 20)
                    
                    if(GeneralFunctions.getSafeAreaInsets().bottom == 0){
                        self.cntView.frame.size.height = Application.screenSize.height - self.homeTabBar.kBarHeight - self.topbarHeight
                    }else{
                        self.cntView.frame.size.height = Application.screenSize.height - self.homeTabBar.kBarHeight - self.topbarHeight
                    }
                    
                    self.googleMapContainerView.frame = CGRect(x: 0, y: 0, width: self.cntView.frame.size.width, height: Application.screenSize.height - self.topbarHeight + 20)
                    self.hideShowHail(isHide: true)
                    
                    /* Subscription */
                    self.subscriptionImgView.image = self.subscriptionImgView.image?.addImagePadding(x: 30, y: 30)/* Subscription */
                    
                    
                    let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: 0.0, longitude: 0.0), zoomLevel:0.0, mapView:self.gMapView)
                    self.gMapView = GMSMapView.map(withFrame: self.googleMapContainerView.bounds, camera: camera)
                    
                    if(GeneralFunctions.hasLocationEnabled() == true){
                        self.gMapView.isMyLocationEnabled = self.isMyLocationEnabled
                    }
                    
                    if(GeneralFunctions.getDayNightForToday().uppercased() == "NIGHT"){
                        self.gMapView.nightMapStyle()
                    }else{
                        self.gMapView.mapStyle = nil
                    }
                    self.gMapView.delegate = self
                    self.googleMapContainerView.addSubview(self.gMapView)
                }else{
                    if(GeneralFunctions.getSafeAreaInsets().bottom == 0){
                        self.ufxCntView.frame.size.height = self.ufxCntView.frame.size.height - self.homeTabBar.tabBar.height + 50
                    }else{
                        self.ufxCntView.frame.size.height = self.ufxCntView.frame.size.height - self.homeTabBar.tabBar.height + 85
                    }
                }
                
                self.getLocation = GetLocation(uv: self, isContinuous: true)
                self.getLocation.buildLocManager(locationUpdateDelegate: self)
                
                if(self.ufxCntView != nil){
                    self.ufxCntView.frame.size = CGSize(width: self.ufxCntView.frame.width, height: self.ufxPAGE_HEIGHT)
                    self.ufxScrollView.contentSize = CGSize(width: self.ufxScrollView.frame.size.width, height: self.ufxPAGE_HEIGHT)
                }
                
                self.checkLocationEnabled()
                
                if((self.userProfileJson.get("eEmailVerified").uppercased() != "YES" && self.userProfileJson.get("ePhoneVerified").uppercased() != "YES") && self.userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES" && self.userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES"){
                    
                    let verifyBtn = Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_EMAILMOBILE_DRIVER_TXT"), uv: self, btnTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_VERIFY_TXT"), delayShow: 1, delayHide: 15)
                    verifyBtn.addTarget(self, action: #selector(self.openAccountVerify(sender:)), for: UIControl.Event.touchUpInside)
                    
                }else if((self.userProfileJson.get("eEmailVerified").uppercased() != "YES" && self.userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES")){
                    
                    let verifyBtn = Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_EMAIL_DRIVER_TXT"), uv: self, btnTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_VERIFY_TXT"), delayShow: 1, delayHide: 15)
                    verifyBtn.addTarget(self, action: #selector(self.openAccountVerify(sender:)), for: UIControl.Event.touchUpInside)
                    
                }else if((self.userProfileJson.get("ePhoneVerified").uppercased() != "YES" && self.userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES")){
                    
                    let verifyBtn = Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_MOBILE_DRIVER_TXT"), uv: self, btnTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_VERIFY_TXT"), delayShow: 1, delayHide: 15)
                    verifyBtn.addTarget(self, action: #selector(self.openAccountVerify(sender:)), for: UIControl.Event.touchUpInside)
                }
                
                
                if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                    // self.prepareMenuItems()
                }else{
                    let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nav_refresh")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onRefreshCalled))
                    self.homeTabBar.navItem.rightBarButtonItem = rightButton;
                    
                    self.onOffSwitch = CMSwitchViewWithLabel.init(frame: self.ufxSwitchCntView.bounds)
                    self.onOffSwitch.onText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONLINE")
                    self.onOffSwitch.offText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFLINE")
                    self.onOffSwitch.onTextColor = UIColor.UCAColor.AppThemeColor
                    self.onOffSwitch.offTextColor = UIColor.UCAColor.AppThemeColor
                    self.onOffSwitch.dotColor = UIColor(hex: 0xFF0000)
                    self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
                    self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)
                    self.onOffSwitch.delegate = self
                    self.ufxSwitchCntView.addSubview(self.onOffSwitch)
                    
                    
                    self.ufxAddressContainerView.layer.addShadow(opacity: 0.8, radius: 2, UIColor.lightGray)
                    self.ufxAddressContainerView.layer.roundCorners(radius: 12)
                    if(self.isDataSet != false){
                        if(self.isDriverOnline){
                            self.setOnlineState(isAlertShown: false)
                        }else{
                            self.setOfflineState(isAlertShown: false)
                        }
                    }
                }
                
                self.setData()
                self.isDataSet = true
            }
            //             // DRIVER DESTINATION MODE //
            //            self.driverDestinationModeSetup() // DRIVER DESTINATION MODE //
        }
        
        
        if(GeneralFunctions.getValue(key: "IS_WORK_LOCATION_CHANGED") != nil){
            
            let dataStr = GeneralFunctions.getValue(key: "IS_WORK_LOCATION_CHANGED") as! String
            if(dataStr.uppercased() == "YES" && userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
                
                let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                self.userProfileJson = userProfileJson
                
                if(userProfileJson.get("eSelectWorkLocation").uppercased() == "FIXED"){
                    onAddressFound(address: userProfileJson.get("vWorkLocation"), location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: userProfileJson.get("vWorkLocationLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: userProfileJson.get("vWorkLocationLongitude"))), isPickUpMode: false, dataResult: "")
                }else{
                    self.onRefreshCalled()
                }
            }
            
            GeneralFunctions.removeValue(key: "IS_WORK_LOCATION_CHANGED")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        self.noDataAvailZoneView.isHidden = true
        self.getZones()
        self.zoneLbl.text = self.generalFunc.getLanguageLabel(origValue: "QUEUE", key: "LBL_MENU_QUEUE")
        // Text color is handled by applyTheme()
        self.zoneLbl.fontFamilyWeight = "Bold"
        self.zoneLbl.setFontFamily()
        
        self.bidLbl.fontFamilyWeight = "Bold"
        self.bidLbl.setFontFamily()
        // Text color is handled by applyTheme()
        // Text color is handled by applyTheme()
        
        self.callToAdminLbl.fontFamilyWeight = "Bold"
        self.callToAdminLbl.setFontFamily()
        // Text color is handled by applyTheme()
        
        self.hailMenuLbl.fontFamilyWeight = "Bold"
        self.hailMenuLbl.setFontFamily()
        // Text color is handled by applyTheme()
        
        self.bidLbl.text = self.generalFunc.getLanguageLabel(origValue: "BID", key: "LBL_MENU_BID")
        self.callToAdminLbl.text = self.generalFunc.getLanguageLabel(origValue: "CALL", key: "LBL_MENU_BASE")
        self.hailMenuLbl.text = self.generalFunc.getLanguageLabel(origValue: "FD", key: "LBL_MENU_FD")
//        let isOddTap = self.hailTapCount % 2 != 0
//        if isOddTap {
//            self.hailMenuLbl.textColor = UIColor(hex: 0xEEC8A3)
//            self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
//            self.hailIcon.tintColor = UIColor(hex: 0xEEC8A3)
//        } else {
//            self.hailMenuLbl.textColor = UIColor.black
//            self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
//            self.hailIcon.tintColor = UIColor.black
//        }
        
        
        let isOddTap = self.hailTapCount % 2 != 0
        if isOddTap {
            self.hailMenuLbl.textColor = UIColor(hex: 0xFE9933)
            self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
            self.hailIcon.tintColor = UIColor(hex: 0xFE9933)
            self.setOnlineState(isAlertShown: true)
            self.onOffSwitch.onText = self.generalFunc.getLanguageLabel(origValue: "FLAG", key: "LBL_SWITCH_FLAG_TXT")
            self.onOffSwitch.dotColor = UIColor(hex: 0xFE9933)
            self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
            self.onOffSwitch.onTextColor = UIColor(hex: 0xFE9933)
            self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)//EEC8A3
        } else {
            // Use theme color instead of hardcoded black
            self.hailMenuLbl.textColor = ThemeManager.shared.textColor()
            self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
            self.hailIcon.tintColor = ThemeManager.shared.textColor()
        }
        
        
//        if fdTap {
//            self.isFdREnabled = "no"
//            self.isDriverOnline = true
//            self.updateStatus1(offline: false, isAlertShown: true)
//            self.configFDTap(isEnabled: false)
//        }else{
//            self.isFdREnabled = "yes"
//            self.updateStatus1(offline: true, isAlertShown: true)
//            self.configFDTap(isEnabled: true)
//          //  self.openTaxiHail()
//        }
        isZoneTap = false
        
    }
    
    @objc private func appDidEnterBackground() {
        isInBackground = true
        backgroundTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(handleBackgroundDuration), userInfo: nil, repeats: false)
    }
    
    @objc private func appWillEnterForeground() {
        backgroundTimer?.invalidate()
        isInBackground = false
        //  senAppStateToServer(isTerminate: "no")
    }
    
    @objc private func appDidBecomeActive() {
        backgroundTimer?.invalidate()
        isInBackground = false
    }
    
    @objc private func handleBackgroundDuration() {
        if isInBackground {
            // senAppStateToServer(isTerminate: "yes")
        }
    }
    func senAppStateToServer(isTerminate:String){
        
        if(Configurations.isUserLoggedIn() == false){
            return
        }
        
        let parameters = ["type":"CheckAppTerminate","iMemberId": GeneralFunctions.getMemberd(), "eAppTerminate": isTerminate]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: view, isOpenLoader: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            print("dataSuccess")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                }else{
                    
                }
                
            }
        })
    }
    
    
    //    func addTitleView(){
    //        print(self.activeZone)
    //        let leftView = UIView.init(frame: CGRect(x:0, y:0, width:35, height: 35))
    //        let imageView = UIImageView.init(frame: leftView.bounds)
    //        Utils.createRoundedView(view: imageView, borderColor: UIColor.UCAColor.AppThemeTxtColor, borderWidth: 1)
    //        imageView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(self.userProfileJson.get("vImage"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
    //        leftView.addSubview(imageView)
    //        self.homeTabBar.navItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftView)
    //
    //        rightView = UIView.init(frame: CGRect(x:0, y:0, width:28, height: 36))
    //        let rightImageView = UIImageView.init(frame: rightView.bounds)
    //        rightImageView.image = UIImage(named: "ic_notification_bell")!.tint(with: UIColor.UCAColor.AppThemeTxtColor)
    //        rightView.addSubview(rightImageView)
    //        rightView.setOnClickListener { (instance) in
    //            self.notificationTapped()
    //        }
    //
    //        let label = UILabel(frame: CGRect(x: -40, y: 6, width: 70, height: 28))
    //           label.text = self.activeZone
    //           label.font = UIFont.systemFont(ofSize: 13)
    //           label.textColor = UIColor.UCAColor.AppThemeTxtColor
    //           label.textAlignment = .left
    //           rightView.addSubview(label)
    //
    //        self.homeTabBar.navItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightView)
    //
    //        let titleView = UIView.init(frame: CGRect(x:0, y:0, width:125, height: 32))
    //        self.onOffSwitch = CMSwitchViewWithLabel.init(frame: titleView.bounds)
    //        self.onOffSwitch.onText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONLINE")
    //        self.onOffSwitch.offText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFLINE")
    //        self.onOffSwitch.onTextColor = UIColor.UCAColor.AppThemeColor
    //        self.onOffSwitch.offTextColor = UIColor.UCAColor.AppThemeColor
    //        self.onOffSwitch.dotColor = UIColor(hex: 0xFF0000)
    //        self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
    //        self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)
    //        self.onOffSwitch.delegate = self
    //        titleView.addSubview(self.onOffSwitch)
    //        self.homeTabBar.navItem.titleView = titleView
    //
    //        if(isDataSet != false){
    //            if(self.isDriverOnline){
    //                self.setOnlineState(isAlertShown: false)
    //            }else{
    //                self.setOfflineState(isAlertShown: false)
    //            }
    //        }
    //    }
    //suleman
//    func addTitleView() {
//        print(self.activeZone)
//        
//        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
//        let imageView = UIImageView(frame: leftView.bounds)
//        Utils.createRoundedView(view: imageView, borderColor: UIColor.UCAColor.AppThemeTxtColor, borderWidth: 1)
//        imageView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(self.userProfileJson.get("vImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"))
//        leftView.addSubview(imageView)
//        self.homeTabBar.navItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
//        
//        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
//        rightView.backgroundColor = .clear
//        
//        
//        let label = UILabel(frame: CGRect(x: 10, y: 4, width: 50, height: 28))
//        label.text = self.activeZone
//        label.font = UIFont.systemFont(ofSize: 13)
//        label.textColor = UIColor.UCAColor.AppThemeTxtColor
//        label.textAlignment = .center
//        
//        //        label.layer.borderColor = UIColor.white.cgColor
//        //        label.layer.borderWidth = 2.0
//        //   label.layer.cornerRadius = 5.0
//        label.layer.masksToBounds = true
//        
//        let isActiveZoneEmpty = self.activeZone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//        
//        if isActiveZoneEmpty {
//            label.layer.borderWidth = 0
//            label.layer.borderColor = UIColor.clear.cgColor
//        } else {
//            label.layer.borderWidth = 2.0
//            label.layer.borderColor = UIColor.white.cgColor
//            label.layer.cornerRadius = 5.0
//        }
//        
//        rightView.addSubview(label)
//        
//        let rightImageView = UIImageView(frame: CGRect(x: 75, y: 4, width: 28, height: 28))
//        rightImageView.image = UIImage(named: "ic_notification_bell")!.tint(with: UIColor.UCAColor.AppThemeTxtColor)
//        rightView.addSubview(rightImageView)
//        
//        
//        self.homeTabBar.navItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
//        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 125, height: 32))
//        self.onOffSwitch = CMSwitchViewWithLabel(frame: titleView.bounds)
//        self.onOffSwitch.onText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONLINE")
//        self.onOffSwitch.offText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFLINE")
//        self.onOffSwitch.onTextColor = UIColor.UCAColor.AppThemeColor
//        self.onOffSwitch.offTextColor = UIColor.UCAColor.AppThemeColor
//        self.onOffSwitch.dotColor = UIColor(hex: 0xFF0000)
//        self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
//        self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)
//        self.onOffSwitch.delegate = self
//        titleView.addSubview(self.onOffSwitch)
//        self.homeTabBar.navItem.titleView = titleView
//        
//        // Online/Offline State (unchanged)
//        if (isDataSet != false) {
//            if (self.isDriverOnline) {
//                self.setOnlineState(isAlertShown: false)
//            } else {
//                self.setOfflineState(isAlertShown: false)
//            }
//        }
//    }
    //suleman
    
    
    func addTitleView() {
        print(self.activeZone)
        //suleman
        // Left: Profile Image
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let imageView = UIImageView(frame: leftView.bounds)
        Utils.createRoundedView(view: imageView, borderColor: UIColor.UCAColor.AppThemeTxtColor, borderWidth: 1)
        imageView.sd_setImage(
            with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(self.userProfileJson.get("vImage"))"),
            placeholderImage: UIImage(named: "ic_no_pic_user")
        )
        leftView.addSubview(imageView)
        self.homeTabBar.navItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
        
        // Right View
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        rightView.backgroundColor = .clear
        
        // Zone Label
        let label = UILabel(frame: CGRect(x: 10, y: 4, width: 50, height: 28))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.UCAColor.AppThemeTxtColor
        label.textAlignment = .center
        label.layer.masksToBounds = true
        self.zoneLabel = label
        rightView.addSubview(label)
        
        // Notification Bell
//        let rightImageView = UIImageView(frame: CGRect(x: 75, y: 4, width: 28, height: 28))
//        rightImageView.image = UIImage(named: "ic_notification_bell")?.tint(with: UIColor.UCAColor.AppThemeTxtColor)
//        rightImageView.isUserInteractionEnabled = true
//        rightView.addSubview(rightImageView)
//        rightView.setOnClickListener { (instance) in
//            self.notificationTapped()
//        }
        print(notificationCounter)

        let rightImageView = UIImageView(frame: CGRect(x: 75, y: 4, width: 28, height: 28))
        rightImageView.image = UIImage(named: "ic_notification_bell")?.tint(with: UIColor.UCAColor.AppThemeTxtColor)
        rightImageView.isUserInteractionEnabled = true
        rightView.addSubview(rightImageView)

        let counterLabel = UILabel(frame: CGRect(x: rightImageView.frame.maxX - 10, y: 0, width: 18, height: 18))
        counterLabel.backgroundColor = UIColor.red
        counterLabel.textColor = .white
        counterLabel.font = .systemFont(ofSize: 11, weight: .bold)
        counterLabel.textAlignment = .center
        counterLabel.layer.cornerRadius = 9
        counterLabel.layer.masksToBounds = true
        counterLabel.text = notificationCounter
        counterLabel.isHidden = (notificationCounter == "0" || notificationCounter.isEmpty)
        rightView.addSubview(counterLabel)

        rightView.setOnClickListener { _ in
            self.notificationTapped()
        }

        
        self.homeTabBar.navItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
        
        // Title View (Center) - Online/Offline Switch
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 125, height: 32))
        self.onOffSwitch = CMSwitchViewWithLabel(frame: titleView.bounds)
        self.onOffSwitch.onText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONLINE")
        self.onOffSwitch.offText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFLINE")
        self.onOffSwitch.onTextColor = UIColor.UCAColor.AppThemeColor
        self.onOffSwitch.offTextColor = UIColor.UCAColor.AppThemeColor
        self.onOffSwitch.dotColor = UIColor(hex: 0xFF0000)
        self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
        self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)
        self.onOffSwitch.delegate = self
        titleView.addSubview(self.onOffSwitch)
        self.homeTabBar.navItem.titleView = titleView
        
        self.updateZoneLabel(self.activeZone)
        
        if isDataSet {
            isDriverOnline ? setOnlineState(isAlertShown: false) : setOfflineState(isAlertShown: false)
        }
       
    }

    @objc func notificationBellTapped() {
        print("🔔 Notification bell tapped!")
        let notification = GeneralFunctions.instantiateViewController(pageName: "NotificationsUV") as! NotificationsUV
        self.pushToNavController(uv: notification)
    }
    
    func updateZoneLabel(_ newZone: String) {
        guard let label = self.zoneLabel else { return }
        let trimmedZone = newZone.trimmingCharacters(in: .whitespacesAndNewlines)
        var displayText = trimmedZone.isEmpty ? "0" : trimmedZone

        if self.availability == "Not Available" {
            displayText = "0"
        }
        if label.text != displayText {
//        if label.text != newZone {
            label.text = displayText
            label.font = UIFont.boldSystemFont(ofSize: 15)
            let isEmpty = displayText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            if isEmpty {
                label.layer.borderWidth = 0
                label.layer.borderColor = UIColor.clear.cgColor
            } else {
                label.layer.borderWidth = 2.0
                label.layer.borderColor = UIColor.white.cgColor
                label.layer.cornerRadius = 5.0
            }
        }
    }

    
    func removeTitleView(){
        
        if(self.fabMenu != nil){
            self.fabMenu.close(isTriggeredByUserInteraction: true)
        }
    }
    
    @objc func notificationTapped(){
        let notificationsTabUV = GeneralFunctions.instantiateViewController(pageName: "NotificationsTabUV") as! NotificationsTabUV
        self.pushToNavController(uv: notificationsTabUV)
    }
    
    func prepareMenuItems(){
        
        if(fabMenu != nil){
            fabMenu.removeFromSuperview()
            fabMenu = nil
        }
        if(fabMenu == nil){
            let fabMenuButton = FABButton(image: Icon.cm.photoCamera, tintColor: .white)
            fabMenuButton.backgroundColor = UIColor.UCAColor.AppThemeColor
            fabMenuButton.pulseColor = UIColor.UCAColor.AppThemeTxtColor
            
            fabMenuButton.image = UIImage(named: "ic_plus")!.resize(toHeight: 30)!.resize(toWidth: 30)!.tint(with:  UIColor.UCAColor.AppThemeTxtColor)
            
            fabMenu = FABMenu()
            fabMenu.frame = CGRect(x: Configurations.isRTLMode() ? 15 : (Application.screenSize.width - 65), y: self.cntView.frame.size.height - 130, width: 50, height: 50)//85
            fabMenu.fabButton = fabMenuButton
            fabMenu.layer.addShadow(opacity: 0.9, radius: 2.5, UIColor.gray)
            
            self.cntView.addSubview(fabMenu)
        }
        let haiItem = FABMenuItem()
        haiItem.title = "  " + generalFunc.getLanguageLabel(origValue: "", key: "LBL_TAXI_HAIL") + "  "
        haiItem.titleLabel.font = UIFont.init(name: Fonts().semibold, size: 14)
        haiItem.titleLabel.cornerRadius = 2
        haiItem.titleLabel.clipsToBounds = true
        haiItem.fabButton.pulseColor = UIColor.UCAColor.AppThemeTxtColor
        haiItem.titleLabel.backgroundColor = UIColor.white
        haiItem.titleLabel.textColor = UIColor(hex: 0x666666)
        haiItem.fabButton.backgroundColor = UIColor.white
        haiItem.image = UIImage(named: "ic_taxi_hail")!.addImagePadding(x: 40, y: 40)!
        haiItem.layer.addShadow(opacity: 0.9, radius: 2.5, UIColor.gray)
        haiItem.fabButton.setOnClickListener { (instance) in
            self.fabMenu.close(isTriggeredByUserInteraction: true)
            self.openTaxiHail()
        }
        
        let heatItem = FABMenuItem()
        heatItem.title = "  " + generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEAT") + "  "
        heatItem.titleLabel.font = UIFont.init(name: Fonts().semibold, size: 14)
        heatItem.titleLabel.cornerRadius = 2
        heatItem.titleLabel.clipsToBounds = true
        heatItem.fabButton.pulseColor = UIColor.UCAColor.AppThemeTxtColor
        heatItem.titleLabel.backgroundColor = UIColor.white
        heatItem.titleLabel.textColor = UIColor(hex: 0x666666)
        heatItem.fabButton.backgroundColor = UIColor.white
        heatItem.image = UIImage(named: "ic_heat_map_on")!.addImagePadding(x: 40, y: 40)!
        heatItem.layer.addShadow(opacity: 0.9, radius: 2.5, UIColor.gray)
        heatItem.fabButton.setOnClickListener { (instance) in
            self.fabMenu.close(isTriggeredByUserInteraction: true)
            self.heatViewTapped()
        }
        
        let returnItem = FABMenuItem()
        returnItem.title = "  " + generalFunc.getLanguageLabel(origValue: "", key: "LBL_RETURN") + "  "
        returnItem.titleLabel.font = UIFont.init(name: Fonts().semibold, size: 14)
        returnItem.titleLabel.cornerRadius = 2
        returnItem.titleLabel.clipsToBounds = true
        returnItem.fabButton.pulseColor = UIColor.UCAColor.AppThemeTxtColor
        returnItem.titleLabel.backgroundColor = UIColor.white
        returnItem.titleLabel.textColor = UIColor(hex: 0x666666)
        returnItem.fabButton.backgroundColor = UIColor.white
        returnItem.image = UIImage(named: "ic_driver_destinations")!.addImagePadding(x: 40, y: 40)!
        returnItem.layer.addShadow(opacity: 0.9, radius: 2.5, UIColor.gray)
        returnItem.fabButton.setOnClickListener { (instance) in
            self.fabMenu.close(isTriggeredByUserInteraction: true)
            if(self.DRIVER_DESTINATION_AVAILABLE.uppercased() == "YES"){
                let launchPlaceFinder = LaunchPlaceFinder(viewControllerUV: self)
                launchPlaceFinder.currInst = launchPlaceFinder
                launchPlaceFinder.isForDriverDestinations = true
                
                launchPlaceFinder.initializeFinder { (address, latitude, longitude) in
                    
                    self.driverDestinationModeLat = "\(latitude)"
                    self.driverDestinationModeLong = "\(longitude)"
                    self.driverDestinationAddress = address
                    
                    if(self.currentLocation != nil){
                        self.checkRoute()
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
                    }
                }
            }else{
                let msg = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DRIVER_DEST_LIMIT_REACHED") + " " + Configurations.convertNumToAppLocal(numStr: String(GeneralFunctions.parseInt(origValue: 0, data: self.userProfileJson.get("MAX_DRIVER_DESTINATIONS")))) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FOR_A_DAY")
                Utils.showSnakeBar(msg: msg, uv: self)
            }
        }
        
        let locationItem = FABMenuItem()
        locationItem.title = "  " + generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOCATIONS_TXT") + "  "
        locationItem.titleLabel.font = UIFont.init(name: Fonts().semibold, size: 14)
        locationItem.titleLabel.cornerRadius = 2
        locationItem.titleLabel.clipsToBounds = true
        locationItem.fabButton.pulseColor = UIColor.UCAColor.AppThemeTxtColor
        locationItem.titleLabel.backgroundColor = UIColor.white
        locationItem.titleLabel.textColor = UIColor(hex: 0x666666)
        locationItem.fabButton.backgroundColor = UIColor.white
        locationItem.image = UIImage(named: "ic_manage_location")!.addImagePadding(x: 40, y: 40)!
        locationItem.layer.addShadow(opacity: 0.9, radius: 2.5, UIColor.gray)
        locationItem.fabButton.setOnClickListener { (instance) in
            self.fabMenu.close(isTriggeredByUserInteraction: true)
            self.openAvailRadius()
        }
        
        fabMenu.setOnClickListener { (instance) in
            self.fabMenu.open()
        }
        
        fabMenu.delegate = self
        
        
        fabMenu.fabMenuItems.removeAll()
        
        
        if(self.isLocationEnable){
            fabMenu.fabMenuItems.append(locationItem)
        }
        
        if(self.isDestinationEnabled){
            fabMenu.fabMenuItems.append(returnItem)
        }
        
        fabMenu.fabMenuItems.append(heatItem)
        
        if(self.isHailEnabled){
            fabMenu.fabMenuItems.append(haiItem)
        }
        
        if(Configurations.isRTLMode()){
            self.fabMenu.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            heatItem.titleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            haiItem.titleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            returnItem.titleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            locationItem.titleLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
        }
        
        
        if(self.fabMenu != nil && self.userProfileJson.get("eDestinationMode").uppercased() == "YES"){
            self.fabMenu.isHidden = true
        }
        
    }
    
    func fabMenuWillOpen(fabMenu: FABMenu) {
        self.cntBGVIew.isHidden = false
        if(Configurations.isRTLMode()){
            fabMenu.fabButton?.motion(.rotationAngle(0))
            fabMenu.fabButton?.image = UIImage(named: "ic_plus")!.resize(toHeight: 30)!.resize(toWidth: 30)!.tint(with:  UIColor.UCAColor.AppThemeTxtColor)!.rotate(-45)
        }else{
            fabMenu.fabButton?.motion(.rotationAngle(0))
            fabMenu.fabButton?.image = UIImage(named: "ic_plus")!.resize(toHeight: 30)!.resize(toWidth: 30)!.tint(with:  UIColor.UCAColor.AppThemeTxtColor)!.rotate(45)
        }
    }
    
    func fabMenuWillClose(fabMenu: FABMenu) {
        self.cntBGVIew.isHidden = true
        fabMenu.fabButton?.motion(.rotationAngle(0))
        fabMenu.fabButton?.image = UIImage(named: "ic_plus")!.resize(toHeight: 30)!.resize(toWidth: 30)!.tint(with:  UIColor.UCAColor.AppThemeTxtColor)!.rotate(0)
    }
    
    /* Subscription */
    func openSubscriptionView(_ subTxt:String = ""){
        
        self.closeSubscriptionAlertView()
        self.subscriptionView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.subscriptionView)
        self.view.endEditing(true)
        self.subscriptionDoneBtn.clickDelegate = self
        self.subscriptionCancelBtn.clickDelegate = self
        
        self.subscriptionDoneBtn.bgColor = UIColor.UCAColor.AppThemeColor.lighter()
        self.subscriptionCancelBtn.bgColor = UIColor.UCAColor.AppThemeColor.lighter()
        
        self.subscriptionDoneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIBE"))
        self.subscriptionCancelBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"))
        self.subscriptionHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_REQ_H_LBL")
        self.subscriptionHLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.subscriptionSHLbl.text = subTxt//
        
        self.subscriptionDialogView.isHidden = false
        self.subscriptionBgView.isHidden = false
        self.subscriptionView.isHidden = false
        self.subscriptionImgView.backgroundColor = UIColor.white
        
        GeneralFunctions.setImgTintColor(imgView: self.subscriptionImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.subscriptionImgView.transform = .identity
        self.animateSubscriptionImgView()
        
    }
    
    
    func animateSubscriptionImgView(){
        
        let originalTransform = self.subscriptionImgView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.7, animations: {
            
            self.subscriptionImgView.transform = scaledTransform
        },completion:{ finished in
            UIView.animate(withDuration: 0.7, animations: {
                
                self.subscriptionImgView.transform = originalTransform
            },completion:{ finished in
                if(self.subscriptionBgView.isHidden == false){
                    self.animateSubscriptionImgView()
                }
                
            })
        })
        
    }
    
    func closeSubscriptionAlertView(){
        
        if(self.subscriptionBgView.isHidden == false){
            self.subscriptionView.removeFromSuperview()
            self.subscriptionBgView.isHidden = true
            self.subscriptionView.isHidden = true
        }
        
    }/* ......... */
    
//    @objc func getZones(){
//        // Perform the network request in the background
//        //  DispatchQueue.global(qos: .background).async {
//        self.dataArrList.removeAll()
//        var parameters = ["type":"getZonesData", "iDriverId":  GeneralFunctions.getMemberd()]
//        
//        Utils.printLog(msgData: "Parameters::\(parameters)")
//        
//        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
//        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
//        exeWebServerUrl.currInstance = exeWebServerUrl
//        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
//            
//            if(response != ""){
//                let dataDict = response.getJsonDataDict()
//                print("data:\(dataDict)")
//                if(dataDict.get("Action") == "1"){
//                    let dataArr = dataDict.getArrObj(Utils.message_str)
//                    print("test:\(dataDict.get("driverPosition"))")
//                    print("test1:\(self.activeZone)")
//                    if self.activeZone != dataDict.get("driverPosition") {
//                        self.isFirstLoad = true
//                    }
//                    self.activeZone = dataDict.get("driverPosition")
//                    if self.isFirstLoad == true {
//                        self.addTitleView()
//                    }
//                    self.isFirstLoad = false
//                    for i in 0 ..< dataArr.count{
//                        let dataTemp = dataArr[i] as! NSDictionary
//                        
//                        self.dataArrList.append(dataTemp)
//                        if self.dataArrList.count > 0 {
//                            let firstZone = self.dataArrList[0] as! NSDictionary
//                            let zoneName = firstZone.get("vZoneName") as? String ?? "No Zone"
//                        }
//                        //                        if let vehicleDetails = dataTemp["vehicle_details"] as? [Any] {
//                        //
//                        //                            self.vehicleDetailsList.append(contentsOf: vehicleDetails)
//                        //                        }
//                        // self.zoneOrBidTableView.reloadData()
//                        DispatchQueue.main.async {
//                            self.zoneOrBidTableView.reloadData()
//                            self.refreshControl.endRefreshing()
//                        }
//                    }
//                }else{
//                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
//                    DispatchQueue.main.async {
//                        self.refreshControl.endRefreshing()
//                    }
//                }
//                
//            }else{
//                self.generalFunc.setError(uv: self)
//                DispatchQueue.main.async {
//                    self.refreshControl.endRefreshing()
//                }
//            }
//            
//        })
//    }
    
    func startZoneTimer() {
        zoneDisplayTimer?.invalidate()
        
        zoneDisplayTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.currentDisplayIndex += 1
            self.zoneOrBidTableView.reloadData()
        }
    }

    
//    @objc func getZones() {
//        guard !isFetchingZones else {
//               print("Skipped: Already fetching zones")
//               return
//           }
//
//        isFetchingZones = true
//        lastFetchTime = Date()
//        let parameters = ["type": "getZonesData", "iDriverId": GeneralFunctions.getMemberd()]
//        Utils.printLog(msgData: "Parameters::\(parameters)")
//
//        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
//        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
//        exeWebServerUrl.currInstance = exeWebServerUrl
//        exeWebServerUrl.executePostProcess { [weak self] response in
//            guard let self = self else { return }
//
//            DispatchQueue.main.async {
//                self.refreshControl.endRefreshing()
//            }
//            defer {
//                print("✅ API call finished, unlocking fetch")
//                self.isFetchingZones = false
//            }
//            guard !response.isEmpty else {
//                DispatchQueue.main.async {
//                    self.generalFunc.setError(uv: self)
//                }
//                return
//            }
//
//            let dataDict = response.getJsonDataDict()
//            Utils.printLog(msgData: "Response Data::\(dataDict)")
//
//            guard dataDict.get("Action") == "1" else {
//                DispatchQueue.main.async {
//                    self.generalFunc.setError(
//                        uv: self,
//                        title: "",
//                        content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message"))
//                    )
//                }
//                return
//            }
//            let dataArr = dataDict.getArrObj(Utils.message_str)
//            var newList: [NSDictionary] = []
//
//            for item in dataArr {
//                if let zoneData = item as? NSDictionary {
//                    newList.append(zoneData)
//                }
//            }
//
//            DispatchQueue.main.async {
//                self.dataArrList = newList
//
//                let newZone = dataDict.get("driverPosition")
//                if self.activeZone != newZone {
//                    self.isFirstLoad = true
//                    self.activeZone = newZone
//                }
//
//                if self.isFirstLoad {
//                    self.addTitleView()
//                    self.isFirstLoad = false
//                }
//
//                if !self.zoneOrBidTableView.isDragging && !self.zoneOrBidTableView.isDecelerating {
//                    self.zoneOrBidTableView.reloadData()
//                } else {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        if !self.zoneOrBidTableView.isDragging && !self.zoneOrBidTableView.isDecelerating {
//                            self.zoneOrBidTableView.reloadData()
//                        }
//                    }
//                }
//                self.startZoneTimer()
//            }
//        }
//    }
    
    @objc func getZones() {
        
        guard !isFetchingZones else {
            print("Skipped: Already fetching zones")
            return
        }

        isFetchingZones = true
        print("Fetching Zones...")

        let parameters = [
            "type": "getZonesData",
            "iDriverId": GeneralFunctions.getMemberd(),
            "AppVersion": Utils.applicationVersion()
        ]
        Utils.printLog(msgData: "Parameters::\(parameters)")

        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl

        exeWebServerUrl.executePostProcess { [weak self] response in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }

            defer {
                self.isFetchingZones = false
                print("Finished fetching zones")
            }
            if (isZoneTap){
                guard !response.isEmpty else {
                    DispatchQueue.main.async {
                        self.generalFunc.setError(uv: self)
                    }
                    return
                }
                
            }

            let dataDict = response.getJsonDataDict()
            Utils.printLog(msgData: "Response Data::\(dataDict)")

            guard dataDict.get("Action") == "1" else {
                DispatchQueue.main.async {
//                    self.generalFunc.setError(
//                        uv: self,
//                        title: "",
//                        content: self.generalFunc.getLanguageLabel(
//                            origValue: "",
//                            key: dataDict.get("message")
//                        )
//                    )
                    if !self.isShowingBids {
                        self.noDataAvailZoneView.isHidden = false
                        self.noDataAvailZoneView.text = dataDict.get("message")
                        self.noDataAvailZoneView.textAlignment = .center
                        self.noDataAvailZoneView.numberOfLines = 0
                        self.noDataAvailZoneView.lineBreakMode = .byWordWrapping
                    }
                   
                }
                self.updateZoneLabel("0")
                return
            }
            DispatchQueue.main.async {
                self.noDataAvailZoneView.isHidden = true
            }
            self.getBids(suppressSnackBar: true)
            let dataArr = dataDict.getArrObj(Utils.message_str)
            var newList: [NSDictionary] = []

            for item in dataArr {
                if let zoneData = item as? NSDictionary {
                    newList.append(zoneData)
                }
            }

            DispatchQueue.main.async {
                self.dataArrList = newList
                
                let newZone = dataDict.get("driverPosition")
                //                if self.activeZone != newZone {
                //                    self.isFirstLoad = true
                //                    self.activeZone = newZone
                //                }
                //
                //                if self.isFirstLoad {
                //                    self.addTitleView()
                //                    self.isFirstLoad = false
                //                }
                
                self.updateZoneLabel(newZone)
                
                if !self.zoneOrBidTableView.isDragging && !self.zoneOrBidTableView.isDecelerating {
                    self.zoneOrBidTableView.reloadData()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if !self.zoneOrBidTableView.isDragging && !self.zoneOrBidTableView.isDecelerating {
                            self.zoneOrBidTableView.reloadData()
                        }
                    }
                }
                
                self.lastFetchTimes["zone"] = Date()
                self.startZoneTimer()
                struct UpdateAlertState {
                    static var activeAlert: UIAlertController?
                    static var isPresenting = false
                }
                
                let isUpdate = (dataDict.get("isAppUpdate") == "true")
                
                if isUpdate {
                    let title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NEW_UPDATE_AVAIL")
                    let message = self.generalFunc.getLanguageLabel(
                        origValue: "New update is available to download. Downloading the latest update, you will get latest features, improvements and bug fixes.",
                        key: dataDict.get(Utils.message_str)
                    )
                    let positive = self.generalFunc.getLanguageLabel(origValue: "Update", key: "LBL_UPDATE")
                    let negative = self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT")
                    
                    let presentFresh = {
                        guard !UpdateAlertState.isPresenting else { return }
                        UpdateAlertState.isPresenting = true
                        
                        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: negative, style: .cancel, handler: { _ in
                            UpdateAlertState.activeAlert = nil
                        }))
                        alert.addAction(UIAlertAction(title: positive, style: .default, handler: { _ in
                            UpdateAlertState.activeAlert = nil
                            if let url = URL(string: "itms-apps://itunes.apple.com/app/bars/id\(CommonUtils.appleAppId)") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }))
                        
                        self.present(alert, animated: true) {
                            UpdateAlertState.isPresenting = false
                        }
                        UpdateAlertState.activeAlert = alert
                    }
                    
                    if let current = UpdateAlertState.activeAlert {
                    
                        current.dismiss(animated: false) {
                            UpdateAlertState.activeAlert = nil
                            presentFresh()
                        }
                    } else {
                        presentFresh()
                    }
                    
                    return
                } else {
                    if let current = UpdateAlertState.activeAlert {
                        current.dismiss(animated: false) {
                            UpdateAlertState.activeAlert = nil
                        }
                    }
                }
                //                if(dataDict.get("isAppUpdate") != "" && dataDict.get("isAppUpdate") == "true"){
                //
                //                    self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NEW_UPDATE_AVAIL"), content: self.generalFunc.getLanguageLabel(origValue: "New update is available to download. Downloading the latest update, you will get latest features, improvements and bug fixes.", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Update", key: "LBL_UPDATE"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), completionHandler: { (btnClickedIndex) in
                //
                //                        if(btnClickedIndex == 0){
                //                            UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/bars/id\(CommonUtils.appleAppId)")!)
                //                        }
                //
                //                    })
                //                    return
                //                }
            }
        }
    }

     func getBids(suppressSnackBar: Bool = false) {
//    @objc func getBids() {
         guard !isFetchingBids else {
             print("Skipped: Already fetching bids")
             return
         }
        isFetchingBids = true
        self.isShowingBids = true
//        self.bidArrList.removeAll()
        DispatchQueue.main.async {
            self.noDataAvailZoneView.isHidden = true
        }

        let parameters = ["type": "getRidesForBidding", "iDriverId": GeneralFunctions.getMemberd()]
        Utils.printLog(msgData: "Parameters::\(parameters)")

        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl

        exeWebServerUrl.executePostProcess { response in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                defer {
                    self.isFetchingBids = false
                }
                if response != "" {
                    let dataDict = response.getJsonDataDict()
                    print("Data Dict: \(dataDict)")
                    if dataDict.get("Action") == "1" {
                        let dataArr = dataDict.getArrObj(Utils.message_str)
                        var newBidArrList: [NSDictionary] = []
                        for item in dataArr {
                            if let dataTemp = item as? NSDictionary {
//                                self.bidArrList.append(dataTemp)
                                newBidArrList.append(dataTemp)
                            }
                        }
                        if newBidArrList != self.bidArrList {
                            self.bidArrList = newBidArrList
                            self.bidCountLbl.text = "(\(self.bidArrList.count))"
                            self.zoneOrBidTableView.reloadData()
                            self.lastFetchTimes["bid"] = Date()
                        }else {
                            print("No data change")
                        }
//                        self.bidCountLbl.text = "(\(self.bidArrList.count))"
//                        self.lastFetchTimes["bid"] = Date()
//                        self.zoneOrBidTableView.reloadData()
                    } else {
                        self.bidCountLbl.text = "(0)"
                        self.bidArrList.removeAll()
                        self.zoneOrBidTableView.reloadData()
//                        Utils.showSnakeBar(msg: dataDict.get("message"), uv: self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            if self.view.window != nil && !suppressSnackBar {
                                Utils.showSnakeBar(msg: dataDict.get("message"), uv: self)
                            }
                        }
                    }
                } else {
//                    self.generalFunc.setError(uv: self)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        if self.view.window != nil && !suppressSnackBar {
//                            self.generalFunc.setError(uv: self)
//                        }
//                    }
                }
            }
        }
    }


//    func getBids() {
//        self.bidArrList.removeAll()
//
//        var parameters = ["type": "getRidesForBidding", "iDriverId": GeneralFunctions.getMemberd()]
//
//        Utils.printLog(msgData: "Parameters::\(parameters)")
//
//        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
//        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
//        exeWebServerUrl.currInstance = exeWebServerUrl
//
//        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
//            if (response != "") {
//                let dataDict = response.getJsonDataDict()
//                print("Data Dict: \(dataDict)")
//              
//                if dataDict.get("Action") == "1" {
//                    let dataArr = dataDict.getArrObj(Utils.message_str)
//                    for i in 0 ..< dataArr.count{
//                        let dataTemp = dataArr[i] as! NSDictionary
//                        
//                        self.bidArrList.append(dataTemp)
//                    }
//                    self.zoneOrBidTableView.reloadData()
//                } else {
//                    //self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
//                    Utils.showSnakeBar(msg: dataDict.get("message"),uv: self)
//                }
//            } else {
//                self.generalFunc.setError(uv: self)
//            }
//        })
//    }


    func bidForRide(iCabId: String,rideType: String){
        var parameters = ["type":"bidForRide", "iDriverId":  GeneralFunctions.getMemberd(),"iCabBookingId": iCabId,"rideType": rideType]
        Utils.printLog(msgData: "Parameters::\(parameters)")
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                print("data:\(dataDict)")
                if(dataDict.get("Action") == "1"){
                    
                }else{
                  //  self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }

        })
    }
    
    func setData(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        GeneralFunctions.saveValue(key: "IS_DRIVER_ONLINE", value: "false" as AnyObject)
        
        //userPicImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImage"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        self.zoneView.isHidden = false
        self.zonesDetailView.isHidden = true
        
        self.zoneTapView.setOnClickListener{ (instance) in
//            self.hailMenuLbl.textColor = UIColor.black
//            self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
//            self.hailIcon.tintColor = UIColor.black
            isZoneTap = true
            self.isShowingBids = false
            self.vtForBid.isHidden = true
            self.getZones()
            self.zonesDetailView.isHidden = false
//            self.zoneTxt.font = self.zoneTxt.font.withSize(12)
//            self.typeTxt.font = self.zoneTxt.font.withSize(12)
            self.myLocImgView.isHidden = true
            self.fabMenu.isHidden = true
            self.changeCell = "zone"
            self.userProfileJson.get("CALL_LINK")
            print("test\(self.userProfileJson.get("CALL_LINK"))")
            self.carsTxt.isHidden = false
            self.nowTxt.isHidden = false
            self.uc15minTxt.isHidden = false
            self.uc30minTxt.isHidden = false
            self.paxTxt.isHidden = false
            self.uc15.isHidden = false
            self.uc30.isHidden = false
            self.uc45.isHidden = false
            self.typeWithPaxLeading.priority = UILayoutPriority.defaultHigh
            self.typeWithZoneName.priority = UILayoutPriority.defaultLow
            self.typeWithFB.priority = UILayoutPriority.defaultHigh
            self.zoneLeading.constant = 2
            self.typeWithPaxLeading.constant = 34
            self.isBidShow = "yes"
            self.typeTxt.text = "VT"
            self.zoneTxt.text = "Zone Name".uppercased()
            
            if self.isZoneShow == "yes"{
                self.zonesDetailView.isHidden = false
                self.isZoneShow = "no"
            }else{
                self.zonesDetailView.isHidden = true
                self.myLocImgView.isHidden = false
                self.fabMenu.isHidden = false
                self.isZoneShow = "yes"
            }
           
        }
//        if (self.isFrom == "push") && (self.isZoneShow == "no" || self.isZoneShow == ""){
//            self.isBidShow = "yes"
//            self.zonesDetailView.isHidden = false
//        }
        
        self.bidTapView.setOnClickListener{ (instance) in
//            self.hailMenuLbl.textColor = UIColor.black
//            self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
//            self.hailIcon.tintColor = UIColor.black
            isZoneTap = false
            self.vtForBid.isHidden = false
            self.noDataAvailZoneView.isHidden = true
            self.getBids(suppressSnackBar: false)
//            self.getBids()
            self.isZoneShow = "yes"
            self.zonesDetailView.isHidden = false
//            self.zoneTxt.font = self.zoneTxt.font.withSize(14)
//            self.typeTxt.font = self.zoneTxt.font.withSize(14)
            self.myLocImgView.isHidden = true
            self.fabMenu.isHidden = true
            self.changeCell = "bid"
            self.carsTxt.isHidden = true
            self.nowTxt.isHidden = true
            self.uc15minTxt.isHidden = true
            self.uc30minTxt.isHidden = true
            self.paxTxt.isHidden = true
            self.uc15.isHidden = true
            self.uc30.isHidden = true
            self.uc45.isHidden = true
            self.typeWithPaxLeading.priority = UILayoutPriority.defaultLow
            self.typeWithZoneName.priority = UILayoutPriority.defaultHigh
            self.typeWithFB.priority = UILayoutPriority.defaultLow
            self.zoneLeading.constant = 20
            self.typeWithPaxLeading.constant = -118//-15 ///-120
            self.typeTxt.text = "JOBS"
            self.zoneTxt.text = "DATE/TIME"
            if self.isBidShow == "yes"{
                self.zonesDetailView.isHidden = false
                self.isBidShow = "no"
            }else{
                self.zonesDetailView.isHidden = true
                self.myLocImgView.isHidden = false
                self.fabMenu.isHidden = false
                self.isBidShow = "yes"
            }
            self.zoneOrBidTableView.reloadData()
        } 
        self.callToAdminView.setOnClickListener{ (instance) in
//            self.hailMenuLbl.textColor = UIColor.black
//            self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
//            self.hailIcon.tintColor = UIColor.black
            isZoneTap = false
            self.zonesDetailView.isHidden = true
            self.myLocImgView.isHidden = false
            self.fabMenu.isHidden = false
            //let number = self.userProfileJson.get("CALL_LINK")
//            UIApplication.shared.openURL(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
            if let number = self.userProfileJson.get("CALL_LINK") as? String,
               let encodedNumber = "tel://\(number)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedNumber) {

                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
        self.hailTapView.setOnClickListener{ (instance) in
            self.hailTapCount += 1
            isZoneTap = false
            let isOddTap = self.hailTapCount % 2 != 0
            if isOddTap {
                self.hailMenuLbl.textColor = UIColor(hex: 0xFE9933)
                self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
                self.hailIcon.tintColor = UIColor(hex: 0xFE9933)
            } else {
                // Use theme color instead of hardcoded black
                self.hailMenuLbl.textColor = ThemeManager.shared.textColor()
                self.hailIcon.image = self.hailIcon.image?.withRenderingMode(.alwaysTemplate)
                self.hailIcon.tintColor = ThemeManager.shared.textColor()
            }
//            if self.isFdREnabled == "no" {
//                self.isFdREnabled = "yes"
//                self.updateStatus1(offline: true, isAlertShown: true)
//            } else {
//                self.isFdREnabled = "no"
//                self.updateStatus1(offline: false, isAlertShown: true)
//            }
          
//            if(onlineOrOffline == "Available") {
//                
//              //  Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "Offline first", key: "LBL_AVAIL_TAXI_MESSAGE"), uv: self)
//               
//            }else{
                if fdTap {
                    self.isFdREnabled = "no"
                    self.isDriverOnline = true
                    self.updateStatus1(offline: false, isAlertShown: true)
                    self.configFDTap(isEnabled: false)
                }else{
                    self.isFdREnabled = "yes"
                    self.updateStatus1(offline: true, isAlertShown: true)
                    self.configFDTap(isEnabled: true)
                  //  self.openTaxiHail()
                }
           // }
        }
        
        if(userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            
            
            self.changeCarLbl.isHidden = true
            self.carNumLbl.isHidden = true
            self.carNameLBl.text = " \(userProfileJson.get("vName")) \(userProfileJson.get("vLastName"))"
            self.carNameLBl.textColor = UIColor.UCAColor.AppThemeColor
            
            self.onOffSwitch.setDefaultText(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFLINE"), with: UIColor.UCAColor.AppThemeColor)
            self.onOffSwitch.dotColor = UIColor(hex: 0xFF0000)
            self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
            self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)
            
            self.jobLocHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Your Job Location", key: "LBL_YOUR_JOB_LOCATION_TXT").uppercased()
            self.jobLocAddLbl.text = "-----"
            self.pendingJobLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pending Jobs", key: "LBL_PENDING_JOBS").uppercased()
            self.pendingJobCountLbl.text = "--"
            
            self.upcomingJobLbl.text = self.generalFunc.getLanguageLabel(origValue: "Upcoming Jobs", key: "LBL_UPCOMING_JOBS").uppercased()
            self.upcomingJobCountLbl.text = "--"
            
            self.ufxUserNameLbl.text = "\(userProfileJson.get("vName").uppercased()) \(userProfileJson.get("vLastName").uppercased())"
            
            self.availabilityRadiusLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "Within", key: "LBL_WITHIN")) \(userProfileJson.get("vWorkLocationRadius")) \(self.generalFunc.getLanguageLabel(origValue: "", key: userProfileJson.get("eUnit") == "KMs" ? "LBL_KM_DISTANCE_TXT" : "LBL_MILE_DISTANCE_TXT")) \(self.generalFunc.getLanguageLabel(origValue: "Work Radius", key: "LBL_RADIUS"))"
          
            
            let availRadiusTapGue = UITapGestureRecognizer()
            availRadiusTapGue.addTarget(self, action: #selector(self.openAvailRadius))
            
            self.editAvailRadiusImgView.isUserInteractionEnabled = true
            self.editAvailRadiusImgView.addGestureRecognizer(availRadiusTapGue)
            
            self.pendingJobCountLbl.setClickDelegate(clickDelegate: self)
            self.upcomingJobCountLbl.setClickDelegate(clickDelegate: self)
            
            setUFXRadiusLblFrame()
            
            getProviderStates()
           
        }else{
            self.changeCarLbl.isHidden = false
            self.carNumLbl.isHidden = false
            
            self.changeCarLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE").uppercased()
            self.changeCarLbl.setClickDelegate(clickDelegate: self)
            self.carNumLbl.text = userProfileJson.get("vLicencePlateNo") == "" ? "" : userProfileJson.get("vLicencePlateNo")
            
            self.carNameLBl.text = (userProfileJson.get("vMake") == "" && userProfileJson.get("vModel") == "") ? "" : "\(userProfileJson.get("vMake")) \(userProfileJson.get("vModel"))"
            
            self.onOffSwitch.setDefaultText(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFLINE"), with: UIColor.UCAColor.AppThemeColor)
            self.onOffSwitch.dotColor = UIColor(hex: 0xFF0000)
            self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
            self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)
        
        }
        
        let heatViewTapGue = UITapGestureRecognizer()
        heatViewTapGue.addTarget(self, action: #selector(self.heatViewTapped))
        heatMapImgView.isUserInteractionEnabled = true
        
        heatMapImgView.addGestureRecognizer(heatViewTapGue)
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("ONLYDELIVERALL") == "Yes"){
            heatMapImgView.isHidden = true
            heatMapImgView.frame.origin.x = heatMapImgView.frame.origin.x - heatMapImgView.frame.size.width - 15
        }
        
        ConfigPubNub.getInstance().buildPubNub()
        
        self.userLocTapGue.addTarget(self, action: #selector(self.myLocImgTapped))
        self.myLocImgView.isUserInteractionEnabled = true
        self.myLocImgView.addGestureRecognizer(self.userLocTapGue)
        
        checkPendingRequests()
        
        deleteTripStatusMessages()
        
        
        if((userProfileJson.get("eEmailVerified").uppercased() != "YES" && userProfileJson.get("ePhoneVerified").uppercased() != "YES") && userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES" && userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES"){

            let verifyBtn = Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_EMAILMOBILE_DRIVER_TXT"), uv: self, btnTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_VERIFY_TXT"), delayShow: 1, delayHide: 15)
            verifyBtn.addTarget(self, action: #selector(self.openAccountVerify(sender:)), for: UIControl.Event.touchUpInside)
            
        }else if((userProfileJson.get("eEmailVerified").uppercased() != "YES" && userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES")){
            
            let verifyBtn = Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_EMAIL_DRIVER_TXT"), uv: self, btnTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_VERIFY_TXT"), delayShow: 1, delayHide: 15)
            verifyBtn.addTarget(self, action: #selector(self.openAccountVerify(sender:)), for: UIControl.Event.touchUpInside)
            
        }else if((userProfileJson.get("ePhoneVerified").uppercased() != "YES" && userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES")){
            
            let verifyBtn = Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_MOBILE_DRIVER_TXT"), uv: self, btnTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_VERIFY_TXT"), delayShow: 1, delayHide: 15)
            verifyBtn.addTarget(self, action: #selector(self.openAccountVerify(sender:)), for: UIControl.Event.touchUpInside)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appTerminated), name: NSNotification.Name(rawValue: Utils.appKilledNotificationKey), object: nil)
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("eShowVehicles").uppercased() == "NO"){
            self.carNameLBl.isHidden = true
            self.carNumLbl.isHidden = true
            self.changeCarLbl.isHidden = true
            self.topDriverDetailView.isHidden = true
        }
    }
    
    func configFDTap(isEnabled: Bool){
        if isEnabled {
            fdTap = true
//            self.setOfflineState(isAlertShown: true)
            self.setOnlineState(isAlertShown: true)
            self.onOffSwitch.onText = self.generalFunc.getLanguageLabel(origValue: "FLAG", key: "LBL_SWITCH_FLAG_TXT")
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "You have flagged down. You can still receive jobs on bid. Stay on bid tab to see jobs you can accept and bid for it.", key: "LBL_SWITCH_FLAG_RESTRICT"), uv: self)
            self.onOffSwitch.dotColor = UIColor(hex: 0xFE9933)
            self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
            self.onOffSwitch.onTextColor = UIColor(hex: 0xFE9933)//0xEEC8A3)
            self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)//EEC8A3
        }else{
            fdTap = false
           // self.setOfflineState(isAlertShown: true)
            self.setOnlineState(isAlertShown: true)
            self.onOffSwitch.onTextColor = UIColor.UCAColor.AppThemeColor
            self.onOffSwitch.onText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONLINE")
            self.onOffSwitch.dotColor = UIColor(hex: 0x009900)
        }
    }
    
    func setWorkLocationArea(isHide:Bool){
        if(workLocAreaHeight != nil){
            if( isHide == false){
                self.editWorkLocBtn.bgColor = UIColor(hex: 0xFFFFFF)
                self.editWorkLocBtn.titleColor = UIColor(hex: 0x000000)
                self.editWorkLocBtn.pulseColor = UIColor(hex: 0xFFFFFF).darker(by: 20)
                self.editWorkLocBtn.enableCustomColor()
                self.editWorkLocBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT"))
                self.workLocLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_WORK_LOCATION")
                self.workLocLbl.textColor = UIColor(hex: 0xFFFFFF)
                GeneralFunctions.setImgTintColor(imgView: self.workLocImgView, color: UIColor(hex: 0xFFFFFF))
                self.workLocArea.isHidden = false
                self.workLocAreaHeight.constant = 50
                self.editWorkLocBtn.clickDelegate = self
                self.isLocationEnable = true
            }else{
                self.isLocationEnable = false
                workLocAreaHeight.constant = 0
                self.workLocArea.isHidden = true
            }
        }
    }
    
    func setUFXRadiusLblFrame(){
    }
    
    @objc func openAvailRadius(){
    }
    
    func getProviderStates(){
        
        let parameters = ["type":"GetUserStats", "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.pendingJobCountLbl.text = dataDict.get("Pending_Count")
                    self.upcomingJobCountLbl.text = dataDict.get("Upcoming_Count")
                    self.availabilityRadiusLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "Within", key: "LBL_WITHIN")) \(dataDict.get("Radius")) \(self.generalFunc.getLanguageLabel(origValue: "", key: self.userProfileJson.get("eUnit") == "KMs" ? "LBL_KM_DISTANCE_TXT" : "LBL_MILE_DISTANCE_TXT")) \(self.generalFunc.getLanguageLabel(origValue: "Work Radius", key: "LBL_RADIUS"))"
                }
                
            }else{
                
//                if(isAlertShown == true){
//                    self.generalFunc.setError(uv: self)
//                }
            }
            
        })
    }
    
    @objc func openTaxiHail(){
        let parameters = ["type":"CheckVehicleEligibleForHail","iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let taxiHailUv = GeneralFunctions.instantiateViewController(pageName: "TaxiHailUV") as! TaxiHailUV
                    self.pushToNavController(uv: taxiHailUv)
                    
                }else{
                    if(dataDict.get(Utils.message_str) == "REQUIRED_MINIMUM_BALNCE"){
                        //                self.generalFunc.setError(uv: self, title: "", content: dict.get("Msg"))
                        let openMinAmountReqView = OpenMinAmountReqView(uv: self, containerView: self.contentView)
                        openMinAmountReqView.setHandler(handler: { (isSkipped, isOpenWallet, view, bgView) in
                            if(isOpenWallet == true){
                                if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() == "CASH" || (self.APPSTORE_MODE_IOS != nil && (self.APPSTORE_MODE_IOS as! String).uppercased() == "REVIEW")){
                                    let contactUsUV = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                    self.pushToNavController(uv: contactUsUV)
                                }else{
                                    let manageWalletUv = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    self.pushToNavController(uv: manageWalletUv)
                                }
                            }
                        })
                        openMinAmountReqView.show(msg: dataDict.get("Msg"))
                        return
                    }
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    func checkLocationEnabled(){
        if(locationDialog != nil){
            locationDialog.removeView()
            locationDialog = nil
        }
        
        if(GeneralFunctions.hasLocationEnabled() == false || InternetConnection.isConnectedToNetwork() == false){
            if(APPSTORE_MODE_IOS != nil && (APPSTORE_MODE_IOS as! String).uppercased() != "REVIEW"){
                locationDialog = OpenLocationEnableView(uv: self, containerView: self.cntView == nil ? (self.ufxCntView == nil ? UIView() : self.ufxCntView) : self.cntView , gMapView: self.gMapView, isMapLocEnabled: isMyLocationEnabled)
                locationDialog.show()
                
                if(GeneralFunctions.hasLocationEnabled() == false){
                    goOffline(isAlertShown: false)
                }
            }
            return
        }else{
            if(self.gMapView != nil && self.gMapView.isMyLocationEnabled != self.isMyLocationEnabled){
                self.gMapView.isMyLocationEnabled = self.isMyLocationEnabled
            }
        }
        
    }
    
    @objc func appTerminated(){
        
//        let parameters = ["type":"updateDriverStatus", "isUpdateOnlineDate": "", "iDriverId": GeneralFunctions.getMemberd(),"latitude": "", "longitude": "", "Status": "Not Available"]
//        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
//        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
//        exeWebServerUrl.currInstance = exeWebServerUrl
//        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
//
//        })
//
//        sleep(4)
    }
    
    @objc func appInForground(){
        checkLocationEnabled()
        
        if(userProfileJson != nil && userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            self.navigationController?.navigationBar.layer.zPosition = -1
            
            if(self.ufxUserNameLbl != nil){                
                getProviderStates()
            }
        }
    }
    
    @objc func openAccountVerify(sender:FlatButton){
        
        self.snackbarController?.animate(snackbar: .hidden, delay: 0)
        
        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
        
        if((userProfileJson.get("eEmailVerified").uppercased() != "YES" && userProfileJson.get("ePhoneVerified").uppercased() != "YES") && userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES" && userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES"){
            accountVerificationUv.requestType = "DO_PHONE_VERIFY"
            accountVerificationUv.isForMobile = true
        }else if((userProfileJson.get("eEmailVerified").uppercased() != "YES" && userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES") ){
            accountVerificationUv.requestType = "DO_EMAIL_VERIFY"
            accountVerificationUv.isForMobile = false
        }else if((userProfileJson.get("ePhoneVerified").uppercased() != "YES" && userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES") ){
            accountVerificationUv.requestType = "DO_PHONE_VERIFY"
            accountVerificationUv.isForMobile = true
        }
        
        accountVerificationUv.isMainPage = true
        accountVerificationUv.mainScreenUv = self
        self.pushToNavController(uv: accountVerificationUv)
    }
    
    @objc func myLocImgTapped() {
        if(GeneralFunctions.hasLocationEnabled() == true){
            if(self.currentLocation == nil){
                return
            }
            let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude), zoomLevel:Utils.defaultZoomLevel, mapView:self.gMapView)
            
            self.gMapView.animate(to: camera)
        }
        else{
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
        }
    }
    
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.changeCarLbl){
            self.loadAvailableCar()
        }else if(self.manageVehiclesLbl != nil && sender == self.manageVehiclesLbl){
            self.selectCarBGView.removeFromSuperview()
            self.selectCarView.removeFromSuperview()
            
            openManageVehiclesScreen()
        }else if(self.addNewVehicleLbl != nil && sender == self.addNewVehicleLbl){
            self.selectCarBGView.removeFromSuperview()
            self.selectCarView.removeFromSuperview()
            
            let addVehiclesUv = GeneralFunctions.instantiateViewController(pageName: "AddVehiclesUV") as! AddVehiclesUV
            addVehiclesUv.isFromMainPage = true
            addVehiclesUv.mainScreenUv = self
             self.pushToNavController(uv: addVehiclesUv)
        }else if(self.pendingJobCountLbl != nil && sender == self.pendingJobCountLbl){
            //openHistory(isFirstUpcoming: false)
            self.passType = "pending"
            self.openBooking()
        }else if(self.upcomingJobCountLbl != nil && sender == self.upcomingJobCountLbl){
            //openHistory(isFirstUpcoming: true)
            self.passType = "upcoming"
            self.openBooking()
        }
    }
    
    func openHistory(isFirstUpcoming:Bool){
        //FIXME: manage ride history
//        let rideHistoryUv = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
//        let myBookingsUv = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
//        let pendingBookingsUv = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
//        rideHistoryUv.HISTORY_TYPE = "PAST"
//        myBookingsUv.HISTORY_TYPE = "LATER"
//        pendingBookingsUv.HISTORY_TYPE = "PENDING"
//
//        rideHistoryUv.pageTabBarItem.title = self.generalFunc.getLanguageLabel(origValue: "PAST", key: "LBL_PAST")
//        myBookingsUv.pageTabBarItem.title = self.generalFunc.getLanguageLabel(origValue: "UPCOMING", key: "LBL_UPCOMING")
//        pendingBookingsUv.pageTabBarItem.title = self.generalFunc.getLanguageLabel(origValue: "UPCOMING", key: "LBL_PENDING")
//
//        var uvArr = [UIViewController]()
//
//        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
//            if(isFirstUpcoming == true){
//                uvArr += [myBookingsUv]
//                uvArr += [pendingBookingsUv]
//                uvArr += [rideHistoryUv]
//            }else{
//                uvArr += [pendingBookingsUv]
//                uvArr += [myBookingsUv]
//                uvArr += [rideHistoryUv]
//            }
//        }else{
//            uvArr += [rideHistoryUv]
//            uvArr += [myBookingsUv]
//        }
//        if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() == "YES"){
//            let rideHistoryTabUv = RideHistoryTabUV(viewControllers: uvArr, selectedIndex: 0)
//            self.pushToNavController(uv: rideHistoryTabUv)
//        }else{
//            rideHistoryUv.isDirectPush = true
//            self.pushToNavController(uv: rideHistoryUv)
//        }
        
    }
    
    func openManageVehiclesScreen(){
        let manageVehiclesUV = GeneralFunctions.instantiateViewController(pageName: "ManageVehiclesUV") as! ManageVehiclesUV
        self.pushToNavController(uv: manageVehiclesUV)
    }
    
    @objc func releaseAllTask(isDismiss:Bool = true){
        
        if(updateDriverStatus != nil){
            updateDriverStatus.stopFrequentUpdate()
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
        
        GeneralFunctions.removeObserver(obj: self)
        
        if(isDismiss){
            self.dismiss(animated: false, completion: nil)
            self.navigationController?.dismiss(animated: false, completion: nil)
        }
    }
    
    
    func onLocationUpdate(location: CLLocation) {
        
        self.currentLocation = location
//
//        if(gMapView == nil){
//            releaseAllTask()
//            return
//        }
//
        
        let vAvailability = userProfileJson.get("vAvailability")
        //onlineOrOffline = vAvailability
        print("suleman2\(onlineOrOffline)")
        if(vAvailability == "Available" && isFirstLocationUpdate == true && userProfileJson.get("ePhoneVerified").uppercased() == "YES" ){
            
            updateStatus(offline: false, isAlertShown: true, true)

        }
        
        let GO_ONLINE = GeneralFunctions.getValue(key: "GO_ONLINE")
        
        if(GO_ONLINE != nil && (GO_ONLINE as! String) == "1"){
            updateStatus(offline: false, isAlertShown: true, true)
            GeneralFunctions.removeValue(key: "GO_ONLINE")
        }
        if(gMapView != nil){
            var currentZoomLevel:Float = self.gMapView.camera.zoom
            
            if(currentZoomLevel < Utils.defaultZoomLevel && isFirstLocationUpdate == true){
                currentZoomLevel = Utils.defaultZoomLevel
            }
            
            
            let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoomLevel:currentZoomLevel, mapView:self.gMapView)
            
            if (isHeatMapEnabled == false){
                self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
            }
        }
        
        
        if(isFirstLocationUpdate == true && userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            self.jobLocAddLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOAD_ADDRESS")
            
            self.findUserLocAddress()
            
        }
        
        isFirstLocationUpdate = false
        
        updateLocationToPubNub()
        
        if(driverDestinationModeView != nil && driverDestinationModeView.isHidden == false && gMapView != nil){
            self.boundMapForDestinationMode()
        }
    }
    
    @objc func onRefreshCalled(){
        findUserLocAddress()
        getProviderStates()
    }
    
    func findUserLocAddress(){
        if(self.currentLocation == nil){
            return
        }
        
        if(userProfileJson.get("eSelectWorkLocation").uppercased() == "FIXED"){
            onAddressFound(address: userProfileJson.get("vWorkLocation"), location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: userProfileJson.get("vWorkLocationLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: userProfileJson.get("vWorkLocationLongitude"))), isPickUpMode: false, dataResult: "")
        }else{
            getAddressFromLocation = GetAddressFromLocation(uv: self, addressFoundDelegate: self)
            getAddressFromLocation.setLocation(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude)
            getAddressFromLocation.executeProcess(isOpenLoader: false, isAlertShow: false)
        }
    }
    
    func onAddressFound(address: String, location: CLLocation, isPickUpMode: Bool, dataResult: String) {
        if(getAddressFromLocation != nil){
            getAddressFromLocation.addressFoundDelegate = nil
            getAddressFromLocation = nil
        }
        
        self.jobLocAddLbl.text = address
        self.jobLocAddLbl.fitText()
        
        let height = address.height(withConstrainedWidth: Application.screenSize.width - 20, font: self.jobLocAddLbl.font!)
        
        ufxPAGE_HEIGHT = ufxPAGE_HEIGHT  - self.ufxJobLocAreaHeight.constant
        
        self.ufxJobLocAreaHeight.constant = 105 + height
        ufxPAGE_HEIGHT = ufxPAGE_HEIGHT + self.ufxJobLocAreaHeight.constant
        
        ufxCntView.frame.size = CGSize(width: ufxCntView.frame.width, height: ufxPAGE_HEIGHT)
        self.ufxScrollView.contentSize = CGSize(width: self.ufxScrollView.frame.size.width, height: ufxPAGE_HEIGHT)
    }
    
    
    func checkPendingRequests(){
        GeneralFunctions.saveValue(key: Utils.DRIVER_CURRENT_REQ_OPEN_KEY, value: "false" as AnyObject)
        let currentReqArr = userProfileJson.getArrObj("CurrentRequests")
        
        if(currentReqArr.count > 0){
            updateCurrentReqFreqTask = UpdateFreqTask(interval: 5)
            updateCurrentReqFreqTask.currInst = updateCurrentReqFreqTask
            updateCurrentReqFreqTask.setTaskRunListener(onTaskRunCalled: self)
            updateCurrentReqFreqTask.startRepeatingTask()
        }else{
            for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                if(key.hasPrefix(Utils.DRIVER_REQ_CODE_PREFIX_KEY)){
                    
                    var newValue = value
                    if let b = newValue as? String {
                        if(NetworkHelper.isEncAllowed() == true && key != "SERVERURL"){
                            newValue = DataHelper.sharedInstance.decrypt(input: b) as AnyObject
                        }
                    }
                    
                    let dataValue = Int64(newValue as! String)
                    let day = 1000 * 60 * 60 * 24 * 1
                    let currentTimeInmill = Utils.currentTimeMillis() - Int64(day)
                    
                    if(currentTimeInmill > dataValue!){
                        GeneralFunctions.removeValue(key: key)
                    }
                }
            }
        }
    }
    
    func deleteTripStatusMessages(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            
            var newValue = value
            if let b = newValue as? String {
                if(NetworkHelper.isEncAllowed() == true && key != "SERVERURL"){
                    newValue = DataHelper.sharedInstance.decrypt(input: b) as AnyObject
                }
            }
            
            if(key.hasPrefix(Utils.TRIP_STATUS_MSG_PRFIX)){
                
                let dataValue = Int64(newValue as! String)
                let day = 1000 * 60 * 60 * 24 * 1
                let currentTimeInmill = Utils.currentTimeMillis() - Int64(day)
                
                if(currentTimeInmill > dataValue!){
                    GeneralFunctions.removeValue(key: key)
                }
            }
        }
    }
    
    func onTaskRun(currInst: UpdateFreqTask) {
        if(GeneralFunctions.getValue(key: Utils.DRIVER_CURRENT_REQ_OPEN_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DRIVER_CURRENT_REQ_OPEN_KEY) as! String == "true")){
            return
        }
        
        let currentReqArr = userProfileJson!.getArrObj("CurrentRequests")
        
        if(currentReqTaskPosition < currentReqArr.count){
            
            let msg_str = currentReqArr[currentReqTaskPosition] as! NSDictionary
            
            let message = msg_str.get("tMessage")
            
            FireTripStatusMessges().fireTripMsg(message, true, "Script")
            
            currentReqTaskPosition = currentReqTaskPosition + 1
            
            return
        }else{
            updateCurrentReqFreqTask.stopRepeatingTask()
        }
    }
    
    
    @objc func heatViewTapped(){
        
        gMapView.clear()
        
        onlineData.removeAll()
        historyData.removeAll()
        dtaCircleHeatMap.removeAll()
        currentRadius = 0
        
        if(isHeatMapEnabled == false){
            isHeatMapEnabled = true
            gMapView.delegate = self
            heatMapImgView.image = UIImage(named: "ic_heat_map_on")
            
            
            let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: getCenterCoordinate().latitude, longitude: getCenterCoordinate().longitude), zoomLevel:14, mapView:self.gMapView)
            
            self.isCameraUpdateIgnore = true
            
            self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
            
            loadHeatMapData()
            
        }else{
            isHeatMapEnabled = false
            gMapView.delegate = nil
            heatMapImgView.image = UIImage(named: "ic_heat_map_off")
            
            if(self.currentLocation != nil){
                
                
                let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude), zoomLevel:Utils.defaultZoomLevel, mapView:self.gMapView)
                
                self.gMapView.animate(with: GMSCameraUpdate.setCamera(camera))
            }else{
                
                
                let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: getCenterCoordinate().latitude, longitude: getCenterCoordinate().longitude), zoomLevel:Utils.defaultZoomLevel, mapView:self.gMapView)
                self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
            }
        }
    }
   
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if(self.isCameraUpdateIgnore == true){
            self.isCameraUpdateIgnore = false
            return
        }
        
        if(isHeatMapEnabled){
            loadHeatMapData()
        }
    }
    
    func loadHeatMapData() {
        var radius = getRadius()
        
        if(radius < 0.5){
            radius = 1.0
        }
        
        if(currentRadius == 0.0 || radius > (currentRadius + 0.001)){
            getNearByPassenger(radius: radius, centerLatitude: getCenterCoordinate().latitude, centerLongitude: getCenterCoordinate().longitude)
        }
    }
    
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.gMapView.center
        let centerCoordinate = self.gMapView.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = self.gMapView.convert(CGPoint(self.gMapView.frame.size.width / 2.0, 0), from: gMapView)
        let point = self.gMapView.projection.coordinate(for: topCenterCoor)
        return point
    }
    
    func getRadius() -> CLLocationDistance {
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        
        let radius = (centerLocation.distance(from: topCenterLocation)) / 1000
        
        return round(radius)
    }
    
    func switchValueChanged(_ sender: Any!, andNewValue value: Bool) {
        if fdTap{
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "Press FD to initiate flag down", key: "LBL_SWITCH_FLAG_RESTRICT"), uv: self)
            self.configFDTap(isEnabled: true)
            return
        }
        if (value == true) {
            if(self.userProfileJson.get("ONLYDELIVERALL") != "Yes" ){
                
                /* Help note changes for Ride*/
                if ((self.userProfileJson.get("ENABLE_SAFETY_FEATURE_RIDE").uppercased() == "YES" || self.userProfileJson.get("ENABLE_SAFETY_FEATURE_DELIVERY").uppercased() == "YES" || self.userProfileJson.get("ENABLE_SAFETY_FEATURE_UFX").uppercased() == "YES") && self.userProfileJson.get("ENABLE_SAFETY_CHECKLIST").uppercased() == "YES"){
                    self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
                    let helpNoteForRideUV = GeneralFunctions.instantiateViewController(pageName: "HelpNoteForRideUV") as! HelpNoteForRideUV
                    helpNoteForRideUV.isRideLater = true
                    self.pushToNavController(uv: helpNoteForRideUV)
                    return
                }/* Help note changes for Ride*/

                self.onOffSwitch.dotColor = UIColor(hex: 0x009900)
            }else{
                self.onOffSwitch.dotColor = UIColor(hex: 0x009900)
                self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
                self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)
            }
        } else {
            if(userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                self.onOffSwitch.dotColor = UIColor(hex: 0xFF0000)
            }else{
                self.onOffSwitch.dotColor = UIColor(hex: 0xFF0000)
                self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
                self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)
            }
        }
        self.updateOnlineStatus(isAlertShown: true, true)
    }
    
    func stateChanged(onlineOfflineStatusSwitch: UISwitch) {
        
        onlineOfflineStatusSwitch.tintColor = UIColor(hex: 0xFFFFFF)
        onlineOfflineStatusSwitch.onTintColor = UIColor(hex: 0xFFFFFF)
        
        if(onlineOfflineStatusSwitch.isOn){
            onlineOfflineStatusSwitch.thumbTintColor = UIColor(hex: 0xFF0000)
        } else {
            onlineOfflineStatusSwitch.thumbTintColor = UIColor(hex: 0x009900)
        }
        
        updateOnlineStatus(isAlertShown: true)
    }
    
    
    func updateOnlineStatus(isAlertShown: Bool, _ switchValueChanged:Bool = false){
        if fdTap{
            return
        }
        if(isDriverOnline == false){
            goOnline(isAlertShown: isAlertShown, switchValueChanged)
        }else{
            goOffline(isAlertShown: isAlertShown, switchValueChanged)
        }
    }
    
    func goOnline(isAlertShown: Bool, _ switchValueChanged:Bool = false){
        if(currentLocation != nil){
            let currentLocLatitude:String = self.currentLocation!.coordinate.latitude.description
            let currentLocLongitude:String = self.currentLocation!.coordinate.longitude.description
            
            if(currentLocLatitude != "" && currentLocLatitude != "0.0" && currentLocLongitude != "" && currentLocLongitude != "0.0"){
                updateStatus(offline: false,isAlertShown: isAlertShown, switchValueChanged)
            
            }else{
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
                self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
            }
        }else{
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
            self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
        }
    }
    
    func goOffline(isAlertShown: Bool, _ switchValueChanged:Bool = false){
        if(isDriverOnline == true){
            if(currentLocation == nil){
                currentLocation = CLLocation(latitude: 0.0,longitude: 0.0)
            }
            updateStatus(offline: true, isAlertShown: isAlertShown, switchValueChanged)
            
        }else{
            self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
        }
       
    }
    
    func updateStatus1(offline:Bool, isAlertShown:Bool, _ switchValueChanged:Bool = false){
        
        if(self.fabMenu != nil){
            self.fabMenu.close(isTriggeredByUserInteraction: true)
        }
        
        var vAvailability_str:String = ""
        if(offline == false){
            vAvailability_str = "Available"
        }else{
            vAvailability_str = "Not Available"
        }
        self.availability = vAvailability_str
        onlineOrOffline = self.availability
        print("suleman1\(onlineOrOffline)")
        let currentLocLatitude = self.currentLocation!.coordinate.latitude.description
        let currentLocLongitude = self.currentLocation!.coordinate.longitude.description
        
        var parameters = ["type":"updateDriverStatus", "isUpdateOnlineDate": offline == false ? "true" : "", "iDriverId": GeneralFunctions.getMemberd(),"latitude": currentLocLatitude, "longitude": currentLocLongitude, "Status": vAvailability_str,"isFlagEnabled": self.isFdREnabled ?? "no"]
        
        if(switchValueChanged == true){
            parameters["isOnlineSwitchPressed"] = offline == false ? "true" : ""
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: isAlertShown)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
              
            }else{
                if(isAlertShown == true){
                    self.generalFunc.setError(uv: self)
                }
            }
        })
    }
    
    func updateStatus(offline:Bool, isAlertShown:Bool, _ switchValueChanged:Bool = false){
        
        if(self.fabMenu != nil){
            self.fabMenu.close(isTriggeredByUserInteraction: true)
        }
        
        var vAvailability_str:String = ""
        if(offline == false){
            vAvailability_str = "Available"
        }else{
            vAvailability_str = "Not Available"
        }
        self.availability = vAvailability_str
        onlineOrOffline = self.availability
        let currentLocLatitude = self.currentLocation!.coordinate.latitude.description
        let currentLocLongitude = self.currentLocation!.coordinate.longitude.description
        
        var parameters = ["type":"updateDriverStatus", "isUpdateOnlineDate": offline == false ? "true" : "", "iDriverId": GeneralFunctions.getMemberd(),"latitude": currentLocLatitude, "longitude": currentLocLongitude, "Status": vAvailability_str,"isFlagEnabled": self.isFdREnabled ?? "no"]
        
        if(switchValueChanged == true){
            parameters["isOnlineSwitchPressed"] = offline == false ? "true" : ""
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: isAlertShown)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                if(offline == false){
                   self.isDriverOnline = false
                }
                self.getZones()//suleman
                let dataDict = response.getJsonDataDict()
                self.getBids(suppressSnackBar: true)
                if (dataDict.get("UberX_message") != ""){
                    self.generalFunc.setAlertMessage(uv: self, title: "", content:self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("UberX_message")) , positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    })
                }
                
                self.DRIVER_DESTINATION_AVAILABLE = dataDict.get("DRIVER_DESTINATION_AVAILABLE").uppercased()
        
                self.checkStatusUpdateRespose(dict: dataDict, offline: offline, isAlertShown: isAlertShown)
                // Driver Destinations Changes
                if(dataDict.get("ENABLE_DRIVER_DESTINATIONS") == "Yes" && self.userProfileJson.get("ONLYDELIVERALL") != "Yes"){
                    
                    self.driverDestinationModeSetup()
                }else{
                    if(self.driverDestiImgView != nil){
                        self.isDestinationEnabled = false
                        self.driverDestiImgView.isHidden = true
                    }
                }// Driver Destinations Changes
                
                
                if(dataDict.get("Enable_Hailtrip") == "Yes" && self.isDriverOnline == true){
                    if(self.userProfileJson.get("ONLYDELIVERALL") != "Yes"){
                        self.hideShowHail(isHide: false)
                    }else{
                        self.hideShowHail(isHide: true)
                    }
                }else{
                    self.hideShowHail(isHide: true)
                }
                
            }else{
                self.setSwitchStatusAvoidUpdate(value: offline, isAnim: false)
                
                if(isAlertShown == true){
                    self.generalFunc.setError(uv: self)
                }
            }
        })
    }
    
    
    func checkStatusUpdateRespose(dict:NSDictionary, offline:Bool, isAlertShown:Bool){
        
//        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
//
//            if(btnClickedIndex == 0){
//                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
//                self.pushToNavController(uv: contactUsUv)
//            }
//
//        })
        if(dict.get("Action") == "1"){
            
            if(dict.get(Utils.message_str) == "REQUIRED_MINIMUM_BALNCE" && isDriverOnline == false && isAlertShown == true){
                let openMinAmountReqView = OpenMinAmountReqView(uv: self, containerView: userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX ? self.cntView : self.ufxCntView)
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
                openMinAmountReqView.show(msg: dict.get("Msg"))
                
            }
//            self.HailEnableOnDriverStatus = dict.get("Enable_Hailtrip")
            if(isDriverOnline == false){
                self.setOnlineState(isAlertShown: isAlertShown)
                
                
                self.setWorkLocationArea(isHide: (dict.get("isExistUberXServices").uppercased() == "YES" && self.userProfileJson.get("UFX_SERVICE_AVAILABLE") == "Yes") ? false : true)
                
            }else{
                self.setOfflineState(isAlertShown: isAlertShown)
            }
            
        }else{
            let message = dict.get("message")
            if (message == "LBL_DRIVER_DOC_EXPIRED") {
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: message, key: message))
                
                if(offline == true){
                    self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
                }else {
                    self.setOfflineState(isAlertShown: false)
                }
                    
                return
            }
            
            if(offline == true){
                self.setSwitchStatusAvoidUpdate(value: true, isAnim: false)
            }else{
                self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
            }
            
            
            
            let message_str = dict.get("message")
            
            if(isAlertShown == false){
                return
            }
            
            
            if(dict.get(Utils.message_str) == "SESSION_OUT"){
                
                self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.releaseAllTask(isDismiss: true)
                    GeneralFunctions.logOutUser()
                    GeneralFunctions.restartApp(window: self.window!)
                })
                
                return
                
            }else if(message_str == "DO_EMAIL_PHONE_VERIFY" || message_str == "DO_PHONE_VERIFY" || message_str == "DO_EMAIL_VERIFY"){
                
                var alertTxt = ""
                
                if((self.userProfileJson.get("eEmailVerified").uppercased() != "YES" && self.userProfileJson.get("ePhoneVerified").uppercased() != "YES") && self.userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES" && self.userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES"){
                    alertTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_EMAILMOBILE_DRIVER_TXT")
                }else if((self.userProfileJson.get("eEmailVerified").uppercased() != "YES" && self.userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES") ){
                    alertTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_EMAIL_DRIVER_TXT")
                }else if((self.userProfileJson.get("ePhoneVerified").uppercased() != "YES" && self.userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES") ){
                    alertTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_MOBILE_DRIVER_TXT")
                }
                
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "\(alertTxt)"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                        if(message_str == "DO_EMAIL_PHONE_VERIFY"){
                            accountVerificationUv.requestType = "DO_EMAIL_PHONE_VERIFY"
                        }else if(message_str == "DO_PHONE_VERIFY"){
                            accountVerificationUv.isForMobile = true
                            accountVerificationUv.requestType = "DO_PHONE_VERIFY"
                        }else if(message_str == "DO_EMAIL_VERIFY"){
                            accountVerificationUv.isForMobile = false
                            accountVerificationUv.requestType = "DO_EMAIL_VERIFY"
                        }
                        accountVerificationUv.isMainPage = true
                        accountVerificationUv.requestType = message_str
                        accountVerificationUv.mainScreenUv = self
                        self.pushToNavController(uv: accountVerificationUv)
                    }
                })
                
                return
            }else if((dict.get(Utils.message_str) == "PENDING_SUBSCRIPTION" || dict.get(Utils.message_str) == "LBL_PENDING_MIXSUBSCRIPTION") && isDriverOnline == false){  /* Subscription */
                
                if(self.subscriptionBgView.isHidden == true){
                    if(dict.get(Utils.message_str) == "PENDING_SUBSCRIPTION"){
                        self.openSubscriptionView(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_REQ_SH_LBL"))
                    }else{
                        self.openSubscriptionView(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PENDING_MIXSUBSCRIPTION"))
                    }
                }
                
                return
                
            }else if(message_str == "REQUIRED_MINIMUM_BALNCE"){
                let openMinAmountReqView = OpenMinAmountReqView(uv: self, containerView: self.contentView)
                openMinAmountReqView.setHandler(handler: { (isSkipped, isOpenWallet, view, bgView) in
                    if(isOpenWallet == true){
                        if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() == "CASH" || (self.APPSTORE_MODE_IOS != nil && (self.APPSTORE_MODE_IOS as! String).uppercased() == "REVIEW")){
                            let contactUsUV = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                            self.pushToNavController(uv: contactUsUV)
                        }else{
                            let manageWalletUv = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                            self.pushToNavController(uv: manageWalletUv)
                        }
                    }
                })
                openMinAmountReqView.show(msg: dict.get("Msg"))
                
                return
            }else if(message_str == "LBL_INACTIVE_CARS_MESSAGE_TXT"){
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: message_str), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT").uppercased() , nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT").uppercased(), completionHandler: { (btnClickedId) in
                    
                    if(btnClickedId == 1){
                        let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                        self.pushToNavController(uv: contactUsUv)
                    }
                })
                
                return
            }
            
            if(message_str != "" && message_str == "LBL_DRIVER_BLOCK"){
                if(dict.get("isShowContactUs") == "Yes"){
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: message_str), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
                        
                        if(btnClickedIndex == 0){
                            let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                            self.pushToNavController(uv: contactUsUv)
                        }
                        
                    })
                    return
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key:message_str))
                
                    return
                }
            }
            
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: message, key: message))
            
        }
    }
    
    func setOnlineState(isAlertShown:Bool){
        
        DispatchQueue.main.async {
            if(isAlertShown){
                if fdTap{
              
                }else{
                    self.onOffSwitch.onText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONLINE")
                    self.onOffSwitch.offText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFLINE")
                    Utils.hideSnackBar(uv: self)
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONLINE_HEADER_TXT"), uv: self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        Utils.hideSnackBar(uv: self)
                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONLINE_HEADER_TXT"), uv: self)
//                    }
                }
            }
            self.setSwitchStatusAvoidUpdate(value: true, isAnim: false)
        }
        
        GeneralFunctions.saveValue(key: "IS_DRIVER_ONLINE", value: "true" as AnyObject)
        isDriverOnline = true
        
        addNotifyOnPassengerRequested()
        
        ConfigPubNub.getInstance().subscribeToCabReqChannel()
        
        if(updateDriverStatus == nil){
            updateDriverStatus = UpdateDriverStatus(uv: self)
        }
        updateDriverStatus.isOnline = true
        updateDriverStatus.scheduleDriverUpdate()
        
        updateLocationToPubNub()
        
        // DRIVER DESTINATION MODE //
        if(userProfileJson.get("ENABLE_DRIVER_DESTINATIONS").uppercased() == "YES"){
            
            self.isDestinationEnabled = true
            if(self.fabMenu != nil && self.userProfileJson.get("eDestinationMode").uppercased() == "YES"){
                self.fabMenu.isHidden = true
            }
            self.openDriverDestinationTrip(isFromRestartApp: true)
        }
        
        (UIApplication.shared.delegate as! AppDelegate).configureOnlineState(true)
        
    }
    
    func setOfflineState(isAlertShown:Bool){
        
        DispatchQueue.main.async {
            if(isAlertShown){
                if fdTap{
              
                }else{
                    self.onOffSwitch.onText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONLINE")
                    self.onOffSwitch.offText = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFLINE")
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFLINE_HEADER_TXT"), uv: self)
                }
               
            }

            
            self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
        }
        
        GeneralFunctions.saveValue(key: "IS_DRIVER_ONLINE", value: "false" as AnyObject)
        
        isDriverOnline = false
        
        ConfigPubNub.getInstance().unSubscribeToCabReqChannel()
        
        if(updateDriverStatus == nil){
            updateDriverStatus = UpdateDriverStatus(uv: self)
        }
        updateDriverStatus.isOnline = false
        updateDriverStatus.stopFrequentUpdate()
        
        self.hideShowHail(isHide: true)
        
        self.setWorkLocationArea(isHide: true)
        
        // DRIVER DESTINATION MODE //
        if(userProfileJson.get("ENABLE_DRIVER_DESTINATIONS").uppercased() == "YES"){
            if(self.driverDestiImgView != nil){
                self.hideDestinationMode()
            }
        }
        
        (UIApplication.shared.delegate as! AppDelegate).configureOnlineState(false)
    }
    
    func hideShowHail(isHide:Bool){
        if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
            var height = 0
            if(isHide == false){
                height = 65
            }
            self.view.layoutIfNeeded()
            if(hailImgViewHeight != nil){
                hailImgViewHeight.constant = CGFloat(height)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                if(isHide == false){
                    self.taxiHailImgView.isHidden = false
                    self.isHailEnabled = true
                    self.prepareMenuItems()
                }else{
                    self.taxiHailImgView.isHidden = true
                    self.isHailEnabled = false
                    self.prepareMenuItems()
                }
            })
        }
       
    }
    
    func setSwitchStatus(value:Bool, isAnim:Bool){
        DispatchQueue.main.async {
            self.onOffSwitch.configSwitchState(value, animated: isAnim)
        }
    }
    
    func setSwitchStatusAvoidUpdate(value:Bool, isAnim:Bool){
        DispatchQueue.main.async {
            self.onOffSwitch.configSwitchStateAvoidUpdate(value, animated: isAnim)
            
            if (value == true) {
                if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                    if fdTap{
                        self.onOffSwitch.dotColor = UIColor(hex: 0xFE9933)
                    }else{
                        self.onOffSwitch.dotColor = UIColor(hex: 0x009900)
                    }
                   
                }else{
                    self.onOffSwitch.dotColor = UIColor(hex: 0x009900)
                    self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
                    self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)
                }
            } else {
                if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                    self.onOffSwitch.dotColor = UIColor(hex: 0xFF0000)
                }else{
                    self.onOffSwitch.dotColor = UIColor(hex: 0xFF0000)
                    self.onOffSwitch.color = UIColor(hex: 0xFFFFFF)
                    self.onOffSwitch.tintColor = UIColor(hex: 0xFFFFFF)
                }
            }
        }
    }
    
    func openManageProfile(isOpenEditProfile: Bool){
        let manageProfileUv = GeneralFunctions.instantiateViewController(pageName: "ManageProfileUV") as! ManageProfileUV
        manageProfileUv.isOpenEditProfile = isOpenEditProfile
        self.pushToNavController(uv: manageProfileUv)
    }
    
    func getNearByPassenger(radius:Double, centerLatitude:Double, centerLongitude:Double){
        
        if(task_update_heatMapData != nil){
            task_update_heatMapData!.cancel()
        }
        
        let parameters = ["type":"loadPassengersLocation", "Radius": "\(radius)", "iMemberId": GeneralFunctions.getMemberd(),"Latitude": "\(centerLatitude)", "Longitude": "\(centerLongitude)"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    self.checkNearByPassengerDataResponse(radius: radius, dict: dataDict)
                }else{
                    //                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                //                self.generalFunc.setError(uv: self)
            }
            
        })
        
        self.task_update_heatMapData = exeWebServerUrl
        
    }
    
    func checkNearByPassengerDataResponse(radius:Double,dict:NSDictionary){
        
        if(self.isHeatMapEnabled == false){
            gMapView.clear()
            
            onlineData.removeAll()
            historyData.removeAll()
            dtaCircleHeatMap.removeAll()
            currentRadius = 0
            return
        }
        
        if(dict.get("Action")  == "1"){
            self.currentRadius = radius
            let message = dict.get("message")
            
            var list = [GMUWeightedLatLng]()
            var onlineList = [GMUWeightedLatLng]()
            if(message != ""){
                let message_arr = dict.getArrObj("message")
                
                for i in 0 ..< message_arr.count {
                    let tempItem = message_arr[i] as! NSDictionary
                    
                    let type = tempItem.get("Type")
                    
                    //                    print("Type::\(type)")
                    
                    let latitude = Double(tempItem.get("Latitude"))
                    let longitude = Double(tempItem.get("Longitude"))
                    
                    let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(latitude!, longitude!), intensity: 1.0)
                    
                    if(type == "Online"){
                        
                        onlineList.append(coords)
                    }else{
                        list.append(coords)
                    }
                }
                
                heatmapLayer = GMUHeatmapTileLayer()
                heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                                    startPoints: gradientStartPoints as [NSNumber],
                                                    colorMapSize: 256)
//                heatmapLayer.opacity = 1
//                heatmapLayer.radius = 50
                self.heatmapLayer.weightedData = list
                heatmapLayer.map = gMapView
                onlineHeatmapLayer = GMUHeatmapTileLayer()
                onlineHeatmapLayer.gradient = GMUGradient(colors: onlineGradientColors,
                                                          startPoints: onlineGradientStartPoints as [NSNumber],
                                                          colorMapSize: 256)
//                onlineHeatmapLayer.opacity = 1
//                onlineHeatmapLayer.radius = 50
                self.onlineHeatmapLayer.weightedData = onlineList
                onlineHeatmapLayer.map = gMapView
                self.gMapView.setNeedsDisplay()
            }
        }
    }
    
    func updateLocationToPubNub(){
        if(isDriverOnline == true && currentLocation != nil){
            if(lastPublishedLoc != nil){
                
                if(currentLocation!.distance(from: lastPublishedLoc) < PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT){
                    return
                }else{
                    lastPublishedLoc = currentLocation
                }
                
            }else{
                lastPublishedLoc = currentLocation
            }
            
            ConfigPubNub.getInstance().publishMsg(channelName: GeneralFunctions.getLocationUpdateChannel(), content: GeneralFunctions.buildLocationJson(location: currentLocation!))
        }
    }
    
    func goToMyLoc(sender: UITapGestureRecognizer) {
        
        if(currentLocation == nil){
            return
        }
        
        var currentZoomLevel:Float = self.gMapView.camera.zoom
        
        if(currentZoomLevel < Utils.defaultZoomLevel){
            currentZoomLevel = Utils.defaultZoomLevel
        }
        
        let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude), zoomLevel:currentZoomLevel, mapView:self.gMapView)
        
        self.gMapView.animate(to: camera)
    }
    
    func loadAvailableCar(){
        carListDataArrList.removeAll()
        
        let parameters = ["type":"LoadAvailableCars", "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    self.carListDataArrList.removeAll()
                    
                    for i in 0 ..< dataArr.count{
                        self.carListDataArrList += [dataArr[i] as! NSDictionary]
                    }
                    
                    let totalVehicleCount = self.carListDataArrList.count == 0 ? 1 : self.carListDataArrList.count
                    
                    self.selectCarView = self.generalFunc.loadView(nibName: "SelectCarDesign", uv: self, isWithOutSize: true)
                    
                    let defaultHeight:CGFloat = 240
                    
                    let heightOfRow:CGFloat = 50
//                    if(IS_SHOW_VEHICLE_TYPE.uppercased() == "YES"){
//                        heightOfRow = 60
//                    }
                    
                    self.selectCarView.frame.size = CGSize(width: Application.screenSize.width > 370 ? 360 : (Application.screenSize.width - 50), height: ((CGFloat(totalVehicleCount) * heightOfRow) + defaultHeight) > self.contentView.frame.height - 100 ? (self.contentView.frame.height - 120) : ((CGFloat(totalVehicleCount) * heightOfRow) + defaultHeight))
                    
//                    _ = ((self.selectCarView.frame.height / 2) - (self.contentView.frame.height / 2)) >= 0 ? ((self.selectCarView.frame.height / 2) - (self.contentView.frame.height / 2)) : self.contentView.bounds.midY
                    
                    self.selectCarView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY )
                    
                    self.selectCarBGView = UIView()
                    self.selectCarBGView.frame = self.cntView.frame
                    self.cntView.addSubview(self.selectCarBGView)
                    self.cntView.addSubview(self.selectCarView)
                    
                    self.selectCarBGView.alpha = 0
                    self.selectCarView.alpha = 0
    
                    UIView.animate(
                        withDuration: 0.5,
                        delay: 0,
                        options: .curveEaseInOut,
                        animations: {
                            self.selectCarBGView.alpha = 0.4
                            self.selectCarView.alpha = 1
                        }
                    )
                    
//                    GeneralFunctions.setImgTintColor(imgView: self.selectCarHImgView, color: UIColor.UCAColor.AppThemeColor)
                    self.closeCarImgView.setOnClickListener(clickHandler: { (img) in
                        self.removeSelectCarView()
                    })
                    self.selectCarHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CAR_TXT")
                    self.manageVehiclesLbl.text = self.generalFunc.getLanguageLabel(origValue: "Manage", key: "LBL_MANAGE").uppercased()
                    self.manageVehiclesLbl.setClickDelegate(clickDelegate: self)
                    self.manageVehiclesLbl.borderColor = UIColor.UCAColor.AppThemeColor
//                    if (IS_SHOW_VEHICLE_TYPE.uppercased() != "YES"){
                        self.addNewVehicleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_VEHICLES").uppercased()
                        self.addNewVehicleLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                        self.addNewVehicleLbl.setClickDelegate(clickDelegate: self)
//                    }else{
//                        self.addNewVehicleLbl.isHidden = true
//                    }
                    
                    self.selectCarBGView.backgroundColor = UIColor.black
                    self.selectCarBGView.alpha = 0.4
                    self.selectCarView.layer.shadowOpacity = 0.5
                    self.selectCarView.layer.shadowOffset = CGSize(width: 0, height: 3)
                    self.selectCarView.layer.shadowColor = UIColor.black.cgColor
                    self.selectCarView.layer.cornerRadius = 10
                    self.selectCarView.layer.masksToBounds = true
                    self.selectCarTableView.separatorColor = .clear
                    self.selectCarTableView.separatorStyle = .none
                    self.selectCarTableView.dataSource = self
                    self.selectCarTableView.delegate = self
                    self.selectCarTableView.register(CountryListTVCell.self, forCellReuseIdentifier: "SelectCarListTVCell")
                    self.selectCarTableView.register(UINib(nibName: "SelectCarListTVCell", bundle: nil), forCellReuseIdentifier: "SelectCarListTVCell")
                    self.selectCarTableView.tableFooterView = UIView()
                    
                    if #available(iOS 15.0, *) {
                        self.selectCarTableView.sectionHeaderTopPadding = 0
                    } else {}
                    
                    self.selectCarTableView.bounces = false
                    self.selectCarTableView.reloadData()
                    
                    let selectCarBgTapGue = UITapGestureRecognizer()
                    selectCarBgTapGue.addTarget(self, action: #selector(self.removeSelectCarView))
                    self.selectCarBGView.addGestureRecognizer(selectCarBgTapGue)
                    
                }else{
                    
                    let alertMsgLbl = dataDict.get("message")
                    
                    if(alertMsgLbl == "LBL_INACTIVE_CARS_MESSAGE_TXT"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: alertMsgLbl), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT").uppercased() , nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT").uppercased(), completionHandler: { (btnClickedId) in
                            
                            if(btnClickedId == 1){
                                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                self.pushToNavController(uv: contactUsUv)
                            }
                        })
                        return
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: alertMsgLbl))
                    }
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
        })
    }
    
    @objc func removeSelectCarView(){
        self.selectCarBGView.removeFromSuperview()
        self.selectCarView.removeFromSuperview()
    }
    
    func requestChangeCar(selectedDataDict:NSDictionary){
        
        let parameters = ["type":"SetDriverCarID", "iDriverId": GeneralFunctions.getMemberd(), "iDriverVehicleId": selectedDataDict.get("iDriverVehicleId")]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.carNumLbl.text = selectedDataDict.get("vLicencePlate")
                    self.carNameLBl.text = "\(selectedDataDict.get("vMake")) \(selectedDataDict.get("vTitle"))"
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INFO_UPDATED_TXT"), uv: self)
                    
                    if(selectedDataDict.get("Enable_Hailtrip").uppercased() == "YES" && self.isDriverOnline == true){
                        self.hideShowHail(isHide: false)
                    }else{
                        self.hideShowHail(isHide: true)
                    }
                }else{
                    
                    /* Subscription */
                    if((dataDict.get(Utils.message_str) == "PENDING_SUBSCRIPTION" || dataDict.get(Utils.message_str) == "LBL_PENDING_MIXSUBSCRIPTION")){  /* Subscription */
                        
                        if(self.subscriptionBgView.isHidden == true){
                            if(dataDict.get(Utils.message_str) == "PENDING_SUBSCRIPTION"){
                                self.openSubscriptionView(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_REQ_SH_LBL"))
                            }else{
                                self.openSubscriptionView(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PENDING_MIXSUBSCRIPTION"))
                            }
                           
                        }
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                    
                }
                
            }else{
                
                self.generalFunc.setError(uv: self)
            }
            
        })
    }
    
    func startTimerForUpdates(cell: ZonesTableViewCell, vehicleTypes: [String], passengers: [String]) {
        timer?.invalidate()
        if vehicleTypes.isEmpty || passengers.isEmpty {
            timer?.invalidate()
            cell.typeCarLbl.text = "N/A"
            cell.paxLbl.text = "0"
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.currentIndex = (self.currentIndex + 1) % vehicleTypes.count
            cell.typeCarLbl.text = vehicleTypes[self.currentIndex]
            cell.paxLbl.text = passengers[self.currentIndex]
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.zoneOrBidTableView {
            if self.changeCell == "zone"{
                let selectedZone = self.dataArrList[indexPath.row]
                self.selectedZoneData = selectedZone
                self.showModal()
                
            }else{
                let selectedBid = self.bidArrList[indexPath.row]
                bidForRide(iCabId: selectedBid.get("iCabBookingId"),rideType: selectedBid.get("rideType"))
            }
        }else if tableView == self.zoneTableView{
            
        }else{
            let item = self.carListDataArrList[indexPath.item]
            removeSelectCarView()
            
            self.requestChangeCar(selectedDataDict: item)
        }
    }
    
    func showVehicleDetailsAlert(_ message: String) {
        let alert = UIAlertController(title: "Vehicle Details", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.zoneOrBidTableView{
            if self.changeCell == "zone"{
                return self.dataArrList.count
            }else{
              // return 2
                return self.bidArrList.count
            }
            //        }else if tableView == self.zoneTableView{
            //
            //            return self.dataArrList.count
            //        }
        }else if tableView == self.zoneTableView, let selectedZone = selectedZoneData {
//            if let vehicleDetails = selectedZone["vehicle_details"] as? [String] {
//                if vehicleDetails.count == 0 {
//                    modalView.isHidden = true
//                    let alert = UIAlertController(title: "", message: "N/A", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                    return 0
//                }
//                modalView.isHidden = true
//                return vehicleDetails.count
//            }
            let value = selectedZone
            let vehicleTypesString = value.get("vehicle_type") as? String ?? ""

        
            if !vehicleTypesString.isEmpty {
                let cleanedVehicleTypesString = vehicleTypesString
                    .replacingOccurrences(of: "(\n", with: "")
                    .replacingOccurrences(of: "\n)", with: "")
                    .replacingOccurrences(of: "\n", with: "")
                    .replacingOccurrences(of: "(", with: "")
                    .replacingOccurrences(of: ")", with: "")

                self.vehicle_type = cleanedVehicleTypesString
                    .split(separator: ",")
                    .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
            }
            if self.vehicle_type.count == 0 {
                modalView.isHidden = true
                let alert = UIAlertController(title: "", message: "N/A", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return 0
            }
            modalView.isHidden = true
            return self.vehicle_type.count
        }
        return self.carListDataArrList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func drawLineOnLabel(label: UILabel) {
        let shapeLayer = CAShapeLayer()
    
        let lineYPosition = label.frame.origin.y + label.frame.size.height - 5
    
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: lineYPosition))
        path.addLine(to: CGPoint(x: label.frame.size.width, y: lineYPosition))
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
    
        label.layer.addSublayer(shapeLayer)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.zoneOrBidTableView {
            if self.changeCell == "zone"{
                if indexPath.row >= self.dataArrList.count {
                    return UITableViewCell()
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "ZonesTableViewCell", for: indexPath) as! ZonesTableViewCell

                let value = self.dataArrList[indexPath.row]

//                if indexPath.row == 0 {
//                    cell.zoneNameLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                    cell.carsLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                    cell.nowLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                    cell.ucLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                    cell.typeCarLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                    cell.paxLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                } else {
//                    cell.zoneNameLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                    cell.carsLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                    cell.nowLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                    cell.ucLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                    cell.typeCarLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                    cell.paxLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                }
                cell.zoneNameLbl.text = value.get("vZoneName")
                if let cars = value.get("no_of_vehicles") as? String, !cars.isEmpty {
                    cell.carsLbl.text = cars
                } else {
                    cell.carsLbl.text = "0"
                }

                if let now = value.get("no_of_live_booking") as? String, !now.isEmpty {
                    cell.nowLbl.text = now
                } else {
                    cell.nowLbl.text = "0"
                }

                if let ucj = value.get("min_15") as? String, !ucj.isEmpty {
                    cell.ucLbl.text = ucj
                } else {
                    cell.ucLbl.text = "0"
                }

                if let ucj30 = value.get("min_30") as? String, !ucj30.isEmpty {
                    cell.uc30Lbl.text = ucj30
                } else {
                    cell.uc30Lbl.text = "0"
                }

//                let vehicleTypesString = value.get("vehicle_type") as? String ?? ""
//                let passengersString = value.get("no_of_passengers") as? String ?? ""
//
//                var vehicleTypes: [String] = []
//                var passengers: [String] = []
//
//                if !vehicleTypesString.isEmpty {
//            
//                    let cleanedVehicleTypesString = vehicleTypesString
//                        .replacingOccurrences(of: "(\n", with: "")
//                        .replacingOccurrences(of: "\n)", with: "")
//                        .replacingOccurrences(of: "\n", with: "")
//                        .replacingOccurrences(of: "(", with: "")
//                        .replacingOccurrences(of: ")", with: "")
//
//
//                    vehicleTypes = cleanedVehicleTypesString
//                        .split(separator: ",")
//                        .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
//                        .filter { !$0.isEmpty }
//                }
//
//                if !passengersString.isEmpty {
//                   
//                    let cleanedPassengersString = passengersString
//                        .replacingOccurrences(of: "(\n", with: "")
//                        .replacingOccurrences(of: "\n)", with: "")
//                        .replacingOccurrences(of: "\n", with: "")
//                        .replacingOccurrences(of: "(", with: "")
//                        .replacingOccurrences(of: ")", with: "")
//
//    
//                    passengers = cleanedPassengersString
//                        .split(separator: ",")
//                        .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
//                        .filter { !$0.isEmpty }
//                }
//
//                cell.typeCarLbl.text = vehicleTypes.first ?? "N/A"
//                cell.paxLbl.text = passengers.first ?? "0"
//
//                var currentIndex = 0
//                let totalVehicleTypes = vehicleTypes.count
//                let totalPassengers = passengers.count
//
//
//                let maxCount = max(totalVehicleTypes, totalPassengers, 1)
//
//                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
//                    let vehicleType = currentIndex < totalVehicleTypes ? vehicleTypes[currentIndex] : "N/A"
//                    let passengerCount = currentIndex < totalPassengers ? passengers[currentIndex] : "0"
//
//                    cell.typeCarLbl.text = vehicleType
//                    cell.paxLbl.text = passengerCount
//
//                    currentIndex = (currentIndex + 1) % maxCount
//                }


                let vehicleTypesString = value.get("vehicle_type") as? String ?? ""
                let passengersString = value.get("no_of_passengers") as? String ?? ""

                var vehicleTypes: [String] = []
                var passengers: [String] = []

                if !vehicleTypesString.isEmpty {
                    let cleaned = vehicleTypesString
                        .replacingOccurrences(of: "(\n", with: "")
                        .replacingOccurrences(of: "\n)", with: "")
                        .replacingOccurrences(of: "\n", with: "")
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")

                    vehicleTypes = cleaned
                        .split(separator: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                }

                if !passengersString.isEmpty {
                    let cleaned = passengersString
                        .replacingOccurrences(of: "(\n", with: "")
                        .replacingOccurrences(of: "\n)", with: "")
                        .replacingOccurrences(of: "\n", with: "")
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")

                    passengers = cleaned
                        .split(separator: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                }

                let maxCount = max(vehicleTypes.count, passengers.count, 1)
                let displayIndex = currentDisplayIndex % maxCount

                cell.typeCarLbl.text = vehicleTypes[safe: displayIndex] ?? "N/A"
                if let uc45 = value.get("min_45") as? String, !uc45.isEmpty {
                    cell.paxLbl.text = uc45
                } else {
                    cell.paxLbl.text = "0"
                }
//                cell.paxLbl.text = passengers[safe: displayIndex] ?? "0"

                // Force theme application
                cell.applyTheme()
                
                return cell
            }

//            {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ZonesTableViewCell", for: indexPath) as! ZonesTableViewCell
//
//                let value  = self.dataArrList[indexPath.row]
//                if indexPath.row == 0 {
//                    cell.zoneNameLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                    cell.carsLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                    cell.nowLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                    cell.ucLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                    cell.typeCarLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                    cell.paxLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
//                }else{
//                    cell.zoneNameLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                    cell.carsLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                    cell.nowLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                    cell.ucLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                    cell.typeCarLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                    cell.paxLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
//                }
//                cell.zoneNameLbl.text = value.get("vZoneName")
//              //  drawLineOnLabel(label: cell.zoneNameLbl)
//                if let cars = value.get("no_of_vehicles") as? String, !cars.isEmpty {
//                    cell.carsLbl.text = cars
//                } else {
//                    cell.carsLbl.text = "0"
//                }
//                if let now = value.get("no_of_live_booking") as? String, !now.isEmpty {
//                    cell.nowLbl.text = now
//                } else {
//                    cell.nowLbl.text = "0"
//                }
//                if let ucj = value.get("min_15") as? String, !ucj.isEmpty {
//                    cell.ucLbl.text = ucj
//                } else {
//                    cell.ucLbl.text = "0"
//                }
//                if let ucj30 = value.get("min_30") as? String, !ucj30.isEmpty {
//                    cell.uc30Lbl.text = ucj30
//                } else {
//                    cell.uc30Lbl.text = "0"
//                }
//                let vehicleTypesString = value.get("vehicle_type")
//                let passengersString = value.get("no_of_passengers")
//
////                if let vehicleTypes = value.get("vehicle_type") as? [String], !vehicleTypes.isEmpty {
////                    cell.typeCarLbl.text = vehicleTypes.first
////                } else {
////                    cell.typeCarLbl.text = "N/A"
////                }
////
////                if let passengers = value.get("no_of_passengers") as? [String], !passengers.isEmpty {
////                    cell.paxLbl.text = passengers.first
////                } else {
////                    cell.paxLbl.text = "0"
////                }
//                
//                let cleanedVehicleTypesString = vehicleTypesString
//                    .replacingOccurrences(of: "(\n", with: "")
//                    .replacingOccurrences(of: "\n)", with: "")
//                    .replacingOccurrences(of: "\n", with: "")
//
//                let cleanedPassengersString = passengersString
//                    .replacingOccurrences(of: "(\n", with: "")
//                    .replacingOccurrences(of: "\n)", with: "")
//                    .replacingOccurrences(of: "\n", with: "")
//                
//                let vehicleTypes = cleanedVehicleTypesString
//                    .split(separator: ",")
//                    .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
//
//                let passengers = cleanedPassengersString
//                    .split(separator: ",")
//                    .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
//
//                var currentIndex = 0
//                let totalVehicleTypes = vehicleTypes.count
//                let totalPassengers = passengers.count
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    let vehicleType = vehicleTypes[safe: currentIndex] ?? "N/A"
//                    let passengerCount = passengers[safe: currentIndex] ?? "0"
//                    cell.typeCarLbl.text = vehicleType
//                    cell.paxLbl.text = passengerCount
//                    
//                    currentIndex = (currentIndex + 1) % max(totalVehicleTypes, totalPassengers)
//                }
//               // startTimerForUpdates(cell: cell, vehicleTypes: vehicleTypes, passengers: passengers)
//
//                return cell
//            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "BidTableViewCell", for: indexPath) as! BidTableViewCell
                let value = self.bidArrList[indexPath.row]
                cell.timeLbl.text = value.get("dBooking_date")
                cell.zoneLbl.text = value.get("ZoneName")
                cell.vehicleTypeBid.text = value.get("vVehicleType")
                
                // Force theme application
                cell.applyTheme()
                
                return cell
            }
        }else if tableView == self.zoneTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
            let value  = self.dataArrList[indexPath.row]
//            let vehicleDetails = value["vehicle_details"] as? [String] ?? []
//            var vehicleDetailsText = vehicleDetails.joined(separator: ", ")
//            if vehicleDetails.isEmpty {
//                cell.textLabel?.text = "0"
//            }else{
//                cell.textLabel?.text = vehicleDetailsText
//            }
            let vehicleTypesString = value.get("vehicle_type") as? String ?? ""

            var vehicleTypes: [String] = []

            if !vehicleTypesString.isEmpty {
                let cleanedVehicleTypesString = vehicleTypesString
                    .replacingOccurrences(of: "(\n", with: "")
                    .replacingOccurrences(of: "\n)", with: "")
                    .replacingOccurrences(of: "\n", with: "")
                    .replacingOccurrences(of: "(", with: "")
                    .replacingOccurrences(of: ")", with: "")

                vehicleTypes = cleanedVehicleTypesString
                    .split(separator: ",")
                    .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
            }
            if vehicleTypes.isEmpty{
                cell.textLabel?.text = "N/A"
            }else{
                if indexPath.row < vehicleTypes.count {
                        cell.textLabel?.text = vehicleTypes[indexPath.row]
                } else {
                    cell.textLabel?.text = "N/A"
                }
            }

            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCarListTVCell", for: indexPath) as! SelectCarListTVCell
            
            let item = self.carListDataArrList[indexPath.item]
            
            cell.carNameLbl.text = "\(item.get("vMake")) \(item.get("vTitle"))" + " (\(item.get("vLicencePlate")))"
            /*if(item.get("IS_SHOW_VEHICLE_TYPE").uppercased() == "YES"){
             if(item.get("eType").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
             cell.carNameLbl.text = "\(cell.carNameLbl.text!)\n(\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE")))"
             }else if(item.get("eType").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || item.get("eType").uppercased() == "DELIVERY"){
             cell.carNameLbl.text = "\(cell.carNameLbl.text!)\n(\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY")))"
             }else{
             cell.carNameLbl.text = "\(cell.carNameLbl.text!)\n(\(item.get("eType")))"
             }
             }*/
            
            if(item.get("DriverSelectedVehicleId") == item.get("iDriverVehicleId")){
                cell.selectionImgView.image = UIImage(named: "ic_select_true")
                GeneralFunctions.setImgTintColor(imgView: cell.selectionImgView, color: UIColor.UCAColor.AppThemeColor)
            }else{
                cell.selectionImgView.image = UIImage(named: "ic_select_false")
                GeneralFunctions.setImgTintColor(imgView: cell.selectionImgView, color: UIColor(hex: 0xd3d3d3))
            }
            
            //        GeneralFunctions.setImgTintColor(imgView: cell.selectionImgView, color: UIColor.UCAColor.AppThemeColor)
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let item = self.carListDataArrList[indexPath.item]
//        var heightOfRow:CGFloat = 50
        /*if(item.get("IS_SHOW_VEHICLE_TYPE").uppercased() == "YES"){
            heightOfRow = 60
        }*/
        if tableView == self.zoneTapView {
            return 10
        }else if tableView == self.zoneOrBidTableView{
//            //
//            if self.bidArrList.count > 0{
                return UITableView.automaticDimension
//            }else{
////                return 50
              //  return UITableView.automaticDimension
            //}
        }
        return 44
    }
    
    // DRIVER DESTINATION MODE //
    func driverDestinationModeSetup(){
       
        if(userProfileJson.get("ENABLE_DRIVER_DESTINATIONS").uppercased() == "YES" && self.userProfileJson.get("ONLYDELIVERALL") != "Yes" && self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
            self.driverDestinationModeView.layer.addShadow(opacity: 0.9, radius: 2.5, UIColor.gray)
            self.driverDestinationModeView.addSubview(linearBar)

            cancelimgView.setOnClickListener { (instance) in
                self.setDestinationModeTo(isStart: false)
            }
            
            startDestModeBtn.backgroundColor = UIColor.UCAColor.AppThemeColor
            startDestModeBtn.clickDelegate = self
            startDestModeBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_START_DEST_MODE_TXT"))

            if(self.startDestModeBtn.button != nil) {
                /* If set to ButtonTitleEdgeInsets for SlideTripBtn */
                /* If set to ButtonImageEdgeInsets for SlideTripBtn */
                
                if Application.screenSize.width > 360 {
                    self.startDestModeBtn.button!.imageEdgeInsets.left = 20
                    self.startDestModeBtn.button!.imageEdgeInsets.right = 20
                    self.startDestModeBtn.button!.titleEdgeInsets.left = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 45 : 55) : (Configurations.isRTLMode() ? 40 : 60)
                    self.startDestModeBtn.button!.titleEdgeInsets.right = Application.screenSize.width > 320 ? (Configurations.isRTLMode() ? 55 : 45) : (Configurations.isRTLMode() ? 60 : 40)
                }
                
                
                self.startDestModeBtn.button!.titleLabel?.textAlignment  = .center
                self.startDestModeBtn.button!.titleLabel?.lineBreakMode = .byWordWrapping
                self.startDestModeBtn.button!.titleLabel?.numberOfLines = 1
                self.startDestModeBtn.button!.titleLabel?.adjustsFontSizeToFitWidth = true
                self.startDestModeBtn.button!.titleLabel?.minimumScaleFactor = 0.6
                self.startDestModeBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeTxtColor, bgColor: UIColor.UCAColor.AppThemeColor, pulseColor: UIColor.UCAColor.AppThemeColor)
            }
            self.startDestModeBtn.Reset()
            noteLbl.text  =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_NOTE_TXT") + ": "  +  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_START_DESTINATION_TRIP")
            driverDestiImgView.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            driverDestiImgView.setOnClickListener { (instance) in
                
                if(self.DRIVER_DESTINATION_AVAILABLE.uppercased() == "YES"){
                    let launchPlaceFinder = LaunchPlaceFinder(viewControllerUV: self)
                    launchPlaceFinder.currInst = launchPlaceFinder
                    launchPlaceFinder.isForDriverDestinations = true
                    
                    launchPlaceFinder.initializeFinder { (address, latitude, longitude) in
                        
                        self.driverDestinationModeLat = "\(latitude)"
                        self.driverDestinationModeLong = "\(longitude)"
                        self.driverDestinationAddress = address
                        
                        if(self.currentLocation != nil){
                            self.checkRoute()
                        }else{
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
                        }
                        
                    }
                    
                }else{
                    
                    
                    let msg = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DRIVER_DEST_LIMIT_REACHED") + " " + Configurations.convertNumToAppLocal(numStr: String(GeneralFunctions.parseInt(origValue: 0, data: self.userProfileJson.get("MAX_DRIVER_DESTINATIONS")))) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FOR_A_DAY")
                    Utils.showSnakeBar(msg: msg, uv: self)
                }
              
            }
        }
    }
    
    
    
    
    func checkRoute(_ isFromRestart:Bool = false){
    
        let mapDic = MapDictionary.init(p_latitude: "\(self.currentLocation!.coordinate.latitude)", p_longitude: "\(self.currentLocation!.coordinate.longitude)", d_latitude: "\(self.driverDestinationModeLat)", d_longitude: "\(self.driverDestinationModeLong)", max_latitude: "", max_longitude: "", min_latitude: "", min_longitude: "", search_query: "", isPickUpMode: "", session_token:"", toll_skipped:"", place_id:"", waypoints_Str: "", errorLbl: nil, loaderView: nil)
        MapServiceAPI.shared().getDirectionService(mapDictionary: mapDic, isOpenLoader: false, isAlertShow: false, uv: self) { (pointsArray, sourceAddress, endAddress, distance, duration, waypointsArray, serviceName, routesArray) in
            
            if(pointsArray.count == 0){
                if(self.directionFailedDialog != nil){
                    self.directionFailedDialog.disappear()
                    self.directionFailedDialog = nil
                }
                
                self.directionFailedDialog = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ROUTE_NOT_FOUND"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                })
                return
            }
            
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
            
            var latArray = [String]()
            var longArray = [String]()
            for step in pointsArray{
                if(fromWeb == true){
                    latArray.append(step.get("latitude"))
                    longArray.append(step.get("longitude"))
                }else{
                    latArray.append((step ).getObj("end_location").get("lat"))
                    longArray.append((step ).getObj("end_location").get("lng"))
                }
            }
            if(latArray.count == 0 || longArray.count == 0){
                if(self.directionFailedDialog != nil){
                    self.directionFailedDialog.disappear()
                    self.directionFailedDialog = nil
                }
                
                self.directionFailedDialog = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ROUTE_NOT_FOUND"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                })
                
                return
            }else{
                self.driverRoutesLat = latArray.joined(separator: ",")
                self.driverRoutesLong = longArray.joined(separator: ",")
                
                for i in 0..<self.listOfPaths.count{
                    self.listOfPaths[i].map = nil
                }
                self.listOfPaths.removeAll()
                self.listOfPoints.removeAll()
                
                let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
                
                let path = GMSMutablePath()
                for i in 0..<pointsArray.count{
                    let item = pointsArray[i]
                    
                    if(fromWeb == true){
                        
                        path.add(CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("longitude"))))
                        
                    }else{
                        let polyPoints = pointsArray[i].getObj("polyline").get("points")
                        self.listOfPoints += [polyPoints]
                        self.addPolyLineWithEncodedStringInMap(encodedString: polyPoints)
                    }
                    
                }
                if(fromWeb == true){
                    self.addPolyLineWithEncodedStringInMap(encodedString: "", path)
                }
                
                let destMarker = GMSMarker()
                destMarker.position = CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.driverDestinationModeLat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.driverDestinationModeLong))
                destMarker.icon = UIImage.init(named:"ic_pin_dest_selection")
                destMarker.appearAnimation = GMSMarkerAnimation.pop
                destMarker.map = self.gMapView
                
                let pickupMarker = GMSMarker()
                pickupMarker.position = CLLocationCoordinate2D(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude)
                pickupMarker.icon = UIImage.init(named:"ic_pin_source_selection")
                pickupMarker.appearAnimation = GMSMarkerAnimation.pop
                pickupMarker.map = self.gMapView
                
                self.boundMapForDestinationMode()
                
                if(self.fabMenu != nil){
                    self.fabMenu.isHidden = true
                }
                if(isFromRestart == false){
                    self.setDestinationModeTo(isStart: true)
                }
            }
        }
    
    }
    
    func boundMapForDestinationMode(){
        
        if(self.gMapView != nil){
            var bounds = GMSCoordinateBounds()
            bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude))
            bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.driverDestinationModeLat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.driverDestinationModeLong)))
            let edgeInsets = UIEdgeInsets.init(top: self.navigationController?.navigationBar.height ?? 100, left: 20, bottom: 300, right: 20)
            let update = GMSCameraUpdate.fit(bounds, with: edgeInsets)
            self.gMapView.animate(with: update)
        }
    }
    
    func addPolyLineWithEncodedStringInMap(encodedString: String, _ pathFromPoints:GMSMutablePath? = nil) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: encodedString == "" ? pathFromPoints : path)
        polyLine.strokeWidth = 5
        polyLine.strokeColor = UIColor.black
        polyLine.map = self.gMapView
        
        self.listOfPaths += [polyLine]
    }
    
    func setDestinationModeTo(isStart:Bool){
     
        if(isStart == true){
            
            if(self.fabMenu != nil && self.userProfileJson.get("eDestinationMode").uppercased() == "YES"){
                self.fabMenu.isHidden = true
            }
            self.heatMapImgView.isHidden = true
            linearBar.startAnimation()
            hailImgViewHeight.constant = CGFloat(0)
            self.driverDestiImgView.isHidden = true
            self.destAddressLbl.text = self.driverDestinationAddress
            self.destAddressSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DESTINATION") + ": " + Configurations.convertNumToAppLocal(numStr: String(GeneralFunctions.parseInt(origValue: 0, data: self.userProfileJson.get("MAX_DRIVER_DESTINATIONS")) -  GeneralFunctions.parseInt(origValue: 0, data: self.userProfileJson.get("iDestinationCount")))) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMAINIG_TXT").lowercased()
            self.destAddressSHLbl.textColor = UIColor(hex: 0x3252b4)
          
            self.driverDestinationModeView.isHidden = false
            self.topDriverDetailView.isUserInteractionEnabled = false
            self.rightView.isUserInteractionEnabled = false
            self.homeTabBar.navItem.titleView!.isUserInteractionEnabled = false
            
            self.view.layoutIfNeeded()
            self.destModeViewHeight.constant = 310
            self.startDestModeBtn.Reset()
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                
            })
            
        }else{
            
            if(self.fabMenu != nil){
                self.fabMenu.isHidden = false
            }
            if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("ONLYDELIVERALL") == "Yes"){}else{
                self.heatMapImgView.isHidden = false
            }
            linearBar.stopAnimation()
            hailImgViewHeight.constant = CGFloat(65)
            self.driverDestiImgView.isHidden = false
            
            self.gMapView.clear()
            
            self.view.layoutIfNeeded()
            self.destModeViewHeight.constant = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.driverDestinationModeView.isHidden = true
                self.topDriverDetailView.isUserInteractionEnabled = true
                self.rightView.isUserInteractionEnabled = true
                self.homeTabBar.navItem.titleView!.isUserInteractionEnabled = true
            })
        }
    }
    
    func hideDestinationMode(){
        
        self.isDestinationEnabled = false
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("ONLYDELIVERALL") == "Yes"){}else{
            self.heatMapImgView.isHidden = false
        }
        self.gMapView.clear()
       
        self.driverDestiImgView.isHidden = true
        self.view.layoutIfNeeded()
        self.driverDestTopHeight.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.driverDestTopView.isHidden = true
            self.fabMenu.isHidden = false
        })
        
    }
    
    
    func openDriverDestinationTrip(isFromRestartApp:Bool){
        
        if(self.userProfileJson.get("eDestinationMode").uppercased() == "YES"){
            
            if(self.fabMenu != nil){
                self.fabMenu.isHidden = true
            }
            self.heatMapImgView.isHidden = true
            linearBar.stopAnimation()
            hailImgViewHeight.constant = CGFloat(0)
            self.driverDestiImgView.isHidden = true
            self.driverDestTopView.isHidden = false
            self.view.layoutIfNeeded()
            self.driverDestTopHeight.constant = 100
            self.destModeViewHeight.constant = 0

            
            GeneralFunctions.setImgTintColor(imgView: self.driverDestTopCloseView, color: UIColor.white)
            
            if(isFromRestartApp == true){
              
                self.driverDestinationModeLat = self.userProfileJson.getObj("DriverDestinationData").get("tDestinationStartedLatitude")
                self.driverDestinationModeLong = self.userProfileJson.getObj("DriverDestinationData").get("tDestinationStartedLongitude")
                self.driverDestinationAddress = self.userProfileJson.getObj("DriverDestinationData").get("tDestinationStartedAddress")
                
                if(self.currentLocation != nil){
                    self.checkRoute(true)
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
                }
            }
            
            self.destAddressTopLbl.text = self.userProfileJson.getObj("DriverDestinationData").get("tDestinationStartedAddress")
            self.destModeOnTopLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DESTINATION_MODE_ON_TXT")
            self.destModeOnTopLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            self.destModeOnTopLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
    
           
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.topDriverDetailView.isUserInteractionEnabled = true
                self.rightView.isUserInteractionEnabled = true
                self.homeTabBar.navItem.titleView!.isUserInteractionEnabled = true
                self.driverDestinationModeView.isHidden = true
                self.driverDestTopCloseView.setOnClickListener { (instance) in
                   
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_DESTINATION_TRIP"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_YES_TXT").uppercased(), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO").uppercased(), completionHandler: { (btnClickedId) in
                 
                        if(btnClickedId == 0){
                            
                            self.endDriverDestination()
                        }
                    })
                 
                }
            })
        }else{
            
            if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("ONLYDELIVERALL") == "Yes"){}else{
                self.heatMapImgView.isHidden = false
            }
            if(self.driverDestiImgView != nil){
                self.driverDestiImgView.isHidden = false
            }
            
        }
    }
    
    func endDriverDestination(){
        let parameters = ["type":"CancelDriverDestination","iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                   
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    self.DRIVER_DESTINATION_AVAILABLE = self.userProfileJson.get("DRIVER_DESTINATION_AVAILABLE").uppercased()
                    
                    if(self.driverDestiImgView != nil){
                        self.hideDestinationMode()
                    }
                    
                    
                    // DRIVER DESTINATION MODE //
                    if(self.isDriverOnline == true){
                        self.hailImgViewHeight.constant = CGFloat(65)
                        self.driverDestiImgView.isHidden = false
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func startDriverDestination(){
        
        let parameters = ["type":"startDriverDestination","iDriverId": GeneralFunctions.getMemberd(), "tRootDestLatitudes": self.driverRoutesLat, "tRootDestLongitudes": self.driverRoutesLong, "tAdress": self.driverDestinationAddress, "eStatus": "Active", "tDriverDestLatitude": self.driverDestinationModeLat, "tDriverDestLongitude": self.driverDestinationModeLong]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    self.DRIVER_DESTINATION_AVAILABLE = self.userProfileJson.get("DRIVER_DESTINATION_AVAILABLE").uppercased()


                    self.openDriverDestinationTrip(isFromRestartApp:false)
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: dataDict.get("message"))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func myBtnTapped(sender: MyButton) {
        if(self.editWorkLocBtn != nil && sender == self.editWorkLocBtn){
        }else if(self.startDestModeBtn == sender){
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_START_DESTINATION_TRIP"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_YES_TXT").uppercased(), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO").uppercased(), completionHandler: { (btnClickedId) in
                
                if(btnClickedId == 0){
                    
                    self.startDriverDestination()
                }
            })
          
        }else if(self.subscriptionDoneBtn == sender){
            
            self.closeSubscriptionAlertView()
            let subscriptionUV = GeneralFunctions.instantiateViewController(pageName: "SubscriptionUV") as! SubscriptionUV
            self.pushToNavController(uv: subscriptionUV)
            
        }else if(self.subscriptionCancelBtn == sender){
            self.closeSubscriptionAlertView()
        }
    }

    func myBtnSlided(sender: MySliderButton) {
        if self.startDestModeBtn == sender {
            
             self.startDriverDestination()
        }
    }
    
    @IBAction func unwindToMainScreen(_ segue:UIStoryboardSegue) {
        
        if(segue.source.isKind(of: AddDestinationUV.self))
        {
            let addDestinationUv = segue.source as! AddDestinationUV
            self.driverDestinationModeLat = "\(addDestinationUv.selectedLocation.coordinate.latitude)"
            self.driverDestinationModeLong = "\(addDestinationUv.selectedLocation.coordinate.longitude)"
            self.driverDestinationAddress = addDestinationUv.selectedAddress
            
            if(self.currentLocation != nil){
                self.checkRoute()
            }else{
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
            }
            
        }else if(segue.source.isKind(of: HelpNoteForRideUV.self)){ /* Help note changes for Ride*/
            self.onOffSwitch.dotColor = UIColor(hex: 0x009900)
            self.updateOnlineStatus(isAlertShown: true, true)
        }
    }
     func openBooking()  {
     if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
         
         if(userProfileJson.get("ONLYDELIVERALL") == "Yes"){
             let orderUV = GeneralFunctions.instantiateViewController(pageName: "BookingsUV") as! BookingsUV
             orderUV.PAGE_TYPE = "ORDER"
             orderUV.homeTabBar = self.homeTabBar
             orderUV.isFromViewProfile = true
             orderUV.navItem = self.navigationItem
             self.pushToNavController(uv: orderUV)
             
         }else{
             let bookingTabUV = GeneralFunctions.instantiateViewController(pageName: "BookingTabUV") as! BookingTabUV
             bookingTabUV.isFromViewProfile = true
             self.pushToNavController(uv: bookingTabUV)
         }
     }else{
         let bookingUV = GeneralFunctions.instantiateViewController(pageName: "BookingsUV") as! BookingsUV
         bookingUV.PAGE_TYPE = "BOOKING"
         bookingUV.homeTabBar = self.homeTabBar
         bookingUV.isFromViewProfile = true
         bookingUV.vSubFilterParam = self.passType
         bookingUV.navItem = self.navigationItem
         self.pushToNavController(uv: bookingUV)
     
     }
 }
    
}




open class LinearProgressBar: UIView {
    
    //FOR DATA
    fileprivate var screenSize: CGRect = UIScreen.main.bounds
    fileprivate var isAnimationRunning = false
    
    //FOR DESIGN
    fileprivate var progressBarIndicator: UIView!
    
    //PUBLIC VARS
    open var backgroundProgressBarColor: UIColor = UIColor.clear
    open var progressBarColor: UIColor = UIColor.black//UIColor.UCAColor.AppThemeColor//UIColor(hex: 0x3252b4)
    open var heightForLinearBar: CGFloat = 3
    open var widthForLinearBar: CGFloat = 0
    
    public init () {
        super.init(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: screenSize.width, height: 0)))
        self.progressBarIndicator = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 0, height: heightForLinearBar)))
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.progressBarIndicator = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 0, height: heightForLinearBar)))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LIFE OF VIEW
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.screenSize = UIScreen.main.bounds
        
        if widthForLinearBar == 0 || widthForLinearBar == self.screenSize.height {
            widthForLinearBar = self.screenSize.width
        }
        
        self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x,y :self.frame.origin.y), size: CGSize(width: widthForLinearBar, height: self.frame.height))
    }
    
    //MARK: PUBLIC FUNCTIONS    ------------------------------------------------------------------------------------------
    
    //Start the animation
    open func startAnimation(){
        
        self.configureColors()
        
        self.show()
        
        if !isAnimationRunning {
            self.isAnimationRunning = true
            
            UIView.animate(withDuration: 0.5, delay:0, options: [], animations: {
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: self.heightForLinearBar)
            }, completion: { animationFinished in
                self.addSubview(self.progressBarIndicator)
                self.configureAnimation()
            })
        }
    }
    
    //Start the animation
    open func stopAnimation() {
        
        self.isAnimationRunning = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar, height: 0)
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: 0)
        })
    }
    
    //MARK: PRIVATE FUNCTIONS    ------------------------------------------------------------------------------------------
    
    fileprivate func show() {
        
        // Only show once
        if self.superview != nil {
            return
        }
        
        // Find current top viewcontroller
        if let topController = getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(self)
        }
    }
    
    fileprivate func configureColors(){
        
        self.backgroundColor = self.backgroundProgressBarColor
        self.progressBarIndicator.backgroundColor = self.progressBarColor
        self.layoutIfNeeded()
    }
    
    fileprivate func configureAnimation() {
        
        guard let superview = self.superview else {
            stopAnimation()
            return
        }
        
        self.progressBarIndicator.frame = CGRect(origin: CGPoint(x: 0, y :0), size: CGSize(width: 0, height: heightForLinearBar))
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar*0.7, height: self.heightForLinearBar)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: superview.frame.width, y: 0, width: 0, height: self.heightForLinearBar)
                
            })
            
        }) { (completed) in
            if (self.isAnimationRunning){
                self.configureAnimation()
            }
        }
    }
    
    // -----------------------------------------------------
    //MARK: UTILS    ---------------------------------------
    // -----------------------------------------------------
    
    fileprivate func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}




extension Notification.Name {
    static let appDidEnterBackground = Notification.Name("appDidEnterBackground")
    static let appWillEnterForeground = Notification.Name("appWillEnterForeground")
    static let appDidBecomeActive = Notification.Name("appDidBecomeActive")
}


extension Array {
    subscript(safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}
