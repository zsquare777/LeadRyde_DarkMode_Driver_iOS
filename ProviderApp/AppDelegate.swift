//
//  AppDelegate.swift
//  DriverApp
//

import UIKit
import GoogleMaps
import AVFoundation
import Firebase
import Fabric
import GoogleSignIn
import IQKeyboardManagerSwift
import FBSDKCoreKit
import AVKit
import AVFoundation
import BackgroundTasks
//latest push
//suleman
var rideEnd = ""
var appState = ""
var startFromForeground = ""
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SINManagedPushDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var push:SINManagedPush!
    var refreshRequired = true
    var fcmDeviceToken = ""

    
    private var _pipController: AVPictureInPictureController?
    private let _bufferDisplayLayer = AVSampleBufferDisplayLayer()
    private var _pipPossibleObservation: NSKeyValueObservation?
    private var _observer: NSObjectProtocol?
    private let _startButton = UIButton()
    var videoContainerView = UIView()
    var bufferDisplayLayer = AVSampleBufferDisplayLayer()
    
    var isProviderOnline:Bool = false
    var isProviderOnJob:Bool = false
    var isPipImageVideoGenerated = false
    
    static let timeInternal = 30
    static let accuracy = 200
    
    var timer:Timer!
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        

        /* SET FONTFAMILY */
        GeneralFunctions.saveValue(key: "FONTFAMILY", value: Utils.getFontWeightList(familyName: Utils.fontFname) as AnyObject)
        UIFont.overrideDefaultTypography()
        /* */
        
        print(Fonts())
        
        // Override point for customization after application launch.
        GeneralFunctions.saveValue(key: "SERVERURL", value: CommonUtils.webServer as AnyObject)
        
        Configurations.setAppLocal()
       // Fabric.with([Crashlytics.self])

        Configurations.clearSDMemory()
       
        GeneralFunctions.saveValue(key: "SINCHCALLING", value: false as AnyObject)
        if Configurations.isDevelopmentMode() == true{
            self.push = Sinch.managedPush(with: SINAPSEnvironment.development)
        }else{
            self.push = Sinch.managedPush(with: SINAPSEnvironment.production)
        }
        self.push.delegate = self
        self.push.setDesiredPushTypeAutomatically()

        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {

            let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as! [AnyHashable : Any]
            
            let notification = userInfo["aps"] as? NSDictionary
            
            
            if(notification?.get("body") != "" && (notification!.get("body")).getJsonDataDict().get("MsgType") == "CHAT"){
                
                if(Application.window != nil && Application.window?.rootViewController != nil){
                    
                    if(GeneralFunctions.getVisibleViewController(Application.window!.rootViewController) != nil && GeneralFunctions.getVisibleViewController(Application.window!.rootViewController)!.className != "MessagesViewController"){
                        GeneralFunctions.saveValue(key: "OPEN_MSG_SCREEN", value: "true" as AnyObject)
                    }
                }
            }else if (notification?.get("body") != "" && (notification!.get("body")).getJsonDataDict().get("MsgType") == "VOIP"){
                
                if GeneralFunctions.getMemberd() != "" {
                    SinchCalling.getInstance().initSinchClient()
                    let result:SINNotificationResult = SINPushHelper.queryPushNotificationPayload(userInfo)
                    if result.isCall(){
                        GeneralFunctions.saveValue(key: "SINCHCALLING", value: true as AnyObject)
                        
                        SinchCalling.getInstance().client.relayRemotePushNotification(userInfo)
                    }
                }
                
            }else{
                print("userInfo:PUSH:\(String(describing: userInfo))")
            
                if(notification != nil && notification?.get("alert") == "" && notification?.get("sound") == ""){
                    if(notification != nil && notification?.get("body") != ""){
                        
                        if((notification!["body"] as? NSDictionary) != nil){
                            let jsonDic = notification!["body"] as! NSDictionary
                            
                            FireTripStatusMessges().fireTripMsg(jsonDic.convertToJson(), false, "Push")
                        }else if((notification!["body"] as? String) != nil){
                            
                             
                            let jsonData = notification!["body"] as! String
                            
                            FireTripStatusMessges().fireTripMsg(jsonData, false, "Push")
                        }
                       
                    }
                }else if(notification != nil && notification?.get("alert") != "" && notification?.get("sound") != ""){
                    //if(notification != nil && notification?.get("body") != ""){
                     //   if let jsonDic = notification?["body"] as? [String: Any] {
//                            UserDefaults.standard.set("yes", forKey: "appTerminated")
//                            print("pushKill:\(UserDefaults.standard.string(forKey: "pushReceived"))")
//                            UserDefaults.standard.set(jsonDic, forKey: "resultPush")
//                            print("appKill:\(UserDefaults.standard.string(forKey: "appTerminated"))")
//                            let result1 = UserDefaults.standard.dictionary(forKey: "resultPush") as NSDictionary?
//                            print(result1)
                           // handlePushNotification(userInfo)
                        //}
                  //  }
                    if(notification != nil && notification?.get("body") != ""){
                        
                        if((notification!["body"] as? NSDictionary) != nil){
                            let jsonDic = notification!["body"] as! NSDictionary
                            let dictionary = jsonDic as? [String: Any]
                                UserDefaults.standard.set(dictionary, forKey: "notificationBody")
                            appState = "kill"
                           // FireTripStatusMessges().fireTripMsg(jsonDic.convertToJson(), false, "Push")
                        }else if((notification!["body"] as? String) != nil){
                            
                             
                            let jsonData = notification!["body"] as! String
                            
                            FireTripStatusMessges().fireTripMsg(jsonData, false, "Push")
                        }
                       
                    }
                }
                
                
            }
        }
        
        
        Configurations.setAppThemeNavBar()
        
