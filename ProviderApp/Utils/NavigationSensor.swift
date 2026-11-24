//
//  NavigationSensor.swift
//  DriverApp
//
//  Created by Admin on 31/10/19.
//  Copyright © 2019 @. All rights reserved.
//

import UIKit
import CoreMotion
import SpriteKit

protocol DeviceAngleChangeDelegate {
    func onDeviceAngleChanged(azimuth:Double)
}

class NavigationSensor: NSObject, OnLocationUpdateDelegate {

    public static var ENABLE_NAVIGATION_MODE_DRIVER_APP = "No"
    public static var DRIVER_APP_NAVIGATION_MODE_STRATEGY = "DeviceSensor"
    
    public static var MINIMUM_DIFF_BW_AZIMUTH:Double = 10
    private static var instance:NavigationSensor?
    private var mAzimuth:Double = -1
    
    var getLocation:GetLocation!
    
    var listeners = [UIViewController:DeviceAngleChangeDelegate]()
    
    private var updateFreqTask:UpdateFreqTask?
    private var mMotionManager:CMMotionManager?
    
    private var currentLocation:CLLocation?
    
    var activateDispatch = false
    
    override init() {
        super.init()
        
        if(NavigationSensor.ENABLE_NAVIGATION_MODE_DRIVER_APP.uppercased() != "YES"){
            if(NavigationSensor.retrieveInstance() != nil){
                NavigationSensor.getInstance().listeners.removeAll()
                
                if(NavigationSensor.getInstance().mMotionManager != nil){
                    NavigationSensor.getInstance().mMotionManager!.stopDeviceMotionUpdates()
                    NavigationSensor.getInstance().mMotionManager = nil
                }
                
                if(NavigationSensor.getInstance().updateFreqTask != nil){
                    NavigationSensor.getInstance().updateFreqTask!.stopRepeatingTask()
                    NavigationSensor.getInstance().updateFreqTask = nil
                }
            }
            return
        }
        
        if(NavigationSensor.DRIVER_APP_NAVIGATION_MODE_STRATEGY.uppercased() == "LOCATION"){
            getLocation = GetLocation(uv: nil, isContinuous: true)
            getLocation.buildLocManager(locationUpdateDelegate: self)
            return
        }
        
        let mMotionManager = CMMotionManager()
        mMotionManager.deviceMotionUpdateInterval = 1.0 / 2
        self.mMotionManager = mMotionManager
        //mMotionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: handleMove)
        
        if(mMotionManager.isDeviceMotionAvailable){
            mMotionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            let updateFreqTask = UpdateFreqTask(interval: 1.0)
            updateFreqTask.currInst = updateFreqTask
            self.updateFreqTask = updateFreqTask
            
            updateFreqTask.setTaskRunHandler { (instance) in
                if (mMotionManager.deviceMotion != nil) {
                    self.handleMove(motion: mMotionManager.deviceMotion, error: nil)
                }
            }
            updateFreqTask.startRepeatingTask()
        }
        
//        print("MotionAvail::\(mMotionManager.isDeviceMotionAvailable)")
//        mMotionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.) { (motion, error) in
//            print("MotionAvail:Called:")
//            self.handleMove(motion: motion, error: error)
//        }
    }
    
    public static func getInstance() -> NavigationSensor{
        if(instance == nil){
            instance = NavigationSensor()
        }
        return instance!
    }
    
    public static func retrieveInstance() -> NavigationSensor?{
        return instance
    }
    
    public func configSensor(activateDispatch:Bool){
        self.activateDispatch = activateDispatch
    }
    
    public func activateSensor(uv:UIViewController?, delegate:DeviceAngleChangeDelegate?){
        if(uv == nil || delegate == nil){
            return
        }
        
        listeners[uv!] = delegate!
    }
    
    public func deActivateSensor(uv:UIViewController?){
        if(NavigationSensor.retrieveInstance() == nil || uv == nil){
            return
        }
        
        listeners.removeValue(forKey: uv!)
    }
    
    public static func destroySensor(){
        if(NavigationSensor.retrieveInstance() == nil){
            return
        }
        
        NavigationSensor.getInstance().listeners.removeAll()
        
        if(NavigationSensor.getInstance().getLocation != nil){
            NavigationSensor.getInstance().getLocation!.locationUpdateDelegate = nil
            NavigationSensor.getInstance().getLocation!.releaseLocationTask()
            NavigationSensor.getInstance().getLocation = nil
        }
        
        if(NavigationSensor.getInstance().mMotionManager != nil){
            NavigationSensor.getInstance().mMotionManager!.stopDeviceMotionUpdates()
            NavigationSensor.getInstance().mMotionManager = nil
        }
        
        if(NavigationSensor.getInstance().updateFreqTask != nil){
            NavigationSensor.getInstance().updateFreqTask!.stopRepeatingTask()
            NavigationSensor.getInstance().updateFreqTask = nil
        }
        NavigationSensor.instance = nil
    }
    
    func handleMove(motion: CMDeviceMotion?, error: Error?) {
        if(motion == nil){
            return
        }
        
        if #available(iOS 11.0, *) {
            let mAzimuthAngle = motion!.heading
            
            if(abs(mAzimuth - mAzimuthAngle) > NavigationSensor.MINIMUM_DIFF_BW_AZIMUTH){
                mAzimuth = mAzimuthAngle
                for (_, value) in listeners {
                    value.onDeviceAngleChanged(azimuth: mAzimuth)
                }
            }
        }
    }
    
    func onLocationUpdate(location: CLLocation) {
        
        if(currentLocation == nil){
            currentLocation = location
        }
        
        if(getLocation != nil && location.distance(from: currentLocation!) > NavigationSensor.MINIMUM_DIFF_BW_AZIMUTH){
            mAzimuth = currentLocation!.bearingToLocationDegrees(destinationLocation: location, currentRotation: mAzimuth)
            self.currentLocation = location
            for (_, value) in listeners {
                value.onDeviceAngleChanged(azimuth: mAzimuth)
            }
        }
    }
    
    func getCurrentBearing() -> Double{
        if(!activateDispatch){
            return -1
        }
        return mAzimuth
    }
}
