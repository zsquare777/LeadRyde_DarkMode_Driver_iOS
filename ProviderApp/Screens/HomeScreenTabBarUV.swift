//
//  HomeScreenTabBarUV.swift
//  PassengerApp
//
//  Created by Apple on 02/08/19.
//  Copyright © 2019 @. All rights reserved.


import UIKit

class HomeScreenTabBarUV: UITabBarController {
    
    var tabbarHidden = false {
        didSet {
            var frame = self.view.bounds
            if tabbarHidden {
                frame.size.height += self.tabBar.bounds.size.height + 4
            } else {
                frame.size.height -= (self.tabBar.bounds.size.height + 4)
            }
            self.view.frame = frame
        }
    }
    
    lazy var bannerAd: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: 0xf1f1f1)
        return view
    }()
    
    var navItem: UINavigationItem!
    var kBarHeight: CGFloat = 64
    var bannerAdHeight: CGFloat = 4
    
    let generalFunc = GeneralFunctions()
    
    var mainScreenUV: MainScreenUV!
    var driverStatesUV: DriverStatesUV!
    var accountSuspendUV: AccountSuspendUV!
    
    var bookingTabUV: BookingTabUV!
    var manageWalletUV: YourZonesUV!
    var manageProfileUv: ViewProfileUV!
    
    var tabBarViewHeight: CGFloat!
    
    var isFromDeliverAllLiveTask = false
    var liveTaskData: NSDictionary!
    
    var isFirstLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.invalidateIntrinsicContentSize()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = kBarHeight
        tabFrame.origin.y = self.view.frame.size.height - bannerAdHeight - kBarHeight
        self.tabBar.frame = tabFrame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Configurations.setLightStatusBar()
        if isFirstLoad == false {
            isFirstLoad = true
            delegate = self
            kBarHeight = kBarHeight + GeneralFunctions.getSafeAreaInsets().bottom
            
        
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(hex: 0xf1f1f1)
                
                let boldFont = UIFont.boldSystemFont(ofSize: 16)
                
                let normalAttributes: [NSAttributedString.Key: Any] = [
                    .font: boldFont,
                    .foregroundColor: UIColor.black
                ]
                let selectedAttributes: [NSAttributedString.Key: Any] = [
                    .font: boldFont,
                    .foregroundColor: UIColor.UCAColor.AppThemeColor
                ]
                
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
                appearance.inlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
                appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
                appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
                appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
                
                self.tabBar.standardAppearance = appearance
                self.tabBar.scrollEdgeAppearance = appearance
            } else {
                let boldFont = UIFont.boldSystemFont(ofSize: 16)
                UITabBarItem.appearance().setTitleTextAttributes([
                    .font: boldFont,
                    .foregroundColor: UIColor.gray
                ], for: .normal)
                UITabBarItem.appearance().setTitleTextAttributes([
                    .font: boldFont,
                    .foregroundColor: UIColor.UCAColor.AppThemeColor
                ], for: .selected)
            }
            
            
            self.tabBar.tintColor = UIColor.UCAColor.AppThemeColor
            
            // Add bottom spacer view
            view.addSubview(bannerAd)
            bannerAd.heightAnchor.constraint(equalToConstant: bannerAdHeight).isActive = true
            bannerAd.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            bannerAd.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            
            manageWalletUV = (GeneralFunctions.instantiateViewController(pageName: "YourZonesUV") as! YourZonesUV)
            manageWalletUV.homeTabBar = self
            let icon3 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALL_ZONE_TXT"),
                                     image: UIImage(named: "zoneMenu"),
                                     selectedImage: UIImage(named: "zoneMenu"))
            manageWalletUV.tabBarItem = icon3
            
            manageProfileUv = (GeneralFunctions.instantiateViewController(pageName: "ViewProfileUV") as! ViewProfileUV)
            manageProfileUv.homeTabBar = self
            let icon4 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_PROFILE"),
                                     image: UIImage(named: "ic_home_profile"),
                                     selectedImage: UIImage(named: "ic_home_profile"))
            manageProfileUv.tabBarItem = icon4
            
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            let eStatus = userProfileJson.get("eStatus")
            
            var bookingsUV: BookingsUV!
            if (userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) {
                if (userProfileJson.get("ONLYDELIVERALL") == "Yes") {
                    bookingsUV = GeneralFunctions.instantiateViewController(pageName: "BookingsUV") as? BookingsUV
                    bookingsUV.PAGE_TYPE = "ORDER"
                    bookingsUV.homeTabBar = self
                    let icon2 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "Orders", key: "LBL_ORDERS_TXT"),
                                             image: UIImage(named: "ic_home_bookings"),
                                             selectedImage: UIImage(named: "ic_home_bookings"))
                    bookingsUV.tabBarItem = icon2
                    bookingsUV.navItem = self.navItem
                } else {
                    bookingTabUV = (GeneralFunctions.instantiateViewController(pageName: "BookingTabUV") as! BookingTabUV)
                    bookingTabUV.homeTabBar = self
                    let icon2 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_BOOKINGS"),
                                             image: UIImage(named: "ic_home_bookings"),
                                             selectedImage: UIImage(named: "ic_home_bookings"))
                    bookingTabUV.tabBarItem = icon2
                }
            } else {
                bookingsUV = GeneralFunctions.instantiateViewController(pageName: "BookingsUV") as? BookingsUV
                bookingsUV.PAGE_TYPE = "BOOKING"
                bookingsUV.homeTabBar = self
                let icon2 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_BOOKINGS"),
                                         image: UIImage(named: "ic_home_bookings"),
                                         selectedImage: UIImage(named: "ic_home_bookings"))
                bookingsUV.tabBarItem = icon2
                bookingsUV.isFromViewProfile = true
                bookingsUV.navItem = self.navItem
            }
            
            if (eStatus == "inactive") {
                driverStatesUV = (GeneralFunctions.instantiateViewController(pageName: "DriverStatesUV") as! DriverStatesUV)
                driverStatesUV.homeTabBar = self
                let icon1 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_BOTTOM_MENU"),
                                         image: UIImage(named: "ic_search_locmap"),
                                         selectedImage: UIImage(named: "ic_search_locmap"))
                driverStatesUV.tabBarItem = icon1
                
                if (userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) {
                    if (userProfileJson.get("ONLYDELIVERALL") == "Yes") {
                        let controllers = [driverStatesUV!, bookingsUV!, manageWalletUV!, manageProfileUv!]
                        self.viewControllers = controllers
                    } else {
                        let controllers = [driverStatesUV!, bookingTabUV!, manageWalletUV!, manageProfileUv!]
                        self.viewControllers = controllers
                    }
                } else {
                    let controllers = [driverStatesUV!, bookingsUV!, manageWalletUV!, manageProfileUv!]
                    self.viewControllers = controllers
                }
            } else if (eStatus == "Suspend") {
                accountSuspendUV = (GeneralFunctions.instantiateViewController(pageName: "AccountSuspendUV") as! AccountSuspendUV)
                accountSuspendUV.homeTabBar = self
                
                if (userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) {
                    if (userProfileJson.get("ONLYDELIVERALL") == "Yes") {
                        let controllers = [accountSuspendUV!, bookingsUV!, manageWalletUV!, manageProfileUv!]
                        self.viewControllers = controllers
                    } else {
                        let controllers = [accountSuspendUV!, bookingTabUV!, manageWalletUV!, manageProfileUv!]
                        self.viewControllers = controllers
                    }
                } else {
                    let controllers = [accountSuspendUV!, bookingsUV!, manageWalletUV!, manageProfileUv!]
                    self.viewControllers = controllers
                }
            } else {
                if isFromDeliverAllLiveTask {
                    // keep your existing flow
                } else {
                    var appTerminated = UserDefaults.standard.string(forKey: "appTerminated")
                    print("pushKillMain:\(UserDefaults.standard.string(forKey: "pushReceived"))")
                    print("appKillMain:\(UserDefaults.standard.string(forKey: "appTerminated"))")
                    
                    if appState == "kill" {
                        appState = ""
                        rideEnd = ""
                        startFromForeground = "no"
                        if let result = UserDefaults.standard.dictionary(forKey: "notificationBody") {
                            let viewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                            let cabRequestedUV = GeneralFunctions.instantiateViewController(pageName: "CabRequestedUV") as! CabRequestedUV
                            cabRequestedUV.passengerJsonDetail_dict = result as NSDictionary
                            cabRequestedUV.initializedMiliSeconds = Utils.currentTimeMillis()
                            viewController!.closeDrawerMenu()
                            GeneralFunctions.removeAllAlertViewFromNavBar(uv: viewController!)
                            DispatchQueue.main.async() {
                                if viewController!.navigationController == nil {
                                    let navController = UINavigationController(rootViewController: cabRequestedUV)
                                    navController.navigationBar.isTranslucent = false
                                    viewController!.present(navController, animated: false, completion: nil)
                                } else {
                                    viewController!.navigationController?.pushViewController(cabRequestedUV, animated: false)
                                }
                            }
                        }
                    }
                    UserDefaults.standard.set("", forKey: "resultPush")
                    if startFromForeground == "" {
                        rideEnd = "done"
                    }
                    mainScreenUV = (GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV)
                    mainScreenUV.homeTabBar = self
                    let icon1 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_BOTTOM_MENU"),
                                             image: UIImage(named: "ic_search_locmap"),
                                             selectedImage: UIImage(named: "ic_search_locmap"))
                    mainScreenUV.tabBarItem = icon1
                    
                    if (userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX) {
                        if (userProfileJson.get("ONLYDELIVERALL") == "Yes") {
                            let controllers = [mainScreenUV!, bookingsUV!, manageWalletUV!, manageProfileUv!]
                            self.viewControllers = controllers
                        } else {
                            let controllers = [mainScreenUV!, bookingTabUV!, manageWalletUV!, manageProfileUv!]
                            self.viewControllers = controllers
                        }
                    } else {
                        let controllers = [mainScreenUV!, bookingsUV!, manageWalletUV!, manageProfileUv!]
                        self.viewControllers = controllers
                    }
                }
            }
            
            for i in 0..<(self.viewControllers?.count ?? 0) {
                let viewController = self.viewControllers![i]
                if viewController.isKind(of: DriverStatesUV.self) {
                    self.setnavBarTintColor(color: UIColor(hex: 0x15ADDE))
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarViewHeight = self.view.frame.size.height
        self.tabBar.layer.addShadow(opacity: 0.9, radius: 2.5, UIColor.gray)
    }
    
    // MARK: - Delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if viewController.isKind(of: MainScreenUV.self) {
            (viewController as! MainScreenUV).isTabNavigationPerformed = true
            let mainScreen = viewController as! MainScreenUV
            if let currentVC = selectedViewController, currentVC.isKind(of: MainScreenUV.self) {
                mainScreen.zonesDetailView.isHidden = true
                mainScreen.isZoneShow = "yes"
                mainScreen.isBidShow = "yes"
            }
        }
        isZoneTap = false
        let fromVC = selectedViewController
        let toVC = viewController
        let fromViewLoaded = fromVC?.isViewLoaded ?? false
        let toViewLoaded = toVC.isViewLoaded
        let fromView = fromVC?.view
        let toView = toVC.view
        
        if fromView == nil || toView == nil {
            print("❗️View is nil: fromViewLoaded=\(fromViewLoaded), toViewLoaded=\(toViewLoaded)")
            return true
        }
        
        if (selectedViewController?.isKind(of: ViewProfileUV.self) ?? false) {
            (selectedViewController as! ViewProfileUV).tableViewLastCntOffset = nil
        }
        
        if fromView != toView {
            self.removeTitleView()
        }
        return true
    }
    
    override func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
    
    func setTabBarVisible(visible: Bool, animated: Bool, completion: @escaping ((Bool)->Void)) {
        if ((self.tabBar.isHidden == false && visible == true) || (self.tabBar.isHidden == true && visible == false)) {
            return completion(false)
        }
        let height = self.tabBar.frame.size.height + self.bannerAdHeight
        let offsetY = (visible ? -height : height)
        let duration = (animated ? 0.3 : 0.0)
        
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
            let frame = self.tabBar.frame
            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
            if visible {
                self.tabBar.isHidden = false
                self.bannerAd.isHidden = false
            } else {
                self.tabBar.isHidden = true
                self.bannerAd.isHidden = true
            }
        }, completion: completion)
    }
    
    func removeTitleView() {
        self.navItem.leftBarButtonItem = nil
        self.navItem.rightBarButtonItem = nil
        self.navItem.titleView = nil
    }
}

// MARK: - Transition
class MyTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.3
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: .to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: { success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
