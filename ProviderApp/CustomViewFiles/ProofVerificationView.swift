//
//  ProofVerificationView.swift
//  DriverApp
//
//  Created by Apple on 29/09/20.
//  Copyright © 2020 @. All rights reserved.
//

import UIKit

class ProofVerificationView: UIView {

    @IBOutlet weak var closeImgView: UIImageView!
    @IBOutlet weak var proofImgView: UIImageView!
    @IBOutlet weak var proofSLbl: MyLabel!
    @IBOutlet weak var proofNoteLbl: MyLabel!
    @IBOutlet weak var proofDeclineBtn: MyButton!
    @IBOutlet weak var proofConfBtn: MyButton!
    
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
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProofVerificationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
