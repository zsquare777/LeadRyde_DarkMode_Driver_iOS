//
//  SearchPlacesUV.swift
//  DriverApp
//
//  Created by ADMIN on 20/11/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import CoreLocation

protocol OnPlaceSelectDelegate {
    func onPlaceSelected(location:CLLocation, address:String, searchBar:UISearchBar, searchPlaceUv:SearchPlacesUV)
    func onPlaceSelectCancel(searchBar:UISearchBar, searchPlaceUv:SearchPlacesUV)
}

class SearchPlacesUV: UIViewController, UISearchBarDelegate, MyLabelClickDelegate, UITableViewDelegate, UITableViewDataSource, OnLocationUpdateDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var existingPlacesView: UIView!
    @IBOutlet weak var searchPlaceTableView: UITableView!
    
    @IBOutlet weak var placesHLbl: MyLabel!
    @IBOutlet weak var homeLocAreaView: UIView!
    @IBOutlet weak var homeLocHLbl: MyLabel!
    @IBOutlet weak var homeLocVLbl: MyLabel!
    @IBOutlet weak var homeLocEditImgView: UIImageView!
    @IBOutlet weak var homeLocImgView: UIImageView!
  
    
    @IBOutlet weak var setLocMapAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var setLocMapLbl: MyLabel!
    @IBOutlet weak var setLocRightArrowImgView: UIImageView!
    @IBOutlet weak var setLocOnMapAreaView: UIView!
    @IBOutlet weak var pinImgView: UIImageView!
    
    @IBOutlet weak var recentLocationHLbl: MyLabel!
    @IBOutlet weak var generalHAreaView: UIView!
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet weak var generalAreaViewHeight: NSLayoutConstraint!
    @IBOutlet weak var recentLocTableView: UITableView!
    
    let generalFunc = GeneralFunctions()
    
    
    let searchBar = UISearchBar()
    var userProfileJson:NSDictionary!
    
    var locationBias:CLLocation!
    
    var placeSelectDelegate:OnPlaceSelectDelegate?
    
    var isScreenLoaded = false
    
    var isScreenKilled = false
    
    var isHomePlaceAdded = false
   
    var dataArrList = [RecentLocationItem]()
    var searchPlaceDataArr = [SearchLocationItem]()
    
    var cntView:UIView!
    
    var PAGE_HEIGHT:CGFloat = 310
    
    var keyboardHeightSet = false
    
    var cancelLbl:MyLabel!
    
    var loaderView:UIView!
    
    var placeSearchExeServerTask:ExeServerUrl!
    
    var fromAddAddress = false
    
    var isFromSelectLoc = false
    
    var getLocation:GetLocation!
    
    var currentLocation:CLLocation!
    
    var getAddressFrmLocation:GetAddressFromLocation!
    
    var SCREEN_TYPE = ""
    
    var currentSearchQuery = ""
    
    var defaultPageHeight:CGFloat = 0
    
    var errorLbl:MyLabel!
    
    var homeLoc:CLLocation!
    
    var currentCabType = ""
    
    var finalPageHeight:CGFloat = 0
    
    var isFromDeliverAll = false
    var session_token = ""
    
    var sessionTokenFreqTask:UpdateFreqTask!
    var MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE:Int = 2
    
    var isForDriverDestinations = false
    
    var favoriteLocationArray = NSMutableArray()
    var FAV_HOME = "0"
    var FAV_LOC_MAP = "1"
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        if(isScreenKilled){
            self.closeCurrentScreen()
        }
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.sizeToFit()
        
        searchBar.delegate = self
        
        if #available(iOS 13, *) {
            searchBar.searchTextField.backgroundColor = UIColor.white
        }
        
        scrollView.keyboardDismissMode = .onDrag
        
        searchBar.setImage(UIImage(named:"ic_search_nav")?.setTintColor(color: UIColor.UCAColor.AppThemeColor), for: .search, state: .normal)
        //if(currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && userProfileJson.get("APP_DESTINATION_MODE").uppercased() == "NONSTRICT" && isDriverAssigned == false){
           self.PAGE_HEIGHT = self.PAGE_HEIGHT + 50
        //}
        
        //        navItem.titleView = searchBar
        let textWidth = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").width(withConstrainedHeight: 29, font: UIFont(name: Fonts().light, size: 17)!)
        searchBar.frame.size = CGSize(width: Application.screenSize.width - 55 - textWidth, height: 40)
        searchBar.tintColor = UIColor.UCAColor.AppThemeColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:searchBar)
        
        cancelLbl = MyLabel()
        cancelLbl.font = UIFont(name: Fonts().light, size: 17)!
        cancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
        cancelLbl.setClickDelegate(clickDelegate: self)
        cancelLbl.fitText()
        cancelLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.navigationItem.titleView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:cancelLbl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE = GeneralFunctions.parseInt(origValue: 2, data: userProfileJson.get("MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE"))

        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        
        if(isScreenLoaded == false){
            cntView = self.generalFunc.loadView(nibName: "SearchPlacesScreenDesign", uv: self, contentView: scrollView)
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT > scrollView.frame.height ? PAGE_HEIGHT : scrollView.frame.height)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT > scrollView.frame.height ? PAGE_HEIGHT : scrollView.frame.height)
            finalPageHeight = self.cntView.frame.size.height
            
            self.scrollView.addSubview(cntView)
            self.scrollView.bounces = false
            
            
            isScreenLoaded = true
            
            
            self.recentLocTableView.bounces = false
            
            setData()
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        
        self.searchBar.becomeFirstResponder()
        
