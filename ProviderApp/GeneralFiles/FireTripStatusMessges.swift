//
//  FireTripStatusMessges.swift
//  DriverApp
//
//  Created by Admin on 25/08/18.
//  Copyright © 2018 @. All rights reserved.
//

import Foundation

class FireTripStatusMessges: NSObject {
    
    var isFromPubSub = false
    let generalFunc = GeneralFunctions()
    
    var tmp_msg = ""
    
    func fireTripMsg(_ messageStr:String, _ isFromPubSub:Bool, _ receivedBy:String){
        
        tmp_msg = GeneralFunctions.isKeyExistInUserDefaults(key: "OLD_PUSH_MESSAGE") ? GeneralFunctions.getValue(key: "OLD_PUSH_MESSAGE") as! String : ""
        if(tmp_msg == messageStr){
            return
        }
        GeneralFunctions.saveValue(key: "OLD_PUSH_MESSAGE", value: messageStr as AnyObject)
        
        self.isFromPubSub = isFromPubSub
        let result = messageStr.getJsonDataDict()
        var viewController = Application.window != nil ? (Application.window!.rootViewController != nil ? (Application.window!.rootViewController!) : nil) : nil
        
        if(viewController != nil){
            viewController = GeneralFunctions.getVisibleViewController(viewController, isCheckAll: true)
        }
        
      //ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMiIFCAHEc9roL9aQtjzaSxPLQ4B+70CNcEpUKaHILKj hassansalmanayub1@gmail.com

        if(result.count != 0){
            if(result.get("tSessionId") != "" && result.get("tSessionId") != GeneralFunctions.getSessionId()){
                return
            }
            
            if(result.get("Message") == "CabRequested"){
                CabRequestStatus.updateDriverRequestStatus(PassengerId: result.get("PassengerId"), UpdatedStatus: "Received", ReceiverByscriptName: receivedBy, repeatCount: 1, vMsgCode: result.get("MsgCode"))
            }
            
            let isMsgExist = GeneralFunctions.isTripStatusMsgExist(msgDataDict: result, isFromPubSub: isFromPubSub)
            
            if(isMsgExist == true){
                return
            }
            
            let msg_str = result.get("Message")
            let msgType_str = result.get("MsgType")
            
            if(msgType_str != "" && msgType_str == "CHAT"){
                if(Application.window != nil && Application.window?.rootViewController != nil){
                    
                    if(GeneralFunctions.getVisibleViewController(Application.window!.rootViewController) != nil && GeneralFunctions.getVisibleViewController(Application.window!.rootViewController)!.className != "MessagesViewController"){
                        
                        let receiverName = result.get("FromMemberName")
                        let receiverId = result.get("iFromMemberId")
                        let tripId = result.get("iTripId")
                        let fromMemberImageName = result.get("FromMemberImageName")
                        
                        let chatUv = GeneralFunctions.instantiateViewController(pageName: "MessagesViewController") as! MessagesViewController
                        chatUv.receiverId = receiverId
                        chatUv.receiverDisplayName = receiverName
                        chatUv.assignedtripId = tripId
                        chatUv.pPicName = fromMemberImageName
                        Application.window!.rootViewController?.pushToNavController(uv: chatUv, isDirect: true)
                        
                        return
                    }
                }
                return
            }
            
            if(msg_str == "OrderItemsReviewed" || msg_str == "OrderPaymentByUser"){
                
                self.generalFunc.setAlertMessage(uv: nil, title: "", content: result.get("vTitle"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                })
            }
            
            if(msg_str != "" && msg_str == "TripCancelled"){
                
                var viewController = Application.window != nil ? (Application.window!.rootViewController != nil ? (Application.window!.rootViewController!) : nil) : nil
                
                if(viewController != nil){
                    let chkViewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                    if(chkViewController?.navigationController != nil && chkViewController?.navigationController!.viewControllers.count == 1){
                        viewController = chkViewController!.navigationController!
                    }
                }
                
                self.generalFunc.setAlertMessage(uv: viewController, title: "", content: result.get("vTitle") == "" ? (msg_str == "TripCancelled" ? generalFunc.getLanguageLabel(origValue: "", key: "LBL_PASSENGER_CANCEL_TRIP_TXT") : generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ADD_BY_PASSENGER")) : result.get("vTitle"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    let window = Application.window!
                    
                    let getUserData = GetUserData(uv: viewController == nil ? UIViewController() : viewController!, window: window)
                    getUserData.getdata()
                    
                })
                
            }else if(msg_str != "" && msg_str == "DestinationAdded"){
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.tripDestinationAdded), object: self, userInfo: ["body":result.convertToJson()])
            }else if(msg_str == "OrderCancelByAdmin" || msg_str == "OrderDeclineByRestaurant"){ // For Deliver All
                
                if result.get("vTitle") != ""
                {
                    if(Application.window != nil && Application.window?.rootViewController != nil && GeneralFunctions.getMemberd() != ""){
                        //(GeneralFunctions()).setError(uv: nil, title: "", content: result.get("vTitle"))
                        
                        self.generalFunc.setAlertMessage(uv: nil, title: "", content: result.get("vTitle"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            let window = Application.window
                            GeneralFunctions.restartApp(window: window!)
                        })
                        
                    }
                }
                
            }else if(msg_str != ""){
                let msgCode = result.get("MsgCode")
                
                if(msgCode != ""){
                    let codeValue = GeneralFunctions.getValue(key: Utils.DRIVER_REQ_CODE_PREFIX_KEY + msgCode)
                    
                    if(codeValue == nil){
                        
                        /* FOR POOL */
                        
                        if (GeneralFunctions.isKeyExistInUserDefaults(key: "STOP_POOL_REQUEST") == true && GeneralFunctions.getValue(key: "STOP_POOL_REQUEST") as! Bool == true){
                            return
                        }
                        /* FOR POOL */
                        
                        let codeValue = GeneralFunctions.getValue(key: Utils.DRIVER_REQ_CODE_PREFIX_KEY + msgCode)
                        let viewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                        if(codeValue == nil){
                            GeneralFunctions.saveValue(key: Utils.DRIVER_REQ_CODE_PREFIX_KEY + msgCode, value: "\(Utils.currentTimeMillis())" as AnyObject)
                           
                            if(viewController != nil){
                                var pushReceived = UserDefaults.standard.string(forKey: "pushReceived")
                                print("pushSulemanTest:\(UserDefaults.standard.string(forKey: "pushReceived"))")
                                print("appSUlemanTest:\(UserDefaults.standard.string(forKey: "appTerminated"))")
                               if appState == "" && rideEnd == "done"{
                                   
                                    let cabRequestedUV = GeneralFunctions.instantiateViewController(pageName: "CabRequestedUV") as! CabRequestedUV
                                    cabRequestedUV.passengerJsonDetail_dict = result
                                    cabRequestedUV.initializedMiliSeconds = Utils.currentTimeMillis()
                                    
                                    viewController!.closeDrawerMenu()
                                    
                                    GeneralFunctions.removeAllAlertViewFromNavBar(uv: viewController!)
                                    
                                    //viewController!.pushToNavController(uv: cabRequestedUV)
                                    DispatchQueue.main.async() {
                                        if(viewController!.navigationController == nil){
                                            let navController = UINavigationController(rootViewController: cabRequestedUV)
                                            navController.navigationBar.isTranslucent = false
                                            viewController!.present(navController, animated: false, completion: nil)
                                        }else{
                                            viewController!.navigationController?.pushViewController(cabRequestedUV, animated: false)
                                        }
                                    }
//                                    
                                }else{
                                    UserDefaults.standard.set("no", forKey: "pushReceived")
                                    appState = ""
                                    rideEnd = "done"
                                    return
                                }
                            }
                        }
                        
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.passengerRequestArrived), object: self, userInfo: ["body":result.convertToJson()])
                    }
                }
                
            }
            
            // FROM ADMIN
            if(msgType_str == "" && result.get("vTitle") != "" && msg_str != "CabRequested" && msg_str != "TripCancelled"){
                if msg_str == "BidRidesAvailable"{
//                    Utils.showSnakeBar(msg: result.get("vTitle"),uv: Application.window!.rootViewController!)
//                    let mainScreen = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
//                    mainScreen.isFrom = "push"
//                    Application.window!.rootViewController?.pushToNavController(uv: mainScreen, isDirect: true)
                    if let mainVC = viewController as? MainScreenUV {
                        print("suleman")
                       // if mainVC.changeCell == "zone" || mainVC.changeCell == "" {
                            NotificationCenter.default.post(name: NSNotification.Name("SHOW_BID_VIEW"), object: nil)
                       // }
                    }
                }else{
                    (GeneralFunctions()).setError(uv: Application.window!.rootViewController!, title: result.get("vTitle"), content: result.get("vBody"))
                }
            }// .........
            
        }else if(messageStr.trim() != ""){
            if(Application.window != nil && Application.window?.rootViewController != nil){
//                && Utils.isMyAppInBackground() == false
                (GeneralFunctions()).setError(uv: Application.window!.rootViewController!, title: "", content: messageStr)
            }
        }
    }


}
