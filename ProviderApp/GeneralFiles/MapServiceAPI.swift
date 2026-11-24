////
////  MapServiceAPI.swift
////  PassengerApp
////
////  Created by Apple on 11/11/19.
////  Copyright © 2019 @. All rights reserved.
////
//
//import UIKit
//import CoreLocation
//
//class MapDictionary {
//    
//    var p_latitude:String = ""
//    var p_longitude:String = ""
//    var d_latitude:String = ""
//    var d_longitude:String = ""
//    var max_latitude:String = ""
//    var max_longitude:String = ""
//    var min_latitude:String = ""
//    var min_longitude:String = ""
//    var search_query:String = ""
//    var isPickUpMode:String = ""
//    var session_token:String = ""
//    var toll_skipped:String = ""
//    var place_id:String = ""
//    var waypoints_Str:String = ""
//    var errorLbl:MyLabel? = nil
//    var loaderView:UIView? = nil
//    
//    init(p_latitude:String, p_longitude:String, d_latitude:String, d_longitude:String,max_latitude:String, max_longitude:String, min_latitude:String, min_longitude:String, search_query:String, isPickUpMode:String, session_token:String, toll_skipped:String, place_id:String, waypoints_Str:String, errorLbl:MyLabel?, loaderView:UIView?) {
//        
//        self.p_latitude = p_latitude
//        self.p_longitude = p_longitude
//        self.d_latitude = d_latitude
//        self.d_longitude = d_longitude
//        self.max_latitude = max_latitude
//        self.max_longitude = max_longitude
//        self.min_latitude = min_latitude
//        self.min_longitude = min_longitude
//        self.search_query = search_query
//        self.isPickUpMode = isPickUpMode
//        self.session_token = session_token
//        self.toll_skipped = toll_skipped
//        self.place_id = place_id
//        self.errorLbl = errorLbl
//        self.loaderView = loaderView
//        self.waypoints_Str = waypoints_Str
//    }
//}
//
//
//class MapServiceAPI: NSObject {
//
//    typealias ReverseGeoCodeHandler = (_ address:String, _ location:CLLocation, _ isPickUpMode:Bool, _ dataResult:String, _ serviceName:String) -> Void
//    typealias AutoCompleteHandler = (_ placesArray:[NSDictionary], _ session_token:String, _ location:CLLocation?, _ serviceName:String) -> Void
//    typealias DirectionHandler = (_ pointsArray:[NSDictionary], _ startAddress:String, _ endAddress:String, _ distance:String, _ time:String, _ waypoints_Array:[Int], _ serviceName:String, _ rotesArray:[NSDictionary]) -> Void
//    typealias PlaceDetailHandler = (_ location:CLLocation, _ serviceName:String) -> Void
//    
//    public static var sharedMapServiceAPI:MapServiceAPI?
//    var userProfileJson:NSDictionary!
//    let generalFunc = GeneralFunctions()
//    
//    var placeSearchExeServerTask:ExeServerUrl!
//    var webMapAPIPRFX = ""
//    var webMapAPIDB = ""
//    
//    static func shared() -> MapServiceAPI{
//        if(sharedMapServiceAPI == nil){
//            sharedMapServiceAPI = MapServiceAPI()
//            sharedMapServiceAPI!.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
//        }
//        sharedMapServiceAPI!.webMapAPIPRFX = GeneralFunctions.getValue(key: "GOOGLE_API_REPLACEMENT_URL") as! String
//        sharedMapServiceAPI!.webMapAPIDB = GeneralFunctions.getValue(key: "TSITE_DB") as! String
//        
//        return sharedMapServiceAPI!
//    }
//    
//    
//    // MARK: Reverse Geocode Service
//    func getGeoCodeService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, completionHandler: @escaping ReverseGeoCodeHandler){
//        
//        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
//        
//        var geoCodeUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(mapDictionary.p_latitude),\(mapDictionary.p_longitude)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=ture"
//        
//        if(fromWeb == true){
//            geoCodeUrl = "\(webMapAPIPRFX)reversegeocode?language_code=en&latitude=\(mapDictionary.p_latitude)&longitude=\(mapDictionary.p_longitude)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=ture&TSITE_DB=\(webMapAPIDB)"
//        }
//        
//        Utils.printLog(msgData: "geoCodeUrl::\(geoCodeUrl)")
//        
//        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
//        
//        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
//            
//            if(response != ""){
//                
//                let dataDict = response.getJsonDataDict()
//                if(fromWeb == true){
//                    
//                    if(dataDict.get("Action") == "0"){
//                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
//                        return
//                    }
//                    
//                    completionHandler(dataDict.get("address"), CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("longitude"))), mapDictionary.isPickUpMode.uppercased() == "YES" ? true : false, response, dataDict.get("vServiceName"))
//                }else{
//                    
//                    
//                    if(dataDict.get("status").uppercased() != "OK" || dataDict.getArrObj("results").count == 0){
//                        completionHandler("", CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: "0.0"), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: "0.0")), mapDictionary.isPickUpMode.uppercased() == "YES" ? true : false, response, "Google")
//                        return
//                    }
//                    
//                    let resultsArr = dataDict.getArrObj("results")
//                    
//                    let address = (resultsArr.object(at: 0) as! NSDictionary).get("formatted_address")
//                    
//                    let addressArr = address.split{$0 == ","}.map(String.init)
//                    
//                    var finalAddress = ""
//                    
//                    for i in 0..<addressArr.count {
//                        
//                       // if(addressArr[i].containsIgnoringCase(find: "Unnamed Road") == false && addressArr[i].isNumeric() == false){
//                            finalAddress = finalAddress == "" ? addressArr[i] : "\(finalAddress), \(addressArr[i])"
//                       // }
//                    }
//                    
//                    completionHandler(finalAddress, CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.p_latitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.p_longitude)), mapDictionary.isPickUpMode.uppercased() == "YES" ? true : false, response, "Google")
//                }
//                
//                
//            }else{
//                if(isAlertShow){
//                    self.generalFunc.setError(uv: uv)
//                }
//                
//            }
//        }, url: geoCodeUrl)
//        
//    }
//    
//    // MARK: Autocomplete Service
//    func getAutoCompleteService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, tableView:UITableView?, completionHandler: @escaping AutoCompleteHandler){
//        
//        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
//        
//        var autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?location=\(mapDictionary.p_latitude),\(mapDictionary.p_longitude)&input=\(mapDictionary.search_query)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true&sessiontoken=\(mapDictionary.session_token)&radius=20000"
//        
//
//        if(fromWeb == true){
//            autoCompleteUrl = "\(webMapAPIPRFX)autocomplete?language_code=\(Configurations.getGoogleMapLngCode())&latitude=\(mapDictionary.p_latitude)&longitude=\(mapDictionary.p_longitude)&search_query=\(mapDictionary.search_query)&max_latitude=\(mapDictionary.max_latitude)&max_longitude=\(mapDictionary.max_longitude)&min_latitude=\(mapDictionary.min_latitude)&min_longitude=\(mapDictionary.min_longitude)&session_token=\(mapDictionary.session_token)&TSITE_DB=\(webMapAPIDB)"
//        
//        }
//        
//        Utils.printLog(msgData: "autoCompleteUrl::\(autoCompleteUrl)")
//        if(placeSearchExeServerTask != nil){
//            placeSearchExeServerTask.cancel()
//            placeSearchExeServerTask = nil
//        }
//        
//        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
//        self.placeSearchExeServerTask = exeWebServerUrl
//        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
//            
//            
//            if(response != ""){
//                
//                if(mapDictionary.errorLbl != nil){
//                    mapDictionary.errorLbl?.isHidden = true
//                }
//                
//                let dataDict = response.getJsonDataDict()
//                
//                if(tableView != nil){
//                    if(dataDict.get("vServiceName").uppercased() == "GOOGLE" || fromWeb == false){
//                        let power_googleImgView = UIImageView()
//                        power_googleImgView.image = UIImage(named: "ic_powered_google_light_bg")!.imageWithInsets(insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 15))
//                        power_googleImgView.contentMode = .bottomRight
//                        power_googleImgView.frame.size.height = 25
//                        tableView!.tableFooterView = power_googleImgView
//                    }else{
//                        var frame = CGRect.zero
//                        frame.size.height = 1
//                        tableView!.tableFooterView = UIView()
//                        
//                        if #available(iOS 15.0, *) {
//                            tableView!.sectionHeaderTopPadding = 0
//                        } else {}
//                    }
//                }
//                
//                
//                if(fromWeb == true){
//                    
//                    if(dataDict.get("Action") == "0"){
//                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
//                        return
//                    }
//                    
//                    let predictionsArr = dataDict.getArrObj("data")
//                    if(predictionsArr.count > 0){
//                        
//                        var finalArray = [NSDictionary]()
//                        for i in 0..<predictionsArr.count{
//                            let item = predictionsArr[i] as! NSDictionary
//                            
//                            let dataDic = ["PlaceId": item.get("PlaceId"), "place_title": item.get("place_title"), "place_sub_title": item.get("place_sub_title"), "address": item.get("address"), "session_token": mapDictionary.session_token, "latitude": item.get("latitude"), "longitude": item.get("longitude")]
//                            
//                            finalArray.append(dataDic as NSDictionary)
//                            
//                        }
//                        
//                        
//                        
//                        completionHandler(finalArray, mapDictionary.session_token, nil, dataDict.get("vServiceName"))
//                        
//                        
//                        
//                    }else if(predictionsArr.count == 0){
//                        if(mapDictionary.errorLbl != nil){
//                            mapDictionary.errorLbl?.isHidden = false
//                            mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT")
//                        }else{
//                            mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
//                            
//                            mapDictionary.errorLbl?.isHidden = false
//                            
//                        }
//                        
//                    }else{
//                        if(mapDictionary.errorLbl != nil){
//                            mapDictionary.errorLbl?.isHidden = false
//                            mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
//                        }else{
//                            mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
//                            
//                            mapDictionary.errorLbl?.isHidden = false
//                        }
//                    }
//                    
//                }else{
//                    
//                    if(dataDict.get("status").uppercased() == "OK"){
//                        
//                        var finalArray = [NSDictionary] ()
//                        let predictionsArr = dataDict.getArrObj("predictions")
//                        
//                        for i in 0..<predictionsArr.count{
//                            let item = predictionsArr[i] as! NSDictionary
//                            
//                            //if(item.get("place_id") != ""){
//                                let structured_formatting = item.getObj("structured_formatting")
//                                
//                                let dataDic = ["PlaceId": item.get("place_id"), "place_title": structured_formatting.get("main_text"), "place_sub_title": structured_formatting.get("secondary_text"), "address": item.get("description"), "session_token": mapDictionary.session_token, "location": nil]
//                              
//                                finalArray.append(dataDic as NSDictionary)
//                           // }
//                            
//                        }
//                        
//                        completionHandler(finalArray, mapDictionary.session_token, nil, "Google")
//                        
//                    }else if(dataDict.get("status") == "ZERO_RESULTS"){
//                        if(mapDictionary.errorLbl != nil){
//                            mapDictionary.errorLbl?.isHidden = false
//                            mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT")
//                        }else{
//                            mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
//                            
//                            mapDictionary.errorLbl?.isHidden = false
//                            
//                        }
//                        
//                    }else{
//                        if(mapDictionary.errorLbl != nil){
//                            mapDictionary.errorLbl?.isHidden = false
//                            mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
//                        }else{
//                            mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
//                            
//                            mapDictionary.errorLbl?.isHidden = false
//                        }
//                    }
//                }
//            }else{
//                //                self.generalFunc.setError(uv: self)
//                if(mapDictionary.errorLbl != nil){
//                    mapDictionary.errorLbl?.isHidden = false
//                    mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
//                }else{
//                    mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
//                    mapDictionary.errorLbl?.isHidden = false
//                }
//            }
//            
//            if(mapDictionary.loaderView != nil){
//                mapDictionary.loaderView?.isHidden = true
//            }
//            
//        }, url: autoCompleteUrl)
//        
//    }
//    
//    // MARK: Direction Service
//    func getDirectionService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, completionHandler: @escaping DirectionHandler){
//        
//        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
//        
//        var directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(mapDictionary.p_latitude),\(mapDictionary.p_longitude)&destination=\(mapDictionary.d_latitude),\(mapDictionary.d_longitude)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true"
//        
//        if(mapDictionary.toll_skipped.uppercased() == "YES"){
//            directionURL = "\(directionURL)&avoid=tolls"
//        }
//        
//        if(userProfileJson != nil && userProfileJson.get("eUnit") != "KMs"){
//            directionURL = "\(directionURL)&units=imperial"
//        }
//        
//        if(fromWeb == true){
//       
//            let latLongArray = mapDictionary.waypoints_Str.components(separatedBy: "|")
//            
//            directionURL = "\(webMapAPIPRFX)direction?language_code=\(Configurations.getGoogleMapLngCode())&source_latitude=\(mapDictionary.p_latitude)&source_longitude=\(mapDictionary.p_longitude)&dest_latitude=\(mapDictionary.d_latitude)&dest_longitude=\(mapDictionary.d_longitude)&language=\(Configurations.getGoogleMapLngCode())&sensor=ture&toll_avoid=\(mapDictionary.toll_skipped)&waypoints=\(latLongArray.convertToJson())&TSITE_DB=\(webMapAPIDB)"
//        }
//        
//        Utils.printLog(msgData: "DirectionURL::\(directionURL)")
//        
//        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
//        
//        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
//            
//            if(response != ""){
//                let dataDict = response.getJsonDataDict()
//                
//                if(fromWeb == true){
//                   
//                    if(dataDict.get("Action") == "0"){
//                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
//                        return
//                    }
//                    
//                    if((dataDict.getArrObj("data") as! [NSDictionary]).count == 0){
//                        completionHandler([NSDictionary](), "", "", "", "", [Int](), dataDict.get("vServiceName"), [NSDictionary]())
//                        return
//                    }
//                    
//                    let pointsArray = dataDict.getArrObj("data")
//                    var newArray = [NSDictionary]()
//                    var lastIndex = 0
//                    
//                    for i in 0..<pointsArray.count{
//                        
//                        if(i != 0){
//                            
//                            let currentItem = pointsArray[i] as! NSDictionary
//                            let prevItem = pointsArray[lastIndex] as! NSDictionary
//                            let currentLocation = CLLocation(latitude:GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("longitude")))
//                            let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: prevItem.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: prevItem.get("longitude")))
//                            
//                            let distance = location.distance(from: currentLocation)
//                            
//                            if(distance > 10){
//                                lastIndex = i
//                                newArray.append(pointsArray[i] as! NSDictionary)
//                            }
//                            
//                        }else{
//                            newArray.append(pointsArray[i] as! NSDictionary)
//                        }
//                      
//                    }
//                    
//                    completionHandler(newArray, dataDict.get("SourceAddress"), dataDict.get("DestinationAddress"), dataDict.get("distance"), dataDict.get("duration"), dataDict.getArrObj("waypoint_order") as! [Int], dataDict.get("vServiceName"), [NSDictionary]())
//                    
//                }else{
//                    if(dataDict.get("status").uppercased() != "OK" || dataDict.getArrObj("routes").count == 0){
//                        completionHandler([NSDictionary](), "", "", "", "", [Int](), "Google", [NSDictionary]())
//                        return
//                    }
//                    
//                    let routesArr = dataDict.getArrObj("routes")
//                    let legs_arr = (routesArr.object(at: 0) as! NSDictionary).getArrObj("legs")
//                    var steps_arr = [NSDictionary] ()
//                    for i in 0..<legs_arr.count
//                    {
//                        steps_arr += (legs_arr.object(at: i) as! NSDictionary).getArrObj("steps") as! [NSDictionary]
//                    
//                    }
//                   
//                    completionHandler(steps_arr , (legs_arr.object(at: 0) as! NSDictionary).get("start_address"), (legs_arr.object(at: 0) as! NSDictionary).get("end_address"), (legs_arr.object(at: 0) as! NSDictionary).getObj("distance").get("value"), (legs_arr.object(at: 0) as! NSDictionary).getObj("duration").get("value"), (routesArr.object(at: 0) as! NSDictionary).getArrObj("waypoint_order") as! [Int], "Google", routesArr as! [NSDictionary])
//                
//                }
//                
//            }else{
//                
//                completionHandler([NSDictionary](), "", "", "", "", [Int](), fromWeb == true ? "" : "Google", [NSDictionary]())
//            }
//        }, url: directionURL)
//        
//    }
//    
//    // MARK: PlaceDetail Service
//    func getPlaceDetailService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, completionHandler: @escaping PlaceDetailHandler){
//        
//        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
//        
//        var placeDetailUrl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(mapDictionary.place_id)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true&fields=formatted_address,name,geometry&sessiontoken=\(mapDictionary.session_token)"
//        
//        if(fromWeb == true){
//            
//            placeDetailUrl = "\(webMapAPIPRFX)placedetails?place_id=\(mapDictionary.place_id)&session_token=\(mapDictionary.session_token)&TSITE_DB=\(webMapAPIDB)"
//        }
//        
//        Utils.printLog(msgData: "PlaceDetailURL::\(placeDetailUrl)")
//        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
//        self.placeSearchExeServerTask = exeWebServerUrl
//        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
//            
//            if(response != ""){
//                let dataDict = response.getJsonDataDict()
//                
//                if(fromWeb == true){
//                    
//                    if(dataDict.get("Action") == "0"){
//                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
//                        return
//                    }
//                    
//                    let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("longitude")))
//                    completionHandler(location, dataDict.get("vServiceName"))
//                }else{
//                    
//                    if(dataDict.get("status").uppercased() == "OK"){
//                        let resultObj = dataDict.getObj("result")
//                        let geometryObj = resultObj.getObj("geometry")
//                        let locationObj = geometryObj.getObj("location")
//                        let latitude = locationObj.get("lat")
//                        let longitude = locationObj.get("lng")
//                        
//                        let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: latitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: longitude))
//                        completionHandler(location, dataDict.get("vServiceName"))
//                    }else{
//                        self.generalFunc.setError(uv: uv)
//                    }
//                    
//                }
//            
//            }else{
//                self.generalFunc.setError(uv: uv)
//            }
//            
//        }, url: placeDetailUrl)
//        
//    }
//    
//    
//    func XXRadiansToDegrees(radians: Double) -> Double {
//        return radians * 180.0 / Double.pi
//    }
//    
//    func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
//        // Returns a float with the angle between the two points
//        let x = point1.coordinate.longitude - point2.coordinate.longitude
//        let y = point1.coordinate.latitude - point2.coordinate.latitude
//        
//        return fmod(XXRadiansToDegrees(radians: atan2(y, x)), 360.0) + 90.0
//    }
//}


