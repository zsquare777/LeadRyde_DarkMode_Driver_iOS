//
//  OpenListView.swift
//  DriverApp
//
//  Created by Admin on 15/09/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class OpenListView: NSObject , UITableViewDataSource , UITableViewDelegate{
    
    typealias CompletionHandler = (_ selectedItemId:Int) -> Void
    
    var currentInst:OpenListView!
    var uv:UIViewController!
    var containerView:UIView!
    var handler:CompletionHandler!
    var listView:ListView!
    var bgView:UIView!
    let generalFunc = GeneralFunctions()
    let closeImgTapGue = UITapGestureRecognizer()
    var arrListObj = [String]()
    var listHeightContainer = [CGFloat]()
    var textPedding:CGFloat = 15
    var navZposition:CGFloat = 0
    var selectedText = ""
    var _isShowImage = true
    
    var selectedItem = ""
    var newListView:ListBottomSheetView!
    
    var openNewList = false
    var newListCodeString = [String]()
    
    var colorArray = [UIColor]()
    var textColorArray = [UIColor]()
    
    var appLoginUV:AppLoginUV!
    var editProfileUV:EditProfileUV!
    var viewProfileUV:ViewProfileUV!
    
    var startLoading = false
    var isForCurrency = false
    var isForMode = false
    var selectedIndex = -1
    
    init(uv:UIViewController?, containerView:UIView){
        super.init()
        self.uv = uv
        self.containerView = containerView
    }
    
    
    func show(_ isShowImage:Bool = true,listObjects:[String], title:String, currentInst:OpenListView,_ openDirection:OpenDirection = .center,  handler: @escaping CompletionHandler){
        
        self.listHeightContainer = []
        
        self.handler = handler
        self.currentInst = currentInst
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.5
        //        bgView.frame = self.containerView.frame
        bgView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: Application.screenSize.height)
        
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        bgView.isUserInteractionEnabled = true
        
        let bgViewTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
        bgViewTapGesture.addTarget(self, action: #selector(currentInst.removeView))
        bgView.addGestureRecognizer(bgViewTapGesture)
        //Utils.createRoundedView(view: listView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        arrListObj = listObjects
        _isShowImage = isShowImage
        let width = (Application.screenSize.width > 390 ? 375 : (Application.screenSize.width - 40))
        
        var paddingTopBottom:CGFloat = 58
        let heightTitleLbl:CGFloat = 41
        var totalCellsHeight:CGFloat = 0
        if Configurations.isIponeXDevice() {
            paddingTopBottom = 80
        }
        for i in 0 ..< arrListObj.count{
            let listNameHeight = arrListObj[i].height(withConstrainedWidth: width - 68, font: UIFont(name: Fonts().regular, size: 17)!) + 4
            self.listHeightContainer.append(listNameHeight + 15)
            totalCellsHeight = totalCellsHeight + listNameHeight + 15
            
            if (selectedItem.lowercased() == arrListObj[i].lowercased()) {
                self.selectedIndex = i
            }
        }
        
        var extraHeight:CGFloat = totalCellsHeight + paddingTopBottom + heightTitleLbl + 10
        
        if(extraHeight > Application.screenSize.height){
            extraHeight = Application.screenSize.height - 70
        }
        
        let currentWindow = Application.window
        
        if(openNewList == false){
            
            let yPos = Application.screenSize.height - extraHeight
            if openDirection == .center {
                listView = ListView(frame: CGRect(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2, width: width, height: CGFloat(extraHeight)))
                listView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
            }else {
                listView = ListView(frame: CGRect(x: 0, y: yPos, width: Application.screenSize.width, height: CGFloat(extraHeight)))
                listView.closeImgView.contentMode = .scaleAspectFill
                listView.topConstains.constant = 0
                listView.bottomConstrains.constant = 0
                listView.leadingConstrains.constant = 0
                listView.trailingConstrains.constant = 0
            }
            listView.closeImgView.image = UIImage(named:"cm_close_white")!.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -5, bottom: -10, right: -5))
            listView.tableView.dataSource = currentInst
            listView.tableView.delegate = currentInst
            listView.tableView.register(ListTVCell.self, forCellReuseIdentifier: "ListTVCell")
            listView.tableView.register(UINib(nibName: "ListTVCell", bundle: nil), forCellReuseIdentifier: "ListTVCell")
            listView.titleLabelTxt.text = title
            listView.tableView.tableFooterView = UIView()
            
            if #available(iOS 15.0, *) {
                listView.tableView.sectionHeaderTopPadding = 0
            } else {}
            
            listView.tableView.allowsSelection = true
    //        listView.tableView.reloadData()
            
            closeImgTapGue.addTarget(self, action: #selector(currentInst.removeView))
            listView.closeImgView.isUserInteractionEnabled = true
            listView.closeImgView.addGestureRecognizer(closeImgTapGue)
            GeneralFunctions.setImgTintColor(imgView: listView.closeImgView, color: UIColor.black.withAlphaComponent(0.60))
            listView.layer.shadowOpacity = 0.5
            listView.layer.shadowOffset = CGSize(width: 0, height: 3)
            listView.layer.shadowColor = UIColor.black.cgColor
            listView.titleLabelTxt.fitText()
            listView.titleLabelTxt.paddingLeft = textPedding - 3
            if !isShowImage {
                listView.closeImgView.isHidden = true
            }
            self.addListViewToView()
            
            if openDirection == .bottom {
                var listViewRect = listView.frame
                listViewRect.origin.y = Application.screenSize.height
                self.listView.frame = listViewRect
                UIView.animate(withDuration: 0.2, animations: {
                                listViewRect.origin.y = yPos
                                self.listView.frame = listViewRect
                }, completion: nil)
            }else {
                self.listView.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 0.2, animations: {
                 self.listView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion:{ _ in
                    
                })
            }
            
        }else{
            var height = 450.0
            if(arrListObj.count > 4){
                height = height + Double(((arrListObj.count - 4) * 50))
                
                if(height > (Double(Application.screenSize.height) - 70.0)){
                    height = Double((Application.screenSize.height - 70.0))
                }
            }
            
            newListView = ListBottomSheetView(frame: CGRect(x: 0, y: Application.screenSize.height, width: Application.screenSize.width, height: CGFloat(height)))
            
            if(self.uv == nil){
                currentWindow?.addSubview(bgView)
                currentWindow?.addSubview(newListView)
            }else if(self.uv.navigationController != nil){
                self.uv.navigationController?.view.addSubview(bgView)
                self.uv.navigationController?.view.addSubview(newListView)
              
            }else{
                self.uv.view.addSubview(bgView)
                self.uv.view.addSubview(newListView)
            }
            
            self.newListView.titleLbl.text = title
            if(self.isForCurrency){
                self.newListView.subTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CURRENCY_PREFER")
            }else if (isForMode){
                self.newListView.subTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Tell us the mode do you prefer?", key: "")
            }else{
                self.newListView.subTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LANG_PREFER")
            }
            
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                
                self.newListView.frame.origin.y = Application.screenSize.height - CGFloat((height - 50))
            
            }), completion: nil)
            
            self.newListView.closeImgView.setOnClickListener { (instance) in
                self.closeNewListView()
            }
            
            self.bgView.setOnClickListener { (instance) in
                self.closeNewListView()
            }
            
            self.newListView.tableView.delegate = self
            
            // Apply theme-aware background - Google Wallet style (main background)
            let themeManager = ThemeManager.shared
            self.newListView.tableView.backgroundColor = themeManager.backgroundColor()
            
            self.newListView.tableView.dataSource = self
            self.newListView.tableView.tableFooterView = UIView()
            
            if #available(iOS 15.0, *) {
                self.newListView.tableView.sectionHeaderTopPadding = 0
            } else {}

            
            self.newListView.tableView.bounces = false
            self.newListView.tableView.register(UINib(nibName: "ListTVCell", bundle: nil), forCellReuseIdentifier: "ListTVCell")
            self.newListView.tableView.reloadData()
            self.newListView.tableView.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 50, right: 0)
            self.newListView.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            if(self.selectedIndex != -1){
                self.newListView.tableView.scrollToRow(at: IndexPath(row: self.selectedIndex, section: 0), at: .top, animated: true)
            }
        }
        
    }
    
    func closeNewListView(){
        if(self.startLoading == false){
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.newListView.frame.origin.y = Application.screenSize.height
            }, completion: {_ in
                self.startLoading = false
                self.bgView.removeFromSuperview()
                self.newListView.removeFromSuperview()
            })
        }
        
    }
    
    func addListViewToView() {
        let currentWindow = Application.window
        if(self.uv == nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(listView)
        }else if(self.uv.navigationController != nil){
            self.uv.navigationController?.view.addSubview(bgView)
            self.uv.navigationController?.view.addSubview(listView)
            
            listView.tag = Utils.ALERT_DIALOG_CONTENT_TAG
            bgView.tag = Utils.ALERT_DIALOG_BG_TAG
            navZposition = self.uv.navigationController!.navigationBar.layer.zPosition
            self.uv.navigationController?.navigationBar.layer.zPosition = -1
        }else{
            self.uv.view.addSubview(bgView)
            self.uv.view.addSubview(listView)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVCell", for: indexPath) as! ListTVCell
        let title = arrListObj[indexPath.row]
        let themeManager = ThemeManager.shared
        
        // Apply theme-aware background - Google Wallet style
        // Cells use card background to stand out against main background
        cell.backgroundColor = themeManager.cardBackgroundColor()
        cell.contentView.backgroundColor = themeManager.cardBackgroundColor()
        
        if(openNewList){
            let code = indexPath.row < newListCodeString.count ? newListCodeString[indexPath.row] : ""
            let color = indexPath.row < self.colorArray.count ? self.colorArray[indexPath.row] : UIColor.white
            
            cell.loaderView.color = UIColor.UCAColor.AppThemeColor
            cell.newListView.isHidden = false
            
            if(Configurations.isRTLMode()){
                cell.nListViewTitleLbl.textAlignment = .right
            }else{
                cell.nListViewTitleLbl.textAlignment = .left
            }
            cell.nListViewTitleLbl.text = title
            
            // Apply theme-aware text color
            cell.nListViewTitleLbl.textColor = themeManager.textColor()
            
            cell.nListViewLeadingLbl.text = code
            cell.nListViewLeadingLbl.backgroundColor = color
            
            // Apply theme-aware text color for code label
            if indexPath.row < self.textColorArray.count {
                cell.nListViewLeadingLbl.textColor = self.textColorArray[indexPath.row]
            }
            
            GeneralFunctions.setImgTintColor(imgView: cell.nListViewCheckImg, color: UIColor.gray)
            
            if selectedItem.lowercased() == title.lowercased() {
                cell.nListViewCheckImg.image = UIImage(named:"ic_list_true")
                GeneralFunctions.setImgTintColor(imgView: cell.nListViewCheckImg, color: UIColor.UCAColor.AppThemeColor)
            }else{
                cell.nListViewCheckImg.image = UIImage(named:"ic_list_false")
                GeneralFunctions.setImgTintColor(imgView: cell.nListViewCheckImg, color: UIColor.gray)
            }
            
            if(self.startLoading){
                cell.nListViewCheckImg.isHidden = true
            }
            
            
            cell.loaderView.stopAnimating()
            cell.loaderView.isHidden = true
            
            if(selectedItem.lowercased() == title.lowercased() && self.startLoading){
                cell.loaderView.startAnimating()
                cell.loaderView.isHidden = false
                cell.nListViewCheckImg.isHidden = true
            }
        }else{
            
            
            cell.listLabelTxt.text = arrListObj[indexPath.row]
            if Configurations.isRTLMode() {
                cell.listLabelTxt.paddingRight = textPedding
            }else {
                cell.listLabelTxt.paddingLeft = textPedding
            }
            cell.listLabelTxt.fitText()
            cell.listImg.image =  UIImage(named:"ic_liveTrackTrue")!.resize(toHeight: 15)?.resize(toWidth: 15)
            cell.listImg.contentMode = .scaleAspectFit
            
            
            if selectedText.lowercased() == cell.listLabelTxt.text!.lowercased() {
                cell.listLabelTxt.textColor = UIColor.UCAColor.AppThemeColor
                GeneralFunctions.setImgTintColor(imgView: cell.listImg, color: UIColor.UCAColor.AppThemeColor)
            }else {
                // Apply theme-aware text color
                cell.listLabelTxt.textColor = themeManager.textColor().withAlphaComponent(0.60)
                GeneralFunctions.setImgTintColor(imgView: cell.listImg, color: themeManager.textColor().withAlphaComponent(0.60))
            }
            
            if(!_isShowImage) {
                    cell.listImg.isHidden = true
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(openNewList){
            if(isForMode){
                self.closeNewListView()
            }
            if(self.isForCurrency){
                self.closeNewListView()
                if(self.appLoginUV != nil){
                    self.appLoginUV.currencyValueChanged(selectedItemId: indexPath.row)
                }else if(self.editProfileUV != nil){
                    self.editProfileUV.currencyValueChanged(selectedItemId: indexPath.row)
                }
                
                self.newListView.tableView.reloadData()
                
                if(self.viewProfileUV != nil){
                    if(self.handler != nil){
                        self.handler(indexPath.row)
                    }
                }
                
            }else{
                self.bgView.isUserInteractionEnabled = false
                self.newListView.isUserInteractionEnabled = false
                if(self.appLoginUV != nil){
                    self.appLoginUV.lngValueChanged(selectedItemId: indexPath.row)
                }else if(self.editProfileUV != nil){
                    self.editProfileUV.lngValueChanged(selectedItemId: indexPath.row)
                }
                
                self.startLoading = true
                let title = arrListObj[indexPath.row]
                self.selectedItem = title
                self.newListView.tableView.reloadData()
                
                if(self.viewProfileUV != nil){
                    if(self.handler != nil){
                        self.handler(indexPath.row)
                    }
                }
            }
            
            
        }else{
            self.removeView()
            if(self.handler != nil){
                self.handler(indexPath.row)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(openNewList){
            return 60
        }else{
            return self.listHeightContainer[indexPath.row] + 5
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(self.newListView != nil){
            if(scrollView.contentOffset.y > 0){
                self.newListView.tableSapraterView.isHidden = false
            }else{
                self.newListView.tableSapraterView.isHidden = true
            }
        }
        
    }
    
    
    
    @objc func removeView(){
        
        if(self.listView == nil && openNewList){
            self.startLoading = false
            self.newListView.removeFromSuperview()
            bgView.removeFromSuperview()
        }else{
            listView.frame.origin.y = Application.screenSize.height + 2500
            listView.removeFromSuperview()
            bgView.removeFromSuperview()
            if(self.uv != nil){
                self.uv.navigationController?.navigationBar.layer.zPosition = navZposition
            }
        }
        
    }
}

public enum OpenDirection {
    case center
    case bottom
}
