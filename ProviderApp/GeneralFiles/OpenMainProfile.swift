//
//  OpenMainProfile.swift
//  DriverApp
//
//  Created by ADMIN on 11/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces

class OpenMainProfile: NSObject {
    
    var window :UIWindow!
    var viewControlller:UIViewController!
    var userProfileJson:String!
    let generalFunc = GeneralFunctions()
    
    init(uv: UIViewController, userProfileJson:String, window :UIWindow) {
        self.viewControlller = uv
        self.userProfileJson = userProfileJson
        self.window = window
        super.init()
        
        openProfile()
    }
    
    func openProfile(){
//        changeRootViewController
        
        GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: userProfileJson as AnyObject)
        
        saveData()
        
        GeneralFunctions.removeAllAlertViewFromNavBar(uv: self.viewControlller)
        
        GeneralFunctions.removeAlertViewFromWindow(viewTag: Utils.WINDOW_ALERT_DIALOG_CONTENT_TAG, coverViewTag: Utils.WINDOW_ALERT_DIALOG_BG_TAG)
        
        Configurations.setAppLocal()
        
        let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "HomeScreenContainerUV") as! HomeScreenContainerUV
        
        
//        if(window.rootViewController != nil && window.rootViewController!.navigationController != nil){
//            window.rootViewController!.navigationController?.popToRootViewController(animated: false)
//            window.rootViewController!.navigationController?.dismiss(animated: false, completion: nil)
//        }else if(window.rootViewController != nil){
//            window.rootViewController?.dismiss(animated: false, completion: nil)
//        }
        
        
//        let windowSubViews = self.window.subviews
//        
//        for i in 0..<windowSubViews.count{
//            let subView = windowSubViews[i]
//            subView.removeFromSuperview()
//        }
        
        
//        let userData = NSKeyedArchiver.archivedData(withRootObject: GeneralFunctions.removeNullsFromDictionary(origin: userProfileJson as! [String : AnyObject]) )
        
        
        
        let userProfileJsonDict = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        /* SINCH VOIP CALLING.*/
        if userProfileJsonDict.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
            SinchCalling.getInstance().initSinchClient()
           
            
            if (GeneralFunctions.isKeyExistInUserDefaults(key: "SINCHCALLING") == true &&  GeneralFunctions.getValue(key: "SINCHCALLING") as! Bool == true){
                return
            }
        }
        
        (UIApplication.shared.delegate as! AppDelegate).configureOnlineState(false)
        
        Utils.delayWithSeconds(2.0) {
            let userProfileJsonDict = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            if((userProfileJsonDict.get("vEmail") == "" && GeneralFunctions.getValue(key: Utils.ENABLE_EMAIL_OPTIONAL)?.uppercased != "YES") || userProfileJsonDict.get("vPhone") == "") && GeneralFunctions.getMemberd() != "" {
                
                let accountInfoUV = GeneralFunctions.instantiateViewController(pageName: "AccountInfoUV") as! AccountInfoUV
                let navigationController = UINavigationController(rootViewController: accountInfoUV)
                navigationController.navigationBar.isTranslucent = false
                
                UIView.transition(with: self.window,
                                  duration: 0.25,
                                  options: .showHideTransitionViews,
                                  animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                    
                } ,
                                  completion: nil)
                

                return
            }
        }
        
        
        
        let vTripStatus = userProfileJsonDict.get("vTripStatus")
        var lastTripExist = false
        
        var ratings_From_Driver = ""
        if userProfileJsonDict.get("eSystem") == "DeliverAll"
        {
            ratings_From_Driver = userProfileJsonDict.get("Ratings_From_Driver")
            
            
            if(ratings_From_Driver != "Done" && ratings_From_Driver != ""){
                lastTripExist = true
            }
            
        }else
        {
            if(vTripStatus == "Not Active"){
                ratings_From_Driver = userProfileJsonDict.get("Ratings_From_Driver")
                
                if(ratings_From_Driver != "Done"){
                    lastTripExist = true
                }
            }
        }
      
        if (vTripStatus != "" && vTripStatus != "NONE"  && vTripStatus != "Cancelled"
            && (vTripStatus == "Active" || vTripStatus == "On Going Trip"
                || vTripStatus == "Arrived" || lastTripExist == true)) {
            
            (UIApplication.shared.delegate as? AppDelegate)?.isProviderOnJob = true
            (UIApplication.shared.delegate as? AppDelegate)?.configPIPmode()
            
            let last_trip_data = userProfileJsonDict.getObj("TripDetails")
            let passenger_data = userProfileJsonDict.getObj("PassengerDetails")
            
           
            let dataParams = ["Message":"CabRequested", "sourceLatitude": last_trip_data.get("tStartLat"), "sourceLongitude": last_trip_data.get("tStartLong"), "PassengerId": last_trip_data.get("iUserId"), "PName": "\(passenger_data.get("vName"))", "PPicName": "\(passenger_data.get("vImgName"))", "PFId": "\(passenger_data.get("vFbId"))", "PRating": "\(passenger_data.get("vAvgRating"))", "PPhone": "\(passenger_data.get("vPhone"))", "PPhoneC": "\(passenger_data.get("vPhoneCode"))", "PAppVersion": "\(passenger_data.get("iAppVersion"))", "TripId": "\(last_trip_data.get("iTripId"))", "DestLocLatitude": "\(last_trip_data.get("tEndLat"))", "DestLocLongitude": "\(last_trip_data.get("tEndLong"))", "DestLocAddress": "\(last_trip_data.get("tDaddress"))", "REQUEST_TYPE": "\(last_trip_data.get("eType"))", "vDeliveryConfirmCode": "\(last_trip_data.get("vDeliveryConfirmCode"))", "SITE_TYPE": "\(userProfileJsonDict.get("SITE_TYPE"))", "eTollSkipped": "\(last_trip_data.get("eTollSkipped"))", "eHailTrip": "\(last_trip_data.get("eHailTrip"))", "eFareType": "\(last_trip_data.get("eFareType"))", "TimeState": "\(userProfileJsonDict.get("TimeState"))", "TotalSeconds": "\(userProfileJsonDict.get("TotalSeconds"))", "iTripTimeId": "\(userProfileJsonDict.get("iTripTimeId"))", "tUserComment": "\(last_trip_data.get("tUserComment"))", "eBeforeUpload": "\(last_trip_data.get("eBeforeUpload"))", "eAfterUpload": "\(last_trip_data.get("eAfterUpload"))", "tSaddress": "\(last_trip_data.get("tSaddress"))", "tDaddress": "\(last_trip_data.get("tDaddress"))", "eType": "\(last_trip_data.get("eType"))","vReceiverMobile":last_trip_data.get("vReceiverMobile"),"vReceiverName":last_trip_data.get("vReceiverName"),"Running_Delivery_Txt":last_trip_data.get("Running_Delivery_Txt"),"iTripDeliveryLocationId":last_trip_data.get("iTripDeliveryLocationId"),"PaymentPerson":last_trip_data.get("PaymentPerson"), "ePaymentByReceiverForDelivery":last_trip_data.get("ePaymentByReceiverForDelivery"), "eIconType" : "\(last_trip_data.get("eIconType"))", "iOrderId": "\(last_trip_data.get("iOrderId"))" , "LastOrderUserName" : "\(userProfileJsonDict.get("LastOrderUserName"))" , "LastOrderNo" : "\(userProfileJsonDict.get("LastOrderNo"))" , "LastOrderAmount" : "\(userProfileJsonDict.get("LastOrderAmount"))", "vLastName": "\(passenger_data.get("vLastName"))", "ePoolRide":last_trip_data.get("ePoolRide"), "iPersonSize":last_trip_data.get("iPersonSize"),"eBookingFrom":"\(last_trip_data.get("eBookingFrom"))", "eRental":last_trip_data.get("eRental"), "eTransit":last_trip_data.get("eTransit"), "moreServices":last_trip_data.get("moreServices"), "eServiceLocation":last_trip_data.get("eServiceLocation"), "vTripPaymentMode":(last_trip_data.get("vTripPaymentMode")), "ePayWallet":(last_trip_data.get("ePayWallet")), "iStopId":(last_trip_data.get("iStopId")), "totalStopOverPoint":(last_trip_data.get("totalStopOverPoint")), "tTripRequestDateOrig":(last_trip_data.get("tTripRequestDateOrig")),"currentStopOverPoint":(last_trip_data.get("currentStopOverPoint")), "iGcmRegId": "\(passenger_data.get("iGcmRegId"))", "vPhone": "\(passenger_data.get("vPhone"))","vImage":"\(passenger_data.get("vImgName"))", "vServiceTitle": (last_trip_data.get("vServiceTitle")),"vRideNo":(last_trip_data.get("vRideNo")), "eFly":last_trip_data.get("eFly"), "ePaymentBy":(last_trip_data.get("ePaymentBy")),"ADDITIONAL_CHARGE_VERIFICATION_METHOD":(userProfileJsonDict.get("ADDITIONAL_CHARGE_VERIFICATION_METHOD")), "ENABLE_VERIFY_ADDITIONAL_CHARGE_FLOW":(userProfileJsonDict.get("ENABLE_VERIFY_ADDITIONAL_CHARGE_FLOW")), "vChargesDetailData": (last_trip_data.get("vChargesDetailData")), "eApproveRequestSentByDriver":(last_trip_data.get("eApproveRequestSentByDriver")),"ENABLE_MANUAL_TOLL_FEATURE":(userProfileJsonDict.get("ENABLE_MANUAL_TOLL_FEATURE")),"ENABLE_OTHER_CHARGES_FEATURE":(userProfileJsonDict.get("ENABLE_OTHER_CHARGES_FEATURE")), "ENABLE_MANUAL_TOLL_VERIFICATION_METHOD":(userProfileJsonDict.get("ENABLE_MANUAL_TOLL_VERIFICATION_METHOD")), "RESTRICT_PASSENGER_LIMIT_NOTE":(last_trip_data.get("RESTRICT_PASSENGER_LIMIT_NOTE")), "eAskCodeToUser":(last_trip_data.get("eAskCodeToUser")), "vRandomCode":(last_trip_data.get("vRandomCode")), "vText":(last_trip_data.get("vText")), "fCrossOverSpeed":(last_trip_data.get("fCrossOverSpeed")), "vVehicleBookingDistance":(last_trip_data.get("vVehicleBookingDistance")), "eFareCalcModel":(last_trip_data.get("eFareCalcModel")) , "vBaseTime":(last_trip_data.get("vBaseTime")), "tNoteByUser":(last_trip_data.get("tNoteByUser")), "fEstTripGenerateFare":(last_trip_data.get("fEstTripGenerateFare")), "fEstTripGenerateFareWithSymbol":(last_trip_data.get("fEstTripGenerateFareWithSymbol"))
            ] /* PAYMENT FLOW CHANGES " , "vTripPaymentMode":(last_trip_data.get("vTripPaymentMode")), "ePayWallet":(last_trip_data.get("ePayWallet"))"*/
            
            
            if last_trip_data.get("eType") == "Multi-Delivery"
            {
                if ((last_trip_data.get("IS_OPEN_SIGN_VERIFY") == "Yes" && last_trip_data.get("IS_OPEN_FOR_SENDER") == "Yes") || (last_trip_data.get("IS_OPEN_SIGN_VERIFY") == "Yes" && last_trip_data.get("IS_OPEN_FOR_SENDER") == "No"))
                {
                    
                    let viewMultiDeliveryDetailsUV = GeneralFunctions.instantiateViewController(pageName: "ViewMultiDeliveryDetailsUV") as! ViewMultiDeliveryDetailsUV
                    viewMultiDeliveryDetailsUV.tripData = NSMutableDictionary(dictionary: dataParams)
                    
                    viewMultiDeliveryDetailsUV.isLoadFromEndTRip = true
                    
                    if (last_trip_data.get("IS_OPEN_SIGN_VERIFY") == "Yes" && last_trip_data.get("IS_OPEN_FOR_SENDER") == "Yes")
                    {
                        //viewDeliveryDetailsUV.loadFromDriverArrived = true
                        viewMultiDeliveryDetailsUV.checkProofFor = "Sender"
                    }
                    else if (last_trip_data.get("IS_OPEN_SIGN_VERIFY") == "Yes" && last_trip_data.get("IS_OPEN_FOR_SENDER") == "No")
                    {
                        
                        viewMultiDeliveryDetailsUV.checkProofFor = "Receipent"
                        
                    }
                    
                    
                    let navigationController = UINavigationController(rootViewController: viewMultiDeliveryDetailsUV)
                    navigationController.navigationBar.isTranslucent = false
                    
                    UIView.transition(with: self.window,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)} ,
                                      completion: nil)
                    
                    return
                }
            }
            
            
            if userProfileJsonDict.get("eSystem") == "DeliverAll" ? (vTripStatus == "Finished" && ratings_From_Driver != "Done" && ratings_From_Driver != "" && lastTripExist == true) : (vTripStatus == "Not Active" && lastTripExist == true){
                let ePaymentCollect = last_trip_data.get("ePaymentCollect")
                if(userProfileJsonDict.get("eSystem") != "DeliverAll" && ePaymentCollect == "No"){
//                    GeneralFunctions.saveValue(key: "GO_ONLINE", value: "1" as AnyObject)
                    // CollectPayment
                    let collectPaymentUv = GeneralFunctions.instantiateViewController(pageName: "CollectPaymentUV") as! CollectPaymentUV
                    collectPaymentUv.tripData = dataParams as NSDictionary
                    let navigationController = UINavigationController(rootViewController: collectPaymentUv)
                    navigationController.navigationBar.isTranslucent = false
                    
                    UIView.transition(with: self.window,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                        
                    } ,
                                      completion: nil)
                    
                    
                    return
                }else{
                    // Trip Rating
                    
//                    if userProfileJsonDict.get("eSystem") == "DeliverAll"
//                    {
//                        let deliveredOrderRatingUV = GeneralFunctions.instantiateViewController(pageName: "DeliveredOrderRatingUV") as! DeliveredOrderRatingUV
//                        deliveredOrderRatingUV.tripData = dataParams as NSDictionary
//                        let navigationController = UINavigationController(rootViewController: deliveredOrderRatingUV)
//                        navigationController.navigationBar.isTranslucent = false
//
//                        UIView.transition(with: self.window,
//                                          duration: 0.3,
//                                          options: .transitionCrossDissolve,
//                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
//
//                        },completion: nil)
//                        return
//                    }else
//                    {
                        if(last_trip_data.get("eBookingFrom").uppercased() != "KIOSK"){
                            GeneralFunctions.saveValue(key: "GO_ONLINE", value: "1" as AnyObject)
                            let ratingUv = GeneralFunctions.instantiateViewController(pageName: "RatingUV") as! RatingUV
                            ratingUv.tripData = dataParams as NSDictionary
                            let navigationController = UINavigationController(rootViewController: ratingUv)
                            navigationController.navigationBar.isTranslucent = false
                            
                            UIView.transition(with: self.window,
                                              duration: 0.3,
                                              options: .transitionCrossDissolve,
                                              animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                                
                            } ,
                                              completion: nil)
                            
                            return
                        }
                      
