//
//  MySliderButton.swift
//  DriverApp
//
//  Created by NEW MAC on 12/09/19.
//  Copyright © 2019 @. All rights reserved.
//

import UIKit

protocol MySliderBtnClickDelegate {
    func myBtnSlided(sender:MySliderButton)
}

class MySliderButton: UIView {
    
    @IBInspectable internal var isAppTheme:Bool = false
    @IBInspectable internal var isAppTheme1:Bool = true
    @IBInspectable internal var isSliderMove:Bool = false
    @IBInspectable internal var title:String = ""
    @IBInspectable internal var image:UIImage?
    @IBInspectable internal var slidedImage:UIImage?
    
    @IBInspectable internal var titleColor:UIColor!
    @IBInspectable internal var bgColor:UIColor!
    @IBInspectable internal var pulseColor:UIColor!
    
    @IBInspectable internal var fontFamilyWeight:String = "Regular"
    @IBInspectable internal var fontSize:CGFloat = 18
    
    // MARK:- Delegate
    var clickDelegate:MySliderBtnClickDelegate?
    var isLeft = true
    var buttonTitle = ""
    
    var button:RaisedButton!
    var centerX:CGFloat = 0
    var imgRight: UIImageView!
    
    var customTitleColor:UIColor!
    
    var isBtnEnabled = true
    var btnType = ""
    
