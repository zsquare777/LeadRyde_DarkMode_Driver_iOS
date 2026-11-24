//
//  SuscriptionUV.swift
//  DriverApp
//
//  Created by Apple on 21/05/19.
//  Copyright © 2019 @. All rights reserved.
//

import UIKit

class SubscriptionUV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var cntView:UIView!
    
    var generalFunc = GeneralFunctions()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var headerLbl: MyLabel!
    @IBOutlet weak var headerDetailLbl: MyLabel!
    @IBOutlet weak var headerSepView: UIView!
    @IBOutlet weak var headerChooseLbl: MyLabel!
    
    var dataArrList = [NSDictionary]()
    
    var extraHeightArray = [CGFloat] ()
    
    var msgLbl:MyLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackBarBtn()
        
        cntView = self.generalFunc.loadView(nibName: "SubscriptionScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_PLANS")
        
        self.setHeaderView()
        
        self.headerView.isHidden = true
        self.tableView.isHidden = true
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    func setHeaderView(){
        
        self.headerSepView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.headerImgView, color: UIColor.UCAColor.AppThemeColor)
        self.headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIBE_WITH_US")
        self.headerLbl.textColor = UIColor.UCAColor.AppThemeColor
        let headerDetailLbltxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIPTION_GUIDE_TXT")
        self.headerDetailLbl.text = headerDetailLbltxt
        self.headerChooseLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_MEMBERSHIP")
        
        self.tableView.parallaxHeader.view = self.headerView
        self.tableView.parallaxHeader.height = 234 + headerDetailLbltxt.height(withConstrainedWidth: Application.screenSize.width - 40, font:UIFont.init(name: Fonts().regular, size: 17)!)
        self.tableView.parallaxHeader.mode = .bottom
        self.tableView.parallaxHeader.minimumHeight = 10
        
        self.tableView.register(UINib(nibName: "SubscriptionDetailTVCell", bundle: nil), forCellReuseIdentifier: "SubscriptionDetailTVCell")
        self.tableView.delegate = self
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {}

        
        let rightButton = UIBarButtonItem(image: UIImage(named: "ic_active_waybill")!.addImagePadding(x: 5, y: 5), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openAddNewVehicle))
        self.navigationItem.rightBarButtonItem = rightButton
        
        if(self.msgLbl != nil){
            self.msgLbl.isHidden = true
        }
        self.getPlans()
        
    }
    
    @objc func openAddNewVehicle(){
        let subscriptionHistoryUV = GeneralFunctions.instantiateViewController(pageName: "SubscriptionHistoryUV") as! SubscriptionHistoryUV
        subscriptionHistoryUV.SCREEN_TYPE = "History"
        self.pushToNavController(uv: subscriptionHistoryUV)
    }
    
    func getPlans(){
        
        self.dataArrList.removeAll()
        let parameters = ["type": "getSubscriptionPlans", "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.headerView.isHidden = false
            self.tableView.isHidden = false
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.dataArrList = dataDict.getArrObj(Utils.message_str) as! [NSDictionary]
                    
                    for i in 0..<self.dataArrList.count{
                        self.extraHeightArray.append(self.dataArrList[i].get("vPlanDescription").height(withConstrainedWidth: Application.screenSize.width - 40, font:UIFont.init(name: Fonts().regular, size: 16)!))
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
    
    func cancelPlanWith(detailId:String, planID:String){
        
        self.dataArrList.removeAll()
        let parameters = ["type": "CancelSubscription", "iDriverId": GeneralFunctions.getMemberd(), "iDriverSubscriptionDetailsId":detailId, "iDriverSubscriptionPlanId":planID]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.headerView.isHidden = false
            self.tableView.isHidden = false
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.getPlans()
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
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
        
        
        cell.tag = indexPath.row
        
        cell.sPlanDetailsLbl.textColor = UIColor.UCAColor.AppThemeColor
        if(Configurations.isRTLMode() == true){
            cell.sPlanDetailsLbl.textAlignment = .left
        }
        cell.sPlanDetailsLbl.text = Configurations.convertNumToAppLocal(numStr: self.dataArrList[indexPath.row].get("fPlanPrice"))
            
        cell.sPlanHLbl.text = self.dataArrList[indexPath.row].get("vPlanName")
        cell.sPlaNameLbl.text = "(" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_DURATION_TXT") + " " + Configurations.convertNumToAppLocal(numStr: self.dataArrList[indexPath.row].get("PlanDuration")) + ")"
        
        cell.sPlanDescriptionLbl.text = self.dataArrList[indexPath.row].get("vPlanDescription")

        cell.sPlanSubscribeLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        cell.sPlanSubscribeLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        cell.sPlanStatusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBSCRIBED_TXT")
        cell.sPlanStatusVLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        cell.planRenewLbl.isUserInteractionEnabled = true
        cell.planRenewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        cell.planRenewLbl.backgroundColor = UIColor(hex: 0x4864a8)
        cell.planRenewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_RENEW_PLAN_TXT")
      
        if(Configurations.isRTLMode()){
            cell.sPlanStatusLbl.text = ":" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Status")
        }else{
            cell.sPlanStatusLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Status") + ":"
        }
        
        if(self.dataArrList[indexPath.row].get("isRenew").uppercased() == "YES"){
            cell.dummyLbl.isHidden = true
            cell.planRenewLbl.isHidden = false
        }else{
            cell.dummyLbl.isHidden = false
            cell.planRenewLbl.isHidden = true
            cell.planRenewLbl.isUserInteractionEnabled = false
            cell.planRenewLbl.text = ""
            cell.planRenewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            cell.planRenewLbl.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        }
        
        var statusLbl = "LBL_SUBSCRIBE"
        if(self.dataArrList[indexPath.row].get("eSubscriptionStatus").uppercased() == "SUBSCRIBED"){
            
            
            cell.sDateStackView.isHidden = false
            cell.sDateStackViewHeight.constant = 60
            cell.sPlanStatusVLbl.isHidden = false
            cell.sPlanStatusLbl.isHidden = false
            cell.statusTopSpace.constant = 10
            cell.dateStackViewTopSpace.constant = 10
            cell.statusLblHeight.constant = 25
            
            statusLbl = "LBL_CANCEL_SUBSCRIPTION_TXT"
            
            cell.sPlanSubscribeLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            cell.sPlanSubscribeLbl.backgroundColor = UIColor.black
            
        }else{
            
            cell.sDateStackView.isHidden = true
            cell.statusTopSpace.constant = 0
            cell.dateStackViewTopSpace.constant = 0
            cell.sDateStackViewHeight.constant = 0
            cell.statusLblHeight.constant = 0
            cell.sPlanStatusVLbl.isHidden = true
            cell.sPlanStatusLbl.isHidden = true
            
            cell.sPlanSubscribeLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            cell.sPlanSubscribeLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        }
    
        cell.sDateHLbl1.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_ON_TXT")
        cell.sDateHLbl2.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_EXPIRED_ON_TXT")
        
        if(Configurations.isRTLMode()){
            cell.sDateVLbl1.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.dataArrList[indexPath.row].get("tSubscribeDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay) + " :"
            cell.sDateVLbl2.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.dataArrList[indexPath.row].get("tExpiryDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay) + " :"
        }else{
            cell.sDateVLbl1.text = ": " + Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.dataArrList[indexPath.row].get("tSubscribeDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
            cell.sDateVLbl2.text = ": " + Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.dataArrList[indexPath.row].get("tExpiryDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
        }
        
        cell.sPlanSubscribeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: statusLbl)
        cell.sPlanSubscribeLbl.tag = indexPath.row
        cell.sPlanSubscribeLbl.setOnClickListener { (Instance) in
           
            let cell = self.tableView.cellForRow(at:  IndexPath(row: Instance.tag, section: 0)) as! SubscriptionDetailTVCell
            if(cell.sPlanSubscribeLbl.text == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_SUBSCRIPTION_TXT")){
                
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_SUBSCRIPTION_NOTE_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES").uppercased(), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO").uppercased(), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
    
                        self.cancelPlanWith(detailId: self.dataArrList[cell.tag].get("iDriverSubscriptionPlanId"),planID:self.dataArrList[cell.tag].get("iDriverSubscriptionPlanId"))
                    }
                    
                })
                
            }else{
                let subscriptionPaymentUV = GeneralFunctions.instantiateViewController(pageName: "SubscriptionPaymentUV") as! SubscriptionPaymentUV
                subscriptionPaymentUV.planDetails = self.dataArrList[Instance.tag]
                self.pushToNavController(uv: subscriptionPaymentUV)
            }
        }
        
        cell.planRenewLbl.tag = indexPath.row
        cell.planRenewLbl.setOnClickListener { (Instance) in
            let subscriptionPaymentUV = GeneralFunctions.instantiateViewController(pageName: "SubscriptionPaymentUV") as! SubscriptionPaymentUV
            subscriptionPaymentUV.planDetails = self.dataArrList[Instance.tag]
            self.pushToNavController(uv: subscriptionPaymentUV)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(self.dataArrList[indexPath.row].get("eSubscriptionStatus").uppercased() == "SUBSCRIBED"){
            return 200 + self.extraHeightArray[indexPath.row] + 60
        }else{
            return 150 + self.extraHeightArray[indexPath.row]
        }
        
    }
    

    @IBAction func unwindToSubscriptionUV(_ segue:UIStoryboardSegue) {
        
        self.getPlans()
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