//                    }
                }
            }else{
                
                if userProfileJsonDict.get("eSystem") == "DeliverAll"
                {

                    mainScreenUv.isFromDeliverAllLiveTask = true
                    mainScreenUv.liveTaskData = dataParams as NSDictionary
                    let navigationController = UINavigationController(rootViewController: mainScreenUv)
                    navigationController.navigationBar.isTranslucent = false
                    if(Configurations.isRTLMode()){
                        //let navController = NavigationDrawerController(rootViewController: navigationController, leftViewController: nil, rightViewController: nil)
                        //navController.isRightPanGestureEnabled = false
                        UIView.transition(with: self.window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                            
                        } ,
                                          completion: nil)
                        
                    }else{
                        //let navController = NavigationDrawerController(rootViewController: navigationController, leftViewController: nil, rightViewController: nil)
                        //navController.isLeftPanGestureEnabled = false
                        
                        UIView.transition(with: self.window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                            
                        } ,
                                          completion: nil)
                        
                    }
                    
                }else{
                    
                    if (vTripStatus == "Arrived") {
                        // Open active trip page
                        //                    map.put("vTripStatus", "Arrived");
                        //                     bn.putSerializable("TRIP_DATA", map);
                        
                        //                    new StartActProcess(mContext).startActWithData(ActiveTripActivity.class, bn);
                        
//                        GeneralFunctions.saveValue(key: "GO_ONLINE", value: "1" as AnyObject)
                        
                        let activeTripUV = GeneralFunctions.instantiateViewController(pageName: "ActiveTripUV") as! ActiveTripUV
                        activeTripUV.tripData = dataParams as NSDictionary
                        activeTripUV.isTripStarted = false
                        
                        let navigationController = UINavigationController(rootViewController: activeTripUV)
                        navigationController.navigationBar.isTranslucent = false
                        
                        UIView.transition(with: self.window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                            
                        } ,
                                          completion: nil)
                        
                        
                        return
                    } else if (vTripStatus != "Arrived" && vTripStatus == "On Going Trip") {
                        // Open active trip page
                        //                    map.put("vTripStatus", "EN_ROUTE");
                        //                    bn.putSerializable("TRIP_DATA", map);
                        //
                        //                    new StartActProcess(mContext).startActWithData(ActiveTripActivity.class, bn);
                        
//                        GeneralFunctions.saveValue(key: "GO_ONLINE", value: "1" as AnyObject)
                        
                        let activeTripUV = GeneralFunctions.instantiateViewController(pageName: "ActiveTripUV") as! ActiveTripUV
                        activeTripUV.tripData = dataParams as NSDictionary
                        activeTripUV.isTripStarted = true
                        
                        var navigationController = UINavigationController(rootViewController: activeTripUV)
                        
                        if(last_trip_data.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() && last_trip_data.get("eServiceEnd").uppercased() == "YES" && last_trip_data.get("eFareGenerated").uppercased() == "NO"){
                            let uFXAdditionalChargesUV = GeneralFunctions.instantiateViewController(pageName: "UFXAdditionalChargesUV") as! UFXAdditionalChargesUV
                            uFXAdditionalChargesUV.tripData = dataParams as NSDictionary
                            navigationController = UINavigationController(rootViewController: uFXAdditionalChargesUV)
                            
                        }else if(last_trip_data.get("eType").uppercased() != Utils.cabGeneralType_UberX.uppercased() && last_trip_data.get("eVerifyTollCharges").uppercased() == "YES"){
                            
                            let uFXAdditionalChargesUV = GeneralFunctions.instantiateViewController(pageName: "UFXAdditionalChargesUV") as! UFXAdditionalChargesUV
                            uFXAdditionalChargesUV.tripData = dataParams as NSDictionary
                            navigationController = UINavigationController(rootViewController: uFXAdditionalChargesUV)
                            
                                
                        }
                        
                        
                        
                        navigationController.navigationBar.isTranslucent = false
                        
                        UIView.transition(with: self.window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                            
                        } ,
                                          completion: nil)
                        
                        
                        return
                    } else if (vTripStatus != "Arrived" && vTripStatus == "Active") {
                        // Open driver arrived page
//                        GeneralFunctions.saveValue(key: "GO_ONLINE", value: "1" as AnyObject)
                        
                        let driverArrivedUv = GeneralFunctions.instantiateViewController(pageName: "DriverArrivedUV") as! DriverArrivedUV
                        driverArrivedUv.tripData = dataParams as NSDictionary
                        let navigationController = UINavigationController(rootViewController: driverArrivedUv)
                        navigationController.navigationBar.isTranslucent = false
                        
                        UIView.transition(with: self.window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                            
                        } ,
                                          completion: nil)
                        
                        
                        return
                    }
                }
                
            
            }
        }
        
        //let menuUV = GeneralFunctions.instantiateViewController(pageName: "MenuScreenUV") as! MenuScreenUV
//        menuUV.mainScreenUv = mainScreenUv

//        mainScreenUv.menuScreenUv = menuUV


        
        let navigationController = UINavigationController(rootViewController: mainScreenUv)
        navigationController.navigationBar.isTranslucent = false
        if(Configurations.isRTLMode()){
            //let navController = NavigationDrawerController(rootViewController: navigationController, leftViewController: nil, rightViewController: nil)
            //navController.isRightPanGestureEnabled = false
            UIView.transition(with: self.window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)

            } ,
                              completion: nil)

        }else{
            //let navController = NavigationDrawerController(rootViewController: navigationController, leftViewController: nil, rightViewController: nil)
            //navController.isLeftPanGestureEnabled = false

            UIView.transition(with: self.window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)

            } ,
                              completion: nil)

        }
        
//        if(oldViewController != nil){
//            oldViewController.dismiss(animated: false, completion: nil)
//        }
    }
    
    func saveData(){
        SetDataInPreference().setDataWithResponse(dataDict: self.userProfileJson.getJsonDataDict().getObj(Utils.message_str), isLogedIn: true)
        
    }
}
