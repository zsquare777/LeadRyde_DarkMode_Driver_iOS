//
//  SDragView.swift
//  SDragView
//
//  Created by Admin on 9/20/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class SDragViewForRequest: UIView,UIGestureRecognizerDelegate {

    //  MARK: - Public properties
    public var viewCornerRadius:CGFloat = 2
    public var viewBackgroundColor:UIColor = UIColor.white
    
    
    // MARK: - Private properties
    public var dragViewAnimatedTopMargin:CGFloat = 0.0 // View fully visible (upper spacing)
    public var viewDefaultHeight:CGFloat = 0.0// View height when appear
    private var gestureRecognizer = UIPanGestureRecognizer()
    private var dragViewDefaultTopMargin:CGFloat!
    private var viewLastYPosition = 0.0
    var bgViewIsHidden = true
    var cabRequestedUV:CabRequestedUV!
    var disablePan = false
    
    var destLatitude = ""
    var destLongitude = ""
    var requestType = ""
    var eFly = ""
    
    fileprivate var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    fileprivate lazy var navigationBarHeight: CGFloat = {
        return UINavigationBar().intrinsicContentSize.height
    }()
    
    
    required init(dragViewAnimatedTopSpace:CGFloat, viewDefaultHeightConstant:CGFloat, uv:CabRequestedUV, destinationLatitude:String, destinationLongitude:String, tripRequestType:String, EFly:String)
    {
        self.cabRequestedUV = uv
        
        self.destLatitude = destinationLatitude
        self.destLongitude = destinationLongitude
        self.requestType = tripRequestType
        self.eFly = EFly
        
        dragViewAnimatedTopMargin = dragViewAnimatedTopSpace
        viewDefaultHeight = viewDefaultHeightConstant
        
        let screenSize: CGRect = UIScreen.main.bounds
        dragViewDefaultTopMargin = screenSize.height - viewDefaultHeight
        
        super.init(frame: CGRect(x: 0, y:dragViewDefaultTopMargin , width: screenSize.width, height: screenSize.height - dragViewAnimatedTopMargin))
        
        self.backgroundColor = viewBackgroundColor//.withAlphaComponent(0.20) //
        self.layer.cornerRadius = self.viewCornerRadius
        
        self.clipsToBounds = true

        self.layoutIfNeeded()
        
        /*gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gestureRecognizer.delegate = self
        self.addGestureRecognizer(gestureRecognizer)*/
    
        self.isHidden = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if disablePan == true{
           
            return
        }
    
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
          
            var newTranslation = CGPoint()
            var oldTranslation = CGPoint()
            newTranslation = gestureRecognizer.translation(in: self.superview)
            
            UIView.animate(withDuration: 0.1, animations: {
//                self.cabRequestedUV.progressContainerView.alpha = 0
//                self.cabRequestedUV.halfProgressCntView.alpha = 1
                self.cabRequestedUV.progressContainerView.alpha = 1
                self.cabRequestedUV.halfProgressCntView.alpha = 0
            })
            if(!(newTranslation.y < 0 && self.frame.origin.y + newTranslation.y <= dragViewAnimatedTopMargin))
            {
                self.translatesAutoresizingMaskIntoConstraints = true
                self.center = CGPoint(x: self.center.x, y: self.center.y + newTranslation.y)
                
                self.frame = CGRect(x: self.frame.origin.x, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                
                // self.layoutIfNeeded()
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.superview)
                
                oldTranslation.y = newTranslation.y
                if(self.cabRequestedUV.gMapView != nil){
                    self.cabRequestedUV.gMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.superview!.frame.height - self.frame.origin.y, right: 0)
//                    self.cabRequestedUV.halfProgressViewY.constant = self.frame.origin.y - 80
                    self.cabRequestedUV.progressViewY.constant = (self.frame.origin.y / 2) - 55 //self.frame.origin.y - 160
                }
                
            }
            else
            {
                
                self.frame.origin.y = dragViewAnimatedTopMargin
                //self.isUserInteractionEnabled = false
                if(self.cabRequestedUV.gMapView != nil){
//                    self.cabRequestedUV.gMapView.frame.size.height = self.frame.origin.y + 8
                    self.cabRequestedUV.gMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.superview!.frame.height - self.frame.origin.y, right: 0)
//                    self.cabRequestedUV.halfProgressViewY.constant = self.frame.origin.y - 80
                    self.cabRequestedUV.progressViewY.constant = (self.frame.origin.y / 2) - 55 //self.frame.origin.y - 160
                }
            }
            
        }
        else if (gestureRecognizer.state == .ended)
        {
            //self.isUserInteractionEnabled = true
            let vel = gestureRecognizer.velocity(in: self.superview)
            
            
            let finalY: CGFloat = 50.0
            let curY: CGFloat = self.frame.origin.y
            let distance: CGFloat = curY - finalY
            
            let springVelocity: CGFloat = 1.0 * vel.y / distance
            
            if(springVelocity > 0 && self.frame.origin.y <= dragViewAnimatedTopMargin)
            {
                self.frame = CGRect(x: 0, y:self.superview!.frame.height - self.cabRequestedUV.setBottomViewY , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                self.bgViewIsHidden = false
                if(self.cabRequestedUV.gMapView != nil){
                    self.cabRequestedUV.gMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.superview!.frame.height - self.frame.origin.y, right: 0)
                    
//                    self.cabRequestedUV.halfProgressViewY.constant = self.frame.origin.y - 80
                    self.cabRequestedUV.progressViewY.constant = (self.frame.origin.y / 2) - 55 //self.frame.origin.y - 160
                    UIView.animate(withDuration: 0.2, animations: {
//                        self.cabRequestedUV.progressContainerView.alpha = 0
//                        self.cabRequestedUV.halfProgressCntView.alpha = 1
                        self.cabRequestedUV.progressContainerView.alpha = 1
                        self.cabRequestedUV.halfProgressCntView.alpha = 0
                        self.cabRequestedUV.requestBottomSepView.isHidden = false
                    })
                    
    
                }
            }
            else if (springVelocity > 0)
            {
                if(self.cabRequestedUV.gMapView != nil){
                    UIView.animate(withDuration: 0.2, animations: {
                        self.cabRequestedUV.progressContainerView.alpha = 1
                        self.cabRequestedUV.progressViewY.constant = (self.frame.origin.y / 2) - 55 //self.frame.origin.y - 160
                        self.cabRequestedUV.halfProgressCntView.alpha = 0
                        self.cabRequestedUV.requestBottomSepView.isHidden = true
                    })
                }
                
                let velocityDirection = gestureRecognizer.velocity(in: self)
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    if(self.frame.size.width != (self.superview?.frame.size.width)!)
                    {
                        self.frame = CGRect(x:0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        
                    }
                    
                    if velocityDirection.y > 0{
                        if self.frame.origin.y > self.dragViewDefaultTopMargin{
//                            self.dragViewDefaultTopMargin = self.superview!.frame.height - 115
                            self.dragViewDefaultTopMargin = self.superview!.frame.height - 108
                            self.frame.origin.y = self.dragViewDefaultTopMargin
                            self.bgViewIsHidden = true
                        }else{
                            
//                            self.dragViewDefaultTopMargin = self.superview!.frame.height - 115
                            self.dragViewDefaultTopMargin = self.superview!.frame.height - 108
                            self.frame.origin.y = self.dragViewDefaultTopMargin
                            self.bgViewIsHidden = false
                        }
                        
                    }else{
                        
                       
                        self.dragViewDefaultTopMargin = self.superview!.frame.height - self.cabRequestedUV.setBottomViewY
                        self.frame.origin.y = self.dragViewDefaultTopMargin
                       // self.ufxViewController.btnSheetCollectionView.setContentOffset(CGPoint(x: self.ufxViewController.btnSheetCollectionView.contentOffset.x, y:-self.ufxViewController.btnSheetCollectionView.contentInset.top), animated: true)
                        self.bgViewIsHidden = false
                        
                    }
                    if(self.cabRequestedUV.gMapView != nil){
                        self.cabRequestedUV.gMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.superview!.frame.height - self.frame.origin.y, right: 0)
                        
                    }
                    
                }), completion:  { (finished: Bool) in
                   
                })
                
            }
            else if (springVelocity == 0)// If Velocity zero remain at same position
            {
                if(self.cabRequestedUV.gMapView != nil){
                    
                    UIView.animate(withDuration: 0.3, animations: {
//                        self.cabRequestedUV.progressContainerView.alpha = 0
//                        self.cabRequestedUV.halfProgressCntView.alpha = 1
                        self.cabRequestedUV.progressContainerView.alpha = 1
                        self.cabRequestedUV.halfProgressCntView.alpha = 0
                        self.cabRequestedUV.requestBottomSepView.isHidden = false
                    })
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame.origin.y = CGFloat(self.viewLastYPosition)
                    
                    if(self.frame.origin.y == self.dragViewDefaultTopMargin)
                    {
                        if("\(self.frame.size.width)" == "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x:0, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                            self.bgViewIsHidden = true
                        }
                    }
                    else{
                        if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                            self.bgViewIsHidden = false
                        }
                    }
                    if(self.cabRequestedUV.gMapView != nil){
                        self.cabRequestedUV.gMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.superview!.frame.height - self.frame.origin.y, right: 0)
                        
                    }
                }), completion: { (finished: Bool) in
                    if(self.cabRequestedUV.gMapView != nil){
//                       self.cabRequestedUV.halfProgressViewY.constant = self.frame.origin.y - 80
                        self.cabRequestedUV.progressViewY.constant = (self.frame.origin.y / 2) - 55 //self.frame.origin.y - 160
                     
                    }
                    
                })
            }
            else
            {
                if(self.cabRequestedUV.gMapView != nil){
                    UIView.animate(withDuration: 0.3, animations: {
//                        self.cabRequestedUV.progressContainerView.alpha = 0
//                        self.cabRequestedUV.halfProgressCntView.alpha = 1
                        self.cabRequestedUV.progressContainerView.alpha = 1
                        self.cabRequestedUV.halfProgressCntView.alpha = 0
                        self.cabRequestedUV.requestBottomSepView.isHidden = false
                    })
                }
                
                if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                {
                    self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                    
                }
                
                self.bgViewIsHidden = false
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    if self.dragViewAnimatedTopMargin == 0{
                       // self.ufxViewController.btnSheetCollectionView.setContentOffset(CGPoint(x: self.ufxViewController.btnSheetCollectionView.contentOffset.x, y:-self.ufxViewController.btnSheetCollectionView.contentInset.top), animated: true)
                    }
                    self.frame.origin.y = self.dragViewAnimatedTopMargin
                    
                   
                }), completion:  { (finished: Bool) in
                    if(self.cabRequestedUV.gMapView != nil){
                        self.cabRequestedUV.gMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.superview!.frame.height - self.frame.origin.y, right: 0)
//                        self.cabRequestedUV.halfProgressViewY.constant = self.frame.origin.y - 80
                        self.cabRequestedUV.progressViewY.constant = (self.frame.origin.y / 2) - 55 //self.frame.origin.y - 160
                        
                    }
                })
            }
            viewLastYPosition = Double(self.frame.origin.y)
            //self.ufxViewController.moreServicesViewSwipePerformed()
            
            self.addGestureRecognizer(gestureRecognizer)
           // self.ufxViewController.btnSheetCollectionView.isScrollEnabled = true
            
        }
        
    }

    
    func perfomViewOpenORCloseAction(cancelTapped:Bool,closeFull:Bool) {
        
        if(cancelTapped == true)
        {
            if self.frame.origin.y <= 0.0 && closeFull == false{
                self.dragViewDefaultTopMargin = self.superview!.frame.height - self.cabRequestedUV.setBottomViewY
                bgViewIsHidden = false
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    
                    self.frame = CGRect(x:0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                    
                    
                }), completion: { (finished: Bool) in
                    //self.ufxViewController.moreServicesViewSwipePerformed()
                })
                
            }else{
               
                self.dragViewDefaultTopMargin = self.superview!.frame.height
                bgViewIsHidden = true
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    
                    self.frame = CGRect(x:0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                    
                    
                }), completion: { (finished: Bool) in
                    //self.ufxViewController.moreServicesViewSwipePerformed()
                })
            }
            
        }
        else{
            
           
            bgViewIsHidden = false
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                
                if(self.cabRequestedUV != nil && self.cabRequestedUV.progressContainerView != nil && self.cabRequestedUV.halfProgressCntView != nil){
                    self.cabRequestedUV.progressContainerView.alpha = 1
                    self.cabRequestedUV.halfProgressCntView.alpha = 0
                }
                
                self.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                
            }), completion: { (finished: Bool) in
                self.isHidden = false
//                self.dragViewDefaultTopMargin = self.superview!.frame.height - 115
//                self.dragViewDefaultTopMargin = self.superview!.frame.height - 388 //Addon
                
                if(((self.destLatitude == "" || self.destLongitude == "") && (self.requestType != "Multi-Delivery") && (self.requestType != Utils.cabGeneralType_UberX) && (self.requestType != Utils.cabGeneralType_Deliver)) || ((self.destLatitude != "" || self.destLongitude != "") && (self.requestType != "Multi-Delivery") && (self.requestType != Utils.cabGeneralType_UberX) && (self.requestType != Utils.cabGeneralType_Deliver) && (self.eFly.uppercased() == "YES"))){
                    
                    self.dragViewDefaultTopMargin = self.superview!.frame.height - 245 //220
                    
                }else{
                    if((self.destLatitude != "" || self.destLongitude != "") && (self.requestType != "Multi-Delivery") && (self.requestType != Utils.cabGeneralType_UberX) && (self.requestType != Utils.cabGeneralType_Deliver)){
                        
                        self.dragViewDefaultTopMargin = self.superview!.frame.height - 359 //142
                            
                    }else{
                        
                        self.dragViewDefaultTopMargin = self.superview!.frame.height - 339
                        
                    }
                }
                
                self.frame.origin.y = self.dragViewDefaultTopMargin
        
                if(self.cabRequestedUV.gMapView != nil){
                    
                    self.cabRequestedUV.progressContainerView.alpha = 1
                    self.cabRequestedUV.gMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.superview!.frame.height - self.frame.origin.y, right: 0)
                    self.cabRequestedUV.progressViewY.constant = (self.frame.origin.y / 2) - 55 //self.frame.origin.y - 160
                    self.cabRequestedUV.requestBottomSepView.isHidden = false
                }
              
            })
        }
        
       // self.setNavBarViewHeight()
       // self.ufxViewController.moreServicesViewSwipePerformed()
    }
 
}
