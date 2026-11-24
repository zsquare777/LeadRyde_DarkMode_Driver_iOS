//
//  BookingsUV.swift
//  DriverApp
//
//  Created by Admin on 14/10/19.
//  Copyright © 2019 @. All rights reserved.
//

import UIKit
import SwiftExtensionData

class BookingsUV: UIViewController , UITableViewDataSource, UITableViewDelegate, MyBtnClickDelegate, OnLocationUpdateDelegate,IndicatorInfoProvider, UIScrollViewDelegate{
    

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendarView: XFSCalendar!
    @IBOutlet weak var calendarHeaderView: UIView!
    
    @IBOutlet weak var dropDownImgView: UIImageView!
    @IBOutlet weak var prevBtn: UIImageView!
    @IBOutlet weak var nextBtn: UIImageView!
    @IBOutlet weak var titleDateLbl: MyLabel!
    @IBOutlet weak var calenderTitleView: UIView!
    
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var filterHLbl: MyLabel!
    @IBOutlet weak var filterDownImgView: UIImageView!
    
    @IBOutlet weak var imgTotalOrder: UIImageView!
    @IBOutlet weak var totalHOrderLbl: MyLabel!
    @IBOutlet weak var totalVOrderLbl: MyLabel!
    
    @IBOutlet weak var imgTotalrating: UIImageView!
    @IBOutlet weak var totalHRateLbl: MyLabel!
    @IBOutlet weak var totalVRateLbl: MyLabel!
    
    @IBOutlet weak var imgTotalEarning: UIImageView!
    @IBOutlet weak var totalHEarning: MyLabel!
    @IBOutlet weak var totalVEarning: MyLabel!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var avgView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var calendarStackView: UIStackView!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: self.tempIdentifier)
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter
    }()
    
    fileprivate lazy var dateFormatterForAPI: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    let generalFunc = GeneralFunctions()
    
    var navItem:UINavigationItem!
    var filterdData = ""
    var PAGE_TYPE = "BOOKING" //order
    var curentSelectedDate = Date()
    var minimumDate  = Date()
    var userProfileJson:NSDictionary!
    
    var loaderView:UIView!
    
    var dataArrList = [NSDictionary]()
    var nextPage_str = 1
    var tripDataPage_str = 1
    var isLoadingMore = false
    var isNextPageAvail = false
    
    var APP_TYPE = ""
    
    let formatter = DateFormatter()
    
    var testCalendar = Calendar(identifier: Configurations.getCalendarIdentifire())
    
    var registrationDate = ""
    
    var startDate:Date!
    
    var cntView:UIView!
    
    var extraHeightContainer = [CGFloat]()
    
    var currentPageDate:Date!
    
    var isFirstCallFinished = false
    
    var isDataLoaded = false
    
    var msgLbl:MyLabel!
    
    var isDirectPush = false
    var isSafeAreaSet = false
    
    var appTypeFilterArr:NSArray!
    var vFilterParam = ""

    var subFilterOptionArr:NSArray!
    var vSubFilterParam = ""

    var currentWebTask:ExeServerUrl!
    
    var currentLocation:CLLocation?
    var homeTabBar:HomeScreenTabBarUV!
    var isFromViewProfile = false
    
    var CurrencySymbol = ""
    var selectedToDate = ""
    var viewWillDisAppear = false
    var isMultipleTab = false
    
    var tempIdentifier = "en"
    var originalIdentifier = "en"
    
    fileprivate let gregorianFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"

        formatter.locale = Locale(identifier: "en-US")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "", key: PAGE_TYPE == "BOOKING" ? "LBL_BOOKING" : "LBL_ORDERS_NAME_ADMIN"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.originalIdentifier = GeneralFunctions.getValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY) as! String
        GeneralFunctions.saveValue(key: "G_L_C", value: self.originalIdentifier as AnyObject)
        
        if(GeneralFunctions.getValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY) as! String == "ar"){
            self.tempIdentifier = "ar"
            GeneralFunctions.saveValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY, value: "en" as AnyObject)
        }else{
            self.tempIdentifier = GeneralFunctions.getValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY) as! String
        }
        
        cntView = self.generalFunc.loadView(nibName: "BookingsUV", uv: self, contentView: containerView)
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        minimumDate  = Utils.convertDateGregorianToAppLocale(date: userProfileJson.get("RegistrationDate"), dateFormate: "yyyy-MM-dd")

        self.cntView.backgroundColor = UIColor(hex: 0xF1F1F1)
        setupCalender()
        self.containerView.addSubview(cntView)
        self.showCalender(show:false, false)
        self.calendarView.isHidden = false
        self.calendarView.opacity = 0
        self.tableView.delegate = self
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {}

        
        self.tableView.contentInset = UIEdgeInsets.init(top: 6, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 6, right: 0)
    
        self.tableView.register(UINib(nibName: "RideHistoryUFXListTVCell", bundle: nil), forCellReuseIdentifier: "RideHistoryUFXListTVCell")
        self.tableView.register(UINib(nibName: "RideHistoryUFXFinishedListTVCell", bundle: nil), forCellReuseIdentifier: "RideHistoryUFXFinishedListTVCell")
        self.tableView.register(UINib(nibName: "RideHistoryListTVCell", bundle: nil), forCellReuseIdentifier: "RideHistoryTVCell")
        self.tableView.register(UINib(nibName: "OrderHistoryTVC", bundle: nil), forCellReuseIdentifier: "OrderHistoryTVC")
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 6, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 6, right: 0)
        self.tableView.addSubview(self.refreshControl)


        APP_TYPE = userProfileJson.get("APP_TYPE")

        self.dataArrList.removeAll()
        self.filterHLbl.text = self.generalFunc.getLanguageLabel(origValue: "ALL", key: "LBL_ALL").uppercased()
        self.filterHLbl.fitText()
        
        self.filterDownImgView.image = UIImage(named: "ic_arrow_right")!.rotate(90)
        GeneralFunctions.setImgTintColor(imgView: self.filterDownImgView, color: UIColor(hex: 0x202020))
        
        self.scrollView.delegate = self
        
        self.cntView.isHidden = true
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        if(isFromViewProfile){
            self.addBackBarBtn()
        }
        viewWillDisAppear = false
//        if (self.PAGE_TYPE != "BOOKING")  {
//               self.showCalender(show:true, false)
//        }
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        GeneralFunctions.saveValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY, value: self.originalIdentifier as AnyObject)
        viewWillDisAppear = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
