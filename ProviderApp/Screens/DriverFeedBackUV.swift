//
//  DriverFeedBackUV.swift
//  DriverApp
//
//  Created by ADMIN on 24/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class DriverFeedBackUV: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!

    let generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    
    var dataArrList = [NSDictionary]()
    var textSizeArr = [CGFloat]()
    
    var nextPage_str = 1
    var isLoadingMore = false
    var isNextPageAvail = false
    
    var cntView:UIView!
    
    var isFirstLaunch = true

    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
//        self.contentView.addSubview(self.generalFunc.loadView(nibName: "DriverFeedBackScreenDesign", uv: self, contentView: contentView))
        
        self.addBackBarBtn()
        
        setData()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
        // Apply initial theme
        applyTheme()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func themeDidChange() {
        applyTheme()
    }
    
    func applyTheme() {
        let themeManager = ThemeManager.shared
        
        // Update main view background
        self.view.backgroundColor = themeManager.backgroundColor()
        
        // Update content view background
        self.contentView.backgroundColor = themeManager.backgroundColor()
        
        // Update table view background (only if table view is loaded)
        if self.tableView != nil {
            self.tableView.backgroundColor = themeManager.backgroundColor()
            
            // Update separator color
            self.tableView.separatorColor = themeManager.separatorColor()
            
            // Reload table to update cell appearances
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(isFirstLaunch == true){
            
            cntView = self.generalFunc.loadView(nibName: "DriverFeedBackScreenDesign", uv: self, contentView: contentView)
            cntView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: self.contentView.frame.height)
            self.contentView.addSubview(cntView)
            
            self.tableView.delegate = self
            
            self.tableView.dataSource = self
            self.tableView.tableFooterView = UIView()
            
            if #available(iOS 15.0, *) {
                self.tableView.sectionHeaderTopPadding = 0
            } else {}
            
            self.tableView.register(UINib(nibName: "DriverFeedBackTVCell", bundle: nil), forCellReuseIdentifier: "DriverFeedBackTVCell")
            self.tableView.bounces = false
            self.dataArrList.removeAll()
            getDtata()
            
            isFirstLaunch = false
        }
        
        // Apply theme after views are fully set up
        applyTheme()
    }

    func setData(){
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        Utils.printLog(msgData: "App_Type::\(userProfileJson.get("APP_TYPE").uppercased())")
        
        if(userProfileJson.get("APP_TYPE").uppercased() == "RIDE-DELIVERY-UBERX" || userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USER_FEEDBACK")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USER_FEEDBACK")
        }else if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Deliver.uppercased()){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SENDER_fEEDBACK")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SENDER_fEEDBACK")
        }else if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Rider Feedback", key: "LBL_RIDER_FEEDBACK")
            self.title = self.generalFunc.getLanguageLabel(origValue: "Rider Feedback", key: "LBL_RIDER_FEEDBACK")
        }else{
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USER_FEEDBACK")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USER_FEEDBACK")
        }
    }
    
    func getDtata(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = Color.clear
        }else if(loaderView != nil && isLoadingMore == false){
            loaderView.isHidden = false
        }
        
        
        let parameters = ["type": "loadDriverFeedBack", "UserType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd(), "page": self.nextPage_str.description]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        self.dataArrList += [dataTemp]
                        
                        var msgHeight = dataTemp.get("vMessage").height(withConstrainedWidth: Application.screenSize.width - 80, font: UIFont(name: Fonts().light, size: 18)!)
                        if(dataTemp.get("vMessage") == ""){
                            msgHeight = 0
                        }
                        
                        self.textSizeArr += [msgHeight]
                        
                    }
                    let NextPage = dataDict.get("NextPage")
                    
                    if(NextPage != "" && NextPage != "0"){
                        self.isNextPageAvail = true
                        self.nextPage_str = Int(NextPage)!
                        
                        self.addFooterView()
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    
                    self.tableView.reloadData()
                    
                }else{
                    if(self.isLoadingMore == false){
                        _ = GeneralFunctions.addMsgLbl(contentView: self.cntView, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                }
            }else{
                if(self.isLoadingMore == false){
                    self.generalFunc.setError(uv: self)
                }
            }
            self.isLoadingMore = false
            self.loaderView.isHidden = true
            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverFeedBackTVCell", for: indexPath) as! DriverFeedBackTVCell
        
        let item = self.dataArrList[indexPath.item]
        let themeManager = ThemeManager.shared

//        cell.dateLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("tDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateInList)

        // Apply theme-aware colors to container
        cell.containerView.backgroundColor = themeManager.cardBackgroundColor()
        cell.containerView.layer.shadowOpacity = themeManager.isDarkModeActive ? 0.3 : 0.6
        cell.containerView.layer.shadowOffset = CGSize.zero
        cell.containerView.layer.shadowColor = themeManager.isDarkModeActive ? UIColor.black.cgColor : UIColor.lightGray.cgColor
        
        cell.nameLbl.text = item.get("vName")
        cell.userPicImgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        // Apply theme-aware text colors
        cell.nameLbl.textColor = themeManager.textColor()
        cell.commentLbl.textColor = themeManager.secondaryTextColor()
        cell.dateLbl.textColor = themeManager.secondaryTextColor()
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.ratingBar.rating = item.get("vRating1") == "" ? 0 : Float(item.get("vRating1"))!
        cell.commentLbl.text = item.get("vMessage") == "" ? "" : item.get("vMessage")
        if item.get("vMessage") == "" {
            cell.commentLbl.isHidden = true
        }else {
            cell.commentLbl.isHidden = false
        }
        
        cell.dateLbl.text = "\(Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("tDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: "dd MMM, yyyy (EEE)"))"
        cell.commentLbl.fitText()
        
        // Apply theme-aware border color
        let borderColor = themeManager.isDarkModeActive ? UIColor.darkGray : UIColor.lightGray
        Utils.createRoundedView(view: cell.userPicImgView, borderColor: borderColor, borderWidth: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return  165 + self.textSizeArr[indexPath.item]
//        return  165 + (self.textSizeArr[indexPath.item] == 0 ? -40 : self.textSizeArr[indexPath.item])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 15) {
            
            if(isNextPageAvail==true && isLoadingMore==false){
                
                isLoadingMore=true
                
                getDtata()
            }
        }
    }
    
    func addFooterView(){
        let loaderView =  self.generalFunc.addMDloader(contentView: self.tableView, isAddToParent: false)
        loaderView.backgroundColor = UIColor.clear
        loaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 80)
        self.tableView.tableFooterView  = loaderView
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func removeFooterView(){
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
    }
}
