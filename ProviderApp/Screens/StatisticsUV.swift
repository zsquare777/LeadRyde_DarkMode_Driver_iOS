//
//  StatisticsUV.swift
//  DriverApp
//
//  Created by ADMIN on 03/06/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit
import Charts

class StatisticsUV: UIViewController , ChartViewDelegate, IndicatorInfoProvider, AxisValueFormatter{
    
    @IBOutlet weak var contentView: UIView!
//    @IBOutlet weak var yearTxtField: MyTextField!
    @IBOutlet weak var numOfTripHLbl: MyLabel!
    @IBOutlet weak var numOfTripVLbl: MyLabel!
    @IBOutlet weak var totalEarningHLbl: MyLabel!
    @IBOutlet weak var totalEarningVLbl: MyLabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var tripImgView: UIImageView!
    @IBOutlet weak var earningImgView: UIImageView!
    @IBOutlet weak var heightGraphView: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var yearHLbl: MyLabel!
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var calendarImgView: UIImageView!
    @IBOutlet weak var yearVLbl: MyLabel!

    
    let generalFunc = GeneralFunctions()
    
    var isPageLoaded = false
    
    var cntView:UIView!
    
    var loaderView:UIView!
    
    var window:UIWindow!
    
    var yearListArr = [String]()
    var yearListAppLocalArr = [String]()
    
    let numberOfDataItems = 12
    
    var scGraphView:LineChartView!
    
    var currentSelectedYear = ""
    
    var totalEarningsData = [Double]()
    
    var monthsData = [String]()
    
    var isSafeAreaSet = false
    
    var userProfileJson:NSDictionary!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRIP_TXT"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for theme change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        window = Application.window!
        
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        cntView = self.generalFunc.loadView(nibName: "StatisticsScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        self.addBackBarBtn()
        
        self.setnavBarTintColor(color: UIColor.UCAColor.AppThemeColor)
        
        // Apply initial theme
        applyTheme()
        
        //        Utils.printLog(msgData: "Months::\(monthComponents)")
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
        
        // Update container view background (card style)
        self.containerView.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update label text colors
        self.numOfTripHLbl.textColor = themeManager.textColor()
        self.numOfTripVLbl.textColor = themeManager.textColor()
        self.totalEarningHLbl.textColor = themeManager.textColor()
        self.totalEarningVLbl.textColor = themeManager.textColor()
        self.yearHLbl.textColor = themeManager.textColor()
        self.yearVLbl.textColor = themeManager.textColor()
        
        // Update graph view background
        self.graphView.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update calendar view background
        self.calenderView.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update chart colors if chart exists
        if scGraphView != nil {
            updateChartTheme()
        }
    }
    
    func updateChartTheme() {
        guard let chartView = scGraphView else { return }
        let themeManager = ThemeManager.shared
        
        // Update chart background
        chartView.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update axis label colors
        chartView.xAxis.labelTextColor = themeManager.textColor()
        chartView.leftAxis.labelTextColor = themeManager.textColor()
        chartView.rightAxis.labelTextColor = themeManager.textColor()
        
        // Update legend color
        chartView.legend.textColor = themeManager.textColor()
        
        // Update data set colors if data exists
        if let lineData = chartView.data as? LineChartData {
            for dataSet in lineData.dataSets {
                if let lineDataSet = dataSet as? LineChartDataSet {
                    // Value text color
                    lineDataSet.valueTextColor = themeManager.textColor()
                }
            }
        }
        
        // Refresh the chart
        chartView.notifyDataSetChanged()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoaded == false){
            
            self.cntView.layoutIfNeeded()
            
            if(Application.screenSize.height <= 568){
                self.heightGraphView.constant -= 50
            }
            scGraphView = createDarkGraph(CGRect(x:0,y:0, width:contentView.frame.width, height: self.graphView.frame.height))
            
            self.graphView.addSubview(scGraphView)
            setData()
            getData(currentSelectedYear: currentSelectedYear)
            isPageLoaded = true
        }
        
