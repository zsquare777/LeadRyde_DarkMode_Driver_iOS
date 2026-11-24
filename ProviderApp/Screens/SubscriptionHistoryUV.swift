//
//  SubscriptionHistoryUV.swift
//  DriverApp
//
//  Created by Apple on 20/05/19.
//  Copyright © 2019 @. All rights reserved.
//

import UIKit

class SubscriptionHistoryUV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var cntView:UIView!
    
    var generalFunc = GeneralFunctions()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var headerLbl: MyLabel!
    @IBOutlet weak var headerDetailLbl: MyLabel!
    @IBOutlet weak var headerSepView: UIView!
    
    var dataArrList = [NSDictionary]()
    
    var extraHeightArray = [CGFloat] ()
    
    var SCREEN_TYPE = "History"
    
    var msgLbl:MyLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackBarBtn()
        
        cntView = self.generalFunc.loadView(nibName: "SubscriptionHistoryScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        
        if(SCREEN_TYPE == "History"){
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_HISTORY_TITLE_TXT")
        }else{
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_DETAILS")
        }
        
        self.headerView.isHidden = true
        self.tableView.isHidden = true
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setHeaderView()
        self.tableView.reloadData()
        
    }
    
    func setHeaderView(){
       
        
        self.headerSepView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.headerImgView, color: UIColor.UCAColor.AppThemeColor)
        
        var headerDetailLbltxt = ""
        
        self.headerLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        self.tableView.register(UINib(nibName: "SubscriptionDetailTVCell", bundle: nil), forCellReuseIdentifier: "SubscriptionDetailTVCell")
        self.tableView.delegate = self
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {}
        
        if(self.msgLbl != nil){
            self.msgLbl.isHidden = true
        }
        
        if(SCREEN_TYPE == "History"){
            self.headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_HISTORY_TXT")
            headerDetailLbltxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_HISTORY_DESC_TXT")
            
            self.getPlans()
            
        }else{
            
            self.headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YOUR_MEMBERSHIP_DETAILS")
            headerDetailLbltxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MEMBERSHIP_DETAILS_DESC_TXT")
            self.headerView.isHidden = false
            self.tableView.isHidden = false
        }
        self.headerDetailLbl.text = headerDetailLbltxt
        
        self.tableView.parallaxHeader.view = self.headerView
        self.tableView.parallaxHeader.height = 195 + headerDetailLbltxt.height(withConstrainedWidth: Application.screenSize.width - 40, font:UIFont.init(name: Fonts().regular, size: 17)!)
        self.tableView.parallaxHeader.mode = .bottom
        self.tableView.parallaxHeader.minimumHeight = 10
      
    }
    
    func getPlans(){
        
        self.dataArrList.removeAll()
        let parameters = ["type": "getDriverSubscriptionHistory", "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.headerView.isHidden = false
            self.tableView.isHidden = false
            
            if(response != ""){
                
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.dataArrList = dataDict.getArrObj(Utils.message_str) as! [NSDictionary]
                    
                    for i in 0..<self.dataArrList.count{
                        self.extraHeightArray.append(self.dataArrList[i].get("vPlanDescription").height(withConstrainedWidth: Application.screenSize.width - 40, font:UIFont.init(name: Fonts().regular, size: 15)!))
                    }
                    
                    self.tableView.reloadData()
                    
                }else{
                    
                    if(self.msgLbl != nil){
                        self.msgLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message"))
                        self.msgLbl.isHidden = false
                        self.headerView.isHidden = true
                        
                    }else{
                        self.headerView.isHidden = true
                        self.msgLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                }
            }else{
                self.getPlans()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionDetailTVCell", for: indexPath) as! SubscriptionDetailTVCell
        
        cell.subscriptionPlanView.isHidden = true
        cell.subscriptionDetailsView.isHidden = false
        cell.daysLeftView.isHidden = true
        
        var statusLbl = ""
        if(SCREEN_TYPE == "Detail"){
            
            cell.sH1Lbl.text = ": " + self.dataArrList[indexPath.row].get("PlanType")
            if(self.dataArrList[indexPath.row].get("eSubscriptionStatus").uppercased() == "SUBSCRIBED"){
                
                statusLbl = "LBL_SUBSCRIBED_TXT"
                
                cell.sDetailsStackViewTrailSpace.constant = 75
                cell.daysLeftView.isHidden = false
                cell.daysLeftView.backgroundColor = UIColor.UCAColor.AppThemeColor.lighter()
                cell.daysLeftLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            
            }else if(self.dataArrList[indexPath.row].get("eSubscriptionStatus").uppercased() == "UNSUBSCRIBED"){
                
                cell.sDetailsStackViewTrailSpace.constant = 0
                cell.daysLeftView.isHidden = true
                statusLbl = "LBL_NOT_SUBSCRIBED_TXT"
                
            }else if(self.dataArrList[indexPath.row].get("eSubscriptionStatus").uppercased() == "EXPIRED"){
                
                cell.sDetailsStackViewTrailSpace.constant = 0
                cell.daysLeftView.isHidden = true
                statusLbl = "LBL_SUB_EXPIRED_TXT"
                
            }else if(self.dataArrList[indexPath.row].get("eSubscriptionStatus").uppercased() == "CANCELLED"){
                
                cell.sDetailsStackViewTrailSpace.constant = 0
                cell.daysLeftView.isHidden = true
                statusLbl = "LBL_SUB_CANCELLED_TXT"
                
            }
          
        }else{
            
            if(Configurations.isRTLMode()){
                cell.sH1Lbl.text = self.dataArrList[indexPath.row].get("vPlanName") + " :"
            }else{
                cell.sH1Lbl.text = ": " + self.dataArrList[indexPath.row].get("vPlanName")
            }
            
    
            if(self.dataArrList[indexPath.row].get("eSubscriptionStatus").uppercased() == "SUBSCRIBED"){
                
                statusLbl = "LBL_SUB_ACTIVE_TXT"
                if(self.dataArrList[indexPath.row].get("planLeftDays") != "" && GeneralFunctions.parseInt(origValue: 0, data: self.dataArrList[indexPath.row].get("planLeftDays")) != 0){
                    cell.sDetailsStackViewTrailSpace.constant = 75
                    cell.daysLeftView.isHidden = false
                    cell.daysLeftView.backgroundColor = UIColor.UCAColor.AppThemeColor.lighter()
                    cell.daysLeftLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                }else{
                    cell.sDetailsStackViewTrailSpace.constant = 0
                    cell.daysLeftView.isHidden = true
                }
               
            }else if(self.dataArrList[indexPath.row].get("eSubscriptionStatus").uppercased() == "EXPIRED"){
              
                cell.sDetailsStackViewTrailSpace.constant = 0
                cell.daysLeftView.isHidden = true
                statusLbl = "LBL_SUB_EXPIRED_TXT"
                
                
            }else if(self.dataArrList[indexPath.row].get("eSubscriptionStatus").uppercased() == "CANCELLED"){
                
                cell.sDetailsStackViewTrailSpace.constant = 0
                cell.daysLeftView.isHidden = true
                statusLbl = "LBL_SUB_CANCELLED_TXT"
                
            }else if(self.dataArrList[indexPath.row].get("eSubscriptionStatus").uppercased() == "INACTIVE"){
                
                cell.sDetailsStackViewTrailSpace.constant = 0
                cell.daysLeftView.isHidden = true
                statusLbl = "LBL_SUB_INACTIVE_TXT"
            }
       
        }
        
        cell.sDurHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_PLAN_DURATION_TXT")
        
        if(Configurations.isRTLMode()){
            cell.sDurVLbl.text = Configurations.convertNumToAppLocal(numStr: self.dataArrList[indexPath.row].get("PlanDuration")) + " :"
            
            cell.sH2Lbl.text = Configurations.convertNumToAppLocal(numStr: self.dataArrList[indexPath.row].get("fPlanPrice")) + ": "
            cell.sH3Lbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.dataArrList[indexPath.row].get("tSubscribeDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay) + " :"
            cell.sH4Lbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.dataArrList[indexPath.row].get("tExpiryDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay) + " :"
        }else{
            cell.sDurVLbl.text = ": " + Configurations.convertNumToAppLocal(numStr: self.dataArrList[indexPath.row].get("PlanDuration"))
            
            cell.sH2Lbl.text = ": " + Configurations.convertNumToAppLocal(numStr: self.dataArrList[indexPath.row].get("fPlanPrice"))
            cell.sH3Lbl.text = ": " + Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.dataArrList[indexPath.row].get("tSubscribeDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
            cell.sH4Lbl.text = ": " + Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.dataArrList[indexPath.row].get("tExpiryDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
        }
        
        
        cell.bottomStatusLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: statusLbl)
        cell.bottomMonthLbl.text = self.dataArrList[indexPath.row].get("PlanDuration")
        
        
        let daysLeftTxt = self.dataArrList[indexPath.row].get("planLeftDays") + "\n" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DAYS") + "\n" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_DAYS_LEFT_TXT")
        let attributedString = NSMutableAttributedString(string: daysLeftTxt)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5 // Whatever line spacing you want in points
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        cell.daysLeftLbl.attributedText = attributedString
        
        cell.bottomStatusLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        cell.bottomMonthLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        cell.h1Lbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_PLAN_NAME")
        cell.h2Lbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_PLAN_PRICE_TXT")
        cell.h3Lbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_ON_TXT")
        cell.h4Lbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_EXPIRED_ON_TXT")
       
        cell.sDetailBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
       // cell.bottomStatusLbl.text =
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(SCREEN_TYPE == "History"){
            return 230
        }else{
            return 250
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
