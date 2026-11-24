//
//  CommonUtils.swift
//  Login_SignUp
//
//

import UIKit

class CommonUtils {
    
    static let appleAppId = "1575358247"
    
    static let prodURL: String = "https://demo.leadryde.com/"
//    static let prodURL: String = "https://app.leadryde.com/"
//    static let stagingURL: String = "https://app.leadryde.com/"
    static let stagingURL: String = "https://demo.leadryde.com/"
    
    //    static let prodURL: String = "https://leadryde.com/"
    //    static let prodURL: String = "https://www.leadryde.com/"
    //    static let webServer: String = "https://www.leadryde.com/beta/"
    
    
    static let webServer: String = {
            #if STAGING
            return stagingURL
            #else
            return prodURL
            #endif
    }()
    
    
    static var webservice_path: String = "\(webServer)webservice_shark_v2.php";
    
    static let google_geoCode_url: String = "https://maps.googleapis.com/maps/api/geocode/json"
    static let google_direction_url: String = "https://maps.googleapis.com/maps/api/directions/json"
    static let linkedin_url: String = "\(webServer)linkedin-login/linkedin-app.php"
    static let app_user_name = "Driver"
    
    static let user_image_url = webServer + "webimages/upload/Driver/"
    static let passenger_image_url = webServer + "webimages/upload/Passenger/"
    static let restauarant_image_url = webServer + "webimages/upload/Company/"
    
    static let PAYMENTLINK =  webServer+"assets/libraries/webview/payment_configuration_trip.php?";
}