//
//  MapServiceAPI.swift
//  PassengerApp
//
//  Created by Apple on 11/11/19.
//  Copyright © 2019 @. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseAnalytics

class MapDictionary {
    
    var p_latitude:String = ""
    var p_longitude:String = ""
    var d_latitude:String = ""
    var d_longitude:String = ""
    var max_latitude:String = ""
    var max_longitude:String = ""
    var min_latitude:String = ""
    var min_longitude:String = ""
    var search_query:String = ""
    var isPickUpMode:String = ""
    var session_token:String = ""
    var toll_skipped:String = ""
    var place_id:String = ""
    var waypoints_Str:String = ""
    var errorLbl:MyLabel? = nil
    var loaderView:UIView? = nil
    
    init(p_latitude:String, p_longitude:String, d_latitude:String, d_longitude:String,max_latitude:String, max_longitude:String, min_latitude:String, min_longitude:String, search_query:String, isPickUpMode:String, session_token:String, toll_skipped:String, place_id:String, waypoints_Str:String, errorLbl:MyLabel?, loaderView:UIView?) {
        
        self.p_latitude = p_latitude
        self.p_longitude = p_longitude
        self.d_latitude = d_latitude
        self.d_longitude = d_longitude
        self.max_latitude = max_latitude
        self.max_longitude = max_longitude
        self.min_latitude = min_latitude
        self.min_longitude = min_longitude
        self.search_query = search_query
        self.isPickUpMode = isPickUpMode
        self.session_token = session_token
        self.toll_skipped = toll_skipped
        self.place_id = place_id
        self.errorLbl = errorLbl
        self.loaderView = loaderView
        self.waypoints_Str = waypoints_Str
    }
}


