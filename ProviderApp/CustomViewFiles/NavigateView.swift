//
//  NavigateView.swift
//  DriverApp
//
//  Created by Tarwinder Singh on 28/12/17.
//  Copyright © 2017 @. All rights reserved.
//

import UIKit

class NavigateView: UIView {

    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var navContaintView: UIView!
    @IBOutlet weak var navContaintViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressLbl: UILabel!

    var view: UIView!
    
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
        
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NavigateView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