//        searchBar.becomeFirstResponder()
    }
    
    override func closeCurrentScreen() {
        if(sessionTokenFreqTask != nil){
            sessionTokenFreqTask.stopRepeatingTask()
        }
        super.closeCurrentScreen()
    }
    
    @objc func releaseAllTask(){
        
        if(getAddressFrmLocation != nil){
            getAddressFrmLocation!.addressFoundDelegate = nil
            getAddressFrmLocation = nil
        }
        
        if(self.getLocation != nil){
            self.getLocation!.locationUpdateDelegate = nil
            self.getLocation!.releaseLocationTask()
            self.getLocation = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
    }
    
    func setData(){
        self.placesHLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.placesHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.searchPlaceTableView.isHidden = true
        
        if(fromAddAddress != true){
            self.recentLocationHLbl.isHidden = false
            self.recentLocationHLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
            self.recentLocationHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        }else{
            self.recentLocationHLbl.isHidden = true
        }
        
        
        self.recentLocationHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Recent Locations", key: "LBL_RECENT_LOCATIONS")
        self.placesHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Favorite Places", key: "LBL_FAV_LOCATIONS")
        
        self.setLocMapLbl.text = self.generalFunc.getLanguageLabel(origValue: "Set location on map", key: "LBL_SET_LOC_ON_MAP")
        

        if(isForDriverDestinations == true){
            
            let locOnMapTapGue = UITapGestureRecognizer()
            locOnMapTapGue.addTarget(self, action: #selector(self.findLocOnMap))
            self.setLocOnMapAreaView.isUserInteractionEnabled = true
            self.setLocOnMapAreaView.addGestureRecognizer(locOnMapTapGue)
            
           // self.recentLocTableView.register(UINib(nibName: "RecentLocationTVCell", bundle: nil), forCellReuseIdentifier: "RecentLocationTVCell")
            self.recentLocTableView.register(UINib(nibName: "ProfileTVCell", bundle: nil), forCellReuseIdentifier: "ProfileTVCell")
            
            self.existingPlacesView.isHidden = false
            self.recentLocTableView.dataSource = self
            self.recentLocTableView.delegate = self
            
            self.recentLocTableView.bounces = false
            self.recentLocTableView.keyboardDismissMode = .onDrag
            
            var frame = CGRect.zero
            frame.size.height = 1
            recentLocTableView.tableHeaderView = UIView(frame: frame)
            self.recentLocTableView.tableHeaderView?.backgroundColor = UIColor(hex: 0xf1f1f1)
            
            recentLocTableView.tableFooterView = UIView(frame: frame)
            self.recentLocTableView.tableFooterView?.backgroundColor = UIColor(hex: 0xf1f1f1)
            
//            self.recentLocTableView.tableFooterView = UIView()
//            self.recentLocTableView.tableFooterView?.backgroundColor = UIColor(hex: 0xf1f1f1)
        }
        
        self.searchPlaceTableView.dataSource = self
        self.searchPlaceTableView.delegate = self
        
        checkPlaces()
        
        self.searchPlaceTableView.register(UINib(nibName: "GPAutoCompleteListTVCell", bundle: nil), forCellReuseIdentifier: "GPAutoCompleteListTVCell")
        self.recentLocTableView.tableFooterView = UIView()
        
        
        if #available(iOS 15.0, *) {
            self.recentLocTableView.sectionHeaderTopPadding = 0
        } else {}

        
        let power_googleImgView = UIImageView()
        power_googleImgView.image = UIImage(named: "ic_powered_google_light_bg")!.imageWithInsets(insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 15))
        power_googleImgView.contentMode = .bottomRight
        power_googleImgView.frame.size.height = 25
        self.searchPlaceTableView.tableFooterView = power_googleImgView
        
        if(self.isFromSelectLoc == true || GeneralFunctions.getMemberd() == ""){
            
            if(GeneralFunctions.getMemberd() == "") {
                self.generalHAreaView.isHidden = true
                self.generalAreaViewHeight.constant = 0
            }else{
                
                self.setLocMapAreaHeight.constant = 0
                self.setLocOnMapAreaView.isHidden = true
                self.existingPlacesView.isHidden = true
            }
            
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.setLocRightArrowImgView, color: UIColor(hex: 0x6F6F6F))
       
//        GeneralFunctions.setImgTintColor(imgView: self.pinImgView, color: UIColor.UCAColor.AppThemeColor_1)
//        GeneralFunctions.setImgTintColor(imgView: self.desLaterImgView, color: UIColor.UCAColor.AppThemeColor_1)
        
        if(Configurations.isRTLMode()){
            self.setLocRightArrowImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
          
        }
        
        
    }
    
    
    func onAddressFound(address: String, location: CLLocation, isPickUpMode: Bool, dataResult: String) {
//        self.userLocationAddress = address
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelected(location: location, address: address, searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    func onLocationUpdate(location: CLLocation) {
        self.currentLocation = location
        self.locationBias = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.getLocation.locationUpdateDelegate = nil
        self.getLocation.releaseLocationTask()
        self.getLocation = nil
    }
    

    @objc func keyboardWillDisappear(sender: NSNotification){
        let info = sender.userInfo!
        _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
//        if(keyboardHeightSet){
        changeContentSize(PAGE_HEIGHT: finalPageHeight)
//        changeContentSize(PAGE_HEIGHT: (self.PAGE_HEIGHT - keyboardSize))
            keyboardHeightSet = false
//        }
    }
    @objc func keyboardWillAppear(sender: NSNotification){
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        finalPageHeight = self.PAGE_HEIGHT
//        if(Application.screenSize.height < (keyboardSize + self.PAGE_HEIGHT)){
            changeContentSize(PAGE_HEIGHT: (keyboardSize + self.PAGE_HEIGHT))
            keyboardHeightSet = true
//        }
    }
    
    func changeContentSize(PAGE_HEIGHT:CGFloat){
        self.PAGE_HEIGHT = PAGE_HEIGHT
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
//        cntView.backgroundColor = UIColor.blue
//        recentLocTableView.backgroundColor = UIColor.clear
//        existingPlacesView.backgroundColor = UIColor.clear
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //        for(id subview in [yourSearchBar subviews])
        //        {
        //            if ([subview isKindOfClass:[UIButton class]]) {
        //                [subview setEnabled:YES];
        //            }
        //        }
        
        Utils.printLog(msgData: "EndEditing")
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        Utils.printLog(msgData: "Begin Editing")
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(self.currentSearchQuery == searchText.trim()){
            return
        }
        if(session_token == ""){
            session_token = "\(Utils.appUserType)_\(GeneralFunctions.getMemberd())_\(Utils.currentTimeMillis())"
            initializeSessionRegeneration()
        }
        self.currentSearchQuery = searchText.trim()
        fetchAutoCompletePlaces(searchText: searchText.trim())
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        self.closeCurrentScreen()
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelectCancel(searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    func initializeSessionRegeneration(){
        if(self.sessionTokenFreqTask != nil){
            self.sessionTokenFreqTask.stopRepeatingTask()
        }
        let freqTask = UpdateFreqTask(interval: 170)
        freqTask.currInst = freqTask
        freqTask.setTaskRunHandler { (instance) in
            self.session_token = "\(Utils.appUserType)_\(GeneralFunctions.getMemberd())_\(Utils.currentTimeMillis())"
        }
        self.sessionTokenFreqTask = freqTask
        freqTask.startRepeatingTask()
    }

    func fetchAutoCompletePlaces(searchText:String){
        
        if(searchText.count < MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE){
           
            self.searchPlaceTableView.isHidden = true
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
            
            if(self.errorLbl != nil){
                self.errorLbl.isHidden = true
            }
            
            return
        }else{
//            defaultPageHeight = self.PAGE_HEIGHT

            self.existingPlacesView.isHidden = true
            self.searchPlaceTableView.isHidden = false
        }
        
        self.searchPlaceDataArr.removeAll()
        self.searchPlaceTableView.reloadData()
        
        if(self.errorLbl != nil){
            self.errorLbl.isHidden = true
        }else{
            self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
            self.errorLbl?.isHidden = true
        }
        
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
        
        let session_token = self.session_token

        
        let lat = locationBias != nil ? "\(locationBias.coordinate.latitude)" : ""
        let long = locationBias != nil ? "\(locationBias.coordinate.longitude)" : ""
        
        let mapDic = MapDictionary.init(p_latitude: lat, p_longitude: long, d_latitude: "", d_longitude: "", max_latitude: lat, max_longitude: long, min_latitude: lat, min_longitude: long, search_query: searchText, isPickUpMode:"NO", session_token:session_token, toll_skipped:"", place_id:"", waypoints_Str: "", errorLbl: self.errorLbl, loaderView: loaderView)
        MapServiceAPI.shared().getAutoCompleteService(mapDictionary: mapDic, isOpenLoader: false, isAlertShow: false, uv: self, tableView:self.searchPlaceTableView) { (responseArray, sessionToken, nil, serviceName) in
            if(self.currentSearchQuery != searchText){
                return
            }else{
                for i in 0..<responseArray.count{
                    let item = responseArray[i]
                    
                    let searchLocItem = SearchLocationItem(placeId: item.get("PlaceId"), mainAddress: item.get("place_title") == "" ? item.get("address") : item.get("place_title"), subAddress: item.get("place_title") == "" ? "" : item.get("place_sub_title"), description: item.get("address"), session_token: sessionToken, location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("longitude"))))
                    
                    self.searchPlaceDataArr += [searchLocItem]
                    DispatchQueue.main.async {
                        self.searchPlaceTableView.reloadData()
                    }
                    
                }
            }
        }
       
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //fetchPlaecFromTxt(searchText: searchBar.text ?? "")
    }
    
    func fetchPlaecFromTxt(searchText:String){
        
        if(searchText.count < MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE){
            self.existingPlacesView.isHidden = self.isFromSelectLoc == true ? true : false
            self.searchPlaceTableView.isHidden = true
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
            
            if(self.errorLbl != nil){
                self.errorLbl.isHidden = true
            }
            
            return
        }else{
            //            defaultPageHeight = self.PAGE_HEIGHT
            
            self.existingPlacesView.isHidden = true
            self.searchPlaceTableView.isHidden = false
        }
        
        self.searchPlaceDataArr.removeAll()
        self.searchPlaceTableView.reloadData()
        
        if(self.errorLbl != nil){
            self.errorLbl.isHidden = true
        }
        
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
    
        
        var autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(searchText)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true&inputtype=textquery&fields=photos,formatted_address,name,rating,geometry"
        
        if(locationBias != nil){
            autoCompleteUrl = "\(autoCompleteUrl)&location=\(locationBias.coordinate.latitude),\(locationBias.coordinate.longitude)&radius=20000"
        }
        
        if(placeSearchExeServerTask != nil){
            placeSearchExeServerTask.cancel()
            placeSearchExeServerTask = nil
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: false)
        self.placeSearchExeServerTask = exeWebServerUrl
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(self.currentSearchQuery != searchText){
                return
            }
            
            if(response != ""){
                
                
                if(self.errorLbl != nil){
                    self.errorLbl.isHidden = true
                }
                
                if(self.searchPlaceTableView.isHidden == true){
                    self.loaderView.isHidden = true
                    return
                }
                let dataDict = response.getJsonDataDict()
                
                print(dataDict)
                if(dataDict.get("status").uppercased() == "OK"){
                    
                    let predictionsArr = dataDict.getArrObj("candidates")
                    
                    for i in 0..<predictionsArr.count{
                        let item = predictionsArr[i] as! NSDictionary
                        
                        if(item.get("formatted_address") != ""){
                            let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.getObj("geometry").getObj("location").get("lat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.getObj("geometry").getObj("location").get("lng")))
                            
                            let searchLocItem = SearchLocationItem(placeId: "", mainAddress: item.get("formatted_address"), subAddress: "", description: "", session_token: "", location: location)
                            
                            self.searchPlaceDataArr += [searchLocItem]
                        }
                        
                    }
                    
                    self.searchPlaceTableView.reloadData()
                    
                }else if(dataDict.get("status") == "ZERO_RESULTS"){
                    if(self.errorLbl != nil){
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT")
                    }else{
                        self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
                        
                        self.errorLbl.isHidden = false
                    }
                    
                }else{
                    if(self.errorLbl != nil){
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                    }else{
                        self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                        
                        self.errorLbl.isHidden = false
                    }
                }
                
                
            }else{
                //                self.generalFunc.setError(uv: self)
                if(self.errorLbl != nil){
                    self.errorLbl.isHidden = false
                    self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                }else{
                    self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                    self.errorLbl.isHidden = false
                }
            }
            
            self.loaderView.isHidden = true
        }, url: autoCompleteUrl)
    }
    
    @objc func addDestLaterTapped(){
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelected(location: CLLocation(latitude: 0.0, longitude: 0.0), address: "DEST_SKIPPED", searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    @objc func findLocOnMap(){
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
        addDestinationUv.isForDriverDestinations = self.isForDriverDestinations
        
        addDestinationUv.centerLocation = self.locationBias
        
        self.pushToNavController(uv: addDestinationUv)
    }
    
    @objc func homePlaceTapped(){
        //        self.closeCurrentScreen()
        //        self.mainScreenUV.continueLocationSelected(selectedLocation: , selectedAddress: (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String))
        
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelected(location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLatitude") as! String), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLongitude") as! String)), address: (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String), searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    @objc func workPlaceTapped(){
        //        self.closeCurrentScreen()
        //        self.mainScreenUV.continueLocationSelected(selectedLocation: , selectedAddress: )
        
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelected(location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLatitude") as! String), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLongitude") as! String)), address: (GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String), searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.placesHLbl){
            
        }else if(sender == self.homeLocHLbl || sender == self.homeLocVLbl){
            if(isHomePlaceAdded){
                homePlaceTapped()
            }else{
                homePlaceEditTapped()
            }
        }else if(self.cancelLbl != nil && sender == cancelLbl){
            searchBarCancelButtonClicked(self.searchBar)
        }
    }
    
    
    func getHomePlaceTapGue() -> UITapGestureRecognizer{
        let homePlaceTapGue = UITapGestureRecognizer()
        homePlaceTapGue.addTarget(self, action: #selector(self.homePlaceTapped))
        
        return homePlaceTapGue
    }
    
    func getWorkPlaceTapGue() -> UITapGestureRecognizer{
        let workPlaceTapGue = UITapGestureRecognizer()
        workPlaceTapGue.addTarget(self, action: #selector(self.workPlaceTapped))
        
        return workPlaceTapGue
    }
    
    func checkRecentPlaces(){
        
        self.dataArrList.removeAll()
     
        let destLocations = userProfileJson.getArrObj("DestinationLocations")
        
        for i in 0..<destLocations.count{
            let currentItem = destLocations[i] as! NSDictionary
            
            let recentLocItem = RecentLocationItem(location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("tDestLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("tDestLongitude"))), address: currentItem.get("tDaddress"))
            
            self.dataArrList += [recentLocItem]
        }
        
       self.recentLocTableView.isHidden = false
        
        var dataArrHeight:CGFloat = 0
        
        for i in 0..<self.dataArrList.count{
            let address = self.dataArrList[i].address
            var height = address!.height(withConstrainedWidth: Application.screenSize.width - 120, font: UIFont(name: Fonts().light, size: 15)!)
            if(height < 55){
                height = 55
            }
            height = height + 12
            dataArrHeight = dataArrHeight + height
        }
        
        PAGE_HEIGHT = PAGE_HEIGHT + dataArrHeight
        self.finalPageHeight = PAGE_HEIGHT
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        self.recentLocTableView.isScrollEnabled = false
        self.recentLocTableView.reloadData()
        
    }
    
    func checkPlaces(){
        
        if(fromAddAddress != true){
            checkRecentPlaces()
        }
        
        let userHomeLocationAddress = GeneralFunctions.getValue(key: "userHomeLocationAddress") != nil ? (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String) : ""
       
        if(userHomeLocationAddress != ""){
            isHomePlaceAdded = true
            
            let finalStr = NSMutableAttributedString.init(string: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_PLACE") + "\n")
            
            let attributedTitleString = NSMutableAttributedString(string:(GeneralFunctions.getValue(key: "userHomeLocationAddress") as? String ?? ""))
            let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.init(name: Fonts().semibold, size: 13)]
            attributedTitleString.addAttributes(yourOtherAttributes as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributedTitleString.length))
            finalStr.append(attributedTitleString)
            
            let homeLatitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLatitude") as! String)
            let homeLongitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLongitude") as! String)
            
            self.favoriteLocationArray.add(Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_PLACE"), image: "ic_search_home", id: FAV_HOME, attributedTitle:finalStr, rightSideImage: "ic_edit"))
            
            self.homeLoc = CLLocation(latitude: homeLatitude, longitude: homeLongitude)
            
        }else{
            self.favoriteLocationArray.add(Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_HOME_PLACE_TXT"), image: "ic_search_home", id: FAV_HOME, attributedTitle:NSMutableAttributedString.init(string: ""), rightSideImage: "ic_add_plus"))
            isHomePlaceAdded = false
        }
        
        self.homeLocHLbl.setClickDelegate(clickDelegate: self)
        self.homeLocVLbl.setClickDelegate(clickDelegate: self)
        
        self.homeLocImgView.isUserInteractionEnabled = true
        self.homeLocImgView.addGestureRecognizer(self.getHomePlaceTapGue())
        
        if(fromAddAddress != true){
            self.favoriteLocationArray.add(Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "Set location on map", key: "LBL_SET_LOC_ON_MAP"), image: "ic_search_locmap", id:FAV_LOC_MAP, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: ""))
        }
        
        self.recentLocTableView.reloadData()
       
    }
    
    @objc func homePlaceEditTapped(){
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
        addDestinationUv.isForDriverDestinations = self.isForDriverDestinations
        addDestinationUv.SCREEN_TYPE = "HOME"
      
        self.pushToNavController(uv: addDestinationUv)
    }
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(tableView == recentLocTableView){
            if(self.dataArrList.count > 0){
                return 2
            }else{
                return 1
            }
            
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(tableView == self.searchPlaceTableView){
            return self.searchPlaceDataArr.count
        }
        
        if(section == 0 && tableView == recentLocTableView){
            return self.favoriteLocationArray.count
        }
        
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == self.searchPlaceTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "GPAutoCompleteListTVCell", for: indexPath) as! GPAutoCompleteListTVCell
            
            let item = self.searchPlaceDataArr[indexPath.item]
            
            cell.mainTxtLbl.text = item.mainAddress
            cell.secondaryTxtLbl.text = item.subAddress
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            
            return cell
        }
        
        if(tableView == self.recentLocTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCell", for: indexPath) as! ProfileTVCell
            cell.selectionStyle = .none
            if(indexPath.section == 0){
                let headerData = self.favoriteLocationArray[indexPath.row] as! Headline
                if(headerData.attributedTitle == NSMutableAttributedString.init(string: "")){
                    cell.titleLbl.text = headerData.title
                }else{
                    cell.titleLbl.attributedText = headerData.attributedTitle
                }
                
                cell.iconImgView.backgroundColor = getRandomColor()
                
                cell.iconImgView.image = UIImage(named:headerData.image)!.addImagePadding(x: 20, y: 20)
                GeneralFunctions.setImgTintColor(imgView: cell.iconImgView, color: UIColor.white)
                
                var rightImage = ""
                if(headerData.rightSideImage == ""){
                    rightImage = "ic_arrow_right"
                }else{
                    rightImage = headerData.rightSideImage
                }

                cell.nextArrowContainerView.tag = Int(headerData.id)!
                
                cell.nextArrowContainerView.setOnClickListener { (instance) in
                    
                    if("\(instance.tag)" == self.FAV_HOME){
                        self.homePlaceEditTapped()
                    }
                    
                    
                }
            
                if(headerData.id == FAV_HOME){
                    if(Configurations.isRTLMode()){
                        cell.nextArrowImgView.image = UIImage(named:rightImage)?.addImagePadding(x: 22, y: 22)?.rotate(180)
                    }else{
                        cell.nextArrowImgView.image = UIImage(named:rightImage)?.addImagePadding(x: 22, y: 22)
                    }
                }else{
                    if(Configurations.isRTLMode()){
                        cell.nextArrowImgView.image = UIImage(named:rightImage)?.rotate(180)
                    }else{
                        cell.nextArrowImgView.image = UIImage(named:rightImage)
                    }
                }
                
                GeneralFunctions.setImgTintColor(imgView: cell.nextArrowImgView, color: UIColor.lightGray)
                
            }else{
                
                let item = self.dataArrList[indexPath.item]
                cell.titleLbl.text = item.address
                
                cell.titleLbl.text = item.address
                cell.iconImgView.backgroundColor = getRandomColor()
                cell.iconImgView.image = UIImage(named:"ic_search_dest")?.addImagePadding(x: 20, y: 20)
                GeneralFunctions.setImgTintColor(imgView: cell.iconImgView, color: UIColor.white)
                if(Configurations.isRTLMode()){
                    cell.nextArrowImgView.image = UIImage(named:"ic_arrow_right")?.rotate(180)
                }else{
                    cell.nextArrowImgView.image = UIImage(named:"ic_arrow_right")
                }
                GeneralFunctions.setImgTintColor(imgView: cell.nextArrowImgView, color: UIColor.lightGray)
                
            }
            return cell
        }
        return UITableViewCell()
       
    }
    
    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == self.searchPlaceTableView){
            let item = self.searchPlaceDataArr[indexPath.item]
            if(item.location != nil && item.location?.coordinate.latitude != 0.0 && item.location?.coordinate.longitude != 0.0){
                let location = item.location!
                
                if(self.placeSelectDelegate != nil){
                    self.placeSelectDelegate?.onPlaceSelected(location: location, address: item.description, searchBar: self.searchBar, searchPlaceUv: self)
                }
            }else{
                findPlaceDetail(placeId: item.placeId, description: item.description, session_token: item.session_token)
            }
            return
        }
        
        if(indexPath.section == 0 && tableView == self.recentLocTableView){
            let selectedFAVRow = (self.favoriteLocationArray[indexPath.row] as! Headline).id
            
            switch selectedFAVRow {
            case FAV_HOME:
                if(isHomePlaceAdded){
                    homePlaceTapped()
                }else{
                    homePlaceEditTapped()
                }
                break
            case FAV_LOC_MAP:
                self.findLocOnMap()
                break
            default:
                break
            }
            return
        }
        
        let item = self.dataArrList[indexPath.item]
        
        //        self.closeCurrentScreen()
        //        self.mainScreenUV.continueLocationSelected(selectedLocation: item.location, selectedAddress: item.address)
        
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelected(location: item.location, address: item.address, searchBar: self.searchBar, searchPlaceUv: self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if(tableView == self.searchPlaceTableView){
            tableView.estimatedRowHeight = 1500
            tableView.rowHeight = UITableView.automaticDimension
            return UITableView.automaticDimension
        }
        
        if(tableView == self.recentLocTableView){
            if(indexPath.section == 0){
                let selectedFAVRow = (self.favoriteLocationArray[indexPath.row] as! Headline).id
                if(selectedFAVRow == FAV_HOME && isHomePlaceAdded){
                    return 90
                }else{
                    return 55
                }
            }else{
                let address = self.dataArrList[indexPath.row].address
                var height = address!.height(withConstrainedWidth: Application.screenSize.width - 120, font: UIFont(name: Fonts().light, size: 15)!)
                if(height < 55){
                    height = 55
                }
                height = height + 12
                return height
            }
            
        }
        
        tableView.estimatedRowHeight = 1500
        tableView.rowHeight = UITableView.automaticDimension
        if(UITableView.automaticDimension < 50){
            return 50
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView == self.recentLocTableView){
            return 55
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(tableView == self.recentLocTableView){
            let view = UIView.init(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 55))
            view.backgroundColor = UIColor(hex: 0xf1f1f1)
            
            let label = UILabel.init(frame: CGRect(x:15, y:10, width: tableView.frame.size.width - 40, height: 45))
            label.font = UIFont.init(name: Fonts().semibold, size: 17)
            label.numberOfLines = 2
            label.textColor = UIColor.black
            if(section == 0){
                label.text = self.generalFunc.getLanguageLabel(origValue: "Favorite Places", key: "LBL_FAV_LOCATIONS")
            }else if(section == 1){
                label.text = self.generalFunc.getLanguageLabel(origValue: "Recent Locations", key: "LBL_RECENT_LOCATIONS")
            }
            view.addSubview(label)
            return view
        }else{
            var frame = CGRect.zero
            frame.size.height = 1
            let view = UIView(frame: frame)
            view.backgroundColor = UIColor.clear
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func findPlaceDetail(placeId:String, description:String, session_token:String){
        
        if(placeId != ""){
            let mapDic = MapDictionary.init(p_latitude: "", p_longitude: "", d_latitude: "", d_longitude: "", max_latitude: "", max_longitude: "", min_latitude: "", min_longitude: "", search_query: "", isPickUpMode: "", session_token:session_token, toll_skipped:"", place_id:placeId, waypoints_Str: "", errorLbl: nil, loaderView: nil)
            MapServiceAPI.shared().getPlaceDetailService(mapDictionary: mapDic, isOpenLoader: true, isAlertShow: false, uv: self) { (location, serviceName) in
                
                if(self.placeSelectDelegate != nil){
                    
                    self.placeSelectDelegate?.onPlaceSelected(location: location, address: description, searchBar: self.searchBar, searchPlaceUv: self)
                }
            }
        }
        
    }
    
    @IBAction func unwindToSearchPlaceScreen(_ segue:UIStoryboardSegue) {
        //        unwindToSignUp
        
        if(segue.source.isKind(of: AddDestinationUV.self))
        {
            let addDestinationUv = segue.source as! AddDestinationUV
            let selectedLocation = addDestinationUv.selectedLocation
            let selectedAddress = addDestinationUv.selectedAddress
            
            GeneralFunctions.setSelectedLocations(latitude: selectedLocation!.coordinate.latitude, longitude: selectedLocation!.coordinate.longitude, address: selectedAddress, type: addDestinationUv.SCREEN_TYPE)
            
            //            self.mainScreenUV.continueLocationSelected(selectedLocation: selectedLocation, selectedAddress: selectedAddress)
            if(self.placeSelectDelegate != nil){
                self.placeSelectDelegate?.onPlaceSelected(location: selectedLocation!, address: selectedAddress, searchBar: self.searchBar, searchPlaceUv: self)
            }
            
        }
    }
}

class SearchLocationItem {
    
    var placeId:String!
    var mainAddress:String!
    var subAddress:String!
    var description:String!
    var session_token:String!
    var location:CLLocation?
    
    // MARK: Initialization
    
    init(placeId: String, mainAddress:String, subAddress:String, description:String, session_token: String, location:CLLocation?) {
        // Initialize stored properties.
        self.placeId = placeId
        self.mainAddress = mainAddress
        self.subAddress = subAddress
        self.description = description
        self.session_token = session_token
        self.location = location
        
    }
}
