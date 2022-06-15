//
//  String.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/16.
//

import Foundation
import UIKit

extension String {
    func setLineHeight(_ lineHeight: CGFloat) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        
        style.minimumLineHeight = lineHeight
        let myAttribute = [ NSAttributedString.Key.foregroundColor: Asset.Colors.gray4.color, NSAttributedString.Key.paragraphStyle:  style, NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 15)]
        let myAttrString = NSAttributedString(string: self, attributes: myAttribute)
        
//        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
        return myAttrString
    }
}