class MapServiceAPI: NSObject {

    typealias ReverseGeoCodeHandler = (_ address:String, _ location:CLLocation, _ isPickUpMode:Bool, _ dataResult:String, _ serviceName:String) -> Void
    typealias AutoCompleteHandler = (_ placesArray:[NSDictionary], _ session_token:String, _ location:CLLocation?, _ serviceName:String) -> Void
    typealias DirectionHandler = (_ pointsArray:[NSDictionary], _ startAddress:String, _ endAddress:String, _ distance:String, _ time:String, _ waypoints_Array:[Int], _ serviceName:String, _ rotesArray:[NSDictionary]) -> Void
    typealias PlaceDetailHandler = (_ location:CLLocation, _ serviceName:String) -> Void
    
    public static var sharedMapServiceAPI:MapServiceAPI?
    var userProfileJson:NSDictionary!
    let generalFunc = GeneralFunctions()
    
    var placeSearchExeServerTask:ExeServerUrl!
    var webMapAPIPRFX = ""
    var webMapAPIDB = ""
    
    // MapKit helpers
    private var searchCompleter = MKLocalSearchCompleter()
    private var completerDelegate:CompleterDelegate?
    
    static func shared() -> MapServiceAPI{
        if(sharedMapServiceAPI == nil){
            sharedMapServiceAPI = MapServiceAPI()
            sharedMapServiceAPI!.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        }
        sharedMapServiceAPI!.webMapAPIPRFX = GeneralFunctions.getValue(key: "GOOGLE_API_REPLACEMENT_URL") as! String
        sharedMapServiceAPI!.webMapAPIDB = GeneralFunctions.getValue(key: "TSITE_DB") as! String
        print(GeneralFunctions.getValue(key: "GOOGLE_API_REPLACEMENT_URL") as! String)
        return sharedMapServiceAPI!
    }
    
    
    // MARK: Reverse Geocode Service
    func getGeoCodeService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, completionHandler: @escaping ReverseGeoCodeHandler){
        
        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
        
        if(fromWeb == true){
            
            let geoCodeUrl = "\(webMapAPIPRFX)reversegeocode?language_code=en&latitude=\(mapDictionary.p_latitude)&longitude=\(mapDictionary.p_longitude)&sensor=ture&TSITE_DB=\(webMapAPIDB)"
            
            Utils.printLog(msgData: "geoCodeUrl::\(geoCodeUrl)")
            
            let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
            
            exeWebServerUrl.executeGetProcess(completionHandler: { [weak self](response) -> Void in
                
                if(response != ""){
                    
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "0"){
                        self?.generalFunc.setError(uv: uv, title: "", content: self?.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")) ?? "")
                        return
                    }
                    
                    completionHandler(dataDict.get("address"), CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("longitude"))), mapDictionary.isPickUpMode.uppercased() == "YES" ? true : false, response, dataDict.get("vServiceName"))
                    
                }else{
                    if(isAlertShow){
                        self?.generalFunc.setError(uv: uv)
                    }
                }
            }, url: geoCodeUrl)
            
        }else{
            
            // MapKit: CLGeocoder
            let lat = GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.p_latitude)
            let lng = GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.p_longitude)
            let clLocation = CLLocation(latitude: lat, longitude: lng)
            
            Utils.printLog(msgData: "geoCodeUrl:: MapKit CLGeocoder")
            
            CLGeocoder().reverseGeocodeLocation(clLocation) { [weak self] placemarks, error in
                guard let self = self else { return }
                
                if let placemark = placemarks?.first, error == nil {
                    
                    let addressArr = [
                        placemark.subThoroughfare,
                        placemark.thoroughfare,
                        placemark.locality,
                        placemark.subAdministrativeArea,
                        placemark.administrativeArea,
                        placemark.postalCode,
                        placemark.country
                    ].compactMap { $0 }.filter { !$0.isEmpty }
                    
                    let finalAddress = addressArr.joined(separator: ", ")
                    
                    completionHandler(finalAddress, clLocation, mapDictionary.isPickUpMode.uppercased() == "YES" ? true : false, finalAddress, "Apple")
                    
                }else{
                    completionHandler("", CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: "0.0"), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: "0.0")), mapDictionary.isPickUpMode.uppercased() == "YES" ? true : false, "", "Apple")
                    
                    if(isAlertShow){
                        self.generalFunc.setError(uv: uv)
                    }
                }
            }
        }
    }
    
    // MARK: Autocomplete Service
    func getAutoCompleteService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, tableView:UITableView?, completionHandler: @escaping AutoCompleteHandler){
        
        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
        
        if(fromWeb == true){
            
            let autoCompleteUrl = "\(webMapAPIPRFX)autocomplete?language_code=\(Configurations.getGoogleMapLngCode())&latitude=\(mapDictionary.p_latitude)&longitude=\(mapDictionary.p_longitude)&search_query=\(mapDictionary.search_query)&max_latitude=\(mapDictionary.max_latitude)&max_longitude=\(mapDictionary.max_longitude)&min_latitude=\(mapDictionary.min_latitude)&min_longitude=\(mapDictionary.min_longitude)&session_token=\(mapDictionary.session_token)&TSITE_DB=\(webMapAPIDB)"
            
            Utils.printLog(msgData: "autoCompleteUrl::\(autoCompleteUrl)")
            if(placeSearchExeServerTask != nil){
                placeSearchExeServerTask.cancel()
                placeSearchExeServerTask = nil
            }
            
            let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
            self.placeSearchExeServerTask = exeWebServerUrl
            exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    
                    if(mapDictionary.errorLbl != nil){
                        mapDictionary.errorLbl?.isHidden = true
                    }
                    
                    let dataDict = response.getJsonDataDict()
                    
                    if(tableView != nil){
                        var frame = CGRect.zero
                        frame.size.height = 1
                        tableView!.tableFooterView = UIView()
                        
                        if #available(iOS 15.0, *) {
                            tableView!.sectionHeaderTopPadding = 0
                        } else {}
                    }
                    
                    if(dataDict.get("Action") == "0"){
                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
                        return
                    }
                    
                    let predictionsArr = dataDict.getArrObj("data")
                    if(predictionsArr.count > 0){
                        
                        var finalArray = [NSDictionary]()
                        for i in 0..<predictionsArr.count{
                            let item = predictionsArr[i] as! NSDictionary
                            
                            let dataDic = ["PlaceId": item.get("PlaceId"), "place_title": item.get("place_title"), "place_sub_title": item.get("place_sub_title"), "address": item.get("address"), "session_token": mapDictionary.session_token, "latitude": item.get("latitude"), "longitude": item.get("longitude")]
                            
                            finalArray.append(dataDic as NSDictionary)
                        }
                        
                        completionHandler(finalArray, mapDictionary.session_token, nil, dataDict.get("vServiceName"))
                        
                    }else if(predictionsArr.count == 0){
                        if(mapDictionary.errorLbl != nil){
                            mapDictionary.errorLbl?.isHidden = false
                            mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT")
                        }else{
                            mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
                            mapDictionary.errorLbl?.isHidden = false
                        }
                        
                    }else{
                        if(mapDictionary.errorLbl != nil){
                            mapDictionary.errorLbl?.isHidden = false
                            mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                        }else{
                            mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                            mapDictionary.errorLbl?.isHidden = false
                        }
                    }
                    
                }else{
                    if(mapDictionary.errorLbl != nil){
                        mapDictionary.errorLbl?.isHidden = false
                        mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                    }else{
                        mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                        mapDictionary.errorLbl?.isHidden = false
                    }
                }
                
                if(mapDictionary.loaderView != nil){
                    mapDictionary.loaderView?.isHidden = true
                }
                
            }, url: autoCompleteUrl)
            
        }else{
            
            // MapKit: MKLocalSearchCompleter
            Utils.printLog(msgData: "autoCompleteUrl:: MapKit MKLocalSearchCompleter")
            
            if(mapDictionary.errorLbl != nil){
                mapDictionary.errorLbl?.isHidden = true
            }
            
            if(tableView != nil){
                var frame = CGRect.zero
                frame.size.height = 1
                tableView!.tableFooterView = UIView()
                if #available(iOS 15.0, *) {
                    tableView!.sectionHeaderTopPadding = 0
                } else {}
            }
            
            if(placeSearchExeServerTask != nil){
                placeSearchExeServerTask.cancel()
                placeSearchExeServerTask = nil
            }
            
            let delegate = CompleterDelegate(mapDictionary: mapDictionary, uv: uv, generalFunc: generalFunc, completionHandler: completionHandler)
            self.completerDelegate = delegate
            
            let minLat = GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.min_latitude)
            let maxLat = GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.max_latitude)
            let minLng = GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.min_longitude)
            let maxLng = GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.max_longitude)
            
            let centerLat = (minLat + maxLat) / 2.0
            let centerLng = (minLng + maxLng) / 2.0
            let spanLat   = abs(maxLat - minLat)
            let spanLng   = abs(maxLng - minLng)
            
            let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng)
            let span   = MKCoordinateSpan(latitudeDelta: spanLat > 0 ? spanLat : 0.5,
                                          longitudeDelta: spanLng > 0 ? spanLng : 0.5)
            
            searchCompleter.delegate     = delegate
            searchCompleter.region       = MKCoordinateRegion(center: center, span: span)
            if #available(iOS 13.0, *) {
                searchCompleter.resultTypes  = [.address, .pointOfInterest]
            } else {
                // Fallback on earlier versions
            }
            searchCompleter.queryFragment = mapDictionary.search_query
