//
//  OpenTripFinishView.swift
//  PassengerApp
//
//  Created by NEW MAC on 28/09/19.
//  Copyright © 2019 @. All rights reserved.
//

import UIKit

class OpenTripFinishView: NSObject {
    typealias CompletionHandler = () -> Void
    
    var uv:UIViewController!
    var containerView:UIView!

    let generalFunc = GeneralFunctions()
    
    var bgView:UIView!
    
    var tripFinishView:TripFinishView!
    
    var cancelReasonsDataDict:NSDictionary!
    
    var superView:UIView!
    
    var isFromSuccessTrip = false
    
    init(uv:UIViewController){
        self.uv = uv
        super.init()
    }
    
    init(uv:UIViewController?, containerView:UIView){
        super.init()
        self.uv = uv
        self.containerView = containerView
    }

    func show(title:String, Desc:String, handler: @escaping CompletionHandler) {
        
        if(self.uv.navigationController != nil){
            superView = self.uv.navigationController!.view
        }else{
            superView = self.uv.view
        }
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.4
        bgView.frame = superView.frame
        
        bgView.center = CGPoint(x: superView.bounds.midX, y: superView.bounds.midY)
        
        let width = Application.screenSize.width  > 380 ? 370 : Application.screenSize.width - 50
         tripFinishView = TripFinishView(frame: CGRect(x: superView.frame.width / 2, y: superView.frame.height / 2, width:width, height: 360))
        tripFinishView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        tripFinishView.layer.shadowOpacity = 0.5
        tripFinishView.layer.shadowOffset = CGSize(width: 0, height: 3)
        tripFinishView.layer.shadowColor = UIColor.black.cgColor
        
        let currentWindow = Application.window
        
        if(currentWindow != nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(tripFinishView)
        }else{
            self.uv.view.addSubview(bgView)
            self.uv.view.addSubview(tripFinishView)
        }
        
      
        var height:CGFloat = 400
        tripFinishView.descriptionLabel.sizeToFit()
        tripFinishView.descriptionLabel.numberOfLines = 0
        tripFinishView.titleLabel.font = UIFont(name: Fonts().semibold, size: 17)
        tripFinishView.descriptionLabel.font = UIFont(name: Fonts().regular , size: 14)
        Utils.createRoundedView(view: tripFinishView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
//        GeneralFunctions.setImgTintColor(imgView: (tripFinishView.subviews[0] as! UIImageView), color: UIColor.UCAColor.AppThemeColor)
        
        tripFinishView.titleLabel.text = title // self.generalFunc.getLanguageLabel(origValue: "Successfully Finished", key: "LBL_SUCCESS_FINISHED_DL")
        
        tripFinishView.descriptionLabel.text = Desc //self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINISHED_DELIVERY_TXT")
        
        tripFinishView.positiveBtn.text = self.generalFunc.getLanguageLabel(origValue: "OK THANKS", key: "LBL_OK_THANKS").uppercased() 
        tripFinishView.positiveBtn.isUserInteractionEnabled = true
        tripFinishView.positiveBtn.backgroundColor = UIColor.UCAColor.AppThemeColor
        tripFinishView.positiveBtn.setOnClickListener { (btn) in
            self.closeView()
            handler()
        }
        
        if(self.isFromSuccessTrip == true){
            tripFinishView.headerImageView.image = UIImage(named: "ic_trip_success")
        }
        
        height = height + tripFinishView.descriptionLabel.text!.height(withConstrainedWidth: width - 30, font: UIFont(name: Fonts().light, size: 15)!)
        if height > Application.screenSize.height - 80 {
            height = Application.screenSize.height - 100
        }
        tripFinishView.frame.size = CGSize(width: width, height: height)
        tripFinishView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
    }
    
    func closeView(){
        tripFinishView.frame.origin.y = Application.screenSize.height + 2500
        tripFinishView.removeFromSuperview()
        bgView.removeFromSuperview()
    }
}