//        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Fonts().light, size: 24)!]
        
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
  
//        if #available(iOS 13.0, *) {
//            window!.overrideUserInterfaceStyle = .dark
//        } else {
//            // Fallback on earlier versions
//        }

        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = (GeneralFunctions()).getLanguageLabel(origValue: "Done", key: "LBL_DONE")
        
        IQKeyboardManager.shared.disabledToolbarClasses.append(MessagesViewController.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MessagesViewController.self)
        
        IQKeyboardManager.shared.disabledToolbarClasses.append(SignInUV.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(SignUpUV.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(ForgetPasswordUV.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(EditProfileUV.self)


        Analytics.setAnalyticsCollectionEnabled(true)

        FirebaseApp.configure()

        LocalNotification.registerForLocalNotification(on: UIApplication.shared)
        GeneralFunctions.registerRemoteNotification(true)
        
        UNUserNotificationCenter.current().delegate = self
        
        //registerBackgroundTask()
        
        UIViewController.swizzlePresent()
        
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.leadryde.driverapp", using: nil) { task in
                self.handleAppRefresh(task: task as! BGProcessingTask)
            }
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    
    func handlePushNotification(_ userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [String: Any] {
            
            if let alert = aps["body"] as? [String: Any] {
                
                let viewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                
                if let viewController = viewController {
                    
                    let cabRequestedUV = GeneralFunctions.instantiateViewController(pageName: "CabRequestedUV") as! CabRequestedUV
                    cabRequestedUV.passengerJsonDetail_dict = aps as NSDictionary
                    cabRequestedUV.initializedMiliSeconds = Utils.currentTimeMillis()
                    viewController.closeDrawerMenu()
                    
                    GeneralFunctions.removeAllAlertViewFromNavBar(uv: viewController)
                    
                    DispatchQueue.main.async {
                        if let navController = viewController.navigationController {
                            navController.pushViewController(cabRequestedUV, animated: true)
                        } else {
                            let navController = UINavigationController(rootViewController: cabRequestedUV)
                            navController.navigationBar.isTranslucent = false
                            viewController.present(navController, animated: true, completion: nil)
                        }
                    }
                } else {
                    print("Error: No visible view controller found.")
                }
            }
        }
    }


    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let isFacebookURL = url.scheme != nil && url.scheme!.hasPrefix("fb\(Settings.appID!)") && url.host != nil && url.host! == "authorize"
        if isFacebookURL {
            return ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        }

        let isGoogleUrl = url.scheme != nil && url.scheme!.hasPrefix("com.googleusercontent.apps")
        
        if(isGoogleUrl){
            GIDSignIn.sharedInstance()?.handle(url)
        }
        
        return false
        
//        return GIDSignIn.sharedInstance().handle(url as URL!,
//                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
//                                                 annotation: [:])
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        AppEvents.activateApp()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if #available(iOS 13.0, *) {
            let processingTaskRequest = BGProcessingTaskRequest(
                identifier: "com.leadryde.driverapp"
            )
        } else {
           
        }
       
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIMinimumKeepAliveTimeout)

        GeneralFunctions.postNotificationSignal(key: Utils.appBGNotificationKey, obj: self)
        
       // UIApplication.shared.isIdleTimerDisabled = false
        //suleman
        if _pipController?.isPictureInPictureActive == true {
            UIApplication.shared.isIdleTimerDisabled = true
        }else {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.USER_PROFILE_DICT_KEY) == true){
            let userProfileJsonDict = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            let vTripStatus = userProfileJsonDict.get("vTripStatus")
            if (vTripStatus != "Arrived" && vTripStatus == "On Going Trip") {
                self.startTimer()
            }else{
                self.stopTimer()
            }
        }
        
