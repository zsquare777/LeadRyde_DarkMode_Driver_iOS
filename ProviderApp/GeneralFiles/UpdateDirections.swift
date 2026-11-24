//
//  UpdateDirections.swift
//  DriverApp
//
//  Created by ADMIN on 27/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import GoogleMaps

@objc protocol OnDirectionUpdateDelegate:class
{
    func onDirectionUpdate(directionResultDict:NSDictionary)
}

class UpdateDirections: NSObject, OnLocationUpdateDelegate {
    
    var userLocation:CLLocation!
    var timer:Timer!
    var uv:UIViewController!
    
    var getLoc:GetLocation!
    var gMap:GMSMapView!
    var navigateView:navigationVIew!
    var navigationView:NavigateView!
    
    var destinationLocation:CLLocation!
    var fromLocation:CLLocation!
    
    var listOfPoints = [String()]
    
    var listOfPaths = [GMSPolyline]()
    
    let generalFunc = GeneralFunctions()
    
    var eTollSkipped = ""
    
    var isCurrentLocationEnabled = true
    
    var onDirectionUpdateDelegate:OnDirectionUpdateDelegate!
    var userProfileJson:NSDictionary!
    var totalDefaultViewHeight:CGFloat = 0
    
    var ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP = ""
    var DRIVER_ARRIVED_MIN_TIME_PER_MINUTE = ""
    
    var topNavViewHeight:CGFloat = 80
    
    var DESTINATION_UPDATE_TIME_INTERVAL_value:Double = 30
    

    init(uv:UIViewController, gMap:GMSMapView, destinationLocation:CLLocation, navigateView:navigationVIew){
        self.uv = uv
        self.gMap = gMap
        self.destinationLocation = destinationLocation
        self.navigateView = navigateView

        super.init()
    }
    
    init(uv:UIViewController, gMap:GMSMapView, destinationLocation:CLLocation, navigateView:NavigateView){
        self.uv = uv
        self.gMap = gMap
        self.destinationLocation = destinationLocation
        self.navigationView = navigateView
        
        super.init()
    }

    
    init(uv:UIViewController, gMap:GMSMapView, fromLocation:CLLocation, destinationLocation:CLLocation, isCurrentLocationEnabled:Bool){
        self.uv = uv
        self.gMap = gMap
        self.fromLocation = fromLocation
        self.destinationLocation = destinationLocation
        self.isCurrentLocationEnabled = isCurrentLocationEnabled
        
        super.init()
    }
    
    func setCurrentLocEnabled(isCurrentLocationEnabled:Bool){
        self.isCurrentLocationEnabled = isCurrentLocationEnabled
    }
 
