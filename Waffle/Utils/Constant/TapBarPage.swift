//
//  TapBarPage.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation

enum TabBarPage: String {
    case map, home, setting
    
    init?(index: Int) {
        switch index {
        case 0: self = .map
        case 1: self = .home
        case 2: self = .setting
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .map: return 0
        case .home: return 1
        case .setting: return 2
        }
    }
    
    func tabIconName() -> String {
        return self.rawValue
    }
}
