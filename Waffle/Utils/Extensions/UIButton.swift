//
//  UIButton.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/11.
//

import UIKit

extension UIButton {
    func makeRounded(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
    
    func makeCircle(corner: CGFloat) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }
    
    func setEnabled(color: String?) {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = true
            self.isEnabled = true
            if let color = color {
                self.backgroundColor = UIColor(named: color)
                self.setTitleColor(UIColor(named: Asset.Colors.white.name), for: .normal)
            }
        }
    }
    
    func setUnEnabled(color: String?) {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = false
            self.isEnabled = true
            if let color = color {
                self.backgroundColor = UIColor(named: color)
                self.setTitleColor(UIColor(named: Asset.Colors.white.name), for: .disabled)
            }
        }
    }
    
    func setDisabled(with bool: Bool, color: String){
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = !bool
            self.backgroundColor =  bool ? UIColor(named: color)!.withAlphaComponent(0.5) : UIColor(named: color)!
        }
    }
    
    func alignTextBelow(spacing: CGFloat = 10.0) {
        guard let image = self.imageView?.image else {
            return
        }
        guard let titleLabel = self.titleLabel else {
            return
        }

        guard let titleText = titleLabel.text else {
            return
        }
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])

        self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}



