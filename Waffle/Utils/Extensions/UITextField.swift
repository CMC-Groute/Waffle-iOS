//
//  UITextField.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/09.
//

import Foundation
import UIKit

extension UITextField {
    func round(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
    
    func focusingBorder(color: String) {
        self.layer.borderColor = UIColor(named: color)?.cgColor
        self.layer.borderWidth = 2
    }
}

extension UIButton {
    func round(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
    
    func circle(corner: CGFloat) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }
}


