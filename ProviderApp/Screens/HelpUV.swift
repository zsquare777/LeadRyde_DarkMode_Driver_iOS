//
//  HelpUV.swift
//  DriverApp
//
//  Created by ADMIN on 13/05/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class HelpUV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var cntView:UIView!
    
    let generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    
    var dataArrList = [NSDictionary]()
    
    var isDataLoad = false
    var isSafeAreaSet = false

    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)

        cntView = self.generalFunc.loadView(nibName: "HelpScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)

        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.bounces = false
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5 + GeneralFunctions.getSafeAreaInsets().bottom, right: 0)

        self.tableView.register(CountryListTVCell.self, forCellReuseIdentifier: "FAQCategoryListTVCell")
        self.tableView.register(UINib(nibName: "FAQCategoryListTVCell", bundle: nil), forCellReuseIdentifier: "FAQCategoryListTVCell")
        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {}
        
        
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
        
        // Update main view backgrounds
        self.view.backgroundColor = themeManager.backgroundColor()
        self.contentView.backgroundColor = themeManager.backgroundColor()
        
        // Update table view background
        self.tableView.backgroundColor = themeManager.backgroundColor()
        
        // Update separator color (Google Wallet style)
        self.tableView.separatorColor = themeManager.separatorColor()
        
        // Reload table to update cells and headers
        self.tableView.reloadData()
        
        print("✅ HelpUV: Theme applied - Dark mode: \(themeManager.isDarkModeActive)")
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            if(cntView != nil){
                self.cntView.frame = self.view.frame
                cntView.frame.size.height = cntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
            }
            isSafeAreaSet = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if(isDataLoad == false){
            getFAQData()
            isDataLoad = true
        }
        
        // Apply theme after view appears
        applyTheme()
    }

    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAQ_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAQ_TXT")
    }
    
    func getFAQData(){
        self.dataArrList.removeAll()
        
        let parameters = ["type":"getFAQ", "appType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    self.dataArrList = dataArr as! [NSDictionary]

                    self.tableView.reloadData()
                }else{
                   _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
//                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
            }else{
                self.generalFunc.setError(uv: self)
            }
            self.loaderView.isHidden = true
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArrList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrList[section].getArrObj("Questions").count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let themeManager = ThemeManager.shared
        
        let view = UIView.init(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 55))
        view.backgroundColor = themeManager.backgroundColor()
        
        let label = UILabel.init(frame: CGRect(x:15, y:0, width: tableView.frame.size.width - 35, height: 50))
        label.font = UIFont.init(name: Fonts().semibold, size: 17)
        label.numberOfLines = 2
        label.textColor = themeManager.textColor()
        label.text = self.dataArrList[section].get("vTitle")
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCategoryListTVCell", for: indexPath) as! FAQCategoryListTVCell
        let themeManager = ThemeManager.shared

        cell.selectionStyle = .none
        
        // Apply theme-aware backgrounds
        cell.backgroundColor = themeManager.cardBackgroundColor()
        cell.contentView.backgroundColor = themeManager.cardBackgroundColor()

        let itemDict = self.dataArrList[indexPath.section].getArrObj("Questions")[indexPath.row] as! NSDictionary
        cell.titleLbl.text = itemDict.get("vTitle")
        cell.titleLbl.textColor = themeManager.textColor()

        let rightImage = "ic_arrow_right"
        if(Configurations.isRTLMode()){
            cell.rightArrowImgView.image = UIImage(named:rightImage)?.rotate(180)
        }else{
            cell.rightArrowImgView.image = UIImage(named:rightImage)
        }
        
        // Apply theme-aware arrow color
        let arrowColor = themeManager.isDarkModeActive ? UIColor.white.withAlphaComponent(0.6) : UIColor.lightGray
        GeneralFunctions.setImgTintColor(imgView: cell.rightArrowImgView, color: arrowColor)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 1500
        tableView.rowHeight = UITableView.automaticDimension
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHelpCategoryItem = self.dataArrList[indexPath.section].getArrObj("Questions")[indexPath.row] as! NSDictionary
        let helpQuestionAnswersUv = GeneralFunctions.instantiateViewController(pageName: "HelpQuestionAnswersUV") as! HelpQuestionAnswersUV
        helpQuestionAnswersUv.selectedHelpCategoryItem = selectedHelpCategoryItem
        self.pushToNavController(uv: helpQuestionAnswersUv)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class HelpCategoryItem {
    
    var vTitle:String!
    var questionList:NSArray!
    
    // MARK: Initialization
    
    init(vTitle: String, questionList:NSArray) {
        // Initialize stored properties.
        self.vTitle = vTitle
        self.questionList = questionList
        
    }
}
