//
//  CabRequestedUV.swift
//  DriverApp
//
//  Created by ADMIN on 25/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import GoogleMaps
import AudioToolbox
import AVFoundation
import CoreLocation

class CabRequestedUV: UIViewController, OnLocationUpdateDelegate,UIGestureRecognizerDelegate, OnTaskRunCalledDelegate, OnDirectionUpdateDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var pickUpAddContainerView: UIView!
    @IBOutlet weak var pickUpHLbl: MyLabel!
    @IBOutlet weak var pickUpVLbl: MyLabel!
    @IBOutlet weak var pickUpHImgView: UIImageView!
    @IBOutlet weak var progressCntainerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var progressCntainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var gMapContainer: UIView!
//    @IBOutlet weak var dialPView: UIView!
    @IBOutlet weak var dialThemeView: UIView!
    @IBOutlet weak var mcDialView: CircleProgressView!
    @IBOutlet weak var destHLbl: MyLabel!
    @IBOutlet weak var destVLbl: MyLabel!
    @IBOutlet weak var destAddrContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var destAddContainerView: UIView!
    @IBOutlet weak var userRatingBar: RatingView!
    @IBOutlet weak var userNameLbl: MyLabel!
    @IBOutlet weak var timerLbl: MyLabel!
    @IBOutlet weak var requestTypeLbl: MyLabel!
    @IBOutlet weak var pickUpAddTopMargin: NSLayoutConstraint!
    @IBOutlet weak var deliveryPackageView: UIView!
    @IBOutlet weak var packageInfoLbl: MyLabel!
    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var destHImgView: UIImageView!
    @IBOutlet weak var viewDeliveryDetailLbl: MyLabel!
    @IBOutlet weak var requestBottomSepView: UIView!
    
    
    @IBOutlet weak var viewUserNote: MyLabel!
    @IBOutlet weak var jobRefLblHeight: NSLayoutConstraint!
    @IBOutlet weak var jobRefView: UIView!
    @IBOutlet weak var jobTypeLbl: MyLabel!
    @IBOutlet weak var jobRefHLbl: MyLabel!
    @IBOutlet weak var jobRefVLbl: MyLabel!
    @IBOutlet weak var jobRefViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rentalPackageNameLbl: MyLabel!
    
    @IBOutlet weak var bottomScrollIndView: UIView!
    @IBOutlet weak var declineRequestLbl: MyLabel!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var acceptViewImgView: UIImageView!
    @IBOutlet weak var acceptViewLbl: MyLabel!
    @IBOutlet weak var progressViewY: NSLayoutConstraint!
    @IBOutlet weak var halfProgressViewY: NSLayoutConstraint!
    
    @IBOutlet weak var bottomClickView: UIView!
    @IBOutlet weak var halfProgressThemeView: SemiCirleView!
    @IBOutlet weak var halfProgressCntView: UIView!
    @IBOutlet weak var halfProgressView: MKMagneticProgress!
    var bottomAddressView:UIView!
    var gestureRecognizer = UIPanGestureRecognizer()
    var sDragViewDefaultY:CGFloat = 0.0
    
    var dragForRequest:SDragViewForRequest!
    
    var pickUpCustomMarker:GMSMarker!
    var dropOffCustomMarker:GMSMarker!
    var pickUpPinMarker:GMSMarker!
    var dropOffPinMarker:GMSMarker!
    var arcPinMarker:GMSMarker!
    var polylineForPool:GMSPolyline!
    var poolpath = GMSPath()
    var animatePolylineForPool = false
    var animTask:UpdateFreqTask!
    var animationPathOrig = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i_anim:Int = 0
    var animationPolylineOrig = GMSPolyline()
    var animationPolyline = GMSPolyline()
    
    
    @IBOutlet weak var googleMapContainerView: UIView!
    // Multidelivery Outlets
    @IBOutlet weak var deliveryPackageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    
    @IBOutlet weak var packageInfoLblXPosition: NSLayoutConstraint!
    
    var generalFunc = GeneralFunctions()
    
    let passengerMarker : GMSMarker = GMSMarker()
    
    var passengerJsonDetail_dict:NSDictionary?
    var setBottomViewY:CGFloat = 465
    
    var isOnForground = true
//    var startTime:TimeInterval!
    
    var timer:Timer!
    
    var initializedMiliSeconds:Int64!
    
    var progressTapGue = UITapGestureRecognizer()
    
    var currentSecond = UInt8(0)
    
    var REQUEST_TYPE = ""
    
    var isPageLoaded = false
    
//    var mcDialView:CircleProgressView!
    
    var gMapView:GMSMapView!
    
    var cntView:UIView!
    
    var isScreenKilled = false
    
    var PAGE_HEIGHT:CGFloat = 690
    var PAGE_HEIGHT_OFFSET:CGFloat = 50
    var initializedSeconds:Int64 = 30
    
    var isAddressLoaded = false
    
    var RIDER_REQUEST_ACCEPT_TIME = 30
    
    var isCancelReqFired = false
    
    var isSafeAreaSet = false
    
    var currentLocation:CLLocation?
    
    var audioPlayer:AVAudioPlayer?
    var isNotificationSoundKilled = false
    
    var DRIVER_ARRIVED_MIN_TIME_PER_MINUTE:Double = 3
    var userProfileJson:NSDictionary!
    
    var animLocationArr = [CLLocationCoordinate2D]()
    var animLocArrParts:[[CLLocationCoordinate2D]]!
    
    var etaTime = "--"
    var etaDistance = "--"
    
    var updateDirections:UpdateDirections!
    
    var tSourceAddress = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
//        UIView.animate(withDuration: 0.50, delay: 0.0, options:[], animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        }, completion: nil)
        
        self.configureRTLView()
        
        isOnForground = true
        
        if(isScreenKilled == true){
            self.closePassengerRequest()
        }
        
//        self.navigationController?.navigationBar.tintColor = UIColor(hex: 0x33b4ff)
//        self.navigationController?.navigationBar.barTintColor = UIColor(hex: 0x33b4ff)
        
        self.setnavBarTintColor(color: UIColor(hex: 0x15ADDE))
        
        if(audioPlayer != nil){

            audioPlayer!.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
     
        isOnForground = false
        
        self.navigationController?.navigationBar.tintColor = UIColor.UCAColor.AppThemeColor
        self.navigationController?.navigationBar.barTintColor = UIColor.UCAColor.AppThemeColor
        
        if(audioPlayer != nil){
            audioPlayer!.pause()
        }
        
//        UIView.animate(withDuration: 0.1, delay: 0.0, options:[], animations: {
//            self.view.backgroundColor = UIColor.clear
//        }, completion: nil)
    }
    
    deinit {
        
        releaseAllTask()
        
    }
    
    @objc func releaseAllTask(){
        
        progressTapGue.removeTarget(self, action: nil)
        
        if(self.timer != nil){
            self.timer.invalidate()
        }
        
        if(gMapView != nil){
            gMapView.clear()
            gMapView.removeFromSuperview()
            gMapView = nil
        }
        
        if(updateDirections != nil){
            updateDirections.releaseTask()
            updateDirections.onDirectionUpdateDelegate = nil
            updateDirections = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        GeneralFunctions.saveValue(key: Utils.DRIVER_CURRENT_REQ_OPEN_KEY, value: "true" as AnyObject)
         self.updateStatus(status: "Open")
        
        cntView = self.generalFunc.loadView(nibName: "CabRequestedScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        scrollView.backgroundColor = UIColor.clear
        
        let navHeight = self.navigationController!.navigationBar.frame.height
        let width = ((navHeight * 350) / 119)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: ((width * 119) / 350)))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "ic_your_logo")
        imageView.image = image
        
        self.navigationItem.titleView = imageView
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(hex: 0x33b4ff)
        
