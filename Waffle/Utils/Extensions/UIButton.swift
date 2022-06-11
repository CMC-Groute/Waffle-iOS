//
//  UIButton.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/11.
//

import Foundation
import UIKit

extension UIButton {
    func setEnabled(color: String?) {
        self.isUserInteractionEnabled = true
        if let color = color {
            self.backgroundColor = UIColor(named: color)
            self.setTitleColor(UIColor(named: Asset.Colors.white.name), for: .normal)
        }
    }
    
    func setUnEnabled(color: String?) {
        self.isUserInteractionEnabled = false
        if let color = color {
            self.backgroundColor = UIColor(named: color)
            self.setTitleColor(UIColor(named: Asset.Colors.white.name), for: .disabled)
        }
        
    }
}
