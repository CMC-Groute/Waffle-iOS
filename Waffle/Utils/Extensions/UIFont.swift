//
//  UIFont.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/11.
//

import UIKit

enum FontType {
   case regular, bold, medium, light, semibold
}

extension UIFont {
    static func buttonPopUpFont() -> UIFont {
        return self.fontWithName(type: .bold, size: 16)
    }
    
    static func button40pxFont() -> UIFont {
        return self.fontWithName(type: .medium, size: 13)
    }
    
    static func buttonMainFont() -> UIFont {
        return self.fontWithName(type: .bold, size: 16)
    }
    
    static func buttonTextFont() -> UIFont {
        return self.fontWithName(type: .semibold, size: 13)
    }
    
    static func buttonText16Font() -> UIFont {
        return self.fontWithName(type: .regular, size: 16)
    }
    
    static func textFieldTextFont() -> UIFont {
        return self.fontWithName(type: .semibold, size: 16)
    }
    
    static func textFieldTitleFont() -> UIFont {
        return self.fontWithName(type: .semibold, size: 14)
    }
    
    static func textFieldSubTitleFont() -> UIFont {
        return self.fontWithName(type: .semibold, size: 12)
    }
    
    static func labelRegularFont() -> UIFont {
        return self.fontWithName(type: .regular, size: 14)
    }
    
    static func labelTitleFont() -> UIFont {
        return self.fontWithName(type: .regular, size: 15)
    }
    
    static func labelsubInfoFont() -> UIFont {
        return self.fontWithName(type: .medium, size: 13)
    }
    
    static func titleFont() -> UIFont {
        return self.fontWithName(type: .semibold, size: 24)
    }
    
    static func higlightTextFont() -> UIFont {
        return self.fontWithName(type: .semibold, size: 18)
    }
    
    static func topPageTitleFont() -> UIFont {
        return self.fontWithName(type: .semibold, size: 17)
    }
    
    static func etcQuitFont() -> UIFont { //underline with attributeString
        return self.fontWithName(type: .medium, size: 13)
    }
    
    static func etcAgreeFont() -> UIFont { //underline with attributeString
        return self.fontWithName(type: .regular, size: 14)
    }
    
    static func popUpTitleFont() -> UIFont {
        return self.fontWithName(type: .semibold, size: 18)
    }
    
    static func popUpAdditionalTitleFont() -> UIFont {
        return self.fontWithName(type: .regular, size: 14)
    }
    
    static func cardTitleFont() -> UIFont {
        return self.fontWithName(type: .bold, size: 32)
    }
    
    static func cardDateLocationFont() -> UIFont {
        return self.fontWithName(type: .regular, size: 17)
    }
    
    static func cardMessageFont() -> UIFont {
        return self.fontWithName(type: .regular, size: 15)
    }
    
    static func cardNameFont() -> UIFont {
        return self.fontWithName(type: .regular, size: 14)
    }
    
    static func homeCategoryTitle() -> UIFont {
        return self.fontWithName(type: .medium, size: 15)
    }
    
    

}

extension UIFont {
    static func fontWithName(type: FontType, size: CGFloat) -> UIFont {
        var fontName = ""
        switch type {
        case .regular:
            fontName = "AppleSDGothicNeo-Regular"
        case .light:
            fontName = "AppleSDGothicNeo-Light"
        case .medium:
            fontName = "AppleSDGothicNeo-Medium"
        case .semibold:
            fontName = "AppleSDGothicNeo-SemiBold"
        case .bold:
            fontName = "AppleSDGothicNeo-Bold"
        }
        
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