//        if self.homeTabBar != nil {
//            let topBrViewHeight:CGFloat = 70
//            let tabbbaRHeight = self.homeTabBar.tabBar.height
//            let navigationHeight = UIApplication.shared.statusBarFrame.height +
//                self.navigationController!.navigationBar.frame.height
//
//            self.isMultipleTab = true
//            cntView.frame.size.height = Application.screenSize.height - navigationHeight - ((self.isMultipleTab == true) ? topBrViewHeight : 0) - ((self.isFromViewProfile == true) ? 0 : tabbbaRHeight)
//
//        }

        
        self.extraHeightContainer.removeAll()
        let getLocation = GetLocation(uv: self, isContinuous: false)
        getLocation.buildLocManager(locationUpdateDelegate: self)
        self.dataArrList.removeAll()
        self.isLoadingMore = false
        self.nextPage_str = 1
        self.isNextPageAvail = false
        self.tableView.reloadData()
        
        if(self.msgLbl != nil){
            self.msgLbl.isHidden = true
        }
        self.dataArrList.removeAll()
        self.getDtata(isLoadingMore: false)
        setData()
       
        
    }
    
    @objc func setScrollSize(){
    
        var extaHeightOfCalendar:CGFloat = 0.0
        if(self.msgLbl != nil && self.msgLbl.isHidden == false){
            
            extaHeightOfCalendar = extaHeightOfCalendar + 250
            print("Extraheight:\(extaHeightOfCalendar)")
        }else{
            extaHeightOfCalendar = 30
        }
        
        self.tableViewHeight.constant = self.tableView.contentSize.height  + extaHeightOfCalendar
        self.scrollView.contentSize = CGSize(width: self.tableView.contentSize.width, height: self.tableView.contentSize.height + extaHeightOfCalendar + 20 )
        self.scrollView.layoutIfNeeded()
        
    }
    override func viewDidLayoutSubviews() {
        
    }
    func showCalender(show:Bool, _ setCntSize:Bool = true) {
        if   show  {
             self.calendarView.isHidden = true
            self.dropDownImgView.tag = 1
            let dropDownImg = UIImage(named: "ic_arrow_down_app_login")!.withRenderingMode(.alwaysTemplate).setTintColor(color: .lightGray)?.resize(toWidth: 14)!
            dropDownImgView.image =  dropDownImg
            self.calendarHeaderView.isHidden = false
            self.calendarHeaderView.backgroundColor = UIColor(hex: 0xf1f1f1)
            self.tableView.backgroundColor = UIColor(hex: 0xf1f1f1)
            let tableHeaderView = self.generalFunc.loadView(nibName: "OrderHeaderView", uv: self, isWithOutSize: true)
            tableHeaderView.backgroundColor = UIColor(hex: 0xf1f1f1)
            tableHeaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 220)
            self.tableView.tableHeaderView = tableHeaderView
            self.totalHEarning.text = self.generalFunc.getLanguageLabel(origValue: "Total Earnings", key: "LBL_TOTAL_EARNINGS")
            self.totalHOrderLbl.text  = self.generalFunc.getLanguageLabel(origValue: "Total Orders", key: "LBL_TOTAL_TXT")
            self.totalHRateLbl.text = self.generalFunc.getLanguageLabel(origValue: "Total Orders", key: "LBL_AVG")
            GeneralFunctions.setImgTintColor(imgView: imgTotalOrder, color: .white)
            GeneralFunctions.setImgTintColor(imgView: imgTotalrating, color: .white)
            GeneralFunctions.setImgTintColor(imgView: imgTotalEarning, color: .black)
            totalView.backgroundColor = UIColor.UCAColor.AppThemeColor
            avgView.backgroundColor = UIColor.UCAColor.AppThemeColor
            self.calendarView.opacity = 1
            self.dropDownImgView.tag = 1

            
        }else {
            self.tableView.tableHeaderView =  nil
            self.calendarHeaderView.isHidden = true
            self.calendarView.isHidden = true
        }
        
        if(setCntSize == true){
            self.setScrollSize()
        }
        
    }

    func setData(){
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200, height: 44.0))
        label.font = UIFont(name: Fonts().regular, size: 18)!
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        var navigationHeaderTitle = ""
        if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your trips", key: "LBL_YOUR_TRIPS")
        }else if(userProfileJson.get("APP_TYPE").uppercased() == "DELIVERY"){
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your deliveries", key: "LBL_YOUR_DELIVERY")
        }else{
            if(userProfileJson.get("ONLYDELIVERALL") == "Yes"){
                navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Orders", key: "LBL_ORDERS_TXT")
            }else{
                navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your bookings", key: "LBL_YOUR_BOOKING")
            }
            
        }
        label.text = navigationHeaderTitle
        label.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.navigationItem.titleView = label
        if(self.homeTabBar != nil){
            self.homeTabBar.navItem.titleView = label
        }else {
             self.navigationItem.titleView = label
        }
        
        self.calendarView.zPosition = -1
        self.tableView.zPosition = -1
       
        
    }
    
    func setupCalender() {
        prevBtn.backgroundColor = .clear
        nextBtn.backgroundColor = .clear
        self.calendarView.locale = Locale(identifier: self.tempIdentifier)
        calendarView.delegate = self
        calendarView.dataSource = self
        self.calendarView.borderColor = UIColor.clear
        self.calendarView.select(Date())
        self.calendarView.scope = .month
        self.calendarView.accessibilityIdentifier = "calendar"
        self.calendarView.appearance.titleFont = UIFont(name: Fonts().regular , size: 14)
        self.calendarView.appearance.weekdayFont = UIFont(name: Fonts().semibold, size: 14)
        self.calendarView.appearance.weekdayTextColor = UIColor(hex:0x141414)
        self.calendarView.appearance.subtitleDefaultColor = UIColor(hex:0x141414)
        self.calendarView.appearance.titleSelectionColor  = .white
        self.calendarView.appearance.selectionColor = UIColor.UCAColor.AppThemeColor
        self.calendarView.appearance.todayColor = .clear
        self.calendarView.appearance.titleTodayColor = .black
        self.calendarView.select(Date())
        self.calendarView.isHidden = true
        self.dropDownImgView.tag = 1
       
        self.calendarHeaderView.backgroundColor = UIColor(hex: 0xf1f1f1)

        calendarView.reloadData()
        let dropDownImg = UIImage(named: "ic_arrow_down_app_login")!.withRenderingMode(.alwaysTemplate).setTintColor(color: .lightGray)?.resize(toWidth: 14)!
        dropDownImgView.image =  dropDownImg
        let todayDate = self.dateFormatter.string(from: Date())
        
        titleDateLbl!.text =  todayDate
        
        var backImg = UIImage(named: "ic_right_arrow_circle")!
        nextBtn.image = UIImage(named: "ic_right_arrow_circle")
        prevBtn.image = backImg.rotate(180)
        
        if(Configurations.isRTLMode()){
            backImg = backImg.rotate(180)
            nextBtn.image = backImg
            prevBtn.image = backImg.rotate(180)
        }
        
        GeneralFunctions.setImgTintColor(imgView: prevBtn, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: nextBtn, color: UIColor.UCAColor.AppThemeColor)
   
        calenderTitleView.setOnClickListener { (view) in
            self.dropDownImgView.image = self.dropDownImgView.image?.rotate(180)
            if self.dropDownImgView.tag == 0 {
                self.calenderView(show: false)
            }else {
                self.calenderView(show: true)
            }
            if !self.calendarView.isHidden {
                self.calendarView.select(self.curentSelectedDate)
            }
        }
        
        prevBtn.setOnClickListener { (view) in
            let calendar = Calendar.current
            let daysAgo = calendar.date(byAdding: .day, value: -1, to: self.curentSelectedDate)
            if daysAgo! <  self.minimumDate {return}
            self.curentSelectedDate = daysAgo!
            let todayDate = self.dateFormatter.string(from: daysAgo!)
           self.selectedToDate = self.dateFormatterForAPI.string(from: daysAgo!)
            if !self.calendarView.isHidden {
                self.calendarView.select(self.curentSelectedDate)
            }
            self.titleDateLbl!.text =  todayDate
            self.extraHeightContainer.removeAll()
            self.dataArrList.removeAll()
            self.isLoadingMore = false
            self.nextPage_str = 1
            self.isNextPageAvail = false
            
            if(self.tableView != nil){
                self.removeFooterView()
                self.tableView.reloadData()
            }
            
            if(self.msgLbl != nil){
                self.msgLbl.isHidden = true
            }
            
            self.getDtata(isLoadingMore: false)
        }
        
        nextBtn.setOnClickListener { (view) in
            let calendar = Calendar.current
            let daysAafter = calendar.date(byAdding: .day, value: 1, to: self.curentSelectedDate)
            if daysAafter! > Date() {return}
            let todayDate = self.dateFormatter.string(from: daysAafter!)
            self.selectedToDate = self.dateFormatterForAPI.string(from: daysAafter!)
            self.curentSelectedDate = daysAafter!
            if !self.calendarView.isHidden {
                self.calendarView.select(self.curentSelectedDate)
            }
            self.titleDateLbl!.text =  todayDate
            self.extraHeightContainer.removeAll()
            self.dataArrList.removeAll()
            self.isLoadingMore = false
            self.nextPage_str = 1
            self.isNextPageAvail = false
            
            if(self.tableView != nil){
                self.removeFooterView()
                self.tableView.reloadData()
            }
            
            if(self.msgLbl != nil){
                self.msgLbl.isHidden = true
            }
            self.getDtata(isLoadingMore: false)
        }
    }
    
    func calenderView(show:Bool) {
        
        if show {
            self.dropDownImgView.tag = 0
            self.calendarView.isHidden = false
            self.calendarHeaderView.backgroundColor = UIColor.white
            self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: false)
        }else {
            self.dropDownImgView.tag = 1
            self.calendarView.isHidden = true
            self.calendarHeaderView.backgroundColor = UIColor(hex: 0xf1f1f1)
        }
       // self.setScrollSize()
    }
    
    @objc func closeCurrentScreenToMain() {
        let window = Application.window
        let getUserData = GetUserData(uv: self, window: window!)
        getUserData.getdata()
    }
    

    func onLocationUpdate(location: CLLocation) {
        self.currentLocation = location
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
      //MARK:  API
    func getDtata(isLoadingMore:Bool){
        self.filterContainerView.isHidden = true
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view.superview!)
            loaderView.backgroundColor = UIColor.clear
        }else if(loaderView != nil && isLoadingMore == false){
            loaderView.isHidden = false
        }
        
        if(currentWebTask != nil){
            currentWebTask.cancel()
        }
        
        var parameters = ["type": PAGE_TYPE == "BOOKING" ? "getMemberBookings" : "getOrderHistory", "UserType": Utils.appUserType, "memberId": GeneralFunctions.getMemberd(), "page": self.nextPage_str.description,  "vFilterParam": self.vFilterParam , "vSubFilterParam":self.vSubFilterParam]
        if PAGE_TYPE != "BOOKING" {
            let selectedToDate = dateFormatterForAPI.string(from: self.curentSelectedDate)
            parameters = ["type": "getOrderHistory", "iGeneralUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "vFromDate": selectedToDate, "vSubFilterParam": vSubFilterParam, "page":  self.nextPage_str.description, "eSystem":"DeliverAll"]
        }else {
            parameters["dDateOrig"] = selectedToDate
            parameters["tripdataPage"] =  self.tripDataPage_str.description
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        currentWebTask = exeWebServerUrl
        
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            self.cntView.isHidden = false
            if(response != ""){
                
                let dataDict = response.getJsonDataDict()
                if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                    Utils.printLog(msgData: "SESSION_OUT_CALLED")
                    if(GeneralFunctions.isAlertViewPresentOnScreenWindow(viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG) == false){
                        
                        self.generalFunc.setAlertMessage(uv: nil , title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG, completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                            GeneralFunctions.postNotificationSignal(key: ConfigPubNub.removeInst_key, obj: self)
                            GeneralFunctions.postNotificationSignal(key: ConfigSCConnection.removeSCInst_key, obj: self)
                            
                            GeneralFunctions.logOutUser()
                            GeneralFunctions.restartApp(window: Application.window!)
                        })
                    }
                    
                    return
                }
                
                self.CurrencySymbol = dataDict.get("CurrencySymbol")
                let appTypeFilterArr = dataDict.getArrObj("AppTypeFilterArr")
                
                if self.PAGE_TYPE == "BOOKING" {
                    if(appTypeFilterArr.count > 0) {
                        self.appTypeFilterArr = appTypeFilterArr
                        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_filter")!.resize(toWidth: 30)!.resize(toHeight: 30)!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.filterDataTapped))
                        
                        if(self.viewWillDisAppear == false){
                            if(self.homeTabBar == nil){
                                self.navItem.rightBarButtonItem = rightButton
                            }else{
                                if(self.isFromViewProfile && self.navItem != nil){
                                    self.navItem.rightBarButtonItem = rightButton
                                }else{
                                    self.homeTabBar.navItem.rightBarButtonItem = rightButton
                                }
                            }
                        }
                    }
                }else {
                    if(self.homeTabBar == nil){
                        self.navItem.rightBarButtonItem = nil
                    }else {
                        self.homeTabBar.navItem.rightBarButtonItem = nil
                    }
                }
                
                let subFilterOptionArr = dataDict.getArrObj("subFilterOption")
                
                if(subFilterOptionArr.count > 0){
                    self.subFilterOptionArr = subFilterOptionArr
                    
                    let filterTapGue = UITapGestureRecognizer()
                    filterTapGue.addTarget(self, action: #selector(self.filterSubDataTapped))
                    self.filterContainerView.isUserInteractionEnabled = true
                    self.filterContainerView.addGestureRecognizer(filterTapGue)
                    for dict  in subFilterOptionArr {
                        let valu = dict as! NSDictionary
                        if valu.get("vSubFilterParam") == dataDict.get("eFilterSel") {
                            self.filterHLbl.text = valu.get("vTitle")
                        }
                    }
                }
                
                if self.PAGE_TYPE == "BOOKING"  {
                    self.tripDataPage_str = Int(dataDict.get("tripdataPage"))!
                    
                    if dataDict.get("eFilterSel") == "past" {
                        self.showCalender(show:true, false)
                    }else {
                        self.showCalender(show:false, false)
                    }
                }else{
                    self.showCalender(show:true, false)
                }
                
                if   self.totalVOrderLbl != nil {
                    
                    if self.PAGE_TYPE == "BOOKING"{
                         self.totalVOrderLbl.text = (dataDict.get("TripCount") != "" && GeneralFunctions.parseInt(origValue: 0, data: dataDict.get("TripCount")) > 0) ? Configurations.convertNumToAppLocal(numStr: dataDict.get("TripCount")) : "--"
                    }else{
                        self.totalVOrderLbl.text = (dataDict.get("TotalOrder") != "" && GeneralFunctions.parseInt(origValue: 0, data: dataDict.get("TotalOrder")) > 0) ? Configurations.convertNumToAppLocal(numStr: dataDict.get("TotalOrder")) : "--"
                    }
             
                    let string = dataDict.get("TotalEarning")
                    
                      if let number = Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                        if self.PAGE_TYPE != "BOOKING"{
                          self.totalVEarning.text = (dataDict.get("TotalEarning") != "" && number > 0) ? dataDict.get("CurrencySymbol") + " " + Configurations.convertNumToAppLocal(numStr: dataDict.get("TotalEarning")) : "--"
                        }else{
                            self.totalVEarning.text = (dataDict.get("TotalEarningAmount") != "" && number > 0) ?  Configurations.convertNumToAppLocal(numStr: dataDict.get("TotalEarningAmount")) : "--"
                            //self.totalVEarning.text = dataDict.get("TotalEarningAmount")
                        }
                      }else{
                          self.totalVEarning.text = "--"
                      }
                      
                      //self.totalVEarning.text =  dataDict.get("TotalEarning")
                    self.totalVRateLbl.text =  (dataDict.get("AvgRating") != "" && GeneralFunctions.parseFloat(origValue: 0.0, data: dataDict.get("AvgRating")) > 0) ? Configurations.convertNumToAppLocal(numStr: dataDict.get("AvgRating")) : "--"
                }
                
                if(dataDict.get("Action") == "1"){
                    var dataArr = dataDict.getArrObj(Utils.message_str)
                    if(self.isFirstCallFinished == false){
                        self.isFirstCallFinished = true
                    }
                    if self.PAGE_TYPE != "BOOKING" {
                            if let firstData =  dataArr[0] as? NSDictionary {
                                dataArr = firstData.getArrObj("Data")
                        }
                    }
                        for i in 0 ..< dataArr.count{
                            let dataTemp = dataArr[i] as! NSDictionary
                            
                            self.dataArrList.append(dataTemp)
                            /**
                             Calculating address height. As source location address is always available, default height of source address label (20) is minus.
                             93 is minus from screen width due to left and right margins from screen. To check label's width, kindly look into design file.
                             */
                            var sourceAddHeight : CGFloat = 0.0
                            var destAddHeight : CGFloat = 0.0
                            
                            if(dataTemp.get("eType") == "Multi-Delivery" || dataTemp.get("eType") == Utils.cabGeneralType_UberX){
                                sourceAddHeight = dataTemp.get("tSaddress").height(withConstrainedWidth: Application.screenSize.width - 134, font: UIFont(name: Fonts().regular, size: 15)!) - 18
                                //                            destAddHeight = dataTemp.get("tDaddress").height(withConstrainedWidth: Application.screenSize.width - 134, font: UIFont(name: Fonts().regular, size: 15)!) - 18
                            }else{
                                sourceAddHeight = dataTemp.get("tSaddress").height(withConstrainedWidth: Application.screenSize.width - 79, font: UIFont(name: Fonts().regular, size: 15)!) - 18
                                destAddHeight = dataTemp.get("tDaddress").height(withConstrainedWidth: Application.screenSize.width - 79, font: UIFont(name: Fonts().regular, size: 15)!) - 18
                            }
                            
                            /**
                             If destination address is not available then set destination address height to ZERO.
                             */
                            if((dataTemp.get("tDaddress") == "" && dataTemp.get("tDestAddress") == "") || dataTemp.get("eType") == "Multi-Delivery"){
                                destAddHeight = 0
                            }
                            self.extraHeightContainer.append(sourceAddHeight + destAddHeight)
                        }
                    
                    let NextPage = dataDict.get("NextPage")
                    if(NextPage != "" && NextPage != "0"){
                        self.isNextPageAvail = true
                        self.nextPage_str = Int(NextPage)!
                        
                        self.addFooterView()
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    
                    //CATransaction.begin()
                   // CATransaction.setCompletionBlock({
                        //self.setScrollSize()
                        
                    //})
//                    DispatchQueue.main.async {
//                        self.setScrollSize()
//                    }
                    self.tableView.reloadData()
                    self.perform(#selector(self.setScrollSize), with: self, afterDelay: 0.5)
                   // CATransaction.commit()
                    
                    
                    //self.perform(#selector(self.setScrollSize), with: self, afterDelay: 0.3)
                    
                }else{
                    if(isLoadingMore == false){
                        if self.tableView.tableHeaderView == nil {
                        self.msgLbl = GeneralFunctions.addMsgLbl(contentView: self.cntView, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                        }else{
                            self.msgLbl = GeneralFunctions.addMsgLbl(contentView: self.tableView, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                        }
                        
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    self.setScrollSize()
                }
                
                
            }else{
                if(isLoadingMore == false){
                    self.generalFunc.setError(uv: self)
                }
                self.setScrollSize()
            }
            self.filterContainerView.isHidden = false
            self.isLoadingMore = false
            self.loaderView.isHidden = true
            
        })
    }
    
    @objc func filterDataTapped(){
        if(appTypeFilterArr == nil){
            return
        }
        
        var filterDataTitleList = [String]()
        
        for i in 0..<appTypeFilterArr.count{
            let data_tmp = appTypeFilterArr[i] as! NSDictionary
            filterDataTitleList.append(data_tmp.get("vTitle"))
        }
        
        let openListView = OpenListView(uv: self, containerView: self.view)
        let allStr = appTypeFilterArr[0] as! NSDictionary
        
        if(allStr.count != 0){
            openListView.selectedText = self.filterdData == "" ? allStr.get("vTitle") == "" ? self.generalFunc.getLanguageLabel(origValue: "ALL", key: "LBL_ALL") : allStr.get("vTitle") : self.filterdData
        }else{
            openListView.selectedText = self.generalFunc.getLanguageLabel(origValue: "ALL", key: "LBL_ALL")
        }
        
        openListView.show(listObjects: filterDataTitleList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TYPE"), currentInst: openListView, .bottom , handler: { (selectedItemId) in
            self.vFilterParam = (self.appTypeFilterArr[selectedItemId] as! NSDictionary).get("vFilterParam")
            self.filterdData = (self.appTypeFilterArr[selectedItemId] as! NSDictionary).get("vTitle")
            self.extraHeightContainer.removeAll()
            self.dataArrList.removeAll()
            self.isLoadingMore = false
            self.nextPage_str = 1
            self.isNextPageAvail = false
            
            if(self.tableView != nil){
                self.removeFooterView()
                self.tableView.reloadData()
            }
            
            if(self.msgLbl != nil){
                self.msgLbl.isHidden = true
            }
            
            self.getDtata(isLoadingMore: false)
        })
    }
    
    @objc func filterSubDataTapped(){
        if(subFilterOptionArr == nil){
            return
        }
        
        var filterDataTitleList = [String]()
        
        for i in 0..<subFilterOptionArr.count{
            let data_tmp = subFilterOptionArr[i] as! NSDictionary
            filterDataTitleList.append(data_tmp.get("vTitle"))
        }
        
        let openListView = OpenListView(uv: self, containerView: self.view)
        openListView.selectedText = self.filterHLbl.text!
        openListView.show(listObjects: filterDataTitleList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TYPE"), currentInst: openListView, .bottom, handler: { (selectedItemId) in
            self.vSubFilterParam = (self.subFilterOptionArr[selectedItemId] as! NSDictionary).get("vSubFilterParam")
            
            if self.PAGE_TYPE == "BOOKING" {
                self.calenderView(show: false)
                if  self.vSubFilterParam.lowercased() == "past" {
                    self.selectedToDate = self.dateFormatterForAPI.string(from: self.calendarView.selectedDate!)
                    self.showCalender(show: true)
                }else {
                    self.showCalender(show: false)
                }
            }
            self.filterHLbl.text = (self.subFilterOptionArr[selectedItemId] as! NSDictionary).get("vTitle").uppercased()
            self.filterHLbl.fitText()
            
            self.extraHeightContainer.removeAll()
            self.dataArrList.removeAll()
            self.isLoadingMore = false
            self.nextPage_str = 1
            self.isNextPageAvail = false
            
            if(self.tableView != nil){
                self.removeFooterView()
                self.tableView.reloadData()
            }
            
            if(self.msgLbl != nil){
                self.msgLbl.isHidden = true
            }
            
            self.getDtata(isLoadingMore: false) 
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("numberOfRowsInSection   ==  ", self.dataArrList.count)
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.dataArrList[indexPath.item]
        print(item)
        var vBookingNo:String = ""
        if(item.get("vBookingType").uppercased() == "HISTORY" || item.get("iActive") == "Canceled" || item.get("iActive") == "Finished") {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RideHistoryUFXFinishedListTVCell", for: indexPath) as! RideHistoryUFXFinishedListTVCell
           
            cell.dataView.layer.shadowOpacity = 1.5
            cell.dataView.layer.shadowOffset = CGSize(width: 0, height: 3)
            cell.dataView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
            Utils.createRoundedView(view: cell.dataView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
            
            cell.statusView.isHidden = false
            cell.statusView.backgroundColor = UIColor.UCAColor.AppThemeColor
            if(Configurations.isRTLMode() == true){
                cell.statusView.roundCorners([.bottomRight, .topRight], radius: 4)
            }else{
                cell.statusView.roundCorners([.bottomLeft, .topLeft], radius: 4)
            }
    
            cell.rideDateLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dBooking_dateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
            cell.timeVLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dBooking_dateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateTimeOnly)
            
            if(Configurations.isRTLMode() == true){
                cell.timeVLbl.textAlignment = .left
            }else{
                cell.timeVLbl.textAlignment = .right
            }
            
            vBookingNo = Configurations.convertNumToAppLocal(numStr: item.get("vRideNo"))
            
            cell.providerNameLbl.text = item.get("vName")
            
            cell.fareLbl.text = "\(item.get("iFareNew"))"
            
            cell.providerImgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic_user")!,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            })
            
//            Utils.createRoundedView(view: cell.providerImgView, borderColor: UIColor.clear, borderWidth: 0)
            Utils.createRoundedView(view: cell.providerImgView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 15)
            let vTypeNameTxt = item.get("vServiceTitle") == "" ? item.get("vVehicleType") : item.get("vServiceTitle")
            
            cell.vTypeNameLbl.text = vTypeNameTxt.trim()
            cell.vTypeNameLbl.textColor = UIColor.init(hexString: item.get("vService_TEXT_color"))
            cell.vTypeNameLbl.textAlignment = .center
            
            cell.serviceTypeView.backgroundColor = UIColor.init(hexString: item.get("vService_BG_color")) //UIColor(hex: 0xffa524)
            
            if(vTypeNameTxt == ""){
                cell.vTypeNameLbl.isHidden = true
                cell.serviceTypeView.isHidden = true
            }
            cell.rentalPackageNameLbl.text = item.get("vPackageName")
            cell.rentalPackageNameLbl.textColor = UIColor.UCAColor.AppThemeColor_1
            cell.rentalPackageNameLbl.textAlignment = .center

                        if(item.get("vPackageName") == ""){
            //                cell.rentalPackageNameLbl.text = ""
                            cell.rentalPackageNameLbl.isHidden = true
                            cell.rentalPackageHight.constant = 0
                        }else{
                            cell.rentalPackageHight.constant = 18
                            cell.rentalPackageNameLbl.isHidden = false
                        }
            if(item.get("iActive") == "Canceled"){
                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELED_TXT")
            }else if(item.get("iActive") == "Finished"){
                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINISHED_TXT")
            }else{
                cell.statusVLbl.text = item.get("iActiveDisplay") == "" ? item.get("eStatus") : item.get("iActiveDisplay")
            }
            
            cell.statusVLbl.textAlignment = .center
            cell.statusVLbl.text =  "\(cell.statusVLbl.text!)".capitalized

            cell.bookingNoLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING"))# \(vBookingNo)"
            
            if(self.APP_TYPE.uppercased() == "RIDE-DELIVERY" || self.APP_TYPE.uppercased() == "RIDE-DELIVERY-UBERX" || self.APP_TYPE.uppercased() == "RIDE"){
                cell.rideDateLbl.isHidden = false
            }else{
                cell.rideDateLbl.isHidden = true
            }
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            
            if(item.get("eHailTrip").uppercased() == "YES"){
                cell.providerImgView.isHidden = true
                cell.profileImgViewWidth.constant = 0
            }else{
                cell.providerImgView.isHidden = false
                cell.profileImgViewWidth.constant = 60
            }
            
            return cell
        }
        
        
        if (PAGE_TYPE == "ORDER" ) { // MARK: Order History Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTVC", for: indexPath) as! OrderHistoryTVC
            cell.orderSatusLBl.backgroundColor = UIColor.UCAColor.AppThemeColor
            if(Configurations.isRTLMode() == true){
                cell.orderSatusLBl.roundCorners([.bottomRight, .topRight], radius: 5)
            }else{
                cell.orderSatusLBl.roundCorners([.bottomLeft, .topLeft], radius: 5)
            }
            
            cell.nameLbl.text  = item.get("vCompany").capitalized
            cell.orderNoLbl.text = "#\(Configurations.convertNumToAppLocal(numStr: item.get("vOrderNo")))"
            cell.dateLbl.text = "\(Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("tOrderRequestDate_Org"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: "dd MMM, yyyy (EEE)"))"
            cell.timeLbl.text = "\(Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("tOrderRequestDate_Org"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: "hh:mm a"))"
            cell.profileImg.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage:UIImage(named:"ic_no_pic_user"))
            
            cell.name2Lbl.text = item.get("UseName").capitalized
            cell.addressLbl.text = item.get("vUserAddress").capitalized
            cell.orderSatusLBl.text = "\(item.get("iStatus"))"
            cell.fareEarnLbl.text = "\(item.get("EarningFare"))"
            //cell.orderTypeLbl.text = "\(item.get("vServiceCategoryName"))"
          //  let statusBGColor  = UIColor(hexString: item.get("vService_BG_color"))
           // cell.orderTypeLbl.backgroundColor = statusBGColor
           // cell.orderTypeLbl.textColor = UIColor(hexString: item.get("vService_TEXT_color"))
            if item.get("vServiceCategoryName") != ""{
            cell.orderTypeLbl.text = "\(item.get("vServiceCategoryName"))"
            let statusBGColor  = UIColor(hexString: item.get("vService_BG_color"))
            cell.orderTypeLbl.backgroundColor = statusBGColor
            cell.orderTypeLbl.textColor = UIColor(hexString: item.get("vService_TEXT_color"))
            }
            //cell.totlLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOTAL_TXT")
            if item.get("EarningFare") == ""   {
                cell.pendingTxtLbl.isHidden = false
                cell.pendingTxtLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AMT_GENERATE_PENDING")
            }else{
                cell.pendingTxtLbl.isHidden = true
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = UIColor.clear
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RideHistoryTVCell", for: indexPath) as! RideHistoryTVCell
            
            cell.dataView.layer.shadowOpacity = 1.5
            cell.dataView.layer.shadowOffset = CGSize(width: 0, height: 3)
            cell.dataView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
            Utils.createRoundedView(view: cell.dataView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
            
            cell.statusView.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            if(Configurations.isRTLMode() == true){
                cell.statusView.roundCorners([.bottomRight, .topRight], radius: 4)
            }else{
                cell.statusView.roundCorners([.bottomLeft, .topLeft], radius: 4)
            }

            cell.rideDateLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dBooking_dateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
            cell.timeVLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dBooking_dateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateTimeOnly)
   
            if(Configurations.isRTLMode() == true){
                cell.timeVLbl.textAlignment = .left
            }else{
                cell.timeVLbl.textAlignment = .right
            }
            
            cell.pickUpLocVLbl.text = item.get("tSaddress")
            cell.destVLbl.text = item.get("tDaddress") == "" ? "----" : item.get("tDaddress")
            
            cell.destVLbl.fitText()
            cell.pickUpLocVLbl.fitText()
            
            let vTypeNameTxt = item.get("vServiceTitle") == "" ? item.get("vVehicleType") : item.get("vServiceTitle")
            cell.vehicleTypeLbl.text = vTypeNameTxt
            cell.vehicleTypeLbl.textColor = UIColor.init(hexString: item.get("vService_TEXT_color"))
            cell.vehicleTypeLbl.textAlignment = .center
            
            cell.serviceTypeView.backgroundColor = UIColor.init(hexString: item.get("vService_BG_color"))  //UIColor(hex: 0xffa524)
            
            if(vTypeNameTxt == ""){
               cell.vehicleTypeLbl.isHidden = true
               cell.serviceTypeView.isHidden = true
            }
            
            cell.pickUpLocHLbl.text = self.generalFunc.getLanguageLabel(origValue: item.get("eType") == Utils.cabGeneralType_UberX ? "Job Location" : (item.get("eType") == Utils.cabGeneralType_Deliver ? "Sender's location" : "Pick up location"), key: item.get("eType") == Utils.cabGeneralType_UberX ? "LBL_JOB_LOCATION_TXT" : (item.get("eType") == Utils.cabGeneralType_Deliver || item.get("eType") == "Multi-Delivery" ? "LBL_SENDER_LOCATION" : "LBL_PICK_UP_LOCATION")).uppercased()
            
            cell.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: item.get("eType") == Utils.cabGeneralType_Deliver || item.get("eType") == "Multi-Delivery" ? "Receiver's location" : "Destination location", key: item.get("eType") == Utils.cabGeneralType_Deliver || item.get("eType") == "Multi-Delivery" ? "LBL_RECEIVER_LOCATION" : "LBL_DEST_LOCATION").uppercased()

            vBookingNo = Configurations.convertNumToAppLocal(numStr: item.get("vRideNo"))
            
            cell.bookingNoLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING")) #\(vBookingNo)"
            
            if(self.APP_TYPE.uppercased() == "RIDE-DELIVERY" || self.APP_TYPE.uppercased() == "RIDE-DELIVERY-UBERX"){
                cell.rideDateLbl.isHidden = false
            }else{
                cell.rideDateLbl.isHidden = true
            }
            
            cell.rentalPackageNameLbl.text = item.get("vPackageName")
            cell.rentalPackageNameLbl.textColor = UIColor.UCAColor.AppThemeColor_1
            cell.rentalPackageNameLbl.textAlignment = .center

            if(item.get("vPackageName") == ""){
//                cell.rentalPackageNameLbl.text = ""
                cell.rentalPackageNameLbl.isHidden = true
                cell.rentalPackageNameLblHeight.constant = 0
            }else{
                cell.rentalPackageNameLblHeight.constant = 18
                cell.rentalPackageNameLbl.isHidden = false
            }
            
            if(item.get("eCancelled") == "Yes"){
                if(item.get("eCancelBy") == "Admin"){
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELLED_BY_ADMIN")
                }else if(item.get("eCancelBy") == "Driver"){
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key:  item.get("eType") == Utils.cabGeneralType_Ride ? "LBL_CANCELLED_BY_DRIVER" : (item.get("eType") == Utils.cabGeneralType_UberX ? "LBL_CANCELLED_BY_PROVIDER" : "LBL_CANCELLED_BY_CARRIER"))
                }else{
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELED_TXT")
                }
            }else{
                if(item.get("iActive") == "Canceled"){
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELED_TXT")
                }else if(item.get("iActive") == "Finished"){
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINISHED_TXT")
                }else {
                    if(item.get("iActive") == ""){
                        if(item.get("eStatus") == "Pending"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PENDING")
                        }else if(item.get("eStatus") == "Cancel"){
                            if(item.get("eCancelBy") == "Admin"){
                                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELLED_BY_ADMIN")
                            }else if(item.get("eCancelBy") == "Driver"){
                                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key:  item.get("eType") == Utils.cabGeneralType_Ride ? "LBL_CANCELLED_BY_DRIVER" : (item.get("eType") == Utils.cabGeneralType_UberX ? "LBL_CANCELLED_BY_PROVIDER" : "LBL_CANCELLED_BY_CARRIER"))
                            }else{
                                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELED_TXT")
                            }
                        }else if(item.get("eStatus") == "Assign"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ASSIGNED")
                        }else if(item.get("eStatus") == "Accepted"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPTED")
                        }else if(item.get("eStatus") == "Declined"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DECLINED")
                        }else if(item.get("eStatus") == "Failed"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAILED_TXT")
                        }else{
                            cell.statusVLbl.text = item.get("eStatus")
                        }
                    }else{
                        cell.statusVLbl.text = item.get("iActiveDisplay") == "" ? item.get("eStatus") : item.get("iActiveDisplay")
                    }
                }
            }
            
            cell.statusVLbl.textAlignment = .center
            cell.statusVLbl.text =  "\(cell.statusVLbl.text!)".capitalized

            cell.dashedView.backgroundColor = UIColor.clear
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                cell.dashedView.addDashedLine(color: UIColor(hex: 0x141414), lineWidth: 2, true)
            })
            
            cell.btnContainerView.isHidden = true
            cell.btnContainerViewHeight.constant = 0
            cell.btnContainerViewTop.constant = 0
            
            cell.reScheduleBookingBtn.tag = indexPath.item
            cell.reScheduleBookingBtn.clickDelegate = self

            cell.reScheduleBookingBtn.titleColor = UIColor.UCAColor.AppThemeColor
            cell.cancelBookingBtn.titleColor = UIColor.UCAColor.AppThemeColor
            cell.reScheduleBookingBtn.borderColor = UIColor.UCAColor.AppThemeColor
            cell.cancelBookingBtn.borderColor = UIColor.UCAColor.AppThemeColor
            cell.reScheduleBookingBtn.titleColor = UIColor.UCAColor.AppThemeColor
            cell.cancelBookingBtn.titleColor = UIColor.UCAColor.AppThemeColor
            
            cell.cancelBookingBtn.tag = indexPath.item
            cell.cancelBookingBtn.clickDelegate = self

            cell.reScheduleBookingBtn.btnType = item.get("showAcceptBtn").uppercased() == "YES" ? "ACCEPT_JOB" : item.get("showStartBtn").uppercased() == "YES" ? "START" : ""

            cell.reScheduleBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: item.get("showAcceptBtn").uppercased() == "YES" ? "LBL_ACCEPT_JOB" : item.get("showStartBtn").uppercased() == "YES" ? "LBL_START_TRIP" : ""))
            if(item.get("vBookingType").uppercased() == "SCHEDULE" || item.get("vBookingType").uppercased() == "PENDING"){
                
                if(item.get("showAcceptBtn").uppercased() == "YES" || item.get("showStartBtn").uppercased() == "YES"){
                    cell.btnContainerView.isHidden = false
                    cell.btnContainerViewHeight.constant = 35
                    cell.btnContainerViewTop.constant = 15
       
                }
                
                if(item.get("showDeclineBtn").uppercased() == "YES" || item.get("showCancelBtn").uppercased() == "YES"){
                    cell.btnContainerView.isHidden = false
                    cell.btnContainerViewHeight.constant = 35
                    cell.btnContainerViewTop.constant = 15

                    cell.cancelBookingBtn.btnType = item.get("showDeclineBtn").uppercased() == "YES" ? "DELINE_JOB" : item.get("showCancelBtn").uppercased() == "YES" ? "CANCEL" : ""
                    cell.cancelBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: item.get("showDeclineBtn").uppercased() == "YES" ? "LBL_DECLINE_JOB" : item.get("showCancelBtn").uppercased() == "YES" ? "LBL_CANCEL_TRIP" : ""))
                }
            }
         
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = UIColor.clear
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if(self.HISTORY_TYPE == "PAST"){
        
        let item = dataArrList[indexPath.item]
        if PAGE_TYPE == "BOOKING" {
        if(item.get("vBookingType").uppercased() == "HISTORY"){
            if (item.get("eType") == "Multi-Delivery"){
                let rideDetailUV = GeneralFunctions.instantiateViewController(pageName: "RideDetailUV") as! RideDetailUV
                rideDetailUV.iTripId = self.dataArrList[indexPath.item].get("iTripId")
                self.pushToNavController(uv: rideDetailUV)
            }else{
                let rideDetailUV = GeneralFunctions.instantiateViewController(pageName: "RideDetailUV") as! RideDetailUV
                rideDetailUV.iTripId = self.dataArrList[indexPath.item].get("iTripId")
                self.pushToNavController(uv: rideDetailUV)
            }
            }
        }else {
            let orderDetailsUv = GeneralFunctions.instantiateViewController(pageName: "OrderDetailsUV") as! OrderDetailsUV
            orderDetailsUv.orderId =  self.dataArrList[indexPath.item].get("iOrderId")
            self.pushToNavController(uv: orderDetailsUv)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let item = dataArrList[indexPath.item]
        if(item.get("vBookingType").uppercased() == "HISTORY" || item.get("iActive") == "Canceled" || item.get("iActive") == "Finished"){
            if(item.get("vPackageName") == ""){
                return 220
            }else{
            return 235
            }
           
        }
        if(indexPath.item < self.extraHeightContainer.count){
            /*UberX & Multi-Delivery Releted Height Set*/
            if((item.get("eType") == Utils.cabGeneralType_UberX ) || item.get("eType") == "Multi-Delivery") {
                if(item.get("vBookingType").uppercased() == "SCHEDULE"  || item.get("vBookingType").uppercased() == "PENDING"){
                    if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && item.get("moreServices").uppercased() == "YES" && item.get("showViewRequestedServicesBtn").uppercased() == "YES") {
                        return self.extraHeightContainer[indexPath.item] + 326
                    }else{
                        return self.extraHeightContainer[indexPath.item] + 281
                    }
                }else{
                    if((item.get("eType") == Utils.cabGeneralType_UberX && item.get("showViewDetailBtn").uppercased() == "YES") || (item.get("eType") == "Multi-Delivery" && item.get("showLiveTrackBtn").uppercased() == "YES" || item.get("showViewDetailBtn").uppercased() == "YES")){
                        return self.extraHeightContainer[indexPath.item] + 281
                    }else{
                        return self.extraHeightContainer[indexPath.item] + 228
                    }
                }
            }else{
                /*Ride & Delivery Releted Height Set*/
                if(item.get("vBookingType").uppercased() == "SCHEDULE"  || item.get("vBookingType").uppercased() == "PENDING"){
                    if(item.get("showReScheduleBtn").uppercased() == "YES" || item.get("showCancelBtn").uppercased() == "YES"){
                        return self.extraHeightContainer[indexPath.item] + 312
                    }else{
                        return self.extraHeightContainer[indexPath.item] + 262
                    }
                }else{
                    if PAGE_TYPE == "ORDER" {
                            tableView.estimatedRowHeight = 282
                            tableView.rowHeight = UITableView.automaticDimension
                            return UITableView.automaticDimension
                    }
                    return item.get("vPackageName") == "" ? self.extraHeightContainer[indexPath.item] + 262 : self.extraHeightContainer[indexPath.item] + 282
                }
            }
        }else{
            if(item.get("eType") == Utils.cabGeneralType_UberX || item.get("eType") == "Multi-Delivery") {
                return 322 /*Default Cell Height*/
            }else{
                return 326 /*Default Cell Height*/
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y;
        
        if(scrollView == self.scrollView){

            if(currentOffset >= 280 && self.calendarView.isHidden == false){
                self.dropDownImgView.image = self.dropDownImgView.image?.rotate(180)
                self.calenderView(show: false)
                self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: false)
            }

        }
        
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        
        if (maximumOffset - currentOffset <= 15) {
            
            if(isNextPageAvail==true && isLoadingMore==false){
                
                isLoadingMore=true
                
                getDtata(isLoadingMore: isLoadingMore)
            }
        }
    }
    
    func addFooterView(){
        if isLoadingMore {
            let loaderView =  self.generalFunc.addMDloader(contentView: self.tableView, isAddToParent: false)
            loaderView.backgroundColor = UIColor.clear
            loaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 80)
            self.tableView.tableFooterView  = loaderView
            self.tableView.tableFooterView?.isHidden = false
        }
    }
    
    func removeFooterView(){
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
    }
    
        // For Pull To Refersh
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
        self.extraHeightContainer.removeAll()
        self.dataArrList.removeAll()
        self.isLoadingMore = false
        self.nextPage_str = 1
        self.isNextPageAvail = false
        
        if(self.tableView != nil){
            self.removeFooterView()
            self.tableView.reloadData()
        }
        
        if(self.msgLbl != nil){
            self.msgLbl.isHidden = true
        }
        
        self.getDtata(isLoadingMore: false)
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender.btnType == "CANCEL"){
            cancelBooking(position: sender.tag, bookingType: self.dataArrList[sender.tag].get("eType"))
        }else if(sender.btnType == "MORE_SERVICES"){
            
            let index = sender.tag
            let item = dataArrList[index]
            
        }else if(sender.btnType == "START"){
            
            let bookingType = self.dataArrList[sender.tag].get("eType")
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: bookingType == Utils.cabGeneralType_Deliver ? "LBL_CONFIRM_START_DELIVERY" : (bookingType == Utils.cabGeneralType_UberX ?  "LBL_CONFIRM_START_JOB" : "LBL_CONFIRM_START_TRIP_TXT")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_YES_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_NO_TXT"), completionHandler: { (btnClickedIndex) in
                
                if(btnClickedIndex == 0){
                    self.generateTrip(position: sender.tag)
                }
            })
        }else if(sender.btnType == "ACCEPT_JOB"){
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Are you sure, you want to accept this job?", key: "LBL_CONFIRM_ACCEPT_JOB"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_YES_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_NO_TXT"), completionHandler: { (btnClickedIndex) in
                
                if(btnClickedIndex == 0){
                    self.updateBookingStatus(status: "Accepted", iCabBookingId: self.dataArrList[sender.tag].get("iCabBookingId"), vCancelReason: "", position: sender.tag, eConfirmByProvider: "No")
                }
            })
            
        }else if(sender.btnType == "DELINE_JOB"){
            updateBookingStatus(status: "Declined", iCabBookingId: self.dataArrList[sender.tag].get("iCabBookingId"), vCancelReason: "", position: sender.tag, eConfirmByProvider: "Yes")
        }