//            Analytics.logEvent("place_searched", parameters: [
//                "user_id": GeneralFunctions.getMemberd(),
//                "pickup": mapDictionary.isPickUpMode == "YES" ? mapDictionary.search_query : "",
//                "dropoff": mapDictionary.isPickUpMode == "NO" ? mapDictionary.search_query : ""
//            ])
        }
    }
    
    // MARK: Direction Service
    func getDirectionService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, completionHandler: @escaping DirectionHandler){
        print(mapDictionary)
        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
        
        if(fromWeb == true){
            
            let latLongArray = mapDictionary.waypoints_Str.components(separatedBy: "|")
            
            let directionURL = "\(webMapAPIPRFX)direction?language_code=\(Configurations.getGoogleMapLngCode())&source_latitude=\(mapDictionary.p_latitude)&source_longitude=\(mapDictionary.p_longitude)&dest_latitude=\(mapDictionary.d_latitude)&dest_longitude=\(mapDictionary.d_longitude)&language=\(Configurations.getGoogleMapLngCode())&sensor=ture&toll_avoid=\(mapDictionary.toll_skipped)&waypoints=\(latLongArray.convertToJson())&TSITE_DB=\(webMapAPIDB)"
            
            Utils.printLog(msgData: "DirectionURL::\(directionURL)")
            
            let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
            
            exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "0"){
                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
                        return
                    }
                    
                    if((dataDict.getArrObj("data") as! [NSDictionary]).count == 0){
                        completionHandler([NSDictionary](), "", "", "", "", [Int](), dataDict.get("vServiceName"), [NSDictionary]())
                        return
                    }
                    
                    let pointsArray = dataDict.getArrObj("data")
                    var newArray = [NSDictionary]()
                    var lastIndex = 0
                    
                    for i in 0..<pointsArray.count{
                        
                        if(i != 0){
                            
                            let currentItem = pointsArray[i] as! NSDictionary
                            let prevItem = pointsArray[lastIndex] as! NSDictionary
                            let currentLocation = CLLocation(latitude:GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("longitude")))
                            let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: prevItem.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: prevItem.get("longitude")))
                            
                            let distance = location.distance(from: currentLocation)
                            
                            if(distance > 10){
                                lastIndex = i
                                newArray.append(pointsArray[i] as! NSDictionary)
                            }
                            
                        }else{
                            newArray.append(pointsArray[i] as! NSDictionary)
                        }
                      
                    }
                    
                    completionHandler(newArray, dataDict.get("SourceAddress"), dataDict.get("DestinationAddress"), dataDict.get("distance"), dataDict.get("duration"), dataDict.getArrObj("waypoint_order") as! [Int], dataDict.get("vServiceName"), [NSDictionary]())
                    
                }else{
                    completionHandler([NSDictionary](), "", "", "", "", [Int](), "", [NSDictionary]())
                }
            }, url: directionURL)
            
        }else{
            
            // MapKit: MKDirections
            let pLat = GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.p_latitude)
            let pLng = GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.p_longitude)
            let dLat = GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.d_latitude)
            let dLng = GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.d_longitude)
            
            Utils.printLog(msgData: "DirectionURL:: MapKit MKDirections")
            
            // Waypoints handling
            if(mapDictionary.waypoints_Str != ""){
                
                let latLngPairs = mapDictionary.waypoints_Str
                    .components(separatedBy: "|")
                    .compactMap { pair -> CLLocationCoordinate2D? in
                        let parts = pair.components(separatedBy: ",")
                        guard parts.count == 2,
                              let lat = Double(parts[0].trimmingCharacters(in: .whitespaces)),
                              let lng = Double(parts[1].trimmingCharacters(in: .whitespaces))
                        else { return nil }
                        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    }
                
                let allCoordinates = [CLLocationCoordinate2D(latitude: pLat, longitude: pLng)] + latLngPairs + [CLLocationCoordinate2D(latitude: dLat, longitude: dLng)]
                
                var allSteps = [NSDictionary]()
                var totalDistance = 0
                var totalDuration = 0
                
                func fetchSegment(index: Int) {
                    guard index < allCoordinates.count - 1 else {
                        
                        let routesArr: [NSDictionary] = [[
                            "legs": [[
                                "distance": ["value": totalDistance],
                                "duration": ["value": totalDuration],
                                "start_address": "",
                                "end_address": "",
                                "steps": allSteps
                            ] as NSDictionary]
                        ] as NSDictionary]
                        
                        completionHandler(allSteps, "", "", "\(totalDistance)", "\(totalDuration)", Array(0..<latLngPairs.count), "Apple", routesArr)
                        return
                    }
                    
                    let req = MKDirections.Request()
                    req.source        = MKMapItem(placemark: MKPlacemark(coordinate: allCoordinates[index]))
                    req.destination   = MKMapItem(placemark: MKPlacemark(coordinate: allCoordinates[index + 1]))
                    req.transportType = .automobile
                    
                    MKDirections(request: req).calculate { response, error in
                        if let route = response?.routes.first {
                            let steps = self.convertRouteToSteps(route: route)
                            allSteps += steps
                            totalDistance += Int(route.distance)
                            totalDuration += Int(route.expectedTravelTime)
                        }
                        fetchSegment(index: index + 1)
                    }
                }
                fetchSegment(index: 0)
                return
            }
            
            // Simple route (no waypoints)
            let request = MKDirections.Request()
            request.source      = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: pLat, longitude: pLng)))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: dLat, longitude: dLng)))
            request.transportType = .automobile
            request.requestsAlternateRoutes = false
            
            MKDirections(request: request).calculate { (response, error) in
                
                Utils.printLog(msgData: "MapKit Response - Error: \(String(describing: error))")
                Utils.printLog(msgData: "MapKit Response - Routes count: \(response?.routes.count ?? 0)")
                
                guard let route = response?.routes.first, error == nil else {
                    Utils.printLog(msgData: "MapKit Direction FAILED - No route found")
                    completionHandler([NSDictionary](), "", "", "", "", [Int](), "Apple", [NSDictionary]())
                    return
                }
                
                Utils.printLog(msgData: "MapKit Route Found - Distance: \(route.distance)m, Duration: \(route.expectedTravelTime)s")
                Utils.printLog(msgData: "MapKit Polyline points: \(route.polyline.pointCount)")
                
                let steps_arr = self.convertRouteToSteps(route: route)
                let distance = Int(route.distance)
                let duration = Int(route.expectedTravelTime)
                
                Utils.printLog(msgData: "MapKit Steps Array Count: \(steps_arr.count)")
                
                let routesArr: [NSDictionary] = [[
                    "legs": [[
                        "distance": ["value": distance] as [String: Int],
                        "duration": ["value": duration] as [String: Int],
                        "start_address": "",
                        "end_address": "",
                        "steps": steps_arr
                    ] as NSDictionary]
                ] as NSDictionary]
                
                Utils.printLog(msgData: "MapKit Final - Calling completionHandler with \(steps_arr.count) steps")
//                Analytics.logEvent("direction_requested", parameters: [
//                    "user_id": GeneralFunctions.getMemberd(),
//                    "pickup_lat": mapDictionary.p_latitude,
//                    "pickup_lng": mapDictionary.p_longitude,
//                    "dropoff_lat": mapDictionary.d_latitude,
//                    "dropoff_lng": mapDictionary.d_longitude
//                ])
                completionHandler(steps_arr, "", "", "\(distance)", "\(duration)", [Int](), "Apple", routesArr)
            }
        }
    }
    
    // Helper: Convert MKRoute to steps format matching Google's exact structure
    private func convertRouteToSteps(route: MKRoute) -> [NSDictionary] {
        let pointCount = route.polyline.pointCount
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        route.polyline.getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        
        Utils.printLog(msgData: "convertRouteToSteps - Total coords from polyline: \(coords.count)")
        
        var steps_arr = [NSDictionary]()
        
        // Apply 5m filter like original Google code
        var lastLocation: CLLocation? = nil
        
        for i in 0..<coords.count {
            let currentLoc = CLLocation(latitude: coords[i].latitude, longitude: coords[i].longitude)
            
            if i != 0 {
                if let prevLoc = lastLocation {
                    let distance = prevLoc.distance(from: currentLoc)
                    if distance > 5 {
                        let stepDict: NSDictionary = [
                            "end_location": [
                                "lat": coords[i].latitude,
                                "lng": coords[i].longitude
                            ] as [String: Double],
                            "distance": ["value": 0] as [String: Int],
                            "duration": ["value": 0] as [String: Int]
                        ]
                        steps_arr.append(stepDict)
                        lastLocation = currentLoc
                    }
                }
            } else {
                let stepDict: NSDictionary = [
                    "end_location": [
                        "lat": coords[i].latitude,
                        "lng": coords[i].longitude
                    ] as [String: Double],
                    "distance": ["value": 0] as [String: Int],
                    "duration": ["value": 0] as [String: Int]
                ]
                steps_arr.append(stepDict)
                lastLocation = currentLoc
            }
        }
        
        Utils.printLog(msgData: "convertRouteToSteps - After 5m filter: \(steps_arr.count) steps")
        
        return steps_arr
    }
    
    // MARK: PlaceDetail Service
    func getPlaceDetailService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, completionHandler: @escaping PlaceDetailHandler){
        
        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
        
        if(fromWeb == true){
            
            let placeDetailUrl = "\(webMapAPIPRFX)placedetails?place_id=\(mapDictionary.place_id)&session_token=\(mapDictionary.session_token)&TSITE_DB=\(webMapAPIDB)"
            
            Utils.printLog(msgData: "PlaceDetailURL::\(placeDetailUrl)")
            let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
            self.placeSearchExeServerTask = exeWebServerUrl
            exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "0"){
                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
                        return
                    }
                    
                    let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("longitude")))
                    completionHandler(location, dataDict.get("vServiceName"))
                    
                }else{
                    self.generalFunc.setError(uv: uv)
                }
            }, url: placeDetailUrl)
            
        }else{
            
            // MapKit: CLGeocoder (geocode address string from autocomplete)
            Utils.printLog(msgData: "PlaceDetailURL:: MapKit CLGeocoder")
            
            let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
            self.placeSearchExeServerTask = exeWebServerUrl
            
            CLGeocoder().geocodeAddressString(mapDictionary.place_id) { placemarks, error in
                
                if let placemark = placemarks?.first, let location = placemark.location, error == nil {
                    completionHandler(location, "Apple")
                }else{
                    self.generalFunc.setError(uv: uv)
                }
            }
        }
    }
    
    
    func XXRadiansToDegrees(radians: Double) -> Double {
        return radians * 180.0 / Double.pi
    }
    
    func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
        // Returns a float with the angle between the two points
        let x = point1.coordinate.longitude - point2.coordinate.longitude
        let y = point1.coordinate.latitude - point2.coordinate.latitude
        
        return fmod(XXRadiansToDegrees(radians: atan2(y, x)), 360.0) + 90.0
    }
}


