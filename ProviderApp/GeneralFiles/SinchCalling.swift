//
//  SinchCalling.swift
//  DriverApp
//
//  Created by Admin on 10/13/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

protocol SinchCallingProtocol: class {
    func callDidEnd()
    func callDidEstablish()
    func clientDidStart()
}

class SinchCalling: NSObject, SINCallClientDelegate, SINCallDelegate, SINClientDelegate, SINAudioControllerDelegate {
    
    weak var delegate: SinchCallingProtocol? = nil
    
    public static var sinchInstance:SinchCalling?
    
    var sinAudioController: SINAudioController!
    var client: SINClient!
    var callFromSynch:SINCall!
    var callRunnig = false
    
    let generalFunc = GeneralFunctions()
    
    var soundPath = ""
    
    var audioPlayer:AVAudioPlayer?
    var localClient:ScClient!
    var webRTCClient:WebRTCClient!
    var media_type = ""
    var userProfileJson:NSDictionary!
    var signalingUrl = ""
    static func getInstance() -> SinchCalling{
        if(sinchInstance == nil){
            sinchInstance = SinchCalling()
        }
        
        return sinchInstance!
    }
    
    func localizedString(forKey key: String) -> String {
    
        return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
    }
    
    func initSinchClient(){
        
        if(GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) == nil){
            return
        }
        self.getcallingMethodAndPlatform()
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        if(userProfileJson.get("SINCH_APP_KEY") != "" && userProfileJson.get("SINCH_APP_SECRET_KEY") != "" && userProfileJson.get("SINCH_APP_ENVIRONMENT_HOST") != ""){
            if GeneralFunctions.getMemberd() == "" {
                if client != nil{
                    removeSinchClient()
                }
            }else{
                if client == nil{
                    
                    GeneralFunctions.registerRemoteNotification(false)
                    
                    
                    
                    //GeneralFunctions.registerRemoteNotification()
                    client = Sinch.client(withApplicationKey: userProfileJson.get("SINCH_APP_KEY"), applicationSecret: userProfileJson.get("SINCH_APP_SECRET_KEY"), environmentHost: userProfileJson.get("SINCH_APP_ENVIRONMENT_HOST"), userId: Utils.appUserType + "_" + GeneralFunctions.getMemberd())
                    client.delegate = self
                    client.call().delegate = self
                    client.setSupportCalling(true)
                    client.setSupportPushNotifications(true)
                    client.enableManagedPushNotifications()
                  
                    client.start()
                    client.startListeningOnActiveConnection()
                    
                    sinAudioController = client.audioController()
                    if(GeneralFunctions.getValue(key: Utils.VOIP_NOTIFICATION) as? String != nil){
                        if(GeneralFunctions.getValue(key: Utils.VOIP_NOTIFICATION) as? String != ""){
                            let word = (GeneralFunctions.getValue(key: Utils.VOIP_NOTIFICATION) as! String).components(separatedBy: ".")
                            soundPath = Bundle.main.path(forResource: word[0], ofType: "wav")!
                        }else{
                            soundPath = Bundle.main.path(forResource: "telephone", ofType: "wav")!
                        }
                    }else{
                        soundPath = Bundle.main.path(forResource: "telephone", ofType: "wav")!
                    }
                    
                    //SINAudioController.s
                }
            }
        }
        
    }
    
    func playSound(soundPath: String)
    {
        if(soundPath != ""){
            let coinSound = NSURL(fileURLWithPath: soundPath)
            print(coinSound)
            
            
            do{
                //            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                //            try AVAudioSession.sharedInstance().setActive(true)
                
                if #available(iOS 10.0, *) {
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
                audioPlayer!.numberOfLoops = 15
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
                
                
            }catch {
                Utils.printLog(msgData: "Error getting the audio file")
            }
        }
        
    }
    
    func makeACall(IDString:String, assignedData:NSDictionary, selfData:[String:String], withRealNumber:String,_ isVideoCall:Bool = false){
        
        if(media_type.uppercased() == Utils.LOCAL){
            
            let voipCallUV = GeneralFunctions.instantiateViewController(pageName: "LocalVoipCallingUV") as! LocalVoipCallingUV
            voipCallUV.asignedDic = assignedData
            voipCallUV.isVideoCall = isVideoCall == true ? "Yes" : "No"
            voipCallUV.selfDic = selfData as NSDictionary
            
            let visibleViewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
            if(visibleViewController != nil){
                visibleViewController!.pushToNavController(uv: voipCallUV, isDirect: true)
            }else{
                Application.window!.rootViewController?.pushToNavController(uv: voipCallUV, isDirect: true)
            }
           
//            self.storeMessageToclientServer(idString:IDString, callEnded: "No")
            return
       }
        
        
        
        
        if callFromSynch == nil && client != nil{
           
            if client.isStarted(){
                
                if (withRealNumber != ""){
                    callFromSynch = client.call().callPhoneNumber(withRealNumber)
                }else{
                    callFromSynch = client.call().callUser(withId: IDString, headers: selfData)
                }
              
                callFromSynch.delegate = self
                client.setPushNotificationDisplayName(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INCOMING_CALL"))
                
                let sinchCallingUV = GeneralFunctions.instantiateViewController(pageName: "SinchCallingUV") as! SinchCallingUV
                
                sinchCallingUV.assignedData = assignedData
                sinchCallingUV.modalPresentationStyle = .overCurrentContext
                let visibleViewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                if(visibleViewController != nil){
                    visibleViewController!.pushToNavController(uv: sinchCallingUV, isDirect: true)
                }else{
                    Application.window!.rootViewController?.pushToNavController(uv: sinchCallingUV, isDirect: true)
                }
                
//                self.storeMessageToclientServer(idString:IDString, callEnded: "No")
                return
            }else{
                
                if(client.isStarted() == false){
                    self.initSinchClient()
                    return
                }
                callFromSynch.hangup()
                
            }
            
        }else{
            
            if(client == nil){
                self.initSinchClient()
                return
            }
            callFromSynch.hangup()
            
            return
        }
    }
    
    func removeSinchClient(){
        
        self.audioPlayer = nil
        sinAudioController.stopPlayingSoundFile()
        client.unregisterPushNotificationDeviceToken()
        self.client.stop()
        self.client = nil
        if(callFromSynch != nil){
            callFromSynch = nil
        }
       
    }
    
    /* SINCH DELEGATE METHODS.*/
    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        self.playSound(soundPath: soundPath)
        call.delegate = self
        callFromSynch = call
        
        let sinchCallingUV = GeneralFunctions.instantiateViewController(pageName: "SinchCallingUV") as! SinchCallingUV
        sinchCallingUV.assignedData = call.headers! as NSDictionary
        sinchCallingUV.isCallReceiving = true
        sinchCallingUV.modalPresentationStyle = .overCurrentContext
        let visibleViewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
        if(visibleViewController != nil){
            visibleViewController!.pushToNavController(uv: sinchCallingUV, isDirect: true)
        }else{
            Application.window!.rootViewController?.pushToNavController(uv: sinchCallingUV, isDirect: true)
        }
        //callFromSynch.answer()
    }
    
    func callDidEnd(_ call: SINCall!) {
       
        //client.setPushNotificationDisplayName(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_ENDED"))
        
        self.audioPlayer = nil
        sinAudioController.stopPlayingSoundFile()
        callRunnig = false
        callFromSynch = nil
        delegate?.callDidEnd()
        print("<<<<<<<<CALL ENDED>>>>>>>")
    }
    
    func callDidEstablish(_ call: SINCall!) {
        self.audioPlayer = nil
        sinAudioController.stopPlayingSoundFile()
        callRunnig = true
        delegate?.callDidEstablish()
        print("<<<<<<<<CALL ESTABLISH>>>>>>>")
        
    }
    
    func callDidProgress(_ call: SINCall!) {
        print("<<<<<<<<CALL PROGRESS>>>>>>>")
    }
    
    func clientDidStart(_ client: SINClient!) {
        
        print("<<<<<<<<CLIENT DID START>>>>>>>")
    }
    
    func clientDidStop(_ client: SINClient!) {
        
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        self.audioPlayer = nil
        sinAudioController.stopPlayingSoundFile()
        self.client = nil
        //self.initSinchClient()
        print(">>>>>>>CLIENT Did FAIL>>>>>>>")
    }
    
    func storeMessageToclientServer(idString:String, callEnded:String)
    {
        let date = Date()
        let nowDate:String = Utils.convertDateToFormate(date: date, formate: "yyyy-MM-dd HH:mm:ss")
        let parameters = ["type":"SendTripMessageNotification","UserType": Utils.appUserType, "iFromMemberId": GeneralFunctions.getMemberd(), "iToMemberId": idString,"vDate":nowDate, "isForVoip": "Yes", "isCallEnded": callEnded, "eSystem":(idString.contains(find: "Company") ? "DeliverAll":"")]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: UIView(), isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                
            }else{
                
            }
        })
        
    }
  
    func initWebRTC(){
        webRTCClient = WebRTCClient()
    }
    
    func initLocalCalling(){
        if(media_type.uppercased() == Utils.LOCAL){
            if(localClient == nil){
                
                Utils.printLog(msgData: "====Local Call Init ======")
                
                localClient = ScClient(url: self.signalingUrl)
                localClient.setAuthToken(token: Utils.appUserType + "_" + GeneralFunctions.getMemberd())
                localClient.connect()
                
                self.initWebRTC()
                
                localClient.setBasicListener(onConnect: { (scClient) in
                    // Called when socket connection is established
                    
                    Utils.printLog(msgData: "====Local Call Init -onConnect-======")
                    
                    self.localClient.on(eventName: "*", ack: {
                                    (eventName : String, data : AnyObject?) in
                        
                        
                        if let str = data as? String {
                            
                           
                            let finalData = str.components(separatedBy: "@@")
                            
                            print("SDSDSD:\(finalData)")
                            if(Application.window != nil && Application.window?.rootViewController != nil){
                                
                                let voipCallUV = GeneralFunctions.instantiateViewController(pageName: "LocalVoipCallingUV") as! LocalVoipCallingUV
                                voipCallUV.isOutGoing = false
                                if(finalData.count > 3 && (finalData[2]) != "CallEnd" && (finalData[2]).getJsonDataDict().get("type").lowercased() == "offer"){
                                    voipCallUV.messageDataDic = finalData.last?.getJsonDataDict()
                                    voipCallUV.webRTCClient = self.webRTCClient
                                    voipCallUV.roomID = finalData[1]
                                    voipCallUV.client = self.localClient
                                    voipCallUV.listinigEventFor(eventName : eventName, data : data)
                                    
                                    if((finalData[1]) == Utils.appUserType + "_" + GeneralFunctions.getMemberd()){
                                        let visibleViewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                                        if(visibleViewController != nil){
                                            visibleViewController!.pushToNavController(uv: voipCallUV, isDirect: true)
//                                            Application.window!.rootViewController?.pushToNavController(uv: voipCallUV, isDirect: true)
                                        }else{
                                            Application.window!.rootViewController?.pushToNavController(uv: voipCallUV, isDirect: true)
                                        }
                                    }
                                    
                                }else{
                                    
                                    
                                    var localVoipCallingUV:LocalVoipCallingUV!
                                    var viewController = Application.window != nil ? (Application.window!.rootViewController != nil ? (Application.window!.rootViewController!) : nil) : nil
                                    
                                    if(viewController != nil){
                                        viewController = GeneralFunctions.getVisibleViewController(viewController, isCheckAll: true)
                                    }
                                    if(viewController != nil && viewController!.isKind(of: LocalVoipCallingUV.self)){
                                        localVoipCallingUV = (viewController as! LocalVoipCallingUV)
                                    }else if(viewController != nil && viewController!.navigationController != nil){
                                        for i in 0..<viewController!.navigationController!.viewControllers.count{
                                            let currentViewCOntroller = viewController!.navigationController!.viewControllers[i]
                                            
                                            if(currentViewCOntroller.isKind(of: LocalVoipCallingUV.self)){
                                                localVoipCallingUV = (currentViewCOntroller as! LocalVoipCallingUV)
                                            
                                                break
                                            }
                                        }
                                    }
                                    
                                    if(localVoipCallingUV != nil){
                                        
                                        if((finalData[1]) ==  localVoipCallingUV.roomID){
                                            if(finalData.count > 3 && (finalData[2]) != "CallEnd"){
                                                localVoipCallingUV.messageDataDic = finalData.last?.getJsonDataDict()
                                                localVoipCallingUV.listinigEventFor(eventName : eventName, data : data)
                                            }else{
                                                localVoipCallingUV.callEndViewSetup()
                                            }
                                        }
                                        
                                    
                                    }
                                }
                              
                            }
                        }
                    })
                  
                }, onConnectError: { (scClient, error) in
                    
                    Utils.delayWithSeconds(5.0) {
                        if(self.localClient != nil){
                            self.localClient.connect()
                        }
                    }
                    
                }, onDisconnect: { (scClient, error) in
                    Utils.delayWithSeconds(5.0) {
                        
                        if(self.localClient != nil){
                            self.localClient.connect()
                        }
                        
                    }
                    
                })
            }
            
           
        }
    }
    
    func getcallingMethodAndPlatform(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
       
        if(userProfileJson.get("AUDIO_CALLING_METHOD").uppercased() == Utils.SINCH){
            self.media_type = Utils.SINCH
        }else if(userProfileJson.get("AUDIO_CALLING_METHOD").uppercased() == Utils.LOCAL){
            
            
            signalingUrl = userProfileJson.get("WEBRTC_SOCKET_URL")
            Utils.printLog(msgData: "LOCAL CALLLING SOCKET:\(signalingUrl)")
            
            self.media_type = Utils.LOCAL
            self.initLocalCalling()
        }
    }

    
    
    
    
    
}