//        let acceptBtn = UIBarButtonItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPT_TXT"), style: .plain, target: self, action: #selector(self.acceptTapped))
//        self.navigationItem.rightBarButtonItem = acceptBtn
//
//        let declineBtn = UIBarButtonItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DECLINE_TXT"), style: .plain, target: self, action: #selector(self.declineTapped))
//        self.navigationItem.leftBarButtonItem = declineBtn
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightButton
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftButton
        
        
        self.viewDetailsBtn.isUserInteractionEnabled = true
        self.viewDetailsBtn.setTitle(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_DETAILS").uppercased(), for: UIControl.State.normal)
        
        self.bgImgView.image = UIImage(named: "ic_bg_request")
    
        
        switch UIDevice().type {
        case .iPhone4:
            self.bgImgView.image = UIImage(named: "ic_bg_request@640")
        case .iPhone4S:
            self.bgImgView.image = UIImage(named: "ic_bg_request@640")
        case .iPhone5:
            self.bgImgView.image = UIImage(named: "ic_bg_request@640")
        case .iPhone5S:
            self.bgImgView.image = UIImage(named: "ic_bg_request@640")
        case .iPhone6:
            self.bgImgView.image = UIImage(named: "ic_bg_request@750")
        case .iPhone6plus:
            self.bgImgView.image = UIImage(named: "ic_bg_request@1242")
        case .iPhone6S:
            self.bgImgView.image = UIImage(named: "ic_bg_request@750")
        case .iPhone6Splus:
            self.bgImgView.image = UIImage(named: "ic_bg_request@1242")
        case .iPhone7:
            self.bgImgView.image = UIImage(named: "ic_bg_request@750")
        case .iPhone7plus:
            self.bgImgView.image = UIImage(named: "ic_bg_request@1242")
        case .iPhoneSE:
            self.bgImgView.image = UIImage(named: "ic_bg_request@640")
        default:
            print("default")
        }
        
        RIDER_REQUEST_ACCEPT_TIME = GeneralFunctions.getValue(key: Utils.RIDER_REQUEST_ACCEPT_TIME_KEY) == nil ? 30 : GeneralFunctions.parseInt(origValue: 30, data: (GeneralFunctions.getValue(key: Utils.RIDER_REQUEST_ACCEPT_TIME_KEY) as! String))
        
        initializedSeconds = Int64(RIDER_REQUEST_ACCEPT_TIME)
      
        Utils.createRoundedView(view: self.dialThemeView, borderColor: UIColor.clear, borderWidth: 0)
        self.dialThemeView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.mcDialView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.progressContainerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.mcDialView.trackBackgroundColor = UIColor.UCAColor.AppThemeColor
        self.mcDialView.trackFillColor = UIColor.UCAColor.AppThemeTxtColor //UIColor(hex: 0x86d859)
        mcDialView.roundedCap = true
        
        self.jobRefViewHeight.constant = 0
        
        self.halfProgressView.backgroundShapeColor = UIColor.UCAColor.AppThemeColor
        self.halfProgressView.progressShapeColor = UIColor.UCAColor.AppThemeTxtColor //UIColor(hex: 0x86d859)
        self.halfProgressView.spaceDegree = 95
        self.halfProgressView.font = UIFont.init(name: Fonts().semibold, size: 17)!
        self.halfProgressView.percentColor = UIColor.UCAColor.AppThemeTxtColor
        self.halfProgressCntView.backgroundColor = UIColor.clear
        
       
       // self.halfProgressThemeView.backgroundColor = UIColor.UCAColor.AppThemeColor
       // self.halfProgressThemeView.roundCorners([.topLeft, .topRight], radius: 150)
        
        
//        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
//        let APP_TYPE = userProfileJson.get("APP_TYPE")
        
        
        self.jobRefView.isHidden = true
        
        
        
        if(GeneralFunctions.getValue(key: Utils.DIAL_NOTIFICATION) as! String != ""){
            
            playSound(soundName: GeneralFunctions.getValue(key: Utils.DIAL_NOTIFICATION) as! String)
            NotificationCenter.default.addObserver(self, selector: #selector(self.appGoesIntoBG), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.appInForGround), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
        self.bottomClickView.isHidden = true
        
        self.setnavBarTintColor(color: UIColor(hex: 0x15ADDE))
    }
    

    
    override func viewDidLayoutSubviews() {
      //  if(isSafeAreaSet == false){
       //     self.bottomAreaHeight.constant = self.bottomAreaHeight.constant + GeneralFunctions.getSafeAreaInsets().bottom
        //    if(Configurations.isIponeXDevice()){
          //      self.bottomAreaHeight.constant = self.bottomAreaHeight.constant - 15
          //  }
           // isSafeAreaSet = true
      //  }
    }
    
    @objc func appGoesIntoBG()
    {
        Utils.printLog(msgData: "Background")
        if(audioPlayer != nil){
//            audioPlayer!.pause()
            audioPlayer!.play()
        }
    }
    
    @objc func appInForGround(){
        Utils.printLog(msgData: "Forground")
        if(audioPlayer != nil && isNotificationSoundKilled == false){
            audioPlayer!.play()
        }
    }
    
    func playSound(soundName: String)
    {
        if(soundName != ""){
            let word = soundName.components(separatedBy: ".")
            
            let coinSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: word[0], ofType: word[1])!)
           
            
            do{
                //            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                //            try AVAudioSession.sharedInstance().setActive(true)
                
                if #available(iOS 10.0, *) {
    //                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
                    try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
                }
                else {
                    AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
                }
                
                Utils.printLog(msgData: "AVAudioSession Category Playback OK")
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    Utils.printLog(msgData: "AVAudioSession is Active")
                } catch {
                    print(error)
                }
                
                audioPlayer = try AVAudioPlayer(contentsOf:coinSound as URL)
                audioPlayer!.volume = AVAudioSession.sharedInstance().outputVolume
                audioPlayer!.numberOfLoops = 120
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
                
                
            }catch {
                Utils.printLog(msgData: "Error getting the audio file")
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoaded == false){
            
            contentView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
          //  self.scrollView.bounces = false
            //            self.scrollView.setContentViewSize(offset: 15, currentMaxHeight: self.scrollViewCOntentViewHeight.constant)
           // self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            let latitude = GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLatitude"))
            let longitude = GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLongitude"))
            
            gMapContainer.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
            let camera = GeneralFunctions.getCameraPosition(location:CLLocation(latitude: latitude, longitude: longitude), zoomLevel:Utils.defaultZoomLevel, mapView:self.gMapView)
            gMapView = GMSMapView.map(withFrame: self.gMapContainer.frame, camera: camera)
            if(GeneralFunctions.getDayNightForToday().uppercased() == "NIGHT"){
                self.gMapView.nightMapStyle()
            }else{
                self.gMapView.mapStyle = nil
            }
            gMapView.center = CGPoint(x: gMapContainer.bounds.midX, y: gMapContainer.bounds.midY)
            //        googleMapContainerView = gMapView
            //        gMapView = GMSMapView()
            gMapView.isMyLocationEnabled = false
            
//            passengerMarker.position = CLLocationCoordinate2DMake(latitude, longitude)
//            if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"){
//                passengerMarker.icon = UIImage(named: "ic_sender")
//            }else if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX){
//                passengerMarker.icon = UIImage(named: "ic_user")
//            }else{
//                passengerMarker.icon = UIImage(named: "ic_passenger")
//            }
//            passengerMarker.map = self.gMapView
//            passengerMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)

            self.gMapContainer.addSubview(gMapView)
          
            let getLocation = GetLocation(uv: self, isContinuous: true)
            getLocation.buildLocManager(locationUpdateDelegate: self)
            
            isPageLoaded = true
            
            self.setBottomDragView()
            
            if(updateDirections != nil){
                updateDirections.startDirectionUpdate()
            }

            setData()
            addBackgroundObserver()
            self.bottomClickView.isHidden = false
        }
        
    }
    
    func addBackgroundObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
    }
    
    @objc func appInBackground(){
        if(updateDirections != nil){
            updateDirections.pauseDirectionUpdate()
        }
    }
    
    @objc func appInForground(){
        if(updateDirections != nil){
            updateDirections.startDirectionUpdate()
        }
    }
    
    func onLocationUpdate(location: CLLocation) {
        self.currentLocation = location
    }
    
    @IBAction func viewMultiDetailsBtnAction(_ sender: UIButton) {
        
        
    }
   
    func setData(){
        
        self.viewDeliveryDetailLbl.borderWidth = 1
        self.viewDeliveryDetailLbl.borderColor = UIColor.UCAColor.AppThemeColor
        self.viewDeliveryDetailLbl.cornerRadius = 6
        
        
        self.dottedView.addDashedLine(color: UIColor.lightGray, lineWidth: 2)
        GeneralFunctions.setImgTintColor(imgView: pickUpHImgView, color: UIColor.UCAColor.AppThemeColor)
        if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"){
            self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST")
            
            self.requestTypeLbl.isHidden = false
            self.deliveryPackageView.isHidden = false
            self.packageInfoLbl.text = self.passengerJsonDetail_dict!.get("PACKAGE_TYPE").trim()
            //            self.packageInfoLbl.fitText()
            PAGE_HEIGHT = PAGE_HEIGHT - PAGE_HEIGHT_OFFSET
            
            if(Configurations.isRTLMode()){
                self.packageInfoLblXPosition.constant = -40
            }else{
                self.packageInfoLblXPosition.constant = 40
            }
            
            if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"){
                self.viewDeliveryDetailLbl.isHidden = false
                self.hideShowDestView(isHide: true)
                
                self.viewDeliveryDetailLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_DELIVERY_DETAILS").uppercased()
                self.viewDeliveryDetailLbl.setOnClickListener { (instance) in
                    if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"){
                        let viewMultiDeliveryDetailsUV = GeneralFunctions.instantiateViewController(pageName: "ViewMultiDeliveryDetailsUV") as! ViewMultiDeliveryDetailsUV
                        viewMultiDeliveryDetailsUV.cabBookingReqId = self.passengerJsonDetail_dict!.get("iCabRequestId")
                        viewMultiDeliveryDetailsUV.isFromCabRequest = true
                        self.navigationController?.pushViewController(viewMultiDeliveryDetailsUV, animated: true)
                    }
                }
            }
            
        }else if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_Ride){
            if(self.passengerJsonDetail_dict!.get("eFly") == "Yes"){
                self.hideShowDestView(isHide: true)
                self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_REQUEST")
            }else{
                self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST")
            }
    
            
            if (self.passengerJsonDetail_dict!.get("ePoolRequest").uppercased() == "YES"){
                
                self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_POOL_REQUEST") + " (" + Configurations.convertNumToAppLocal(numStr: self.passengerJsonDetail_dict!.get("iPersonSize")) + " " +  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSON") + ")"
            }
            
            self.requestTypeLbl.isHidden = false
            self.deliveryPackageView.isHidden = true
            
            PAGE_HEIGHT = PAGE_HEIGHT - 80 - PAGE_HEIGHT_OFFSET
            
        }else if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX){
           
            self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_JOB_TXT") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST")
            
            //            self.jobTypeLbl.text = self.passengerJsonDetail_dict!.get("SelectedTypeName")
            self.jobTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "Loading service type", key: "LBL_LOAD_SERVICE_TYPE")
            
            self.jobTypeLbl.fitText()
            
            
        }
        
        timerLbl.text = "00:00"
        timerLbl.text = Configurations.convertNumToAppLocal(numStr: timerLbl.text!)
        
        timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