    var fontName = Fonts().light
    var panGestureRecognizer: UIPanGestureRecognizer?
    var timer:Timer!
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        initializeButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        initializeButton()
    }
    
    func initializeButton(){
        if(self.button == nil){
            self.button = RaisedButton()
            self.imgRight = UIImageView()
        }
    }
    override func layoutSubviews() {
        addButton()
    }
    
    func setBoldTitle(_ isBold: Bool) {
        guard let lbl = self.button?.titleLabel else { return }
        let size = lbl.font.pointSize > 0 ? lbl.font.pointSize : fontSize

        if isBold {
            if let customBold = UIFont(name: Fonts().bold, size: size) {
                lbl.font = customBold
            } else {
                lbl.font = UIFont.boldSystemFont(ofSize: size)
            }
        } else {
            if let customRegular = UIFont(name: Fonts().regular, size: size) {
                lbl.font = customRegular
            } else {
                lbl.font = UIFont.systemFont(ofSize: size)
            }
        }
    }

    
    func addButton() {
        initializeButton()
        imgRight.frame = CGRect(x: 10, y: 5, width: self.bounds.size.height - 10, height: self.bounds.size.height - 5)
        button.frame = self.frame
        imgRight.image = UIImage(named: "ic_checkmark")
        GeneralFunctions.setImgTintColor(imgView: imgRight, color: UIColor.UCAColor.AppThemeTxtColor_1)
        button!.backgroundColor = .clear
        button!.isEnabled = true
        if(isAppTheme == false && isAppTheme1 == false){
            button!.title = title.uppercased()
            button!.titleColor = titleColor
            button!.pulseColor = Color.UCAColor.AppThemeColor_1_Hover
            self.backgroundColor = bgColor
        }else if(isAppTheme){
            button!.title = title.uppercased()
            button!.titleColor = Color.UCAColor.AppThemeTxtColor
            button!.pulseColor = Color.UCAColor.AppThemeColor_Hover
            self.backgroundColor = Color.UCAColor.AppThemeColor
        }else if(titleColor != nil && bgColor != nil && pulseColor != nil){
            button!.title = title.uppercased()
            button!.titleColor = titleColor
            button!.pulseColor = pulseColor
            self.backgroundColor = bgColor
        }else{
            button!.title = title.uppercased()
            button!.titleColor = Color.UCAColor.AppThemeTxtColor_1
            button!.pulseColor = Color.UCAColor.AppThemeColor_1_Hover
            self.backgroundColor = Color.UCAColor.AppThemeColor_1
        }
        
        var compareStr = ""
        var fontCon = [String] ()
        fontCon = fontFamilyWeight.components(separatedBy: "-")
        if(fontCon.count > 0){
            compareStr = fontCon.last ?? ""
        }
        
        if("Regular" == fontFamilyWeight || "Regular" == compareStr || Utils.fontFname == fontCon.first ?? ""){
            fontName = Fonts().regular
        }else if("Medium" == fontFamilyWeight || "Medium" == compareStr || "Semibold" == compareStr || "Semibold" == fontFamilyWeight){
            fontName = Fonts().semibold
        }else if("Light" == fontFamilyWeight || "Light" == compareStr){
            fontName = Fonts().light
        }else if("Bold" == fontFamilyWeight || "Bold" == compareStr){
            fontName = Fonts().bold
        }else{
            fontName = Fonts().light
        }
        
        button!.frame = self.frame
        button!.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        button!.pulseAnimation = .centerWithBacking
        button!.titleLabel!.font = UIFont(name: fontName, size: fontSize)
        
        setScaleFactor()
        
        button!.title = self.buttonTitle.uppercased()
        
        if(customTitleColor != nil){
            self.button!.titleColor = customTitleColor
        }
        
        self.button!.isEnabled = self.isBtnEnabled
        
        self.addSubview(button!)
        self.addSubview(imgRight!)
        self.bringSubviewToFront(button!)
        
        if(Configurations.isRTLMode()){
           setRTL()
        }else {
             setLTR()
        }
        button.clipsToBounds = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipteBothButtonsBothPresent(_:)))
        self.button!.addGestureRecognizer(panGestureRecognizer)
        startTimer()
    }
    func startTimer() {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(animationForSlider), userInfo: nil, repeats: true)
    }
    
    @objc func animationForSlider() {
        if(Configurations.isRTLMode()){
            if button.frame.origin.x == 0 {
                var frame = button.frame
                frame.origin.x  = 0
                UIView.animate(withDuration: 1, animations: {
                    frame.origin.x  = -40
                    self.button.frame = frame
                }) { (isSuccess) in
                    UIView.animate(withDuration: 0.1) {
                        frame.origin.x  = 0
                        self.button.frame = frame
                    }
                }
            }
        }else {
            if button.frame.origin.x == 0 {
                var frame = button.frame
                frame.origin.x  = 0
                UIView.animate(withDuration: 1, animations: {
                    frame.origin.x  = 40
                    self.button.frame = frame
                }) { (isSuccess) in
                    UIView.animate(withDuration: 0.1) {
                        frame.origin.x  = 0
                        self.button.frame = frame
                    }
                }
            }
        }
    }
    
    private func setScaleFactor(){
        button!.titleLabel?.frame = self.frame
        button!.titleLabel?.lineBreakMode = .byWordWrapping
        button!.titleLabel?.numberOfLines = 1
        button!.titleLabel?.minimumScaleFactor = 0.8
        button!.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0)
        button!.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func enableCustomColor(){
        button!.titleColor = titleColor
        button!.pulseColor = pulseColor
        button!.backgroundColor = bgColor
    }
    
    func setButtonEnabled(isBtnEnabled:Bool){
        if(self.button == nil){
            self.isBtnEnabled = isBtnEnabled
        }else{
            self.isBtnEnabled = isBtnEnabled
            self.button?.isEnabled = isBtnEnabled
        }
        
        if(isBtnEnabled){
            self.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
        }else{
            self.setButtonTitleColor(color: UIColor(hex: 0x6b6b6b))
        }
    }
    
    func setButtonTitle(buttonTitle:String){
        
        self.buttonTitle = buttonTitle
        if(getButton() != nil){
            getButton()!.title = buttonTitle.uppercased()
        }
    }
    
    func setButtonTitleColor(color:UIColor){
        self.customTitleColor = color
        if(self.button != nil){
            self.button!.titleColor = color
        }
    }
    
    func setAppThemeColor(isAppTheme:Bool){
        if(isAppTheme){
            self.isAppTheme = true
            self.isAppTheme1 = false
        }else{
            self.isAppTheme = false
            self.isAppTheme1 = true
        }
        
        if(self.button != nil){
            if(isAppTheme){
                button!.titleColor = Color.UCAColor.AppThemeTxtColor
                button!.pulseColor = Color.UCAColor.AppThemeColor_Hover
                self.backgroundColor = Color.UCAColor.AppThemeColor
            }else{
                button!.titleColor = Color.UCAColor.AppThemeTxtColor_1
                button!.pulseColor = Color.UCAColor.AppThemeColor_1_Hover
                self.backgroundColor = Color.UCAColor.AppThemeColor_1
            }
        }
    }
    
    func setCustomColor(textColor:UIColor, bgColor:UIColor, pulseColor:UIColor){
        isAppTheme = false
        isAppTheme1 = false
        
        self.titleColor = textColor
        self.bgColor = bgColor
        self.pulseColor = pulseColor
        
        button!.titleColor = textColor
        button!.pulseColor = pulseColor
        self.backgroundColor = bgColor
    }
    
    func getButton() -> RaisedButton?{
        //        return self.subviews[0] as! RaisedButton
        if(self.subviews.count > 0){
            return self.subviews[1] as? RaisedButton
        }else{
            return nil
        }
    }
    
    @objc  func swipteBothButtonsBothPresent(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view!)
        let velocity = gesture.velocity(in: gesture.view!)
        var centerXs:CGFloat = 0
        if timer != nil {
           timer.invalidate()
            timer = nil
        }
        if(Configurations.isRTLMode()){
            centerXs = -(self.bounds.size.width * 60)/100
        }else {
            centerXs = (self.bounds.size.width * 60)/100
        }
        
      
        switch gesture.state {
        case .changed:
            if (isLeft && translation.x < 0) ||  (!isLeft && translation.x > 0) {
                gesture.view!.frame.origin = CGPoint(x: translation.x, y: 0)
                self.imgRight.alpha = 0
                if (isLeft && translation.x < centerXs) ||  (!isLeft && translation.x > centerXs){
                    let percentage : CGFloat  = translation.x/self.frame.size.width;
                    self.imgRight.isHidden = false
                    self.imgRight.alpha = abs(percentage)
                }else {
                    self.imgRight.isHidden = true
                    self.imgRight.alpha = 0
                }
            }else{
                gesture.view!.frame.origin = CGPoint(x: 0, y: 0)
            }
            break
        case .ended:
            print ("Transaltion",translation.x)
            print ("Valocity",velocity.x)
            if (isLeft && translation.x > 0 ) || (!isLeft && translation.x < 0){
                gesture.view!.frame.origin = CGPoint(x: 0, y: 0)
                break
            }
            
            if (isLeft &&  (translation.x < centerX || velocity.x < 1000)) || (!isLeft && ( translation.x > centerX || velocity.x > 1000) ){
                UIView.animate(withDuration: 0.3) {
                    gesture.view!.frame.origin = CGPoint(x: (self.isLeft) ? -(self.center.x * 2) : (self.center.x * 2), y: 0)
                    self.imgRight.isHidden = false
                    self.imgRight.alpha = 1
                    self.clickDelegate?.myBtnSlided(sender: self)
                }
            }else {
                UIView.animate(withDuration: 0.3) {
                    gesture.view!.frame.origin = CGPoint(x: 0, y: 0)
                    self.imgRight.isHidden = true
                    self.imgRight.alpha = 0
                   
                }
            }
        default:
            break
        }
        
        if self.timer == nil {
            self.startTimer()
        }
    }
    
    public func Reset() {
        if(Configurations.isRTLMode()){
            setRTL()
        }else {
            setLTR()
        }/*else {
         button.frame.origin  = CGPoint(x: 0, y: 0)
         self.imgRight.isHidden = true
         centerX = (self.bounds.size.width * 40)/100
         }*/
    }
    
    func setLTR() {
        isLeft = false
        imgRight.frame = CGRect(x: 10, y: 5, width: 35, height: 35)
        button.frame.origin  = CGPoint(x: 0, y: 0)
        imgRight.center.y = button.center.y
        self.imgRight.isHidden = true
        centerX = (self.bounds.size.width * 60)/100
        button.setImage(UIImage(named: "ic_doubble_right_arrow")!.resize(toWidth: 25)!.resize(toHeight: 25), for:.normal)
//        self.button!.imageEdgeInsets.left = 40
        button.leftAlignMent()
    }
    
    func  setRTL() {
        isLeft = true
        imgRight.frame = CGRect(x: (self.bounds.size.width - 45), y: 5, width: 35, height: 35)
        centerX = -(self.bounds.size.width * 60)/100
        imgRight.center.y = self.bounds.size.height/2
        button.frame.origin  = CGPoint(x: 0, y: 0)
        self.imgRight.isHidden = true
        let image = UIImage(named: "ic_doubble_right_arrow")!.resize(toWidth: 25)!.resize(toHeight: 25)!.rotate(180)
//        self.button!.imageEdgeInsets.right = 40
        button.setImage(image, for: .normal)
        button.rightAlignMent()
    }
}

extension UIButton {
    func leftAlignMent (){
        
        semanticContentAttribute = .forceLeftToRight
        contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)

        var  availableWidth = (availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0))
        availableWidth = availableWidth - 20
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth/2, bottom: 0, right: 0)
    }
    
    func rightAlignMent (){
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        var availableWidth = (availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0))
        availableWidth = availableWidth - 20
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth/2 )
    }
}
