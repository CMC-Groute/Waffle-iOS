//
//  Common.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/30.
//

import UIKit

struct Common {
    static func navigationBarTitle() -> [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.foregroundColor: Asset.Colors.black.color, NSAttributedString.Key.font: UIFont.topPageTitleFont()]
    }
}

enum CoordinatorType {
    case app, login, signUp, tab, home, map, setting, archive
}

