//
//  EnterDeliveryCodeView.swift
//  DriverApp
//
//  Created by ADMIN on 12/07/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class EnterDeliveryCodeView: UIView, MyLabelClickDelegate {
    
    typealias CompletionHandler = (_ view:UIView, _ isPositiveBtnClicked:Bool, _ deliveryCode:String) -> Void

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var deliveryCodeTxtField: MyTextField!
    @IBOutlet weak var positiveLbl: MyLabel!
    @IBOutlet weak var negativeLbl: MyLabel!
        
    var view: UIView!
    var handler:CompletionHandler!
    
    let generalFunc = GeneralFunctions()
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func setViewHandler(handler: @escaping CompletionHandler){
        self.handler = handler
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        
        addSubview(view)
        
        self.headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "Delivery Confirmation", key: "LBL_DELIVERY_CONFIRM")
        self.messageLbl.text = ""
        
        
//        self.deliveryCodeTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_REASON"))
        
        self.positiveLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT").uppercased()
        self.negativeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased()
        
        self.positiveLbl.setClickDelegate(clickDelegate: self)
        self.negativeLbl.setClickDelegate(clickDelegate: self)
    }
    
    func buildMessage(deliveryCode:String){
        
        var contentMsg = self.generalFunc.getLanguageLabel(origValue: "Please enter the confirmation code received from recipient.", key: "LBL_DELIVERY_END_NOTE")
        
        if let SITE_TYPE = GeneralFunctions.getValue(key: Utils.SITE_TYPE_KEY) as? String{
            if(SITE_TYPE == "Demo"){
                contentMsg = "\(contentMsg)\n\(self.generalFunc.getLanguageLabel(origValue: "For demo purpose, please enter confirmation code in text box as shown below.", key: "LBL_DELIVERY_END_NOTE_DEMO")) \n\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRMATION_CODE")): \(deliveryCode)" 
            }
        }
        
        self.messageLbl.text = contentMsg
        self.messageLbl.fitText()
        
        let contentMsgHeight = contentMsg.height(withConstrainedWidth: self.view.frame.width - 40, font: UIFont(name: Fonts().light, size: 16)!)
        
        self.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height + contentMsgHeight)
        
        view.frame = bounds
    }

    func myLableTapped(sender: MyLabel) {
        if(sender == self.positiveLbl){
            if(self.handler != nil){
                self.handler(view, true, Utils.getText(textField: self.deliveryCodeTxtField.getTextField()!))
            }
        }else if(sender == self.negativeLbl){
            if(self.handler != nil){
                self.handler(view, false, Utils.getText(textField: self.deliveryCodeTxtField.getTextField()!))
            }
        }
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EnterDeliveryCodeView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
