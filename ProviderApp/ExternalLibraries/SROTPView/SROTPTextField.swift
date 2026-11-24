//
//  SROTPField.swift
//  SOTPTextField
//
//  Created by admin on 11/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

class SOTPTextField: UITextField {

    var previousTextField: SOTPTextField?
    var nextTextField: SOTPTextField?
    let border = UIView()
    public var otpType:SROTPType = .Bordered

    override public func deleteBackward(){
        if text == "" {
            previousTextField?.becomeFirstResponder()
        }
    }

    func addborder(color:UIColor,height:CGFloat){
        switch otpType {
        case .Bordered,.Rounded:
            self.layer.borderWidth = height
            self.layer.borderColor = color.cgColor
      
        default:
             border.backgroundColor = color
             border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
             border.frame = CGRect(x: 0, y: frame.size.height - height, width: frame.size.width, height: height)
             self.addSubview(border)
        }
       
    }

    func changeToActiveBorder(color:UIColor,height:CGFloat){
        switch otpType {
         case .Bordered,.Rounded:
            self.layer.borderWidth = height
            self.layer.borderColor = color.cgColor
         default:
              border.backgroundColor = color
              border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
              border.frame = CGRect(x: 0, y: frame.size.height - 4, width: frame.size.width, height: height)
         }
        
        
       
    }

    func changeToErrorBorder(color:UIColor,height:CGFloat){
        switch otpType {
        case .Bordered,.Rounded:
           self.layer.borderWidth = height
           self.layer.borderColor = color.cgColor
        default:
              border.backgroundColor = color
              border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
              border.frame = CGRect(x: 0, y: frame.size.height - height, width: frame.size.width, height: height)
        }
         
       }


    func changeToInActiveBorder(color:UIColor,height:CGFloat){
        switch otpType {
        case .Bordered,.Rounded:
           self.layer.borderWidth = height
           self.layer.borderColor = color.cgColor
        default:
              border.backgroundColor = color
              border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            border.frame = CGRect(x: 0, y: frame.size.height - height, width: frame.size.width, height: height)
        }
         
        
           
        }
}



//class Indicator: UIView {
//    var isNeedClear = false
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        self.layer.cornerRadius = rect.width/2
//        self.clipsToBounds = true
//        self.layer.borderWidth = 2
//        self.layer.borderColor = UIColor.lightGray.cgColor
//    }
//
//}