//        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
//        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UserDefaults.standard.set("yes", forKey: "appTerminated")
        UserDefaults.standard.set("yes", forKey: "pushReceived")
        self.senAppStateToServer(isTerminate: "Yes")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }

//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//
////        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
////        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
//        
//        registerBackgroundTask()
//    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
            // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

    //        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
    //        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }

            registerBackgroundTask()
            
        if(self.isProviderOnline || self.isProviderOnJob){

            if(self._pipController == nil){
                self.startPIPMode()
            }
        }
        if _pipController?.isPictureInPictureActive != true {
           // UIApplication.shared.isIdleTimerDisabled = false///suleman
        }
        
        self.stopTimer()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }

        self.senAppStateToServer(isTerminate: "No")
        
        GeneralFunctions.postNotificationSignal(key: Utils.appFGNotificationKey, obj: self)
        
     //   UIApplication.shared.isIdleTimerDisabled = true
        if _pipController?.isPictureInPictureActive != true {
           // UIApplication.shared.isIdleTimerDisabled = false///suleman
        }
        
        Utils.resetAppNotifications()
        
        configPIPmode()
        
        self.stopTimer()
//        if appState == "kill"{
//            appState = ""
//            if let result = UserDefaults.standard.dictionary(forKey: "notificationBody") {
//                print(result)
//                let viewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
//                let cabRequestedUV = GeneralFunctions.instantiateViewController(pageName: "CabRequestedUV") as! CabRequestedUV
//                cabRequestedUV.passengerJsonDetail_dict = result as NSDictionary
//                cabRequestedUV.initializedMiliSeconds = Utils.currentTimeMillis()
//                
//                viewController!.closeDrawerMenu()
//                
//                GeneralFunctions.removeAllAlertViewFromNavBar(uv: viewController!)
//                
//                //viewController!.pushToNavController(uv: cabRequestedUV)
//                DispatchQueue.main.async() {
//                    if(viewController!.navigationController == nil){
//                        let navController = UINavigationController(rootViewController: cabRequestedUV)
//                        navController.navigationBar.isTranslucent = false
//                        viewController!.present(navController, animated: false, completion: nil)
//                    }else{
//                        viewController!.navigationController?.pushViewController(cabRequestedUV, animated: false)
//                    }
//                }
//            }
//        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        UserDefaults.standard.set("yes", forKey: "pushReceived")
        self.senAppStateToServer(isTerminate: "Yes")
        UserDefaults.standard.set("yes", forKey: "appTerminated")
        isTncAcceptedThisSession = false
        GeneralFunctions.postNotificationSignal(key: Utils.appKilledNotificationKey, obj: self)
        GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
        GeneralFunctions.postNotificationSignal(key: ConfigPubNub.removeInst_key, obj: self)
        GeneralFunctions.postNotificationSignal(key: ConfigSCConnection.removeSCInst_key, obj: self)
        
        NavigationSensor.destroySensor()
        appState = ""
        Utils.printLog(msgData: "appTerminated::Yes")
        sleep(3)
        self.stopTimer()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()

        // FCM TOKEN
        InstanceID.instanceID().instanceID { (result, error) in
            if let result = result {
                
                self.fcmDeviceToken = result.token
            }
            
            self.push.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
            
            GeneralFunctions.saveValue(key: "APNID", value: token as AnyObject)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.apnIDNotificationKey), object: nil, userInfo: ["body":token, "FCMToken": self.fcmDeviceToken])
            return
        }
        
        self.push.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
        GeneralFunctions.saveValue(key: "APNID", value: token as AnyObject)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.apnIDNotificationKey), object: nil, userInfo: ["body":token, "FCMToken": ""])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("ErrorInReg:\(error)")
        if(UIDevice().type == .simulator){
            let token = "simulator_demo_1234"
            GeneralFunctions.saveValue(key: "APNID", value: token as AnyObject)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.apnIDNotificationKey), object: nil, userInfo: ["body":token, "FCMToken": token])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        if #available(iOS 14.0, *) {
            completionHandler([.alert, .badge, .sound, .banner])
        } else {
            completionHandler([.alert, .badge, .sound])
            // Fallback on earlier versions
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
         print("userInfo::\(userInfo)")
        
        let notification = userInfo["aps"] as? NSDictionary
        
        if(notification != nil && notification?.get("alert") == "" && notification?.get("sound") == ""){
           
            if((notification?.getObj("alert"))?.get("loc-key") == "SIN_INCOMING_CALL_DISPLAY_NAME"){
                self.refreshRequired = false
                self.push.application(application, didReceiveRemoteNotification: userInfo)
                return
            }
            
            if(notification == nil || notification?.get("body") == ""){
                return
            }
            
            
            if((notification!["body"] as? NSDictionary) != nil){
                let jsonDic = notification!["body"] as! NSDictionary
                let messageStr = jsonDic.get("Message") as? String ?? ""
            
                if fdTap == false && (onlineOrOffline == "Not Available" || onlineOrOffline == ""){
                    if messageStr == "BidRidesAvailable" {
                        return
                    }
                }
                
                FireTripStatusMessges().fireTripMsg(jsonDic.convertToJson(), false, "Push")
            }else if((notification!["body"] as? String) != nil){
                
    //            if (application.applicationState == .background) {
    //                return
    //            }
                 
                let jsonData = notification!["body"] as! String
                
                FireTripStatusMessges().fireTripMsg(jsonData, false, "Push")
            }
        }

        
    }
    
    func managedPush(_ managedPush: SINManagedPush!, didReceiveIncomingPushWithPayload payload: [AnyHashable : Any]!, forType pushType: String!) {
        if GeneralFunctions.getMemberd() != "" {
            let result:SINNotificationResult = SINPushHelper.queryPushNotificationPayload(payload)
            if result.isCall(){
                SinchCalling.getInstance().initSinchClient()
                if self.refreshRequired == true{
                    GeneralFunctions.saveValue(key: "SINCHCALLING", value: true as AnyObject)
                }
                SinchCalling.getInstance().client.relayRemotePushNotification(payload)
            }
        }
    }
    
    func senAppStateToServer(isTerminate:String, _ isDoneCount:Int = 0){
        
        if(Configurations.isUserLoggedIn() == false){
            return
        }
        
        let viewController = Application.window != nil ? (Application.window!.rootViewController != nil ? (Application.window!.rootViewController!) : nil) : UIViewController()

//
//        if (UIApplication.State.background == .background) {
//            //                return
//            //
//        }else{
            
            
            
            let parameters = ["type":"CheckAppTerminate","iMemberId": GeneralFunctions.getMemberd(), "eAppTerminate": isTerminate]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: viewController!.view, isOpenLoader: false)
            exeWebServerUrl.currInstance = exeWebServerUrl
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                print("dataSuccess")
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                    }else{
                        
                        if(isDoneCount < 2){
                            self.senAppStateToServer(isTerminate:isTerminate, isDoneCount + 1)
                        }
                        
                    }
                    
                }
            })
       // }
    }
    
    func startPIPMode(){
        self.stopPIPMode()
        
        self.start()
    }
    
    
    func textToImage(drawText text: String) -> UIImage {

        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 1200, height: 700))
        view.backgroundColor = .black
        
        
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 1060, height: 600))
        imageView.image = UIImage(named: "Applaunch_Icon")
        imageView.contentMode = .scaleAspectFit
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1200, height: 700), false, 0)
        view.drawHierarchy(in: CGRect(x: 0, y: 0, width: 1200, height: 700), afterScreenUpdates: true)
       
        imageView.drawHierarchy(in: CGRect(x: 70, y: 100, width: 1060, height: 600), afterScreenUpdates: true)
       
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @objc func start() {

        HSLocationTracking.shared().startLocationTracking()
        
        if AVPictureInPictureController.isPictureInPictureSupported() {

            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)

            } catch let error {
                print(error.localizedDescription)
            }
        
            
            let url = URL.documents.appendingPathComponent("ic_your_logo7.mov")
                
            if(isPipImageVideoGenerated == false){
                GeneralFunctions.writeSingleImageToMovie(image: self.textToImage(drawText: Bundle.main.displayName ?? "App"), movieLength: 900.0, outputFileURL: url) { error in
                }
                
                isPipImageVideoGenerated = true
            }
                
                //if(error == nil){
                let view = UIView.init(frame: CGRect(0, Application.screenSize.height - 150, 1, 1))
                let player = AVPlayer(url: url)
                let playerLayer = AVPlayerLayer(player: player)
                
                    
                view.isHidden = true
                playerLayer.frame = CGRect(0, 0, 50, 50)
                playerLayer.videoGravity = .resizeAspect
                view.layer.addSublayer(playerLayer)
                player.play()
        
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
                    player.seek(to: CMTime.zero)
                    DispatchQueue.global().async {
                        player.play()
                    }
                }
                
                (Application.window?.rootViewController?.view ?? UIView()).addSubview(view)
                
                if #available(iOS 15.0, *) {
                    self._pipController = AVPictureInPictureController.init(playerLayer: playerLayer)
                } else {
                    // Fallback on earlier versions
                    
                }
                
                self._pipController?.delegate = self
               
                
                if #available(iOS 15.0, *) {
                    self._pipController?.canStartPictureInPictureAutomaticallyFromInline = true
                    self._pipController?.startPictureInPicture()
                }else{
                    self._pipController!.startPictureInPicture()
                }
                
                self._pipController?.setValue(1, forKey: "controlsStyle")

                
                self._pipPossibleObservation = self._pipController?.observe(
                    \AVPictureInPictureController.isPictureInPicturePossible,
                    options: [.initial, .new]) { [weak self] _, change in
                        guard self != nil else { return }

                }
            
        }
    }

    
    func stopPIPMode(){
        if(self._pipController != nil && self._pipController!.isPictureInPictureActive){
            self._pipController?.stopPictureInPicture()
        }
        
        self._pipController = nil
    }
    
    
    func clearTempFolder() {
        let fileManager = FileManager.default
            let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            do {
                try fileManager.removeItem(at: myDocuments)
            } catch {
                return
            }
    }
    
    func scheduleAppRefresh() {

        if #available(iOS 13.0, *) {
            let request = BGProcessingTaskRequest(identifier: "com.leadryde.driverapp")
            
            request.requiresNetworkConnectivity = false
            request.requiresExternalPower = false
    

            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Could not schedule app refresh: \(error)")
            }
        } else {
            // Fallback on earlier versions
        }
        
    }

    @available(iOS 13.0, *)
    func handleAppRefresh(task: BGProcessingTask) {
            scheduleAppRefresh()
            
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
            }
            
            // increment instead of a fixed number
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "bgtask")+1, forKey: "bgtask")

            task.setTaskCompleted(success: true)
    }
    
    
    //JP - BACKGROUND NOTIFICATION ALERT CODE START
    
    var BACKGROUND_NOTIFICATION_TIME_INTERVAL_INT = 60
    
    func startTimer(){
        
        if(timer != nil){
            timer!.invalidate()
        }
        if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.USER_PROFILE_DICT_KEY) == true){
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            let BACKGROUND_NOTIFICATION_TIME_INTERVAL = userProfileJson.get("BACKGROUND_NOTIFICATION_TIME_INTERVAL")
            BACKGROUND_NOTIFICATION_TIME_INTERVAL_INT = GeneralFunctions.parseInt(origValue: 60, data: BACKGROUND_NOTIFICATION_TIME_INTERVAL)
        }
        
        timer =  Timer.scheduledTimer(timeInterval: Double(BACKGROUND_NOTIFICATION_TIME_INTERVAL_INT), target: self, selector: #selector(configUserNotificationsCenter), userInfo: nil, repeats: true)
        
    }
    
    func stopTimer(){
        if(timer != nil){
            timer!.invalidate()
        }
    }
    
    //Notification Configuration
    @objc func configUserNotificationsCenter(){
        let generalFunc = GeneralFunctions()
        
        UNUserNotificationCenter.current().delegate = self

        let actionOpenApp = UNNotificationAction(identifier: "OPENAPP", title: generalFunc.getLanguageLabel(origValue: "", key: "LBL_STAY_ONLINE_TXT"), options: [.foreground])
        let actionCloseApp = UNNotificationAction(identifier: "CLOSEAPP", title: generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLOSE_APP_TXT"), options: [])
        
        let notificationCategory = UNNotificationCategory(identifier: "Notification", actions: [actionOpenApp, actionCloseApp], intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([notificationCategory])
        
        self.authBackgroundNotification()
    }
    
    func createBackgroundNotification(){
        if(self._pipController != nil && self._pipController?.isPictureInPictureActive == true){
            return
        }
        let generalFunc = GeneralFunctions()
        
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = ""
        notificationContent.subtitle = ""
        notificationContent.body = generalFunc.getLanguageLabel(origValue: "", key: "LBL_BACKGROUND_NOTIFICATION_TXT")

        notificationContent.categoryIdentifier = "Notification"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.8, repeats: false)

//        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        let notificationRequest = UNNotificationRequest(identifier: "set_local_notification", content: notificationContent, trigger: notificationTrigger)

        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()){
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }

            completionHandler(success)
        }
    }
    
    func authBackgroundNotification(){
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    //Notification
                    self.createBackgroundNotification()
                })
            case .authorized:
                //Notification
                self.createBackgroundNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            case .provisional:
                print("Application Not Allowed to Display Notifications")
            case .ephemeral:
                print("Application Not Allowed to Display Notifications")
            @unknown default:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "OPENAPP":
            print("OPEN APP")
            break
        case "CLOSEAPP":
            print("CLOSE APP")
            exit(0)
        default:
            print("DEFAULT")
        }

        completionHandler()
    }
    
    //JP - BACKGROUND NOTIFICATION ALERT CODE END
}