//        else if(sender.btnType == "CANCEL_BOOKING"){
//            //FIXME: manage bookingType
//            cancelBooking(position: sender.tag, bookingType: "")
//        }
    }
    
    func updateBookingStatus(status:String, iCabBookingId:String, vCancelReason:String, position:Int, eConfirmByProvider:String){
        
        if(status == "Declined" && vCancelReason == ""){
            cancelBooking(position: position, bookingType: self.dataArrList[position].get("eType"))
            return
        }
        
        let parameters = ["type":"UpdateBookingStatus", "iDriverId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "eStatus": status, "iCabBookingId": iCabBookingId, "vCancelReason": vCancelReason, "eConfirmByProvider": eConfirmByProvider]//, "DataType": self.HISTORY_TYPE
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                        
                        self.dataArrList.removeAll()
                        self.isLoadingMore = false
                        self.nextPage_str = 1
                        self.isNextPageAvail = false
                        self.tableView.reloadData()
                        if(self.msgLbl != nil){
                            self.msgLbl.isHidden = true
                        }
                        self.getDtata(isLoadingMore: false)
                        
                    })
                    
                }else{
                    
                    if (dataDict.get("Action") == "0" && dataDict.get("BookingFound").uppercased() == "YES"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "We found that you have booking with same time slot. Are you sure you want to accept?", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedId) in
                            
                            if(btnClickedId == 0){
                                self.updateBookingStatus(status: status, iCabBookingId: iCabBookingId, vCancelReason: vCancelReason, position: position, eConfirmByProvider: "Yes")
                            }
                            
                        })
                        
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                    
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func generateTrip(position:Int){
        
        if(self.currentLocation == nil){
            self.currentLocation = CLLocation.init(latitude: 0.0, longitude: 0.0)
        }
        
        let parameters = ["type":"GenerateTrip", "DriverID": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iCabBookingId": self.dataArrList[position].get("iCabBookingId"), "GoogleServerKey": Configurations.getGoogleServerKey(),"vLatitude" : "\(currentLocation!.coordinate.latitude)","vLongitude" : "\(currentLocation!.coordinate.longitude)"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let window = Application.window
                    
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                    
                }else{
                    if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                        return
                    }
                    if(dataDict.get("DO_RELOAD").uppercased() == "YES"){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnId) in
                            self.dataArrList.removeAll()
                            self.isLoadingMore = false
                            self.nextPage_str = 1
                            self.isNextPageAvail = false
                            self.tableView.reloadData()
                            if(self.msgLbl != nil){
                                self.msgLbl.isHidden = true
                            }
                            self.getDtata(isLoadingMore: false)
                        })
                        
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) != "" && dataDict.get(Utils.message_str) == "LBL_DRIVER_BLOCK"){
                        if(dataDict.get("isShowContactUs") == "Yes"){
                            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                    self.pushToNavController(uv: contactUsUv)
                                }
                                
                            })
                            return
                        }else{
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                            
                            return
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
    
    func cancelBooking(position:Int, bookingType:String){
        
        //        cancelBookingView.bookingType = bookingType
        //        cancelBookingView.PAGE_TYPE = self.HISTORY_TYPE
        
        let openCancelBooking = OpenCancelBooking(uv: self)
        openCancelBooking.cancelTrip(eTripType: bookingType, PAGE_TYPE: "", iTripId: "", iCabBookingId: self.dataArrList[position].get("iCabBookingId")) { (iCancelReasonId, reason) in
            self.continueCancelBooking(iCabBookingId: self.dataArrList[position].get("iCabBookingId"), iCancelReasonId: iCancelReasonId, reason: reason)
        }
    }
    
    func continueCancelBooking(iCabBookingId: String, iCancelReasonId:String, reason:String){
        let parameters = ["type":"cancelBooking", "iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iCancelReasonId": iCancelReasonId, "iCabBookingId": iCabBookingId, "Reason": reason,"vLatitude" : "\(currentLocation!.coordinate.latitude)","vLongitude" : "\(currentLocation!.coordinate.longitude)"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.isLoadingMore = false
                        self.extraHeightContainer.removeAll()
                        self.dataArrList.removeAll()
                        self.tableView.reloadData()
                        self.nextPage_str = 1
                        self.getDtata(isLoadingMore: false)
                    })
                }else{
                    if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                        return
                    }
                    
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
}

