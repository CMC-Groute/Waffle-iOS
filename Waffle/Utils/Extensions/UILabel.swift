//
//  UILabel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/14.
//

import Foundation
import UIKit

extension UILabel {
    func setHeight(_ lineHeight: CGFloat) {
            let text = self.text
            if let text = text {
                let attributeString = NSMutableAttributedString(string: text)
                let style = NSMutableParagraphStyle()

                style.minimumLineHeight = lineHeight
                attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
                self.attributedText = attributeString
            }
        }
        
    func setHeightSpacing(spacing: CGFloat, lineHeight: CGFloat, alignment: NSTextAlignment = .left) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()

            style.minimumLineHeight = lineHeight
            style.alignment = alignment
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
}
