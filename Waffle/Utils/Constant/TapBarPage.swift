//
//  TapBarPage.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation

enum TabBarPage: String, CaseIterable {
    case home, map, setting, archive
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .map
        case 2: self = .setting
        case 3: self = .archive
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .map: return 1
        case .setting: return 2
        case .archive: return 3
        }
    }
    
    func tabIconName() -> String {
        return self.rawValue
    }
}
