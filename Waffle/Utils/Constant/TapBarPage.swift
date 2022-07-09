//
//  TapBarPage.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation

enum TabBarPage: String, CaseIterable {
    case home, setting , archive //map
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .setting
        case 2: self = .archive
        //case 3: self = .archive
        default: self = .archive
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .setting: return 1
        case .archive: return 2
        //case .map: return 3
        }
    }
    
    func tabIconName() -> String {
        return self.rawValue
    }
}