//        startTime = Date.timeIntervalSinceReferenceDate
        if(initializedMiliSeconds != nil && (Utils.currentTimeMillis() - initializedMiliSeconds!) < (RIDER_REQUEST_ACCEPT_TIME * 1000)){
            
//            currentSecond = UInt8((Utils.currentTimeMillis() - initializedMiliSeconds!)/1000)
//            startTime = TimeInterval((Utils.currentTimeMillis() - initializedMiliSeconds!) / 1000)

            initializedSeconds = initializedSeconds - ((Utils.currentTimeMillis() - initializedMiliSeconds!)/1000)
        }else if(initializedMiliSeconds != nil && (Utils.currentTimeMillis() - initializedMiliSeconds!) > ((RIDER_REQUEST_ACCEPT_TIME - 1) * 1000)){
//            startTime = Date.timeIntervalSinceReferenceDate
            
            self.mcDialView.progress  = 0
            
            self.updateStatus(status: "Timeout")
            self.isScreenKilled = true
            self.closePassengerRequest()
        }
        
        timer.fire()
        
        Utils.createRoundedView(view: progressContainerView, borderColor: Color.clear, borderWidth: 0)
        
        userNameLbl.text = self.passengerJsonDetail_dict!.get("PName")
        
        if(Configurations.isRTLMode()){
            userNameLbl.textAlignment = .right
        }
        
        if(self.passengerJsonDetail_dict!.get("GenieOrder").uppercased() != "YES"){
            self.userRatingBar.rating = self.passengerJsonDetail_dict!.get("PRating") == "" ? 0 : Float(self.passengerJsonDetail_dict!.get("PRating"))!
        }else{
            self.userRatingBar.isHidden = true
        }
        
        
        let destLatitude = self.passengerJsonDetail_dict!.get("destLatitude")
        let destLongitude = self.passengerJsonDetail_dict!.get("destLongitude")
        let sourceLatitude = self.passengerJsonDetail_dict!.get("sourceLatitude")
        let sourceLongitude = self.passengerJsonDetail_dict!.get("sourceLongitude")
        
        self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pick Up Address", key: "LBL_PICK_UP_ADDRESS").uppercased()
        self.pickUpVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOAD_ADDRESS")
        
        
        self.jobRefHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Special Instruction", key: "LBL_SPECIAL_INSTRUCTION_TXT")
        self.jobRefHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.jobRefVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOADING_TXT")
        
        if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"){
            self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Sender location", key: "LBL_SENDER_LOCATION").uppercased()
            self.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Receiver's Location", key: "LBL_RECEIVER_LOCATION").uppercased()
            

        }else if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_Ride){
            self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pickup Location", key: "LBL_PICKUP_LOCATION_TXT").uppercased()
            self.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Destination Address", key: "LBL_DEST_ADD_TXT").uppercased()
            
        }else if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX){
            self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Job Location", key: "LBL_JOB_LOCATION_TXT").uppercased()
            self.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Job Location", key: "LBL_JOB_LOCATION_TXT").uppercased()
        }else if(self.passengerJsonDetail_dict!.get("eSystem").uppercased() == "DELIVERALL"){
            
            self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST")
          
            
            self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOCATION_FOR_FRONT").uppercased()
            self.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_LOCATION_TXT").uppercased()
            
        }
//        else{
//            self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pick Up Address", key: "LBL_PICK_UP_ADDRESS").uppercased()
//            self.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ADD_TXT").uppercased()
//        }
        
        if(destLatitude == "" || destLongitude == ""){
            
            self.hideShowDestView(isHide: true)
            checkAddressForLocation(sourceLatitude: sourceLatitude, sourceLongitude: sourceLongitude, destLatitude: "", destLongitude: "")
        }else{
            self.destVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOAD_ADDRESS")
            checkAddressForLocation(sourceLatitude: sourceLatitude, sourceLongitude: sourceLongitude, destLatitude: destLatitude, destLongitude: destLongitude)
        }
