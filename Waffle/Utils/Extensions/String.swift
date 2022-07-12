//
//  String.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/16.
//

import UIKit

extension String {
    func setLineHeight(_ lineHeight: CGFloat) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        
        style.minimumLineHeight = lineHeight
        let myAttribute = [ NSAttributedString.Key.foregroundColor: Asset.Colors.gray4.color, NSAttributedString.Key.paragraphStyle:  style, NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 15)]
        let myAttrString = NSAttributedString(string: self, attributes: myAttribute)
        return myAttrString
    }
    
    func underBarLine() -> NSAttributedString {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: Asset.Colors.black.color, NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 13)] as [NSAttributedString.Key : Any]
        let underlineAttributedString = NSAttributedString(string: self, attributes: underlineAttribute)
        return underlineAttributedString
    }
    
    func underBarLine(length: Int) -> NSAttributedString {
        
        let textRange = NSRange(location: 0, length: length)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(.underlineStyle,
                                           value: NSUnderlineStyle.single.rawValue,
                                           range: textRange)
        attributedText.addAttribute(.foregroundColor,
                                           value: Asset.Colors.black.color,
                                           range: textRange)
        attributedText.addAttribute(.font,
                                           value: UIFont.fontWithName(type: .regular, size: 13),
                                           range: textRange)
        return attributedText
    }
    
    func amPmChangeFormat() -> String {
        if self.contains("AM") {
            return self.replacingOccurrences(of: "AM", with: "오전")
        }else if self.contains("PM") {
            return self.replacingOccurrences(of: "PM", with: "오후")
        }
        return self
    }
}

extension String {
    func toDate() -> Date? { //"yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func toTime() -> Date? { //"HH:mm"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        if let time = timeFormatter.date(from: self) {
            return time
        } else {
            return nil
        }
    }
}

