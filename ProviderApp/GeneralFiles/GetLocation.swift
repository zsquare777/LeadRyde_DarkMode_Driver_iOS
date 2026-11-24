//
//  GetLocation.swift
//  DriverApp
//
//  Created by ADMIN on 25/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import CoreLocation

extension OnLocationUpdateDelegate {
    func onHeadingUpdate(heading:Double){
        
    }
    
    func onLocationUpdate(location:CLLocation){
        
    }
}

protocol OnLocationUpdateDelegate {
    func onLocationUpdate(location:CLLocation)
    func onHeadingUpdate(heading:Double)
}

class GetLocation: NSObject, CLLocationManagerDelegate {
    
    var uv:UIViewController?
    var isContinuous:Bool!
    
    var locationUpdateDelegate:OnLocationUpdateDelegate?
    
    var locationManager:CLLocationManager!
    
    var locationsPassed = [CLLocation]()
    var distanceTraveled = 0.0
    
    var isAddLoc = false
    var accuracyInM = 100.0
    
    init(uv:UIViewController?, isContinuous:Bool) {
        self.uv = uv
        self.isContinuous = isContinuous
        
        
        accuracyInM = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "LOCATION_ACCURACY_METERS") as! String)
        
        super.init()
    }
    
    func buildLocManager(locationUpdateDelegate:OnLocationUpdateDelegate){
        DispatchQueue.main.async {
            
            self.locationUpdateDelegate = locationUpdateDelegate
            
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            self.locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager!.distanceFilter = 2
            self.locationManager!.pausesLocationUpdatesAutomatically = false
            self.locationManager!.allowsBackgroundLocationUpdates = true
            self.locationManager!.startUpdatingHeading()
            self.locationManager!.requestAlwaysAuthorization()
            self.locationManager!.startUpdatingLocation()
            self.locationManager!.startMonitoringSignificantLocationChanges()
            
            if(self.locationManager != nil && self.locationManager!.location != nil){
                self.continueDispatchLoc(self.locationManager!.location!)
            }
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if(locationUpdateDelegate != nil){
            switch UIDevice.current.orientation{
            case .portrait:
                self.locationManager!.headingOrientation = .portrait
            case .portraitUpsideDown:
                self.locationManager!.headingOrientation = .portraitUpsideDown
            case .landscapeLeft:
                self.locationManager!.headingOrientation = .landscapeLeft
            case .landscapeRight:
                self.locationManager!.headingOrientation = .landscapeRight
            default:
                self.locationManager!.headingOrientation = .portrait
            }

            locationUpdateDelegate?.onHeadingUpdate(heading: newHeading.headingAccuracy)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        
        if(locationObj.horizontalAccuracy > accuracyInM){
            print("return calledddd")
            return
        }
            
        if(locationObj.timestamp.timeIntervalSinceNow > -60.0){   // The value is not older than 10 sec.
            addLocationsToArray(locations)
            continueDispatchLoc(locationObj)
        }
    }
    
    func addLocationsToArray(_ locations: [CLLocation]) {
        for location in locations {
            if !locationsPassed.contains(location) {
                locationsPassed.append(location)
            }
        }
    }
    
    func calculateAndDisplayDistance() -> Double {
        var totalDistance = 0.0
        for i in 1..<locationsPassed.count {
//            Utils.printLog(msgData: "locationsPassed::\(locationsPassed)")
            let previousLocation = locationsPassed[i-1]
            let currentLocation = locationsPassed[i]
            totalDistance += currentLocation.distance(from: previousLocation)
        }
        
        distanceTraveled = totalDistance

//        var displayDistance: String
//        displayDistance = String(format: "Distance Travelled: %.2f miles", distanceTraveled * 0.0006213712)
//        Utils.printLog(msgData: "displayDistance::\(displayDistance)")
        
        return distanceTraveled
    }
    
    func continueDispatchLoc(_ locationObj:CLLocation){
        if(locationUpdateDelegate != nil){
            locationUpdateDelegate?.onLocationUpdate(location: locationObj)
        }
        
        if(isContinuous == false){
            releaseLocationTask()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        Utils.printLog(msgData: "LocationAuthStatus:\(status.rawValue)")
    }
    
    func resumeLocationUpdates(){
        if(locationManager == nil){
            return
        }
        locationManager!.delegate = self
        locationManager!.startUpdatingHeading()
        locationManager!.startUpdatingLocation()
        locationManager!.startMonitoringSignificantLocationChanges()
    }
    
    func removeLocationUpdates(){
        if(locationManager == nil){
            return
        }
        locationManager!.delegate = nil
        locationManager!.stopUpdatingHeading()
        locationManager!.stopUpdatingLocation()
        locationManager!.stopMonitoringSignificantLocationChanges()
        
    }
    
    func releaseLocationTask(){
        
        removeLocationUpdates()
        locationUpdateDelegate = nil
        locationManager = nil
        
        if(locationUpdateDelegate != nil){
            locationUpdateDelegate = nil
        }
    }
}
