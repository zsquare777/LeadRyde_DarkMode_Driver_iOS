//
//  YourZonesUV.swift
//  ProviderApp
//
//  Created by Suleman Hussan on 23/06/2025.
//

import UIKit

class YourZonesUV: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containerView: UIView!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var dataArrList = [NSDictionary]()
    var homeTabBar:HomeScreenTabBarUV!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackBarBtn()
        
        cntView = self.generalFunc.loadView(nibName: "YourZonesUV", uv: self, contentView: containerView)
        containerView.addSubview(cntView)
        self.tableView.separatorColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "YourZoneTableViewCell", bundle: nil), forCellReuseIdentifier: "YourZoneTableViewCell")
        
        self.tableView.clipsToBounds = true
        if(self.homeTabBar == nil){
            self.addBackBarBtn()
        }
        self.errorLbl.isHidden = true
        self.tableView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)

        applyTheme()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func themeDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.applyTheme()
        }
    }
    
    func applyTheme() {
        let themeManager = ThemeManager.shared
        
        // Update background colors
        self.view.backgroundColor = themeManager.backgroundColor()
        self.containerView.backgroundColor = themeManager.backgroundColor()
        self.tableView.backgroundColor = themeManager.backgroundColor()
        
        // Update cntView if it exists
        if let cntView = self.cntView {
            cntView.backgroundColor = themeManager.backgroundColor()
        }
        
        // Update error label color
        self.errorLbl.textColor = themeManager.textColor()
        
        // Reload table to update cells - with safety check
        if self.tableView.window != nil {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.homeTabBar != nil){
            self.homeTabBar.navItem.rightBarButtonItem = nil
            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200, height: 44.0))
            label.font = UIFont(name: Fonts().regular, size: 18)!
            label.backgroundColor = UIColor.clear
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.center
            label.text = self.generalFunc.getLanguageLabel(origValue: "Your Zones", key: "LBL_LEFT_MENU_ZONE")
            label.textColor = UIColor.UCAColor.AppThemeTxtColor
            self.homeTabBar.navItem.titleView = label
        } else{
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Your Zones", key: "LBL_LEFT_MENU_ZONE")
            self.title = self.generalFunc.getLanguageLabel(origValue: "Your Zones", key: "LBL_LEFT_MENU_ZONE")
        }
        self.getZones()

    }
    
    @objc func getZones() {
        
        let parameters = [
            "type": "getZonesData",
            "iDriverId": GeneralFunctions.getMemberd(),
            "filterCurrentLocationZones": "Yes"
        ]
        Utils.printLog(msgData: "Parameters::\(parameters)")

        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl

        exeWebServerUrl.executePostProcess { [weak self] response in
            guard let self = self else { return }


            guard !response.isEmpty else {
                DispatchQueue.main.async {
                    self.generalFunc.setError(uv: self)
                }
                return
            }

            let dataDict = response.getJsonDataDict()
            Utils.printLog(msgData: "Response Data::\(dataDict)")

            guard dataDict.get("Action") == "1" else {
                self.errorLbl.isHidden = false
                self.errorLbl.text = dataDict.get("message")
                self.tableView.isHidden = true
                return
            }
            self.tableView.isHidden = false
            self.errorLbl.isHidden = true
            let dataArr = dataDict.getArrObj(Utils.message_str)
            var newList: [NSDictionary] = []

            for item in dataArr {
                if let zoneData = item as? NSDictionary {
                    newList.append(zoneData)
                }
            }

            DispatchQueue.main.async {
                self.dataArrList = newList
                self.tableView.isHidden = false
                self.errorLbl.isHidden = true
                self.tableView.reloadData()
            }

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 25
        return self.dataArrList.count

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourZoneTableViewCell", for: indexPath) as! YourZoneTableViewCell
        let data = self.dataArrList[indexPath.row]
        cell.zoneNameLbl.text = data.get("vZoneName")
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacerView = UIView()
        spacerView.backgroundColor = ThemeManager.shared.backgroundColor()
        return spacerView
    }
    
}
