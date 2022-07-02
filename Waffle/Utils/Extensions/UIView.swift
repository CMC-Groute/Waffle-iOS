//
//  UIView.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/22.
//

import UIKit

extension UIView {
    func roundCorners(value: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = value
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
