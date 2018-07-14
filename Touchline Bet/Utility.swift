//
//  Utility.swift
//  Touchline Bet
//
//  Created by Rujal on 2/11/18.
//  Copyright © 2018 Rujal. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
}
extension UIView {
    
    @IBInspectable var cornerRadius1: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth1: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor1: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