//        checkAddressForLocation(sourceLatitude, sourceLongitude: sourceLongitude, destLatitude: destLatitude_str, destLongitude: destLongitude_str)
    }
    
    func hideShowDestView(isHide:Bool){
        if(isHide == true){
            self.dottedView.isHidden = true
            self.destAddContainerView.isHidden = true
            self.destHImgView.isHidden = true
        }else{
            self.dottedView.isHidden = false
            self.destAddContainerView.isHidden = false
            self.destHImgView.isHidden = false
        }
        
    }
    
    @objc func acceptTapped(){
        //appState = ""
//        if(isAddressLoaded == false){
//            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please wait for address to be loaded.", key: "LBL_WAIT_FOR_ADDRESS"))
//            return
//        }
        
        if(timer != nil){
            timer.invalidate()
        }
        
        if(self.currentLocation == nil){
            self.currentLocation = CLLocation.init(latitude: 0.0, longitude: 0.0)
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        var parameters = [String:String]()
        
        if(self.passengerJsonDetail_dict!.get("eSystem").uppercased() == "DELIVERALL"){
            parameters = ["type":"GenerateTrip","iDriverId": GeneralFunctions.getMemberd(), "iOrderId":self.passengerJsonDetail_dict!.get("iOrderId"), "tSourceLat": self.passengerJsonDetail_dict!.get("sourceLatitude"), "tSourceLong": self.passengerJsonDetail_dict!.get("sourceLongitude"), "tSourceAddress": self.destVLbl.text!, "tDestLatitude": self.passengerJsonDetail_dict!.get("destLatitude"), "tDestLongitude": self.passengerJsonDetail_dict!.get("destLongitude"), "tDestAddress": self.jobRefVLbl.text!, "vDeviceType": Utils.deviceType, "GoogleServerKey": Configurations.getInfoPlistValue(key: "GOOGLE_SERVER_KEY"), "UserType": Utils.appUserType, "vMsgCode": self.passengerJsonDetail_dict!.get("MsgCode"),"vLatitude" : "\(currentLocation!.coordinate.latitude)","vLongitude" : "\(currentLocation!.coordinate.longitude)", "eSystem":"DeliverAll"]
        }else{
            parameters = ["type":"GenerateTrip","DriverID": GeneralFunctions.getMemberd(), "PassengerID": self.passengerJsonDetail_dict!.get("PassengerId"), "start_lat": self.passengerJsonDetail_dict!.get("sourceLatitude"), "start_lon": self.passengerJsonDetail_dict!.get("sourceLongitude"), "iCabBookingId": self.passengerJsonDetail_dict!.get("iBookingId"), "sAddress": self.pickUpVLbl.text!, "vDeviceType": Utils.deviceType, "GoogleServerKey": Configurations.getGoogleServerKey(), "UserType": Utils.appUserType, "vMsgCode": self.passengerJsonDetail_dict!.get("MsgCode"), "iCabRequestId": self.passengerJsonDetail_dict!.get("iCabRequestId"),"ride_type": self.passengerJsonDetail_dict!.get("REQUEST_TYPE"),"vLatitude" : "\(currentLocation!.coordinate.latitude)","vLongitude" : "\(currentLocation!.coordinate.longitude)", "REQUEST_TYPE": self.passengerJsonDetail_dict!.get("REQUEST_TYPE")]
        }
      
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
                    
                    if(GeneralFunctions.getValue(key: Utils.DIAL_NOTIFICATION) as! String != ""){
                        
                        self.isNotificationSoundKilled = true
                        self.audioPlayer = nil
                    }
                    
                }else{
                    
                    if(dataDict.get(Utils.message_str) != "" && dataDict.get(Utils.message_str) == "LBL_DRIVER_BLOCK"){
                        if(dataDict.get("isShowContactUs") == "Yes"){
                            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                    self.pushToNavController(uv: contactUsUv)
                                }else{
                                    self.declineTapped()
                                }
                                
                            })
                            return
                        }else{
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                            self.declineTapped()
                            return
                        }
                    }else{
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                            
                            if(dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                                let window = Application.window
                                
                                let getUserData = GetUserData(uv: self, window: window!)
                                getUserData.getdata()
                            }else{
                                self.declineTapped()
                            }
                            
                        })
                    }
                  
                }
                
            }else{
                
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                    
                    let window = Application.window
                    
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                })
//                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @objc func declineTapped(){
        declineRequest()
    }
    
    @objc func updateTime(){
        initializedSeconds = initializedSeconds - 1
        
        if((initializedSeconds % 5) == 0 && isOnForground){
            
            if(GeneralFunctions.getValue(key: Utils.DIAL_NOTIFICATION) as! String == ""){
                AudioServicesPlayAlertSound(1315)
            }
            
//            currentSecond = initializedSeconds
        }
        
        
        if(initializedSeconds < 1){
            timer.invalidate()
            progressContainerView.removeGestureRecognizer(progressTapGue)
            self.navigationItem.rightBarButtonItem!.isEnabled = false
            self.updateStatus(status: "Timeout")
            closePassengerRequest()
           // appState = ""
            return
            
        }
        
       
        let minutes = Double(initializedSeconds / 60).roundTo(places: 0)
        
        let cusSeconds = Double(initializedSeconds) - (minutes * 60)
        
        let strSeconds = String(format: "%02d", Int(cusSeconds))
        let strMinutes = String(format: "%02d", Int(minutes))
        timerLbl.text = "\(strMinutes):\(strSeconds)"
        timerLbl.text = Configurations.convertNumToAppLocal(numStr: timerLbl.text!)
        
        let value = initializedSeconds
        
        let final = Double(value) / Double(RIDER_REQUEST_ACCEPT_TIME)
        
        self.mcDialView.progress  = final
        
        self.halfProgressView.setProgress(progress: CGFloat(final))
        self.halfProgressView.percentLabelTxt = Configurations.convertNumToAppLocal(numStr: timerLbl.text!)
        
        
        timerLbl.fitText()
    }
    
    func closePassengerRequest(){
        //        self.navigationController?.popViewControllerAnimated(true)
        timer.invalidate()
        progressContainerView.removeGestureRecognizer(progressTapGue)
        
        GeneralFunctions.saveValue(key: Utils.DRIVER_CURRENT_REQ_OPEN_KEY, value: "false" as AnyObject)
        
        
        if(isCancelReqFired == false){
            ConfigPubNub.getInstance().publishMsg(channelName: "PASSENGER_\(self.passengerJsonDetail_dict!.get("PassengerId"))", content: GeneralFunctions.buildRequestCancelJson(iUserId: self.passengerJsonDetail_dict!.get("PassengerId"), vMsgCode: self.passengerJsonDetail_dict!.get("MsgCode")))
            isCancelReqFired = true
        }
        
        if(GeneralFunctions.getValue(key: Utils.DIAL_NOTIFICATION) as! String != ""){
           
            isNotificationSoundKilled = true
            self.audioPlayer = nil
        }
        
        if(self.audioPlayer != nil){
            isNotificationSoundKilled = true
            self.audioPlayer = nil
        }
        
        isScreenKilled = true
        
        if(isOnForground){
//            self.navigationController?.popViewController(animated: true)
//            self.dismiss(animated: true, completion: nil)
            self.releaseAllTask()
            self.closeCurrentScreenAnimConfig(isAnimated: false)
        }
        
        if(self.noteView != nil){
            self.noteView.removeFromSuperview()
        }
    }
    
    func checkAddressForLocation(sourceLatitude:String, sourceLongitude:String, destLatitude:String, destLongitude:String){
        
        if(self.passengerJsonDetail_dict!.get("iCabRequestId") != "" || self.passengerJsonDetail_dict!.get("eSystem").uppercased() == "DELIVERALL"){
            self.checkCabReqAddress()
            return
        }

        let mapDic = MapDictionary.init(p_latitude: "\(sourceLatitude)", p_longitude: "\(sourceLongitude)", d_latitude: "\(destLatitude == "" ? sourceLatitude : destLatitude)", d_longitude: "\(destLongitude == "" ? sourceLongitude : destLongitude)", max_latitude: "", max_longitude: "", min_latitude: "", min_longitude: "", search_query: "", isPickUpMode: "", session_token:"", toll_skipped:"", place_id:"", waypoints_Str: "", errorLbl: nil, loaderView: nil)
        MapServiceAPI.shared().getDirectionService(mapDictionary: mapDic, isOpenLoader: false, isAlertShow: false, uv: self) { (pointsArray, sourceAddress, endAddress, distance, duration, waypointsArray, serviceName, routesArray) in
            
            if(pointsArray.count == 0){
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.checkAddressForLocation(sourceLatitude: sourceLatitude, sourceLongitude: sourceLongitude, destLatitude: destLatitude, destLongitude: destLongitude)
                })
                return
            }
            
            self.pickUpVLbl.text = sourceAddress
            self.destVLbl.text = (destLatitude == "" || destLongitude == "" ) ? "----" : endAddress
        }
       
    }
    
    var noteView:UIView!
    func checkCabReqAddress(){
        let parameters = ["type":"getCabRequestAddress","iCabRequestId": self.passengerJsonDetail_dict!.get("iCabRequestId"), "vMsgCode": self.passengerJsonDetail_dict!.get("MsgCode"), "iDriverId": GeneralFunctions.getMemberd(), "iOrderId": self.passengerJsonDetail_dict!.get("iOrderId"), "eSystem":self.passengerJsonDetail_dict!.get("eSystem")]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                self.isAddressLoaded = true
                if(dataDict.get("Action") == "1"){
                    let msg = dataDict.getObj(Utils.message_str)
                    
                    if(msg.get("tNoteByUser") != ""){
                        self.viewUserNote.isHidden = false
                        self.viewUserNote.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_NOTE")
                        self.viewUserNote.textColor = UIColor.UCAColor.AppThemeColor
                        self.viewUserNote.setClickHandler { instance in
                            self.noteView = GeneralFunctions.showNote(txt: msg.get("tNoteByUser"))
                        }
                    }
                    
                    self.isAddressLoaded = true
                    
                    let destLatitude = self.passengerJsonDetail_dict!.get("destLatitude")
                    let destLongitude = self.passengerJsonDetail_dict!.get("destLongitude")
                    
                    self.pickUpVLbl.text = msg.get("tSourceAddress")
                    self.destVLbl.text = (destLatitude == "" || destLongitude == "" ) ? "----" : msg.get("tDestAddress")
                    self.jobRefVLbl.text = msg.get("tUserComment") == "" ? "----" : msg.get("tUserComment")
                    self.jobRefVLbl.fitText()
                    
                    self.jobTypeLbl.text = self.passengerJsonDetail_dict!.get("SelectedTypeName")
                    self.jobTypeLbl.fitText()
                    
                    
                    if msg.get("iRentalPackageId") != ""{
                        self.rentalPackageNameLbl.text = msg.get("PackageName")
                        self.PAGE_HEIGHT = self.PAGE_HEIGHT + 20
                        //self.pickUpAddTopMargin.constant = 20
                    }else{
                        self.rentalPackageNameLbl.isHidden = true
                    }
                    
                    self.tSourceAddress = msg.get("tSourceAddress")
                    
                    self.addMarker(sourceAddress: msg.get("tSourceAddress"), sourceLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLongitude"))), destAddress: msg.get("tDestAddress"), destLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("destLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("destLongitude"))))
                    
                    if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX){
                        
                        let vTypeHeight = msg.get("SelectedTypeName").height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 18)!)
                        self.PAGE_HEIGHT = self.PAGE_HEIGHT + vTypeHeight
                        
                        let refTextHeight = self.jobRefVLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 20)!) - 24
                        let extraHeight = 86 + refTextHeight
                        
                        self.jobRefViewHeight.constant =  extraHeight
                        self.PAGE_HEIGHT = self.PAGE_HEIGHT + extraHeight
                        