//extension BookingsUV{
//
//
//
//    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        //        let dateString = gregorianFormatter.string(from: calendar.currentPage)
//
//        self.monthLabel.text = "\(Utils.convertDateFormateInAppLocal(date: calendar.currentPage, toDateFormate: "MMMM yyyy"))"
//
//        //        let date = Utils.convertStringToDate(dateStr: "\(dateString)", dateFormat: "yyyy-MM-dd")
//        currentPageDate = calendar.currentPage
//
//    }
//
//    @objc func previousMonthImgTapped(){
//
//        let cal = Calendar(identifier: .gregorian)
//        let date = cal.date(byAdding: .month, value: -1, to: currentPageDate)
//
//        calendarView.setCurrentPage(date!, animated: true)
//    }
//
//    @objc func nextMonthImgTapped(){
//        let cal = Calendar(identifier: .gregorian)
//        let date = cal.date(byAdding: .month, value: 1, to: currentPageDate)
//
//        calendarView.setCurrentPage(date!, animated: true)
//    }
//
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//        let dateString = gregorianFormatter.string(from: date)
//
//        let selectedDayRideHistoryUV = GeneralFunctions.instantiateViewController(pageName: "SelectedDayRideHistoryUV") as! SelectedDayRideHistoryUV
//        selectedDayRideHistoryUV.selectedDate = dateString
//        self.pushToNavController(uv: selectedDayRideHistoryUV)
//
//        if monthPosition == .previous || monthPosition == .next {
//            calendar.setCurrentPage(date, animated: true)
//        }
//    }
//
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
//
//        let registrationDate = userProfileJson.get("RegistrationDate")
//
//        return Utils.convertStringToDate(dateStr: registrationDate, dateFormat: "yyyy-MM-dd")
//    }
//
//    func maximumDate(for calendar: FSCalendar) -> Date {
//        let currentDate = Utils.getCurrentDateInGrogrian(dateFormat: "yyyy-MM-dd", timeZone: "GMT")
//        self.currentPageDate = Date()
//        Utils.printLog(msgData: "currentDate::MAX:\(currentDate)")
//        return Date()
//    }
//
//
//
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.calendarHeightConstraint.constant = bounds.height
//        self.view.layoutIfNeeded()
//    }
//
//}


