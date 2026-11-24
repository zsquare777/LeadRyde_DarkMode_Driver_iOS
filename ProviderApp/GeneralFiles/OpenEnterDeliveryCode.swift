//
//  OpenEnterDeliveryCode.swift
//  DriverApp
//
//  Created by ADMIN on 12/07/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class OpenEnterDeliveryCode: NSObject,MyTxtFieldOnTextChangeDelegate {

    var uv:ActiveTripUV!
    var containerView:UIView!
    
    var deliveryCode = ""
    
    let generalFunc = GeneralFunctions()
    var enterDeliveryCodeView:EnterDeliveryCodeView!
    var bgView:UIView!
    var isErrorRevelead = false
    
    init(uv:ActiveTripUV, containerView:UIView, deliveryCode:String){
        self.uv = uv
        self.containerView = containerView
        self.deliveryCode = deliveryCode
        super.init()
    }
    
    func show(){
        bgView = UIView()
        self.bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.0
        //        bgView.frame = self.containerView.frame
        bgView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: Application.screenSize.height)
        
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)

        
        let bgTapGue = UITapGestureRecognizer()
        bgTapGue.addTarget(self, action: #selector(self.removeView))
        bgView.addGestureRecognizer(bgTapGue)
        
        enterDeliveryCodeView = EnterDeliveryCodeView(frame: CGRect(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2, width: (Application.screenSize.width > 390 ? 375 : (Application.screenSize.width - 50)), height: 180))
        enterDeliveryCodeView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)

        enterDeliveryCodeView.buildMessage(deliveryCode: self.deliveryCode)
        enterDeliveryCodeView.deliveryCodeTxtField.onTextChangedDelegate = self
        enterDeliveryCodeView.setViewHandler { (view, isPositiveBtnClicked, deliveryCode) in
            
            if(isPositiveBtnClicked == true){
                if(self.deliveryCode == deliveryCode && deliveryCode != ""){
                    
                    self.removeView()
                    self.uv.continueEndTrip()
                    
                }else{
                    if(deliveryCode == ""){
                        let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
                        _ = Utils.setErrorFields(textField: self.enterDeliveryCodeView.deliveryCodeTxtField.getTextField()!, error: required_str)
                    }else{
                        let invalid_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVALID_DELIVERY_CONFIRM_CODE")
                        _ = Utils.setErrorFields(textField: self.enterDeliveryCodeView.deliveryCodeTxtField.getTextField()!, error: invalid_str)
                        if !self.isErrorRevelead{
                            self.enterDeliveryCodeView.frame.size.height = self.enterDeliveryCodeView.frame.height + 20
                            self.isErrorRevelead = true
                        }
                    }
                }
            }else{
                
                self.removeView()
            }
        }
        
        
        enterDeliveryCodeView.layer.shadowOpacity = 0.5
        enterDeliveryCodeView.layer.shadowOffset = CGSize(width: 0, height: 3)
        enterDeliveryCodeView.layer.shadowColor = UIColor.black.cgColor
        
       self.addListViewToView()
        
        self.enterDeliveryCodeView.transform = CGAffineTransform(scaleX: 0, y: 0)
        bgView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.2, animations: {
            self.bgView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.enterDeliveryCodeView.transform = CGAffineTransform(scaleX: 1, y: 1)
            Utils.createRoundedView(view:self.enterDeliveryCodeView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
           self.bgView.alpha = 0.5
        }, completion:{ _ in
        })
    }
    
    @objc func removeView(){
        enterDeliveryCodeView.frame.origin.y = Application.screenSize.height + 2500
        
        bgView.removeFromSuperview()
        
        self.uv.tripTaskExecuted = false
        
        UIView.animate(withDuration: 0.95) {
            /* If Reset to SlideTripBtn */
            if(self.uv.slideTripBtn != nil){
                self.uv.slideTripBtn.Reset()
            }
        }
//        self.uv.view.layoutIfNeeded()
        
        UIApplication.shared.isStatusBarHidden = true
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func addListViewToView() {
        let currentWindow = Application.window
        if(self.uv == nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(enterDeliveryCodeView)
        }else if(self.uv.navigationController != nil){
            self.uv.navigationController?.view.addSubview(bgView)
            self.uv.navigationController?.view.addSubview(enterDeliveryCodeView)
            
            enterDeliveryCodeView.tag = Utils.ALERT_DIALOG_CONTENT_TAG
            bgView.tag = Utils.ALERT_DIALOG_BG_TAG
        }else{
            self.uv.view.addSubview(bgView)
            self.uv.view.addSubview(enterDeliveryCodeView)
        }
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
         if self.isErrorRevelead{
             self.enterDeliveryCodeView.frame.size.height = self.enterDeliveryCodeView.frame.height - 20
             self.isErrorRevelead = false
         }
     }
}
