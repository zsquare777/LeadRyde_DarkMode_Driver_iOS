//
//  ExtUIPanGestureRecognizer.swift
//  DriverApp
//

import Foundation
extension UIPanGestureRecognizer {
    
    func isLeft() -> Bool {
        let vc : CGPoint = velocity(in: self.view)
        if vc.x > 0 {
//            print("Gesture went right")
            return false
        } else {
//            print("Gesture went left")
            return true
        }
    }
    
    func isRight() -> Bool {
        let vc : CGPoint = velocity(in: self.view)
        if vc.x > 0 {
//            print("Gesture went right")
            return true
        } else {
//            print("Gesture went left")
            return false
        }
    }
    
    func getXposition() -> CGFloat{
        let vc : CGPoint = velocity(in: self.view)
        return vc.x
    }
}
