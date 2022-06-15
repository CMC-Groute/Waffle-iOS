//
//  UserDefaultKey.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation
import UIKit

enum UserDefaultKey {
    static let nickName = "nickName"
    static let isLoggedIn = "isLoggedIn"
    static let jwtToken = "jwtToken"
}

struct Common {
    static func navigationBarTitle() -> [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.foregroundColor: Asset.Colors.black.color, NSAttributedString.Key.font: UIFont.topPageTitleFont()]
    }
}
