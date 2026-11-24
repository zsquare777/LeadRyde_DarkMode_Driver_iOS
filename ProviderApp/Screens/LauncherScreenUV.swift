//
//  LauncherScreenUV.swift
//  DriverApp
//
//  Created by ADMIN on 04/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import NVActivityIndicatorView

class LauncherScreenUV: UIViewController, OnLocationUpdateDelegate {

    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    @IBOutlet weak var bgImgView: UIImageView!
    let generalFunc = GeneralFunctions()
    
    var getLocation:GetLocation!
    var locationDialog:MTDialog!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        indicatorView.type = .ballPulse
        indicatorView.tintColor = UIColor.UCAColor.AppThemeColor
        indicatorView.color = UIColor.UCAColor.AppThemeColor
//        indicatorView.size = 50
        
        indicatorView.startAnimating()
        
        continueProcess()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.view.addSubview(self.generalFunc.loadView(nibName: "LauncherScreenDesign", uv: self))
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        //self.bgImgView.image = Utils.appLaunchImage()
      
    }
    
//    isOtherButton
    func continueProcess(){
        
        if(InternetConnection.isConnectedToNetwork() == false){
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "No Internet Connection", key: "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
                self.continueProcess()
            })
            
            return
        }
        
        if(Configurations.isUserLoggedIn() == false){
            downloadData()
        }else{
            autoLogin()
        }
    }
    
    func fetchAppStoreVersion(completion: @escaping (String?) -> Void) {
        let appID = CommonUtils.appleAppId

        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appID)") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("❌ Network error: \(error?.localizedDescription ?? "unknown")")
                completion(nil)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let appStoreVersion = results.first?["version"] as? String {
                print("✅ App Store Version: \(appStoreVersion)")
                completion(appStoreVersion)
            } else {
                print("❌ Failed to get version from App Store")
                completion(nil)
            }
        }.resume()
    }

    func downloadData(){
        
        var parameters = ["type":"generalConfigData","UserType": Utils.appUserType, "AppVersion": Utils.applicationVersion()]
        
        if(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) != nil){
            parameters["vLang"] = (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String)
        }
        if(GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) != nil){
            parameters["vCurrency"] = (GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String)
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        //  exeWebServerUrl.featureClassListPara = GetFeatureClassList.getAllGeneralClasses()
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    SinchCalling.getInstance().initSinchClient()
                    //                    if(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil || (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) == dataDict.getObj("DefaultLanguageValues").get("vCode")){
                    
                    SetDataInPreference().setDataWithResponse(dataDict: dataDict, isLogedIn: false)
                    
                    IQKeyboardManager.shared.toolbarDoneBarButtonItemText = (GeneralFunctions()).getLanguageLabel(origValue: "Done", key: "LBL_DONE")
                    
                    if(dataDict.get("SERVER_MAINTENANCE_ENABLE").uppercased() == "YES"){
                        
                        let maintenancePageUV = GeneralFunctions.instantiateViewController(pageName: "MaintenancePageUV") as! MaintenancePageUV
                        
                        GeneralFunctions.changeRootViewController(window: Application.window!, viewController: maintenancePageUV)
                        
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            let appLoginUv = GeneralFunctions.instantiateViewController(pageName: "AppLoginUV") as! AppLoginUV
                            GeneralFunctions.changeRootViewController(window: Application.window!, viewController: appLoginUv)
                        }
                    }
                    
                }else{
                    
                    if(dataDict.get("isAppUpdate") != "" && dataDict.get("isAppUpdate") == "true"){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NEW_UPDATE_AVAIL"), content: self.generalFunc.getLanguageLabel(origValue: "New update is available to download. Downloading the latest update, you will get latest features, improvements and bug fixes.", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Update", key: "LBL_UPDATE"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
//                                UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/bars/id\(CommonUtils.appleAppId)")!)
                                if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(CommonUtils.appleAppId)") {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                            
                            self.continueProcess()
                            
                        })
                        return
                    }
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: dataDict.get("message") == "" ? self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT") : dataDict.get("message"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.continueProcess()
                    })
                }
                
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.continueProcess()
                })
                //                self.generalFunc.setError(self, completionHandler: { (isBtnClicked) -> Void in
                //                    self.findTripData()
                //                })
            }
        })
    }
    
    @objc func appInForground(){
        self.autoLogin()
    }
    
    func addBackgroundObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
    }
    
    func autoLogin(){
        
        
        var parameters = ["type":"getDetail","UserType": Utils.appUserType, "AppVersion": Utils.applicationVersion(), "vDeviceType": Utils.deviceType, "iUserId": GeneralFunctions.getMemberd()]
        
        if(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) != nil){
            parameters["vLang"] =  "\(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String)"
        }
        
        let extraRequestParams = CabRequestStatus.getAllStatusParam()
        for key in extraRequestParams.allKeys {
            parameters[key as! String] = extraRequestParams.get(key as! String)
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            GeneralFunctions.removeObserver(obj: self)
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                    GeneralFunctions.logOutUser()
                    self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.continueProcess()
                    })
                    
                    return
                }
                if(dataDict.get("Action") == "1"){
                    
                    CabRequestStatus.removeDriverRequestStatus(reqKeys: extraRequestParams)
                    
                    _ = SetUserData(uv: self, userProfileJson: dataDict, isStoreUserId: false)
                    
                    if(dataDict.getObj(Utils.message_str).get("SERVER_MAINTENANCE_ENABLE").uppercased() == "YES"){
                        
                        let maintenancePageUV = GeneralFunctions.instantiateViewController(pageName: "MaintenancePageUV") as! MaintenancePageUV
                        
                        GeneralFunctions.changeRootViewController(window: Application.window!, viewController: maintenancePageUV)
                        
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            
                            let window = UIApplication.shared.delegate!.window!
                            _ = OpenMainProfile(uv: self, userProfileJson: response, window: window!)
                        }
                    }
                    
                }else{
                    
                    if(dataDict.get("isAppUpdate") != "" && dataDict.get("isAppUpdate") == "true"){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NEW_UPDATE_AVAIL"), content: self.generalFunc.getLanguageLabel(origValue: "New update is available to download. Downloading the latest update, you will get latest features, improvements and bug fixes.", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Update", key: "LBL_UPDATE"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
//                                UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/bars/id\(CommonUtils.appleAppId)")!)
                                if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(CommonUtils.appleAppId)") {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                            
                            self.continueProcess()
                            
                        })
                        return
                    }else{
                        
                        if(dataDict.get(Utils.message_str) == "LBL_CONTACT_US_STATUS_NOTACTIVE_DRIVER" || dataDict.get(Utils.message_str) == "LBL_ACC_DELETE_TXT"){
                            GeneralFunctions.logOutUser()
                            //                            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            //
                            //                                self.continueProcess()
                            //                            })
                            
                            self.openAccStatusInvalid(dataDict: dataDict)
                            
                            return
                        }
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: dataDict.get("message") == "" ? self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT") : dataDict.get("message"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            self.continueProcess()
                        })
                    }
                    
                }
                
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.continueProcess()
                })
                //                self.generalFunc.setError(self, completionHandler: { (isBtnClicked) -> Void in
                //                    self.findTripData()
                //                })
            }
        })
        
    }
    
    func openAccStatusInvalid(dataDict:NSDictionary){
        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), completionHandler: { (btnClickedIndex) in
            
            if(btnClickedIndex == 0){
                self.continueProcess()
            }else{
                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                self.pushToNavController(uv: contactUsUv)
                self.openAccStatusInvalid(dataDict: dataDict)
            }
        })
    }
}
