//
//  ManageVehiclesUV.swift
//  DriverApp
//
//  Created by ADMIN on 02/06/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class ManageVehiclesUV: UIViewController, UITableViewDelegate, UITableViewDataSource, MyBtnClickDelegate {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noVehiclesView: UIView!
    @IBOutlet weak var noVehicleTitleLbl: MyLabel!
    @IBOutlet weak var addVehicleBtn: MyButton!
    @IBOutlet weak var noVehiclesViewHeight: NSLayoutConstraint!

    @IBOutlet weak var AddVehicleView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    
    var dataArrList = [NSDictionary]()
    var nextPage_str = 1
    var isLoadingMore = false
    var isNextPageAvail = false
    
    var cntView:UIView!
    
    var isSafeAreaSet = false
    var isDataSet = false
    var eType = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        cntView = self.generalFunc.loadView(nibName: "ManageVehiclesScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)

        let APP_TYPE = userProfileJson.get("APP_TYPE")
        if(APP_TYPE == Utils.cabGeneralType_Deliver){
            self.noVehicleTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "You have not added ant vehicles. Please add your vehicle to continue your account process.", key: "LBL_ADD_DELIVERY_VEHICLE_PAGE_GENERAL_NOTE")
        }else if(APP_TYPE == Utils.cabGeneralType_Ride){
            self.noVehicleTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "You have not added ant vehicles. Please add your vehicle to continue your account process.", key: "LBL_ADD_RIDE_VEHICLE_PAGE_GENERAL_NOTE")
        }else{
            self.noVehicleTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "You have not added ant vehicles. Please add your vehicle to continue your account process.", key: "LBL_ADD_VEHICLE_PAGE_GENERAL_NOTE")
        }
        
        self.addBackBarBtn()
        
        setData()
        
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 15 , left: 0, bottom: 100, right: 0)
        
        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {}
        
        self.tableView.register(UINib(nibName: "ManageVehiclesTVCell", bundle: nil), forCellReuseIdentifier: "ManageVehiclesTVCell")
        
        self.addVehicleBtn.clickDelegate = self
        self.addVehicleBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_VEHICLE"))
        
        self.noVehicleTitleLbl.fitText()
