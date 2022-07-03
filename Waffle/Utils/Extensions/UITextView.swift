//
//  UITextView.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit


extension UITextView {
    func focusingBorder(color: String?) {
        if let color = color {
            self.layer.borderColor = UIColor(named: color)?.cgColor
            self.layer.borderWidth = 2
        }else {
            self.layer.borderColor = .none
            self.layer.borderWidth = 0
        }
    }
}

extension UITextView {
    func centerVerticalText() {
       let fitSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
       let size = sizeThatFits(fitSize)
       let calculate = (bounds.size.height - size.height * zoomScale) / 2
       let offset = max(1, calculate)
       contentOffset.y = -offset
   }
}
