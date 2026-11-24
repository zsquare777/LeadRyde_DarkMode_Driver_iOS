//
//  ListBottomSheetView.swift
//  UserApp
//
//  Created by Apple on 02/03/21.
//

import Foundation

import UIKit
import SwiftExtensionData

class ListBottomSheetView: UIView {

  
    @IBOutlet weak var tableSapraterView: UIView!
    @IBOutlet weak var titleLbl: MyLabel!
    @IBOutlet weak var subTitleLbl: MyLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeImgView: UIImageView!
    var view: UIView!
    
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
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        //        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        self.closeImgView.image = self.closeImgView.image?.addImagePadding(x: 15, y: 15)
        
        // CRITICAL: Apply theme IMMEDIATELY after XIB load to override hardcoded colors
        applyTheme()
        
        // Register for theme changes
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        // Apply theme again asynchronously to catch any delayed XIB rendering
        DispatchQueue.main.async {
            self.applyTheme()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func themeDidChange() {
        applyTheme()
    }
    
    func applyTheme() {
        let themeManager = ThemeManager.shared
        
        // CRITICAL: Aggressively override ALL XIB hardcoded colors
        // This is necessary because XIB files have white backgrounds that persist
        
        // 1. Update main view backgrounds
        self.view?.backgroundColor = themeManager.backgroundColor()
        self.backgroundColor = themeManager.backgroundColor()
        
        // 2. Force ALL subviews to adopt background (except specific ones)
        if let mainView = self.view {
            self.recursivelyApplyBackgroundColor(to: mainView, color: themeManager.backgroundColor())
        }
        
        // 3. Update table view background - Google Wallet style
        if self.tableView != nil {
            self.tableView.backgroundColor = themeManager.backgroundColor()
            self.tableView.separatorColor = themeManager.separatorColor()
            self.tableView.superview?.backgroundColor = themeManager.backgroundColor()
        }
        
        // 4. Update label text colors
        if self.titleLbl != nil {
            self.titleLbl.textColor = themeManager.textColor()
            self.titleLbl.backgroundColor = .clear
            self.titleLbl.superview?.backgroundColor = themeManager.backgroundColor()
        }
        if self.subTitleLbl != nil {
            self.subTitleLbl.textColor = themeManager.secondaryTextColor()
            self.subTitleLbl.backgroundColor = .clear
            self.subTitleLbl.superview?.backgroundColor = themeManager.backgroundColor()
        }
        
        // 5. Update separator view
        if self.tableSapraterView != nil {
            self.tableSapraterView.backgroundColor = themeManager.separatorColor()
        }
        
        // 6. Force close button background
        if self.closeImgView != nil {
            self.closeImgView.backgroundColor = .clear
            self.closeImgView.superview?.backgroundColor = themeManager.backgroundColor()
        }
        
        // 7. EXTRA: Force any remaining white backgrounds (bottom section fix)
        // This catches container views that might have been missed
        self.forceOverrideWhiteBackgrounds(in: self, with: themeManager.backgroundColor())
        
        // 8. CRITICAL: Restore rounded top corners
        // Apply rounded corners to the main view (top corners only)
        if let mainView = self.view {
            mainView.layer.cornerRadius = 20
            mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top left and top right
            mainView.layer.masksToBounds = true
        }
        
        // Also apply to self to ensure corner radius is visible
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.masksToBounds = true
        
        // 9. Force layout update
        self.view?.setNeedsLayout()
        self.setNeedsLayout()
        self.view?.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    // Helper method to recursively apply background color
    private func recursivelyApplyBackgroundColor(to view: UIView, color: UIColor) {
        // Don't change background for specific UI elements
        guard !(view is UITableView) && !(view is UIImageView) else {
            return
        }
        
        // Apply background color
        view.backgroundColor = color
        
        // Recursively apply to all subviews
        for subview in view.subviews {
            recursivelyApplyBackgroundColor(to: subview, color: color)
        }
    }
    
    // AGGRESSIVE: Find and replace any white backgrounds
    private func forceOverrideWhiteBackgrounds(in view: UIView, with color: UIColor) {
        // Check if this view has a white or clear background and force theme color
        if let bgColor = view.backgroundColor {
            // Check for white, light gray, or clear backgrounds
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            bgColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            // If it's white-ish (R, G, B all > 0.9) or clear, replace it
            if (red > 0.9 && green > 0.9 && blue > 0.9) || alpha < 0.1 {
                if !(view is UITableView) && !(view is UIImageView) {
                    view.backgroundColor = color
                }
            }
        }
        
        // Recursively check all subviews
        for subview in view.subviews {
            forceOverrideWhiteBackgrounds(in: subview, with: color)
        }
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ListBottomSheetView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