//                        if(self.passengerJsonDetail_dict!.get("eFareType") != "Regular"){
                            self.destVLbl.text = msg.get("tSourceAddress")
                            self.destVLbl.fitText()
//                        }
                        
                    }else{
                        
                        if self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"
                        {
                            var recHTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECIPIENT").uppercased()
                            let count:Int = Int(msg.get("Total_Delivery"))!
                            if count > 1
                            {
                                recHTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_RECIPIENTS").uppercased()
                            }
                            self.destVLbl.isHidden = true
                            self.destHLbl.textColor = UIColor.white
                            self.destHLbl.font = UIFont.systemFont(ofSize: 19)
                            self.destHLbl.text = "\(recHTxt): \(msg.get("Total_Delivery").uppercased())\n\n\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT_MODE_TXT").uppercased()): \(msg.get("ePayType").uppercased())\n\n\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOTAL_DISTANCE").uppercased()): \(msg.get("fDistance").uppercased())\n\n\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Total_Fare").uppercased()): \(msg.get("fTripGenerateFare").uppercased())\n"
                            
                            self.deliveryPackageView.isHidden = true
                            self.deliveryPackageViewHeight.constant = 0
                            self.viewDetailsBtn.isHidden = false
                        }
                        
                        if(msg.get("VehicleTypeName") != "" && self.passengerJsonDetail_dict!.get("ePoolRequest").uppercased() != "YES"){
                            var requestTxt = "\(self.requestTypeLbl.text!) (\(msg.get("VehicleTypeName")))"
                            if msg.get("iRentalPackageId") != ""{
                                
                                if(self.passengerJsonDetail_dict!.get("eFly") == "Yes"){
                                    requestTxt = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RENTAL_AIRCRAFT_REQUEST")) (\(msg.get("VehicleTypeName")))"
                                }else{
                                    requestTxt = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RENTAL_RIDE_REQUEST")) (\(msg.get("VehicleTypeName")))"
                                }
                            }
                            let vTypeHeight = requestTxt.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 20)!) - 24
                            self.requestTypeLbl.text = requestTxt
                           
                            self.PAGE_HEIGHT = self.PAGE_HEIGHT + vTypeHeight
                        }
                        
                    }
                    
                    if(msg.get("moreServices").uppercased() == "YES"){
                        
                        self.viewDeliveryDetailLbl.isHidden = false
                        self.viewDeliveryDetailLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_REQUESTED_SERVICES").uppercased()
                        self.viewDeliveryDetailLbl.setOnClickListener { (instance) in
                        }
                    }
                    
                    self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
                    

                }else{
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.checkCabReqAddress()
                })
            }
        })
    }
    
    func declineRequest(){
      //  appState = ""
        self.updateStatus(status: "Decline")
        let parameters = ["type":"DeclineTripRequest","DriverID": GeneralFunctions.getMemberd(), "PassengerID": self.passengerJsonDetail_dict!.get("PassengerId"), "vMsgCode": self.passengerJsonDetail_dict!.get("MsgCode")]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.closePassengerRequest()
        })
    }
    
    func updateStatus(status:String){
        if(self.passengerJsonDetail_dict == nil){
            return
        }
        
        CabRequestStatus.updateDriverRequestStatus(PassengerId: (self.passengerJsonDetail_dict!.get("PassengerId")), UpdatedStatus: status, ReceiverByscriptName: "AppReqState", repeatCount: 1, vMsgCode: (self.passengerJsonDetail_dict!.get("MsgCode")))
    }
    
    func setBottomDragView(){
        
        let destLatitude = self.passengerJsonDetail_dict!.get("destLatitude")
        let destLongitude = self.passengerJsonDetail_dict!.get("destLongitude")
        if((destLatitude == "" || destLongitude == "") && (self.passengerJsonDetail_dict!.get("REQUEST_TYPE") != "Multi-Delivery") && (self.passengerJsonDetail_dict!.get("REQUEST_TYPE") != Utils.cabGeneralType_UberX)){
            self.setBottomViewY = self.setBottomViewY - 70
        }
        
        if(self.passengerJsonDetail_dict!.get("eFly") == "Yes"){
            self.setBottomViewY = self.setBottomViewY - 80
        }
        
        sDragViewDefaultY = self.contentView.frame.height - setBottomViewY
        dragForRequest = SDragViewForRequest(dragViewAnimatedTopSpace: 0, viewDefaultHeightConstant: 0, uv: self, destinationLatitude: self.passengerJsonDetail_dict!.get("destLatitude"), destinationLongitude: self.passengerJsonDetail_dict!.get("destLongitude"), tripRequestType: self.passengerJsonDetail_dict!.get("REQUEST_TYPE"), EFly: self.passengerJsonDetail_dict!.get("eFly"))
        dragForRequest.backgroundColor = UIColor.white
        dragForRequest.layer.addShadow(opacity: 0.8, radius: 2.5, UIColor.lightGray)
        dragForRequest.layer.roundCorners(radius: 12)
        self.contentView.addSubview(dragForRequest)
        self.dragForRequest.layoutIfNeeded()
        
        self.bottomAddressView = self.generalFunc.loadView(nibName: "RequestBottomAddressView", uv: self, isWithOutSize: true)
        self.bottomAddressView.frame = CGRect(0, 0, self.contentView.frame.width, self.contentView.frame.height - sDragViewDefaultY)
        dragForRequest.addSubview(self.bottomAddressView)
      
       
        self.dragForRequest.dragViewAnimatedTopMargin = sDragViewDefaultY
        self.dragForRequest.perfomViewOpenORCloseAction(cancelTapped:false, closeFull:false)
        
        
        self.acceptView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.acceptViewImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.acceptViewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPT_TXT")
        self.acceptViewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        if(Configurations.isRTLMode()){
            self.acceptView.roundCorners([.topRight, .bottomRight], radius: 6)
            self.acceptViewImgView.image = self.acceptViewImgView.image?.rotate(180)
            GeneralFunctions.setImgTintColor(imgView: self.acceptViewImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }else{
            self.acceptView.roundCorners([.topLeft, .bottomLeft], radius: 6)
        }
        
        self.acceptView.setOnClickListener { (instance) in
            self.acceptTapped()
        }
        
        self.declineRequestLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DECLINE_TXT")
        self.declineRequestLbl.setOnClickListener { (instance) in
            self.declineTapped()
        }
        
    }
    
    
    func boundMapFromSourceToDest(pickUpLocation:CLLocation, destLocation:CLLocation){
        
        if(self.gMapView != nil){
            let maxZoomLevel:Float = 18.0
            
            if(self.gMapView != nil && self.gMapView.minZoom < maxZoomLevel - 5){
                self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel - 5)
            }
            
            var bounds = GMSCoordinateBounds()
            bounds =  bounds.includingCoordinate(pickUpLocation.coordinate)
            if(destLocation.coordinate.latitude != 0.0){
                bounds =  bounds.includingCoordinate(destLocation.coordinate)
            }
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: 45)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                if(self.gMapView != nil){
                    if(self.gMapView.minZoom < maxZoomLevel){
                        self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel)
                    }
                }
                
            }
            
            if(self.gMapView != nil){
                self.gMapView.animate(with: update)
            }
            
            CATransaction.commit()
        }
        
    }
    
    func setETATime(pickUpLocation:CLLocation, destLocation:CLLocation?){
        var lowestKM = 0.0
        var isFirst_lowestKM = true
        if(destLocation != nil){
          
            var distance = pickUpLocation.distance(from: CLLocation(latitude: destLocation!.coordinate.latitude, longitude: destLocation!.coordinate.longitude)) / 1000
            
            if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
                distance = distance *  0.621371
            }
            distance = distance.roundTo(places: 2)
            
            if(isFirst_lowestKM == true){
                lowestKM = distance
                isFirst_lowestKM = false
            }else {
                if (distance < lowestKM) {
                    lowestKM = distance
                }
            }
            
            let lowestTime = lowestKM * DRIVER_ARRIVED_MIN_TIME_PER_MINUTE
            var lowestTime_int = Int(lowestTime * 60)
            
            if(lowestTime_int < 1){
                lowestTime_int = 1
            }
            
            if(lowestKM > 1.5){
                
                if(self.gMapView != nil){
                    
                }
            }
            
            
            let hoursMin = secondsToHoursMinutesSeconds(seconds: lowestTime_int)
            if(hoursMin.0 < 1){
                
                self.etaTime = "\(Configurations.convertNumToAppLocal(numStr: "\(hoursMin.1)")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_SMALL_TXT"))"
            }else{
                let hourTxt = hoursMin.0 == 1 ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOUR_TXT") : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOURS_TXT")
                self.etaTime = "\(Configurations.convertNumToAppLocal(numStr: "\(hoursMin.0)")):\(Configurations.convertNumToAppLocal(numStr: "\(hoursMin.1)")) \(hourTxt)"
            }
            
            
            self.etaDistance = "\(Configurations.convertNumToAppLocal(numStr: "\(distance)")) \n\(self.userProfileJson.get("eUnit"))"
        }
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func addPickupMarker(sourceAddress:String, sourceLocation:CLLocation){
        if(self.pickUpPinMarker != nil){
            self.pickUpPinMarker.map = nil
            self.pickUpPinMarker = nil
        }
        
        if(self.pickUpCustomMarker != nil){
            self.pickUpCustomMarker.map = nil
            self.pickUpCustomMarker = nil
        }
        
        let pickUpMarkerView = self.generalFunc.loadView(nibName: "PickUpMarkerView", uv: self, isWithOutSize: true)
        pickUpMarkerView.frame = CGRect(x: 0, y: 0, width: 192, height: 43)
//        pickUpMarkerView.frame = CGRect(x: 0, y: 0, width: 200, height: 43)
        
        let timeLbl = UILabel(frame: CGRect(x: 2, y: 0, width: 48, height: 43))
        timeLbl.font = UIFont.boldSystemFont(ofSize: 13)
        timeLbl.textAlignment = .center
        if (self.etaDistance != ""){
            timeLbl.text = self.etaDistance
        }else{
            timeLbl.text = "--"
        }
        
        timeLbl.textColor = UIColor.white
        timeLbl.backgroundColor = UIColor.black
        timeLbl.numberOfLines = 2
        pickUpMarkerView.addSubview(timeLbl)
        
        let label = UILabel(frame: CGRect(x: 49, y: 0, width: 144, height: 43))
//        let label = UILabel(frame: CGRect(x: 49, y: 0, width: 152, height: 43))
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 2
//        label.minimumScaleFactor = 6.0
        label.textColor = UIColor.black
        label.text = sourceAddress
        pickUpMarkerView.addSubview(label)
        
        let markerImage = pickUpMarkerView.convertToImage()
        
        let markerView = UIImageView(image: markerImage)
        markerView.layer.shadowOpacity = 0.2
        markerView.layer.shadowColor = UIColor.black.cgColor
        markerView.layer.shadowRadius = 15
        
        var groundAnchorPoint = CGPoint(-0.0, -0.0) //CGPoint(-0.05, 1.05) Top-Right CGPoint(1.05, -0.05)// Bottom-Left //CGPoint(1.05, 1.05) Top-Left //CGPoint(-0.05, -0.05) Bootom-Right
        if(self.pickUpCustomMarker != nil){
            groundAnchorPoint = self.pickUpCustomMarker.groundAnchor
            self.pickUpCustomMarker.map = nil
        }
        
        self.pickUpCustomMarker = GMSMarker()
        self.pickUpCustomMarker.groundAnchor = groundAnchorPoint
        self.pickUpCustomMarker.position = CLLocationCoordinate2D(latitude: sourceLocation.coordinate.latitude, longitude: sourceLocation.coordinate.longitude)
        self.pickUpCustomMarker.iconView = markerView
        
        let pickUpPin = UIImageView(image:UIImage.init(named: ("ic_req_source")))
        self.pickUpPinMarker = GMSMarker()
        
        self.pickUpPinMarker.iconView = pickUpPin
        self.pickUpPinMarker.zIndex = -1
        self.pickUpPinMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        self.pickUpPinMarker.position = sourceLocation.coordinate
        self.pickUpPinMarker.map = self.gMapView
        
        self.pickUpCustomMarker.zIndex = 1
        self.pickUpCustomMarker.appearAnimation = GMSMarkerAnimation.pop
        self.pickUpCustomMarker.map = self.gMapView
    }
    
    func addMarker(sourceAddress:String, sourceLocation:CLLocation, destAddress:String, destLocation:CLLocation){
//        if(destLocation.coordinate.latitude == 0.0 || destLocation.coordinate.longitude == 0.0){
//            self.setETATime(pickUpLocation:sourceLocation, destLocation:nil)
//            self.addPickupMarker(sourceAddress: sourceAddress, sourceLocation: sourceLocation)
//        }else{
//            self.setETATime(pickUpLocation:sourceLocation, destLocation:nil)
//        }
        
//        self.addPickupMarker(sourceAddress: sourceAddress, sourceLocation: sourceLocation)

        //creating a marker view For DropOff
        if(self.dropOffPinMarker != nil){
            self.dropOffPinMarker.map = nil
        }
        
        if(self.dropOffPinMarker != nil){
            self.dropOffPinMarker = nil
        }
        
        if(self.dropOffCustomMarker != nil){
            self.dropOffCustomMarker.map = nil
        }
        
        if(self.dropOffCustomMarker != nil){
            self.dropOffCustomMarker = nil
        }
        
        if(destAddress != ""){
            let dropPin = UIImageView(image:UIImage.init(named: ("ic_req_dest")))
            
            self.dropOffPinMarker = GMSMarker()
            self.dropOffPinMarker.iconView = dropPin
            self.dropOffPinMarker.zIndex = -1
            self.dropOffPinMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            self.dropOffPinMarker.position = destLocation.coordinate
            self.dropOffPinMarker.map = self.gMapView
            
            let dropOffMarkerview = self.generalFunc.loadView(nibName: "PickUpMarkerView", uv: self, isWithOutSize: true)
            dropOffMarkerview.frame = CGRect(x: 0, y: 0, width: 150, height: 43)
            let label2 = UILabel(frame: CGRect(x: 2, y: 0, width: 146, height: 43))
            label2.font = UIFont.boldSystemFont(ofSize: 13)
            label2.textAlignment = .center
            label2.numberOfLines = 2
            label2.textColor = UIColor.black
            label2.text = destAddress
            dropOffMarkerview.addSubview(label2)
            
            // I have taken a pin image which is a custom image
            let dropmarkerImage = dropOffMarkerview.convertToImage()
            //creating a marker view
            let dropmarkerView = UIImageView(image: dropmarkerImage)
            dropmarkerView.layer.shadowOpacity = 0.5
            dropmarkerView.layer.shadowColor = UIColor.black.cgColor
            dropmarkerView.layer.shadowRadius = 10
            
            self.dropOffCustomMarker = GMSMarker()
            self.dropOffCustomMarker.groundAnchor = CGPoint(1.0, 1.0) //CGPoint(-0.05, 1.05) Top-Right CGPoint(1.05, -0.05)// Bottom-Left //CGPoint(1.05, 1.05) Top-Left //CGPoint(-0.05, -0.05) Bootom-Right
            self.dropOffCustomMarker.position = CLLocationCoordinate2D(latitude: destLocation.coordinate.latitude, longitude: destLocation.coordinate.longitude)
            self.dropOffCustomMarker.iconView = dropmarkerView
            self.dropOffCustomMarker.zIndex = 1
            self.dropOffCustomMarker.appearAnimation = GMSMarkerAnimation.pop
            self.dropOffCustomMarker.map = self.gMapView
            
            if(self.userProfileJson.get("IS_SHOW_ROUTE_ON_REQUEST") == "Yes" && self.passengerJsonDetail_dict!.get("eFly") != "Yes" && self.passengerJsonDetail_dict!.get("ePoolRequest") != "Yes"){
                self.drawRoute(fromLoc: sourceLocation, toLoc: destLocation, sourceAddress:sourceAddress)
            }else{
                if(destLocation.coordinate.latitude == 0.0 || destLocation.coordinate.longitude == 0.0){
                    self.setETATime(pickUpLocation:sourceLocation, destLocation:nil)
                    self.addPickupMarker(sourceAddress: sourceAddress, sourceLocation: sourceLocation)
                }else{
                    if(self.userProfileJson.get("IS_SHOW_ROUTE_ON_REQUEST") == "Yes"){
                        if(destAddress != "" && destLocation.coordinate.latitude != 0.0 && destLocation.coordinate.longitude != 0.0){
                            self.updateDirections = UpdateDirections(uv: self, gMap: self.gMapView, fromLocation: sourceLocation, destinationLocation: destLocation, isCurrentLocationEnabled: false)
                            self.updateDirections.onDirectionUpdateDelegate = self
                            self.updateDirections.scheduleDirectionUpdate(eTollSkipped: "")
                        }else{
                            self.setETATime(pickUpLocation:sourceLocation, destLocation:nil)
                            self.addPickupMarker(sourceAddress: sourceAddress, sourceLocation: sourceLocation)
                        }
                    }else{
                        self.drawRoute(fromLoc: sourceLocation, toLoc: destLocation, sourceAddress:sourceAddress)
//                        self.setETATime(pickUpLocation:sourceLocation, destLocation:destLocation)
//                        self.addPickupMarker(sourceAddress: sourceAddress, sourceLocation: sourceLocation)
                    }
                }
            }
            
            if(self.passengerJsonDetail_dict!.get("eFly") == "Yes" || self.passengerJsonDetail_dict!.get("ePoolRequest") == "Yes"){
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//
//                    self.buildArcPath(fromLoc: sourceLocation, toLoc: destLocation, arcCurvature: 0.40)
//                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.buildArcPath(fromLoc: sourceLocation, toLoc: destLocation, arcCurvature: 0.40)
                })
            }
            
            self.boundMapFromSourceToDest(pickUpLocation: sourceLocation, destLocation: destLocation)
            
        }else{
                self.setETATime(pickUpLocation:sourceLocation, destLocation:nil)
                self.addPickupMarker(sourceAddress: sourceAddress, sourceLocation: sourceLocation)
        }
    }
    
    func onDirectionUpdate(directionResultDict: NSDictionary) {
        
        if(directionResultDict.getArrObj("pointsArray").count > 0){
            
            var distanceValue = GeneralFunctions.parseDouble(origValue: 0.0, data: directionResultDict.get("distance")) / 1000
            
            if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
                distanceValue = distanceValue * 0.621371
            }
            
            var distance_final = ""
            
            if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
//                distance_final = "\(String(format: "%.02f", distanceValue)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT"))"
                distance_final = "\(String(format: "%.02f", distanceValue))"
            }else{
//                distance_final = "\(String(format: "%.02f", distanceValue)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_DISTANCE_TXT"))"
                distance_final = "\(String(format: "%.02f", distanceValue))"
            }
            
            self.etaDistance = "\(Configurations.convertNumToAppLocal(numStr: "\(distance_final)")) \n\(self.userProfileJson.get("eUnit"))"
           
            let hoursMin = self.secondsToHoursMinutesSeconds(seconds: Int(GeneralFunctions.parseDouble(origValue: 0.0, data: directionResultDict.get("duration"))))
            if(hoursMin.0 < 1){
                
                self.etaTime = "\(Configurations.convertNumToAppLocal(numStr: "\(hoursMin.1)")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_SMALL_TXT"))"
            }else{
                let hourTxt = hoursMin.0 == 1 ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOUR_TXT") : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOURS_TXT")
                self.etaTime = "\(Configurations.convertNumToAppLocal(numStr: "\(hoursMin.0)"))\(hourTxt) \(Configurations.convertNumToAppLocal(numStr: "\(hoursMin.1)")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_SMALL_TXT"))"
            }
            
            self.addPickupMarker(sourceAddress: "\(self.tSourceAddress)", sourceLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLongitude"))))

        }else{
            
            self.setETATime(pickUpLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLongitude"))), destLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("destLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("destLongitude"))))
            
            self.addPickupMarker(sourceAddress: "\(self.tSourceAddress)", sourceLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLongitude"))))
            
        }
    }
    
    func drawRoute(fromLoc:CLLocation, toLoc:CLLocation, sourceAddress:String){
            
            let mapDic = MapDictionary.init(p_latitude: "\(fromLoc.coordinate.latitude)", p_longitude: "\(fromLoc.coordinate.longitude)", d_latitude: "\(toLoc.coordinate.latitude)", d_longitude: "\(toLoc.coordinate.longitude)", max_latitude: "", max_longitude: "", min_latitude: "", min_longitude: "", search_query: "", isPickUpMode: "", session_token:"", toll_skipped:"", place_id:"", waypoints_Str: "", errorLbl: nil, loaderView: nil)
            MapServiceAPI.shared().getDirectionService(mapDictionary: mapDic, isOpenLoader: false, isAlertShow: false, uv: self) { (pointsArray, sourceAddress, endAddress, distance, duration, waypointsArray, serviceName, routesArray) in
                
                if(pointsArray.count == 0){
                  
                    return
                }
                
                var distanceValue = GeneralFunctions.parseDouble(origValue: 0.0, data: distance) / 1000
                if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
                    distanceValue = distanceValue *  0.621371
                }
                
                var distance_final = ""
                
                
                if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
//                    distance_final = "\(String(format: "%.02f", distanceValue)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT"))"
                    distance_final = "\(String(format: "%.02f", distanceValue))"
                }else{
//                    distance_final = "\(String(format: "%.02f", distanceValue)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_DISTANCE_TXT"))"
                    distance_final = "\(String(format: "%.02f", distanceValue))"
                }
                
                self.etaDistance = "\(Configurations.convertNumToAppLocal(numStr: "\(distance_final)")) \n\(self.userProfileJson.get("eUnit"))"
                
                Utils.printLog(msgData: "etaDistance::\(self.etaDistance)")
                
                
                let hoursMin = self.secondsToHoursMinutesSeconds(seconds: Int(GeneralFunctions.parseDouble(origValue: 0.0, data: duration)))
                if(hoursMin.0 < 1){
                    
                    self.etaTime = "\(Configurations.convertNumToAppLocal(numStr: "\(hoursMin.1)")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_SMALL_TXT"))"
                }else{
                    let hourTxt = hoursMin.0 == 1 ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOUR_TXT") : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOURS_TXT")
                    self.etaTime = "\(Configurations.convertNumToAppLocal(numStr: "\(hoursMin.0)"))\(hourTxt) \(Configurations.convertNumToAppLocal(numStr: "\(hoursMin.1)")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_SMALL_TXT"))"
                }
                
                self.addPickupMarker(sourceAddress: "\(self.tSourceAddress)", sourceLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLongitude"))))
                
                let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
                
                
                if(routesArray.count > 0 && fromWeb == false){
                    let points = (routesArray[0] ).getObj("overview_polyline").get("points")
                    let animatedPath = GMSPath.init(fromEncodedPath: points)!
                    
                    //                self.perform(#selector(self.addMarker), with: self, afterDelay: 0.5)
                    
                    var i_anim:UInt = 0
                    while (i_anim < animatedPath.count()) {
                        
                        self.animLocationArr.append(animatedPath.coordinate(at: i_anim))
                        i_anim += 1
                    }
                    let lat = pointsArray[pointsArray.count/2].getObj("end_location").get("lat")
                    let long = pointsArray[pointsArray.count/2].getObj("end_location").get("lng")
                    self.addArcmarker(location: CLLocation(latitude:GeneralFunctions.parseDouble(origValue: 0.0, data: lat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: long)), text:"")
                    
                    
                }else{
                    var i_anim:UInt = 0
                    for i in 0..<pointsArray.count{
                        
                        let item = pointsArray[i]
                                
                        
                        if(fromWeb == true){
                            self.animLocationArr.append(CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("longitude"))))
                        }else{
                                    
                                    
                            let lat = pointsArray[i].getObj("end_location").get("lat")
                            let long = pointsArray[i].getObj("end_location").get("lng")

                            self.animLocationArr.append(CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: lat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: long)))
                        

                        }
                        
                        if(i_anim == (pointsArray.count / 2) - 1){
                            
                            self.addArcmarker(location: CLLocation(latitude:GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("longitude"))), text:"")
                        }
                                        
                        i_anim += 1
                   }
                }
                
    //            var i_anim:Int = 0
    //            for i in 0..<pointsArray.count{
    //                let item = pointsArray[i]
    //
    //                if(fromWeb == true){
    //                    self.animLocationArr.append(CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("longitude"))))
    //
    //                    if(i_anim == (pointsArray.count / 2) - 1){
    //
    //                        self.addArcmarker(location: CLLocation(latitude:GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("longitude"))), text:"")
    //                    }
    //                }else{
    //
    //                    let lat = pointsArray[i].getObj("end_location").get("lat")
    //                    let long = pointsArray[i].getObj("end_location").get("lng")
    //
    //                    self.animLocationArr.append(CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: lat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: long)))
    //
    //                    if(i_anim == (pointsArray.count / 2) - 1){
    //
    //                        self.addArcmarker(location: CLLocation(latitude:GeneralFunctions.parseDouble(origValue: 0.0, data: lat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: long)), text:"")
    //                    }
    //                }
    //
    //
    //                i_anim += 1
    //            }
                
                if(self.userProfileJson.get("IS_SHOW_ROUTE_ON_REQUEST") == "Yes"){
                    self.animatePolyLineForRoute()
                }
                
            }
            
    }
    
    func stopAnimatePolyLine(){
        
        if (polylineForPool != nil){
            self.polylineForPool.map = nil
        }
        
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
    func animatePolyLineForRoute(_ isForPool:Bool = false){
        self.stopAnimatePolyLine()
        animatePolylineForPool = false
        animationPathOrig.removeAllCoordinates()
        
        animationPolylineOrig.map = nil
        
        var i_anim:Int = 0
        
        while(i_anim < self.animLocationArr.count){
            self.animationPathOrig.add(self.animLocationArr[i_anim])
            i_anim += 1
        }
        self.animationPolylineOrig.path = self.animationPathOrig
        self.animationPolylineOrig.strokeColor = UIColor.black
        self.animationPolylineOrig.strokeWidth = 5
        self.animationPolylineOrig.map = self.gMapView
        
        var interValForPathArayCount:Double = Double(self.animLocationArr.count)
        if (animatePolylineForPool == true){    /* Check For Pool Route Animation.*/
            interValForPathArayCount = Double(self.poolpath.count())
        }
        
        let interval = Utils.MAX_ROUTE_ANIM_INTERVAL / interValForPathArayCount
        animTask = UpdateFreqTask(interval: interval / 1000)
        animTask.currInst = animTask
        animTask.setTaskRunListener(onTaskRunCalled: self)
        
        animTask.startRepeatingTask()
    }
    
    var tempLoc:CLLocation!
    
    func buildArcPath(fromLoc:CLLocation, toLoc:CLLocation, arcCurvature:Double){
        if self.gMapView == nil
        {
            return
        }
        var fromLocation = fromLoc
        var toLocation = toLoc
        let maxZoomLevel = self.gMapView.maxZoom
        self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: self.gMapView.maxZoom - 5)
        
        
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
            self.tempLoc = tempLoc
            path.addLatitude(tempLoc.coordinate.latitude, longitude: tempLoc.coordinate.longitude)
            bounds =  bounds.includingCoordinate(tempLoc.coordinate)
            
            if(i == Int(numPoints / 2)){
                self.addArcmarker(location: tempLoc, text:"")
                
            }
        }
        poolpath = path
        let update = GMSCameraUpdate.fit(bounds, withPadding: 45)
        polylineForPool = GMSPolyline(path: path)
        polylineForPool.strokeWidth = 4.0
        polylineForPool.strokeColor = UIColor(hex: 0x373737)
        polylineForPool.geodesic = true
