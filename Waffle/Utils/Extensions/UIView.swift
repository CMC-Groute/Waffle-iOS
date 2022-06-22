//
//  UIView.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/22.
//

import UIKit

extension UIView {
    
//    @discardableResult
//    public func fill(with view: UIView, edges: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
//        view.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(view)
//        let constraints = [
//            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: edges.left),
//            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: edges.top),
//            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: edges.right),
//            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: edges.bottom)
//        ]
//        addConstraints(constraints)
//        return constraints
//    }
    
    func roundCorners(value: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = value
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