//        let extraHeight = self.noVehicleTitleLbl.text.height(withConstrainedWidth: self.generalNoteLbl.frame.width, font: UIFont (name: "Fonts().light, size: 18)!

        noVehiclesViewHeight.constant = 117.0 + (self.noVehicleTitleLbl.text!).height(withConstrainedWidth: Application.screenSize.width - 40, font: UIFont (name: noVehicleTitleLbl.font.fontName, size: noVehicleTitleLbl.font.pointSize)!) - 20
        
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
        
        // Update table view background
        self.tableView.backgroundColor = themeManager.backgroundColor()
        
        // Update separator color
        self.tableView.separatorColor = themeManager.separatorColor()
        
        // Update no vehicles view background
        self.noVehiclesView.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update no vehicle title label text color
        self.noVehicleTitleLbl.textColor = themeManager.textColor()
        
        // Update add vehicle view background (keep the floating action button themed)
        self.AddVehicleView.backgroundColor = themeManager.backgroundColor()
        self.addView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        // Reload table to update cell appearances
        self.tableView.reloadData()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        noVehiclesView.frame.size = CGSize(width: self.noVehiclesView.frame.width, height: self.addVehicleBtn.frame.maxY + 10)

        if(isDataSet == false){
            
            self.dataArrList.removeAll()
            getDtata()
            
            addImgView.layer.addShadow(opacity: 0.7, radius: 0.7, UIColor.lightGray)
            isDataSet = true
        }
        
        // Apply theme after views are fully set up
        applyTheme()
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            
            if(cntView != nil){
                cntView.frame.size.height = cntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
            }
            
            isSafeAreaSet = true
        }
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MANAGE_VEHICLES")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MANAGE_VEHICLES")
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.addVehicleBtn){
            openAddNewVehicle()
        }
    }
    
    @objc func openAddNewVehicle(){
        let addVehiclesUv = GeneralFunctions.instantiateViewController(pageName: "AddVehiclesUV") as! AddVehiclesUV
        addVehiclesUv.manageVehiUV = self
        self.pushToNavController(uv: addVehiclesUv)
    }
    
    func getDtata(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
        }else if(loaderView != nil && isLoadingMore == false){
            loaderView.isHidden = false
        }
        
        let parameters = ["type": "displaydrivervehicles", "MemberType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "page": self.nextPage_str.description]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        self.dataArrList += [dataTemp]
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
//                        _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
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
            
            if(self.dataArrList.count > 0){
                self.noVehiclesView.isHidden = true
                self.addRightBarBtn()
            }else{
                self.noVehiclesView.isHidden = false
                self.navigationItem.rightBarButtonItem = nil
            }
            self.isLoadingMore = false
            self.loaderView.isHidden = true
            
        })
    }
    
    func addRightBarBtn(){
        self.addView.isHidden = false
        self.addView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.addImgView.image = UIImage(named: "ic_add_plus")
        GeneralFunctions.setImgTintColor(imgView: self.addImgView, color: .white)
        
        self.addView.setOnClickListener { (add) in
            self.openAddNewVehicle()
        }
        
//        let rightButton = UIBarButtonItem(image: UIImage(named: "ic_add_new_vehicle_nav_bar")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openAddNewVehicle))
//        self.navigationItem.rightBarButtonItem = rightButton
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageVehiclesTVCell", for: indexPath) as! ManageVehiclesTVCell
        
        let item = self.dataArrList[indexPath.item]
        let themeManager = ThemeManager.shared
        
        cell.vOtherInfoLbl.text = item.get("vLicencePlate")
        
        if(item.get("eStatus") == "Active"){
            cell.statusLbl.text = self.generalFunc.getLanguageLabel(origValue: "Active", key: "LBL_ACTIVE")
            cell.statusLbl.textColor = UIColor(hex: 0x25860b)
            cell.statusLbl.backgroundColor = UIColor(hex: 0xc1eeb4)
        }else if(item.get("eStatus") == "Inactive"){
            cell.statusLbl.text = self.generalFunc.getLanguageLabel(origValue: "Inactive", key: "LBL_INACTIVE")
            cell.statusLbl.textColor = UIColor(hex: 0x757575)
            cell.statusLbl.backgroundColor = UIColor(hex: 0xe5e5e5)
        }else if(item.get("eStatus") == "Deleted"){
            cell.statusLbl.text = self.generalFunc.getLanguageLabel(origValue: "Deleted", key: "LBL_DELETED")
        }else{
            cell.statusLbl.text = item.get("eStatus")
        }
        
        cell.vehicleNameLbl.text = item.get("vMake")
        
        // Apply theme-aware colors to the container view
        cell.containerView.backgroundColor = themeManager.cardBackgroundColor()
        cell.containerView.layer.shadowOpacity = themeManager.isDarkModeActive ? 0.3 : 0.5
        cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.containerView.layer.shadowColor = themeManager.isDarkModeActive ? UIColor.black.cgColor : UIColor(hex: 0xe6e6e6).cgColor
        
        // Apply theme-aware text colors
        cell.vehicleNameLbl.textColor = themeManager.textColor()
        cell.vOtherInfoLbl.textColor = themeManager.secondaryTextColor()
        
        let padding = UIScreen.main.scale * 15
        
        let uploadDocImg = UIImage(named: "ic_upload_doc_list")
        let editImg = UIImage(named: "ic_pf_edit")!
        let deleteImg = UIImage(named: "ic_pf_trash")!
//        let uploadDocImg = UIImage(named: "ic_upload_doc_list")!.imageWithInsets(insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))

//        let editImg = UIImage(named: "ic_edit_vehicle")!.imageWithInsets(insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        
        
//        UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        let deleteImg = UIImage(named: "ic_delete")!.imageWithInsets(insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        
        cell.uploadVehicleDocumentsImgView.image = uploadDocImg
        cell.editVehicleImgView.image = editImg
        cell.deleteVehicleImgView.image = deleteImg
        
        cell.uploadVehicleDocumentsImgView.tag = indexPath.item
        cell.editVehicleImgView.tag = indexPath.item
        cell.deleteVehicleImgView.tag = indexPath.item
        
        let editTapGue = UITapGestureRecognizer()
        let uploadDocTapGue = UITapGestureRecognizer()
        let deleteTapGue = UITapGestureRecognizer()
        
        editTapGue.addTarget(self, action: #selector(self.editVehicleImgTapped(sender:)))
        uploadDocTapGue.addTarget(self, action: #selector(self.uploadDocImgTapped(sender:)))
        deleteTapGue.addTarget(self, action: #selector(self.deleteImgTapped(sender:)))
        
        cell.uploadVehicleDocumentsImgView.isUserInteractionEnabled = true
        cell.editVehicleImgView.isUserInteractionEnabled = true
        cell.deleteVehicleImgView.isUserInteractionEnabled = true
        
        cell.uploadVehicleDocumentsImgView.addGestureRecognizer(uploadDocTapGue)
        cell.editVehicleImgView.addGestureRecognizer(editTapGue)
        cell.deleteVehicleImgView.addGestureRecognizer(deleteTapGue)
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        GeneralFunctions.setImgTintColor(imgView: cell.uploadVehicleDocumentsImgView, color: .white)
        GeneralFunctions.setImgTintColor(imgView: cell.editVehicleImgView, color: .white)
        GeneralFunctions.setImgTintColor(imgView: cell.deleteVehicleImgView, color: .white)
        
        // Apply theme-aware shadows to action buttons
        let shadowColor = themeManager.isDarkModeActive ? UIColor.darkGray : UIColor.lightGray
        cell.uploadDocView.layer.addShadow(opacity: 0.9, radius: 2, shadowColor)
        cell.editVehicleView.layer.addShadow(opacity: 0.9, radius: 2, shadowColor)
        cell.removeVehicleView.layer.addShadow(opacity: 0.9, radius: 2, shadowColor)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    @objc func editVehicleImgTapped(sender:UITapGestureRecognizer){
        let addVehiclesUv = GeneralFunctions.instantiateViewController(pageName: "AddVehiclesUV") as! AddVehiclesUV
        addVehiclesUv.currentVehicleData =  self.dataArrList[sender.view!.tag]
        addVehiclesUv.iDriverVehicleId = self.dataArrList[sender.view!.tag].get("iDriverVehicleId")
        addVehiclesUv.manageVehiUV = self
        self.pushToNavController(uv: addVehiclesUv)
    }
    
    @objc func uploadDocImgTapped(sender:UITapGestureRecognizer){
    
        let listOfDocumentUV = GeneralFunctions.instantiateViewController(pageName: "ListOfDocumentUV") as! ListOfDocumentUV
        listOfDocumentUV.LIST_TYPE = "vehicle"
        listOfDocumentUV.iDriverVehicleId = self.dataArrList[sender.view!.tag].get("iDriverVehicleId")
        
        self.pushToNavController(uv: listOfDocumentUV)
    }
    
    @objc func deleteImgTapped(sender:UITapGestureRecognizer){
        
        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Do you want to delete this car?", key: "LBL_DELETE_CAR_SURE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedId) in
            
            if(btnClickedId == 0){
                self.deleteCar(iDriverVehicleId: self.dataArrList[sender.view!.tag].get("iDriverVehicleId"))
            }
        })
    }
    
    func deleteCar(iDriverVehicleId:String){
    
        let parameters = ["type":"deletedrivervehicle","iDriverId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iDriverVehicleId": iDriverVehicleId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                        
                        self.dataArrList.removeAll()
                        self.tableView.reloadData()
                        self.getDtata()
                        
                    })
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            
        })
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

    
    @IBAction func unwindToManageVehicles(_ segue:UIStoryboardSegue) {
        
        if(segue.source.isKind(of: AddVehiclesUV.self) || segue.source.isKind(of: ListOfDocumentUV.self) || segue.source.isKind(of: ContactUsUV.self)){
            self.dataArrList.removeAll()
            self.tableView.reloadData()
            getDtata()
        }
    }
}