    func addReleaseObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
    }
    
    func scheduleDirectionUpdate(eTollSkipped:String){
        self.eTollSkipped = eTollSkipped
        addReleaseObserver()
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        /*Initial AddressLbl Text Set*/
        if(navigationView != nil){
            navigationView.addressLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOAD_ADDRESS").uppercased()
            
            if(self.uv.isKind(of: DriverArrivedUV.self)){
                let driverArrivedUv = self.uv as! DriverArrivedUV
                driverArrivedUv.timeLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOADING_TXT")
                driverArrivedUv.distanceLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOADING_TXT")
            }
            
            if(self.uv.isKind(of: ActiveTripUV.self)){
                let activeTripUv = self.uv as! ActiveTripUV
                activeTripUv.timeLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOADING_TXT")
                activeTripUv.distanceLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOADING_TXT")
            }

        }
        
        ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP = GeneralFunctions.getValue(key: Utils.ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP_KEY) as! String
        DRIVER_ARRIVED_MIN_TIME_PER_MINUTE = GeneralFunctions.getValue(key: Utils.DRIVER_ARRIVED_MIN_TIME_PER_MINUTE_KEY) as! String
        
        if(timer != nil){
            timer!.invalidate()
        }
        let DESTINATION_UPDATE_TIME_INTERVAL = GeneralFunctions.getValue(key: "DESTINATION_UPDATE_TIME_INTERVAL")
        
        
        DESTINATION_UPDATE_TIME_INTERVAL_value = GeneralFunctions.parseDouble(origValue: 30, data: DESTINATION_UPDATE_TIME_INTERVAL == nil ? "30" : (DESTINATION_UPDATE_TIME_INTERVAL as! String)) * 60
        
        startTimer()
        
        if(isCurrentLocationEnabled){
            if(getLoc == nil){
                getLoc = GetLocation(uv: self.uv, isContinuous: true)
                getLoc.buildLocManager(locationUpdateDelegate: self)
            }else{
                getLoc.buildLocManager(locationUpdateDelegate: self)
                getLoc.resumeLocationUpdates()
            }
        }
    }
    
   private func startTimer(){
        if(timer != nil){
            timer!.invalidate()
            timer = nil
        }
        
        timer =  Timer.scheduledTimer(timeInterval: DESTINATION_UPDATE_TIME_INTERVAL_value, target: self, selector: #selector(updateDirections), userInfo: nil, repeats: true)
        
        timer.fire()
    }
    
    func startDirectionUpdate(){
        startTimer()
    }
    
    func pauseDirectionUpdate(){
        if(timer != nil){
            timer!.invalidate()
        }
    }
    
    func stopFrequentUpdate(){
        if(timer != nil){
            timer!.invalidate()
        }
        
        if(getLoc != nil){
            getLoc.releaseLocationTask()
            getLoc.locationUpdateDelegate = nil
        }
    }
    
    @objc func releaseTask(){
        if(timer != nil){
            timer!.invalidate()
            timer = nil
        }
        
        if(getLoc != nil){
            getLoc.releaseLocationTask()
            getLoc.locationUpdateDelegate = nil
            getLoc = nil
        }
        
        for i in 0..<self.listOfPaths.count{
            self.listOfPaths[i].map = nil
        }
        
        self.listOfPaths.removeAll()
        self.listOfPoints.removeAll()
       
        GeneralFunctions.removeObserver(obj: self)
    }
    
    func onLocationUpdate(location: CLLocation) {
       
        if(self.userLocation == nil){
            self.userLocation = location
            updateDirections()
        }
        
        self.userLocation = location
    }
    
    @objc func updateDirections(){
        let fromLocation = userLocation == nil ? self.fromLocation : userLocation
        let destinationLocation = self.destinationLocation
        
//        if(gMap == nil || destinationLocation == nil || userLocation == nil || destinationLocation!.coordinate.latitude == 0.0 || destinationLocation!.coordinate.longitude == 0.0){
//            return
//        }

        if(gMap == nil || destinationLocation == nil || fromLocation == nil || destinationLocation!.coordinate.latitude == 0.0 || destinationLocation!.coordinate.longitude == 0.0){
            return
        }
        
        if(ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP.uppercased() == "NO"){

            if(self.navigationView != nil){

                var distance = destinationLocation!.distance(from: fromLocation!) / 1000
                
                let time_value_str = GeneralFunctions.parseDouble(origValue: 2, data: DRIVER_ARRIVED_MIN_TIME_PER_MINUTE) * distance * 60
                let time_str = Utils.formateSecondsToHours(seconds: "\(time_value_str)")
                
                if(userProfileJson != nil && userProfileJson.get("eUnit") != "KMs"){
                    distance = distance *  0.621371
                }
                
                var distance_str = ""
                
                if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
                    distance_str = "\(String(format: "%.02f", distance)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT"))"
                }else{
                    distance_str = "\(String(format: "%.02f", distance)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_DISTANCE_TXT"))"
                }
                
                /* If set to Time & Distance Value in Driverarrived Screen*/
                if(self.uv .isKind(of: DriverArrivedUV.self)){
                    let driverArrivedUv = self.uv as! DriverArrivedUV

                    driverArrivedUv.timeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EST_TXT") + " " + "\(time_str)"
                    driverArrivedUv.distanceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EST_TXT") + " " + "\(distance_str)"

                }
                
                /* If set to Time & Distance Value in ActiveTripUV Screen*/
                if(self.uv .isKind(of: ActiveTripUV.self)){
                    let activeTripUV = self.uv as! ActiveTripUV
                    
                    activeTripUV.timeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EST_TXT") + " " + "\(time_str)"
                    activeTripUV.distanceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EST_TXT") + " " + "\(distance_str)"
                }
                
                self.setDestAddress()
                
                if(self.gMap != nil){
                    var bounds = GMSCoordinateBounds()
                    bounds = bounds.includingCoordinate(fromLocation!.coordinate)
                    bounds = bounds.includingCoordinate(destinationLocation!.coordinate)
                    let edgeInsets = UIEdgeInsets.init(top: topNavViewHeight + 20, left: 10, bottom: 120 + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 10)
                    let update = GMSCameraUpdate.fit(bounds, with: edgeInsets)
                    self.gMap.animate(with: update)
                }
            }
        }else{
            
            let mapDic = MapDictionary.init(p_latitude: "\(fromLocation!.coordinate.latitude)", p_longitude: "\(fromLocation!.coordinate.longitude)", d_latitude: "\(destinationLocation!.coordinate.latitude)", d_longitude: "\(destinationLocation!.coordinate.longitude)", max_latitude: "", max_longitude: "", min_latitude: "", min_longitude: "", search_query: "", isPickUpMode: "", session_token:"", toll_skipped:eTollSkipped, place_id:"", waypoints_Str: "", errorLbl: nil, loaderView: nil)
            MapServiceAPI.shared().getDirectionService(mapDictionary: mapDic, isOpenLoader: false, isAlertShow: false, uv: self.uv) { (pointsArray, sourceAddress, endAddress, distance, duration, waypointsArray, serviceName, routesArray) in
                
                if(pointsArray.count == 0){
                    self.setDestAddress()
                    return
                }
                
                if(self.onDirectionUpdateDelegate != nil){
                    let dic = ["duration":duration, "distance":distance, "pointsArray":pointsArray, "sourceAddress":sourceAddress, "endAddress": endAddress, "waypointsArray":waypointsArray, "serviceName": serviceName] as NSDictionary
                    self.onDirectionUpdateDelegate!.onDirectionUpdate(directionResultDict: dic)
                }
                
                var time_str = Utils.formateSecondsToHours(seconds: duration)
                
                var distance_final = GeneralFunctions.parseDouble(origValue: 0.0, data: distance)
                
                if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
                    distance_final = distance_final * 0.000621371
                }else{
                    distance_final = distance_final * 0.00099999969062399994
                }
                
                distance_final = distance_final.roundTo(places: 2)
                
                var distance_str = ""
                
                if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
                    distance_str = "\(String(format: "%.02f", distance_final)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT"))"
                }else{
                    distance_str = "\(String(format: "%.02f", distance_final)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_DISTANCE_TXT"))"
                }
                
                time_str = Configurations.convertNumToAppLocal(numStr: time_str)
                distance_str = Configurations.convertNumToAppLocal(numStr: distance_str)
                
                if(self.navigationView != nil){
                    /* If set to Time & Distance Value in Driverarrived Screen*/
                    
                    if(self.uv .isKind(of: DriverArrivedUV.self)){
                        let driverArrivedUv = self.uv as! DriverArrivedUV
                        
                        driverArrivedUv.timeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EST_TXT") + " " + "\(time_str)"
                        driverArrivedUv.distanceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EST_TXT") + " " + "\(distance_str)"
                    }
                    
                    /* If set to Time & Distance Value in ActiveTripUV Screen*/
                    if(self.uv .isKind(of: ActiveTripUV.self)){
                        let activeTripUV = self.uv as! ActiveTripUV
                        
                        activeTripUV.distance_final = distance_final
                        activeTripUV.timeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EST_TXT") + " " + "\(time_str)"
                        activeTripUV.distanceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EST_TXT") + " " + "\(distance_str)"
                        
                    }
                    
                    self.setDestAddress()
                }
                
                // FLY Changes
                if(self.uv != nil && self.uv!.isKind(of: ActiveTripUV.self)){
                    if((self.uv as! ActiveTripUV).tripData.get("eFly").uppercased() == "YES"){
                        return
                    }
                }
                
                if(self.uv != nil && self.uv!.isKind(of: CabRequestedUV.self)){
                    if(((self.uv as! CabRequestedUV).passengerJsonDetail_dict!.get("eFly").uppercased() == "YES") || ((self.uv as! CabRequestedUV).passengerJsonDetail_dict!.get("ePoolRequest").uppercased() == "YES")){
                        return
                    }
                }
                
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
            }
           
        }
    }
    
    func setDestAddress(){
        if(self.navigationView != nil){
            /* If set to Address in DriverArrivedUV Screen*/
            if(self.uv .isKind(of: DriverArrivedUV.self)){
                let driverArrivedUv = self.uv as! DriverArrivedUV
                let tSaddress = driverArrivedUv.tripData!.get("tSaddress")

                var destAddrHeight = tSaddress.height(withConstrainedWidth: Application.screenSize.width - 140, font: self.navigationView.addressLbl.font!) - 60
                
                if(destAddrHeight < 0){
                    destAddrHeight = 0
                }
                
                self.navigationView.addressLbl.text = tSaddress.uppercased()
                self.navigationView.addressLbl.numberOfLines = 0
                
                //                self.navigationView.addressLbl.fitText()
                
                if(totalDefaultViewHeight < 1){
                    self.totalDefaultViewHeight = (self.uv as! DriverArrivedUV).topContainerViewHeight.constant
                }
                
                (self.uv as! DriverArrivedUV).topNavigationView.frame.size.height = 90 + destAddrHeight
                (self.uv as! DriverArrivedUV).topNavigationView.view.frame.size.height = 90 + destAddrHeight
                (self.uv as! DriverArrivedUV).topContainerViewHeight.constant =  self.totalDefaultViewHeight + destAddrHeight
                
                topNavViewHeight = (self.uv as! DriverArrivedUV).topContainerViewHeight.constant
                
            }else if(self.uv .isKind(of: ActiveTripUV.self)){ /* If set to Address in ActiveTripUV Screen*/
                let activeTripUv = self.uv as! ActiveTripUV
                
                let tDaddress = activeTripUv.tripData!.get("tDaddress")
                var destAddrHeight = tDaddress.height(withConstrainedWidth: Application.screenSize.width - 156, font: self.navigationView.addressLbl.font!) - 60
                
                if(destAddrHeight < 0){
                    destAddrHeight = 0
                }
                
                self.navigationView.addressLbl.text = tDaddress.uppercased()
                self.navigationView.addressLbl.numberOfLines = 0
                
                //                self.navigationView.addressLbl.fitText()

                if(totalDefaultViewHeight < 1){
                    self.totalDefaultViewHeight = (self.uv as! ActiveTripUV).topContainerViewHeight.constant
                }
                
                (self.uv as! ActiveTripUV).topNavigationView.frame.size.height = 90 + destAddrHeight
                (self.uv as! ActiveTripUV).topNavigationView.view.frame.size.height = 90 + destAddrHeight
                (self.uv as! ActiveTripUV).topContainerViewHeight.constant =  self.totalDefaultViewHeight + destAddrHeight
                
                topNavViewHeight = (self.uv as! ActiveTripUV).topContainerViewHeight.constant
                
            }
        }
    }

    func addPolyLineWithEncodedStringInMap(encodedString: String, _ pathFromPoints:GMSMutablePath? = nil) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: encodedString == "" ? pathFromPoints : path)
        polyLine.strokeWidth = 5
        polyLine.strokeColor = UIColor.black
        polyLine.map = gMap
        
        self.listOfPaths += [polyLine]
    }
}
