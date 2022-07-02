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

enum CategoryType: String {
    case FOOD, BREAKFAST, LUNCH, DINNER, PROP_SHOP
    case TODO, TO_SEE, ETC
}

enum WappleType: String, CaseIterable {
    case wapple = "WAPPLE"
    case choco = "CHOCO"
    case blueberry = "BLUEBERRY"
    case vanila = "VANILA"
    case strawberry = "STRAWBERRY"
    case malcha = "MALCHA"
}

enum DefaultDetailCardInfo: String {
    case when = "토핑이 원하는 날짜와 시간"
    case `where` = "토핑이 원하는 위치"
    case archiveMemo = "약속에 대한 메모를 입력하지 않았어요"
    case topping = "초대한 토핑이 없어요"
    case link = "장소와 관련된 링크 주소를 입력하지 않았어요"
    case placeMemo = "장소에 대한 메모를 입력하지 않았어요"
}

enum CardViewInfoType: String, CaseIterable {
    case lightPurple, lightPink, lightMelon, lightMint, yellow
    
    init(index: Int) {
        switch index {
        case 0: self = .lightPurple
        case 1: self = .lightPink
        case 2: self = .lightMelon
        case 3: self = .lightMint
        case 4: self = .yellow
        default: self = .lightPurple
        }
    }
    
    func colorName() -> String {
        return self.rawValue
    }
}