// MARK: - CompleterDelegate (MKLocalSearchCompleterDelegate)
private class CompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    
    private let mapDictionary:MapDictionary
    private weak var uv:UIViewController?
    private let generalFunc:GeneralFunctions
    private let completionHandler:MapServiceAPI.AutoCompleteHandler
    
    init(mapDictionary:MapDictionary, uv:UIViewController, generalFunc:GeneralFunctions, completionHandler: @escaping MapServiceAPI.AutoCompleteHandler) {
        self.mapDictionary     = mapDictionary
        self.uv                = uv
        self.generalFunc       = generalFunc
        self.completionHandler = completionHandler
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        let results = completer.results
        
        if results.isEmpty {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if(self.mapDictionary.errorLbl != nil){
                    self.mapDictionary.errorLbl?.isHidden = false
                    self.mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT")
                }else{
                    self.mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.uv!.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
                    self.mapDictionary.errorLbl?.isHidden = false
                }
                self.mapDictionary.loaderView?.isHidden = true
            }
            return
        }
        
        var finalArray = [NSDictionary]()
        for result in results {
            let address = result.subtitle.isEmpty ? result.title : "\(result.title), \(result.subtitle)"
            
            let dataDic = [
                "PlaceId": address,
                "place_title": result.title,
                "place_sub_title": result.subtitle,
                "address": address,
                "session_token": mapDictionary.session_token,
                "location": nil
            ] as NSDictionary
            
            finalArray.append(dataDic)
        }
        
        completionHandler(finalArray, mapDictionary.session_token, nil, "Apple")
        
        if(mapDictionary.loaderView != nil){
            mapDictionary.loaderView?.isHidden = true
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if(self.mapDictionary.errorLbl != nil){
                self.mapDictionary.errorLbl?.isHidden = false
                self.mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
            }else{
                self.mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.uv!.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                self.mapDictionary.errorLbl?.isHidden = false
            }
            self.mapDictionary.loaderView?.isHidden = true
        }
    }
}

