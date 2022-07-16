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
    case app, login, signUp, tab, home, setting, archive //map
}

enum WappleType: String, CaseIterable {
    case wapple = "WAFFLE"
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
    
    func wappleLink() -> String {
        switch self {
        case .blueberry:
            return "https://wapple2.s3.ap-northeast-2.amazonaws.com/blueberry.png"
        case .choco:
            return "https://wapple2.s3.ap-northeast-2.amazonaws.com/choco.png"
        case .malcha:
            return "https://wapple2.s3.ap-northeast-2.amazonaws.com/Malcha.png"
        case .strawberry:
            return "https://wapple2.s3.ap-northeast-2.amazonaws.com/Strawberry.png"
        case .vanilla:
            return "https://wapple2.s3.ap-northeast-2.amazonaws.com/VANILLA.png"
        case .wapple:
            return ""
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



enum CategoryType: String, CaseIterable {
    case CAFE = "CAFE"
    case FOOD = "FOOD"
    case BREAKFAST = "BREAKFAST"
    case LUNCH = "LUNCH"
    case DINNER = "DINNER"
    case PROP_SHOP = "PROP_SHOP"
    case TODO = "TODO"
    case TO_SEE = "TO_SEE"
    case ETC = "ETC"
    
    func format() -> String {
        switch self {
            case .CAFE: return "카페"
            case .FOOD: return "맛집"
            case .BREAKFAST: return "아침"
            case .LUNCH: return "점심"
            case .DINNER: return "저녁"
            case .PROP_SHOP: return "소품샵"
            case .TODO: return "할거리"
            case .TO_SEE: return "볼거리"
            case .ETC: return "기타"
        }
    }
}

struct SendCategory {
    static var dictionary: [String: String] = ["카페" : "CAFE",
                                                "맛집" : "FOOD",
                                                "아침" : "BREAKFAST",
                                                "점심" : "LUNCH",
                                                "저녁" : "DINNER",
                                                "소품샵" : "PROP_SHOP",
                                                "할거리" : "TODO",
                                                "볼거리" : "TO_SEE",
                                                "기타" : "ETC"]
}




