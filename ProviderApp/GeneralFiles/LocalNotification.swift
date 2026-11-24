//
//  LocalNotification.swift
//  DriverApp
//
//  Created by ADMIN on 02/09/17.
//  Copyright © 2017 @ All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotification: NSObject, UNUserNotificationCenterDelegate {
    
    class func registerForLocalNotification(on application:UIApplication) {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
                    (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    class func dispatchlocalNotification(with title: String, body: String, userInfo: NSDictionary? = nil, at date:Date, _ sound:String = "", _ identifier:String = "") {
    
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = identifier == "" ? "LOCAL_NOTIFICATION" : identifier
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let identifier = formatter.string(from: date as Date)//(userInfo != nil ? userInfo!.convertToJson() : formatter.string(from: date as Date))
        let identifier = "\(Utils.currentTimeMillis())"
        
        if let info = userInfo {
            let dic = ["body" : info, "identifier": identifier] as [String : Any]
            content.userInfo = dic as [AnyHashable : Any]
        }
       
        if(sound != ""){
            let finalSound = GeneralFunctions.reNameNotificationSound(sound)
//            content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: finalSound))//UNNotificationSound.init(named: UNNotificationSoundName(rawValue: finalSound))
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: finalSound))
        }else{
            if(GeneralFunctions.getValue(key: Utils.PROVIDER_NOTIFICATION) as! String != ""){
//                content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: GeneralFunctions.getValue(key: Utils.PROVIDER_NOTIFICATION) as! String)) //UNNotificationSound.init(named: UNNotificationSoundName(rawValue: GeneralFunctions.getValue(key: Utils.PROVIDER_NOTIFICATION) as! String))
                content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: GeneralFunctions.getValue(key: Utils.PROVIDER_NOTIFICATION) as! String))
            }else{
                content.sound = UNNotificationSound.default
                
            }
        }
        
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (date.timeIntervalSinceNow <= 0) ? 0.1 : date.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier == "" ? "LOCAL_NOTIFICATION" : identifier, content: content, trigger: trigger)

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
    }
    
    class func dispatchlocalNotification(with title: String, body: String, userInfo: NSDictionary? = nil, at date:Date, onlyInBackground:Bool, _ sound:String = "", _ identifier:String = "") {
        
//        if(onlyInBackground == true && Utils.isMyAppInBackground() == false){
//            return
//        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = identifier == "" ? "LOCAL_NOTIFICATION" : identifier

        let identifier = "\(Utils.currentTimeMillis())"
        
        if let info = userInfo {
            let dic = ["body" : info, "identifier": identifier] as [String : Any]
            content.userInfo = dic as [AnyHashable : Any]
        }

        if(sound != ""){
            let finalSound = GeneralFunctions.reNameNotificationSound(sound)
//            content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: finalSound)) //UNNotificationSound.init(named: UNNotificationSoundName(rawValue: finalSound))
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: finalSound))
        }else{
            if(GeneralFunctions.getValue(key: Utils.PROVIDER_NOTIFICATION) as! String != ""){
//                content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: GeneralFunctions.getValue(key: Utils.PROVIDER_NOTIFICATION) as! String))//UNNotificationSound.init(named: UNNotificationSoundName(rawValue: GeneralFunctions.getValue(key: Utils.PROVIDER_NOTIFICATION) as! String))
                content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: GeneralFunctions.getValue(key: Utils.PROVIDER_NOTIFICATION) as! String))
            }else{
                content.sound = UNNotificationSound.default
                
            }
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (date.timeIntervalSinceNow <= 0) ? 0.1 : date.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier == "" ? "LOCAL_NOTIFICATION" : identifier, content: content, trigger: trigger)

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }

}
