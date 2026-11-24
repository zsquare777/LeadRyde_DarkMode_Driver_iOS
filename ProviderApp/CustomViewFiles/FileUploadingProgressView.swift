//
//  FileUploadingProgressView.swift
//  DriverApp
//
//  Created by Admin on 04/10/19.
//  Copyright © 2019 @. All rights reserved.
//

import UIKit

class FileUploadingProgressView: UIView {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var circleProgressBar: CircleProgressView!
    @IBOutlet weak var totalProgressLabel: MyLabel!
    @IBOutlet weak var titleLabel: MyLabel!
    @IBOutlet weak var subTitleLabel: MyLabel!
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
        
        // Make the view stretch with containing view
        //        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        self.backgroundColor = UIColor.clear
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FileUploadingProgressView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
