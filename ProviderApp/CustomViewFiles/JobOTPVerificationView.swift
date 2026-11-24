//
//  JobOTPVerificationView.swift
//  ProviderApp
//
//  Created by Apple on 04/02/21.
//

import Foundation

class JobOTPVerificationView: UIView {

    @IBOutlet weak var otpStackView: OTPStackView!
    @IBOutlet weak var subTitleLbl: MyLabel!
    @IBOutlet weak var titleLbl: MyLabel!
    @IBOutlet weak var closeOTPLbl: MyLabel!
    @IBOutlet weak var submitOTPBtn: MyButton!
    @IBOutlet weak var otpTextFiled: MyTextField!
    @IBOutlet weak var errorLbl: MyLabel!
    @IBOutlet weak var otpViewTopSpace: NSLayoutConstraint!
    var view: UIView!
    
    let generalFunc = GeneralFunctions()
    var numberOfFileds = 4
    
//    override init(frame: CGRect) {
//        // 1. setup any properties here
//
//        // 2. call super.init(frame:)
//        super.init(frame: frame)
//
//        // 3. Setup view from .xib file
//        xibSetup()
//    }
//
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)

        // 3. Setup view from .xib file
        //xibSetup()
    }
    
    
    init(frame: CGRect, numberOfFileds:Int) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        self.numberOfFileds = numberOfFileds
        // 3. Setup view from .xib file
        xibSetup()
        
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        //        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        
        otpStackView.numberOfFields = self.numberOfFileds
        if(self.numberOfFileds == 6){
            self.otpStackView.miniSpacing = 10
        }else if(self.numberOfFileds == 4){
            self.otpStackView.miniSpacing = 25
        }else{
            self.otpStackView.isHidden = true
            self.otpTextFiled.isHidden = false
        }
        self.otpStackView.setupStackView()
        self.otpStackView.addOTPFields()
        
        self.errorLbl.textColor = UIColor.UCAColor.red
        self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OTP_INVALID_TXT")
        self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OTP_VERIFICATION_TITLE_TXT")
        self.closeOTPLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLOSE_TXT")
        self.submitOTPBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONE"))
        self.subTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OTP_VERIFICATION_DESCRIPTION_TXT")
        self.otpTextFiled.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_ENTER_OTP_TXT"))
        
        addSubview(view)
       
    }
 
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "JobOTPVerificationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
