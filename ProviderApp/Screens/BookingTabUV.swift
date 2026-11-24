//
//  BookingTabUV.swift
//  DriverApp
//
//  Created by Admin on 10/09/19.
//  Copyright © 2019 @. All rights reserved.
//


import UIKit

class BookingTabUV: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var buttonBarContainerView: UIView!
    
    let generalFunc = GeneralFunctions()
    
    var viewControllersArr:[UIViewController]!

    var homeTabBar:HomeScreenTabBarUV!
    var isOpenFromMainScreen = false
    
    var isDirectPush:Bool = false
    var isFromViewProfile:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBackBarBtn()
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings.style.buttonBarItemTitleColor = UIColor.UCAColor.AppThemeColor
        
        self.topHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
        buttonBarView.selectedBar.backgroundColor = UIColor.clear
        
        buttonBarView.backgroundColor = UIColor.clear
        
        buttonBarView.layer.zPosition = 9999
        
        //self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_BOOKINGS")
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.black
            newCell?.label.textColor = UIColor.white
            
            newCell?.label.font = UIFont.init(name: Fonts().semibold, size: 16)
            oldCell?.label.font = UIFont.init(name: Fonts().semibold, size: 16)
            
            oldCell?.label.backgroundColor = UIColor.clear
            newCell?.label.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            newCell?.backgroundColor = UIColor.UCAColor.AppThemeColor
            oldCell?.backgroundColor = UIColor.clear
            
            
        }
        
        self.buttonBarContainerView.alpha = 0
        self.topHeaderView.alpha = 0
        self.buttonBarView.alpha = 0
        
        self.containerView.backgroundColor = UIColor(hex: 0xf1f1f1)
        
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200, height: 44.0))
        label.font = UIFont(name: Fonts().regular, size: 18)!
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        
        var navigationHeaderTitle = ""
       let  userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)

        if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your trips", key: "LBL_YOUR_TRIPS")
        }else if(userProfileJson.get("APP_TYPE").uppercased() == "DELIVERY"){
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your deliveries", key: "LBL_YOUR_DELIVERY")
        }else{
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your bookings", key: "LBL_YOUR_BOOKING")
        }
        label.text = navigationHeaderTitle
        label.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.navigationItem.titleView = label
        if(self.homeTabBar != nil){
            self.homeTabBar.navItem.titleView = label
        }else {
            self.navigationItem.titleView = label
        }
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    @objc func filterDataTapped(){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.backgroundColor = UIColor(hex: 0xf1f1f1)
            self.buttonBarContainerView.alpha = 1
            self.topHeaderView.alpha = 1
            self.buttonBarView.alpha = 1
            
        }, completion:{ _ in})
        
        if(buttonBarView.selectedIndex == 0 && viewControllersArr != nil && viewControllersArr.count > 0){
            
            //(viewControllersArr[0] as! BookingsUV).viewDidAppear(true)
        }
    }
    
//    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int) {
//        if toIndex == 1{
//            (viewControllersArr[1] as! DelAllStatisticsUV).viewDidAppear(true)
//        }
//    }
//    
//    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let bookingUV = GeneralFunctions.instantiateViewController(pageName: "BookingsUV") as! BookingsUV
        let orderUV = GeneralFunctions.instantiateViewController(pageName: "BookingsUV") as! BookingsUV
        
        bookingUV.PAGE_TYPE = "BOOKING"
        orderUV.PAGE_TYPE = "ORDER"
        bookingUV.homeTabBar = self.homeTabBar
        bookingUV.isDirectPush = self.isDirectPush
        bookingUV.isFromViewProfile = self.isFromViewProfile
        bookingUV.navItem = self.navigationItem
        
        orderUV.homeTabBar = self.homeTabBar
        orderUV.navItem = self.navigationItem
        var uvArr = [UIViewController]()
        

        uvArr += [bookingUV]
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        if(userProfileJson.get("ONLYDELIVERALL") == "Yes" || userProfileJson.get("DELIVERALL") == "Yes"){
            bookingUV.isMultipleTab = true
            orderUV.isMultipleTab = true
            uvArr += [orderUV]
        }
    
        viewControllersArr = uvArr
        
        return uvArr
    }
}

