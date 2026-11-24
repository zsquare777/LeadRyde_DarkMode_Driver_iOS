//
//  ChangePasswordView.swift

//
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class ChangePasswordView: UIView, MyLabelClickDelegate {

    typealias CompletionHandler = (_ view:UIView, _ isPositiveBtnClicked:Bool) -> Void
    
    @IBOutlet weak var headerLbl: MyLabel!
    @IBOutlet weak var currentPassTxtField: MyTextField!
    @IBOutlet weak var newPassTxtField: MyTextField!
    @IBOutlet weak var reEnterNewPassTxtField: MyTextField!
    @IBOutlet weak var positiveLbl: MyLabel!
    @IBOutlet weak var negativeLbl: MyLabel!
    
    @IBOutlet weak var closeCurentView: UIImageView!

    var view: UIView!
    
    let generalFunc = GeneralFunctions()
    var handler:CompletionHandler!
    
    
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
        
        view.frame = bounds
        
        addSubview(view)
        
        
        self.positiveLbl.setClickDelegate(clickDelegate: self)
        self.negativeLbl.setClickDelegate(clickDelegate: self)
        self.positiveLbl.cornerRadius = 10
        self.positiveLbl.masksToBounds = true
        self.positiveLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.negativeLbl.borderColor = UIColor.UCAColor.AppThemeColor
        self.negativeLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.negativeLbl.borderWidth = 1
        self.negativeLbl.backgroundColor = .clear
        
        self.currentPassTxtField.getTextField()!.isSecureTextEntry = true
        self.newPassTxtField.getTextField()!.isSecureTextEntry = true
        self.reEnterNewPassTxtField.getTextField()!.isSecureTextEntry = true
        
        self.headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE_PASSWORD_TXT")
        
        
        
        self.positiveLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT").uppercased()
        self.negativeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased()
        
        self.currentPassTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CURR_PASS_HEADER").capitalized)
        self.newPassTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPDATE_PASSWORD_HINT_TXT").capitalized)
        self.reEnterNewPassTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPDATE_CONFIRM_PASSWORD_HEADER_TXT"))
        self.closeCurentView.setOnClickListener { (view) in
            if(self.handler != nil){
                self.handler(view, false)
            }
        }
        
        // Register for theme changes
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
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
        
        // Update view background
        self.view.backgroundColor = themeManager.cardBackgroundColor()
        self.backgroundColor = themeManager.cardBackgroundColor()
        
        // Update header text color
        self.headerLbl.textColor = themeManager.textColor()
        
        // Note: positiveLbl keeps app theme color (branding)
        // Note: negativeLbl keeps app theme color border (branding)
        // Text fields will adapt if MyTextField supports theming
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ChangePasswordView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.positiveLbl){
            if(self.handler != nil){
                self.handler(view, true)
            }
        }else if(sender == self.negativeLbl){
            if(self.handler != nil){
                self.handler(view, false)
            }
        }
    }

}
