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
    case vanilla = "VANILLA"
    case strawberry = "STRAWBERRY"
    case malcha = "MALCHA"
    
    init(index: Int) {
        switch index {
        case 0: self = .wapple
        case 1: self = .choco
        case 2: self = .blueberry
        case 3: self = .vanilla
        case 4: self = .strawberry
        case 5: self = .malcha
        default: self = .wapple
        }
    }
    
    func wappleName() -> String {
        return self.rawValue
    }
    
    func wappleColor() -> CardViewInfoType {
        switch self {
            case .wapple: return .lightMelon
            case .choco: return .lightPink
            case .blueberry: return .lightMelon
            case .vanilla: return .lightPurple
            case .strawberry: return .lightMint
            case .malcha: return .yellow
        }
    }
    
    func wappleIndex() -> Int {
        switch self {
            case .vanilla: return 0
            case .choco: return 1
            case .blueberry: return 2
            case .strawberry: return 3
            case .malcha: return 4
            case .wapple: return 0
        }
    }
}

enum DefaultDetailCardInfo: String {
    case when = "토핑이 원하는 날짜와 시간"
    case `where` = "토핑이 원하는 위치"
    case archiveMemo = "약속에 대한 메모를 입력하지 않았어요"
    case noTopping = "-"
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
    
    func cardViewIndex() -> Int {
        switch self {
            case .lightPurple: return 0
            case .lightPink: return 1
            case .lightMelon: return 2
            case .lightMint: return 3
            case .yellow: return 4
        }
    }
}