        // Apply theme after views are fully set up
        applyTheme()
    }
    
    @objc func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return monthsData[Int(value) % monthsData.count]
    }
    
    fileprivate func createDarkGraph(_ frame: CGRect) -> LineChartView {
        let graphView = LineChartView(frame: frame)
        let themeManager = ThemeManager.shared
        
        graphView.delegate = self
        graphView.dragEnabled = true
        graphView.setScaleEnabled(true)
        graphView.pinchZoomEnabled = true
        graphView.chartDescription.text = ""
        graphView.viewPortHandler.setMaximumScaleX(CGFloat(10))
        graphView.viewPortHandler.setMaximumScaleY(CGFloat(5))
        
        // Apply theme-aware background
        graphView.backgroundColor = themeManager.cardBackgroundColor()
        
        let xAxis = graphView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = self
        xAxis.granularity = 1
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.axisMinimum = 0.0
        xAxis.drawLabelsEnabled = true
        // Apply theme-aware axis label color
        xAxis.labelTextColor = themeManager.textColor()
        //        xAxis.labelRotationAngle = 90
        xAxis.setLabelCount(12, force: false)
        
        
        let leftAxis = graphView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawZeroLineEnabled = true
        leftAxis.labelTextColor = themeManager.textColor()
        
        
        let rightAxis = graphView.rightAxis
        rightAxis.axisMinimum = 0
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawZeroLineEnabled = true
        rightAxis.labelTextColor = themeManager.textColor()
        
        //        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
        //                                   font: .systemFont(ofSize: 12),
        //                                   textColor: .white,
        //                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        //        marker.graphView = graphView
        //        marker.minimumSize = CGSize(width: 80, height: 40)
        //        graphView.marker = marker
        
        graphView.legend.form = .default
        graphView.legend.textColor = themeManager.textColor()
        //        graphView.animate(xAxisDuration: 2.5)
        
        
        
        return graphView
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRIP_STATISTICS_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRIP_STATISTICS_TXT")
        
        self.yearHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YEAR")
        self.totalEarningHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Total Earnings", key: "LBL_TOTAL_EARNINGS")
        self.numOfTripHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Number of trips", key: "LBL_NUMBER_OF_TRIPS")

        calenderView.setOnClickListener { (view) in
            let openListView = OpenListView(uv: self, containerView: self.view)
            openListView.selectedText = self.yearVLbl.text!
            openListView.show(listObjects: self.yearListAppLocalArr, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_YEAR"), currentInst: openListView, handler: { (selectedItemId) in
                self.yearVLbl.text =  self.yearListAppLocalArr[selectedItemId]
                self.yearChanged(selectedItemId)
            })
        }
        
        if userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased(){
            self.self.tripImgView.image = UIImage(named: "ic_job_stat")
        }
            
        GeneralFunctions.setImgTintColor(imgView: calendarImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.tripImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.earningImgView, color: UIColor.UCAColor.AppThemeColor)
        if(Configurations.isRTLMode()){
               numOfTripHLbl.textAlignment = .right
               numOfTripVLbl.textAlignment = .right
               totalEarningHLbl.textAlignment = .right
               totalEarningVLbl.textAlignment = .right
               }else{
               numOfTripHLbl.textAlignment = .left
               numOfTripVLbl.textAlignment = .left
               totalEarningHLbl.textAlignment = .left
               totalEarningVLbl.textAlignment = .left
               }
    }
   
    func getData(currentSelectedYear:String){
        containerView.isHidden = true
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        
        self.yearListArr.removeAll()
        self.yearListAppLocalArr.removeAll()
        self.monthsData = []
        self.totalEarningsData = []
        
        let parameters = ["type":"getYearTotalEarnings","iDriverId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "year": currentSelectedYear]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.loaderView.isHidden = true
                    self.containerView.isHidden = false
                    
                    let yearArr = dataDict.getObj(Utils.message_str).getArrObj("YearArr")
                    
                    for i in 0..<yearArr.count{
                        self.yearListArr += [yearArr[i] as! String]
                        self.yearListAppLocalArr += [Configurations.convertNumToAppLocal(numStr: yearArr[i] as! String)]
                        
                        if(i == 0 && self.yearVLbl.text == ""){
                            self.yearVLbl.text = "\(Configurations.convertNumToAppLocal(numStr: self.yearListArr[0]))"
                        }
                    }
                    
                    let yearMonthArr = dataDict.getObj(Utils.message_str).getArrObj("YearMonthArr")
                    
                    //                    let monthComponents = Calendar(identifier: Configurations.getCalendarIdentifire()).shortMonthSymbols
                    
                    
                    for i in 0..<yearMonthArr.count{
                        let item = yearMonthArr[Configurations.isRTLMode() ? (yearMonthArr.count - 1 - i) : i] as! NSDictionary
                        
                        //                        if(yearMonthArr.count == monthComponents.count){
                        //                            self.monthsData += [monthComponents[yearMonthArr.count - 1 - i]]
                        //                        }else{
                        self.monthsData += [item.get("CurrentMonth")]
                        //                        }
                        
                        
                        self.totalEarningsData += [GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("TotalEarnings"))]
                    }
                    
                    if(self.scGraphView != nil){
                        self.scGraphView.removeFromSuperview()
                    }
                    
                    self.scGraphView = self.createDarkGraph(CGRect(x:10,y:0, width:self.contentView.frame.width - 20, height: self.graphView.frame.height))
                    
                    //                    self.scGraphView.chartYMax = GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("MaxEarning"))
                    
                    self.totalEarningVLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("TotalEarning"))
                    self.numOfTripVLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("TripCount"))
                    self.setLineGraphData()
                    self.graphView.addSubview(self.scGraphView)
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func setLineGraphData(){
        let themeManager = ThemeManager.shared
        
        let entries = (0..<monthsData.count).map { (i) -> ChartDataEntry in
            let earningAmount : Double = totalEarningsData[i]
            return ChartDataEntry(x: Double(i), y: earningAmount)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: entries, label: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EARNING"))
        lineChartDataSet.drawIconsEnabled = false
        //        lineChartDataSet.lineDashLengths = [1, 1]
        lineChartDataSet.highlightLineDashLengths = [1, 1]
        lineChartDataSet.setColor(UIColor.UCAColor.AppThemeColor)
        lineChartDataSet.setCircleColor(UIColor.UCAColor.AppThemeColor)
        lineChartDataSet.lineWidth = 1.5
        lineChartDataSet.circleRadius = 5
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.valueFont = .systemFont(ofSize: 14)
        // Apply theme-aware value text color
        lineChartDataSet.valueTextColor = themeManager.textColor()
        lineChartDataSet.formLineDashLengths = [1, 1]
        lineChartDataSet.formLineWidth = 1
        lineChartDataSet.formLineWidth = 15
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = false
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        
        let gradientColors = [UIColor.UCAColor.AppThemeColor_Dark.lighter(by: 90)!.cgColor,
                              UIColor.UCAColor.AppThemeColor_Dark.lighter(by: 30)!.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        lineChartDataSet.fillAlpha = 1
      //  lineChartDataSet.fill = Fill(linearGradient: gradient, angle: 90)
        lineChartDataSet.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: lineChartDataSet)
        
        scGraphView.data = data
        self.scGraphView.legend.enabled = false
        
        // Update chart theme after setting data
        updateChartTheme()
    }
    
    func yearChanged(_ selectedItemId:Int){
        self.getData(currentSelectedYear: self.yearListArr[selectedItemId])
    }
}
