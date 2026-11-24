//
//  ViewMSPDetailsUV.swift
//  DriverApp
//
//  Created by Apple on 02/05/19.
//  Copyright © 2019 @. All rights reserved.
//

import UIKit

class ViewMSPDetailsUV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var cntView:UIView!
    
    var generalFunc = GeneralFunctions()
    var tripData:NSDictionary!
    var dataArrList = [NSDictionary]()
    var extraHeightContainer = [CGFloat]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackBarBtn()
        
        cntView = self.generalFunc.loadView(nibName: "ViewMSPDetailsScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRIP_PLANNER_TXT")
        
        self.tableView.register(UINib(nibName: "MSPDetailsTVCell", bundle: nil), forCellReuseIdentifier: "MSPDetailsTVCell")
        self.tableView.delegate = self
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom, right: 0)
        self.tableView.tableFooterView = UIView()
    
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {}
        
        self.getData()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    

    func getData(){
        
        self.dataArrList.removeAll()
        let parameters = ["type": "GetStopOverPoint", "userType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd(), "iTripId": self.tripData.get("TripId"), "iCabBookingId": ""]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.dataArrList = dataDict.getArrObj(Utils.message_str) as! [NSDictionary]
                    
                    for i in 0..<self.dataArrList.count{
                        
                        let discHeight = self.dataArrList[i].get("tDAddress").trim().height(withConstrainedWidth: Application.screenSize.width - 70, font: UIFont(name: Fonts().light, size: 15)!)
                    
                        self.extraHeightContainer.append(discHeight)
                    }
                    self.tableView.reloadData()
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
                
            }else{
                self.getData()
            }
            
        })
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MSPDetailsTVCell", for: indexPath) as! MSPDetailsTVCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        cell.cellHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STOPOVER_POINT")
        cell.addViewhLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NEXT_STOP_OVER_POINT")
        
        cell.addressLbl.text = self.dataArrList[indexPath.row].get("tDAddress")
        cell.addressLbl.sizeToFit()
        cell.locImgView.image = UIImage(named:"ic_navigate_pin")
        GeneralFunctions.setImgTintColor(imgView: cell.locImgView, color: UIColor.UCAColor.AppThemeColor)
        
        cell.countLbl.text = Configurations.convertNumToAppLocal(numStr: "\(indexPath.row + 1)")
        cell.countCheckImgView.image = UIImage(named:"ic_trip_finish_check")
        GeneralFunctions.setImgTintColor(imgView: cell.countCheckImgView, color: UIColor.UCAColor.AppThemeColor)
        
        cell.countLbl.backgroundColor = UIColor(hex: 0xe0e0e0)
        cell.countLbl.textColor = UIColor.UCAColor.blackColor
        
        if(self.dataArrList[indexPath.row].get("eReached").uppercased() == "YES"){
            cell.countCheckImgView.isHidden = false
            cell.countLbl.isHidden = true
        }else if(self.dataArrList[indexPath.row].get("eCanceled").uppercased() == "YES"){
            cell.countCheckImgView.isHidden = false
            cell.countLbl.isHidden = true
        }else{
            cell.countCheckImgView.isHidden = true
            cell.countLbl.isHidden = false
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.extraHeightContainer[indexPath.row] > 35){
            return 95 + (self.extraHeightContainer[indexPath.row] - 35) + 10
        }
        return 95
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