extension BookingsUV:XFSCalendarDelegate,XFSCalendarDataSource {
    
    func calendar(_ calendar: XFSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarView.frame.size.height = bounds.height
    }
    
    func calendar(_ calendar: XFSCalendar, didSelect date: Date, at monthPosition: XFSCalendarMonthPosition) {
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        titleDateLbl!.text = self.dateFormatter.string(from: date)
        selectedToDate = self.dateFormatterForAPI.string(from: date)
        self.curentSelectedDate = date
        self.extraHeightContainer.removeAll()
        self.dataArrList.removeAll()
        self.isLoadingMore = false
        self.nextPage_str = 1
        self.isNextPageAvail = false
        
        if(self.tableView != nil){
            self.removeFooterView()
            self.tableView.reloadData()
        }
        
        if(self.msgLbl != nil){
            self.msgLbl.isHidden = true
        }
        self.calenderView(show: false)
        self.getDtata(isLoadingMore: false)
    }
    
    private func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    private func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    private func minimumDate(for calendar: FSCalendar) -> Date {
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        minimumDate  = Utils.convertDateGregorianToAppLocale(date: userProfileJson.get("RegistrationDate"), dateFormate: "yyyy-MM-dd")
        let registrationDate = userProfileJson.get("RegistrationDate")
        
        return Utils.convertStringToDate(dateStr: registrationDate, dateFormat: "yyyy-MM-dd")
    }
  
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        if !Configurations.isRTLMode() {
//            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
//            minimumDate  = Utils.convertDateGregorianToAppLocale(date: userProfileJson.get("RegistrationDate"), dateFormate: "yyyy-MM-dd")
//            return minimumDate
//        }else {
//            return Date()
//        }
//    }
}