extension AppDelegate: AVPictureInPictureControllerDelegate {

    public func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        failedToStartPictureInPictureWithError error: Error
    ) {
        print("\(#function)")
        print("pip error: \(error)")
    }

    public func pictureInPictureControllerWillStartPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController
    ) {
       // self.stopPIPMode()
        print("\(#function)")
      //  Prevent screen from locking while PiP is active
        UIApplication.shared.isIdleTimerDisabled = true
    }

    public func pictureInPictureControllerWillStopPictureInPicture(
        _ pictureInPictureController: AVPictureInPictureController
    ) {
        // Allow screen to lock again
        UIApplication.shared.isIdleTimerDisabled = false
        self._pipController = nil
        print("\(#function)")
    }
    
    public func configureOnlineState(_ isOnline:Bool){
        self.isProviderOnline = isOnline
    
        
        configPIPmode()
    }
    
    public func configPIPmode(){
        
        if(self.isProviderOnline || self.isProviderOnJob){
            self.startPIPMode()
        }else{
            self.stopPIPMode()
        }
    }
    
}


extension AppDelegate: AVPictureInPictureSampleBufferPlaybackDelegate {

    public func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        setPlaying playing: Bool
    ) {
        print("\(#function)")
    }

    public func pictureInPictureControllerTimeRangeForPlayback(
        _ pictureInPictureController: AVPictureInPictureController
    ) -> CMTimeRange {
        print("\(#function)")
        return CMTimeRange(start: .negativeInfinity, duration: .positiveInfinity)
    }

    public func pictureInPictureControllerIsPlaybackPaused(
        _ pictureInPictureController: AVPictureInPictureController
    ) -> Bool {
        print("\(#function)")
        return false
    }

    public func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        didTransitionToRenderSize newRenderSize: CMVideoDimensions
    ) {
        print("\(#function)")
        print(newRenderSize)
    }

    public func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        skipByInterval skipInterval: CMTime,
        completion completionHandler: @escaping () -> Void
    ) {
        print("\(#function)")
        completionHandler()
    }
}

extension URL {

    static var documents: URL {
        return FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