//        let dist  = self.currentLocation?.distance(from: toLoc)
//        //        let dist  = self.currentLocation1.distance(from: self.destLocation)
//        let _: [Any] = [GMSStrokeStyle.solidColor(UIColor.black), GMSStrokeStyle.solidColor(UIColor.clear)]
//        let _: [Any] = [dist!/40,dist!/65]
//        //polylineForPool.spans = GMSStyleSpans(polylineForPool.path!, styles as! [GMSStrokeStyle], lengths as! [NSNumber], GMSLengthKind.rhumb)
        polylineForPool.map = self.gMapView
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel)
        }
        
        //        self.gMapView.animate(with: update)
        self.gMapView.moveCamera(update)
        CATransaction.commit()
        
        //self.i_anim = 0
        
        self.animatePolylineForPool = true
        
//        if(self.userProfileJson.get("IS_SHOW_ROUTE_ON_REQUEST") == "Yes"){
            self.animatePolyLine(true)
//        }
    }
    
    func addArcmarker(location:CLLocation, text:String){
        if(arcPinMarker != nil){
            self.arcPinMarker.map = nil
            self.arcPinMarker = nil
        }
        self.arcPinMarker = GMSMarker()
        let image = Utils.textToImage(drawText: self.etaTime as NSString, inImage: UIImage(named:"ic_reqArc")!, atYPoint: 12).resize(toHeight: 30)!
        self.arcPinMarker.icon = image
        self.arcPinMarker.zIndex = -1
        self.arcPinMarker.groundAnchor = CGPoint(-0.0, -0.0)
        self.arcPinMarker.position = location.coordinate
        self.arcPinMarker.map = self.gMapView
        
    }
    
    func animatePolyLine(_ isForPool:Bool = false){
        
        var interValForPathArayCount:Double = 0
        if (animatePolylineForPool == true){    /* Check For Pool Route Animation.*/
            interValForPathArayCount = Double(self.poolpath.count())
        }
        
        let interval = Utils.MAX_ROUTE_ANIM_INTERVAL / interValForPathArayCount
        animTask = UpdateFreqTask(interval: interval / 1000)
        animTask.currInst = animTask
        animTask.setTaskRunListener(onTaskRunCalled: self)
        
        animTask.startRepeatingTask()
    }
    
    func onTaskRun(currInst: UpdateFreqTask) {
        if(currInst == self.animTask){
            
            if (animatePolylineForPool == true){
                
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
                
            }else{
                if (self.i_anim < self.animLocationArr.count) {
                    self.animationPath.add(self.animLocationArr[i_anim])
                    
                    self.animationPolyline.path = self.animationPath
                    
                    self.animationPolyline.strokeColor = UIColor.gray
                    self.animationPolyline.strokeWidth = 5
                    
                    self.animationPolyline.map = self.gMapView
                    
                    self.i_anim += 1
                }
                else {
                    self.i_anim = 0
                    self.animationPath = GMSMutablePath()
                    self.animationPolyline.map = nil
                }
            }
            
            return
        }
    }
    
  
}
