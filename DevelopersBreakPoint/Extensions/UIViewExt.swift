//
//  UIViewExt.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/19/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

extension UIView{
    
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
        
        @IBInspectable var CornerRadius:CGFloat{
            get{return self.layer.cornerRadius}
            set{self.layer.cornerRadius=newValue}
        }
//        @IBInspectable var BorderWidth:CGFloat{
//            get{return self.layer.borderWidth}
//            set{self.layer.borderWidth=newValue}
//        }
//        @IBInspectable var BorderColor:UIColor{
//            get{return UIColor(cgColor: self.layer.borderColor!)}
//            set{self.layer.borderColor=newValue.cgColor}
//        }
    
   @objc func keyboardWillChange(_ notification:NSNotification){
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
}
