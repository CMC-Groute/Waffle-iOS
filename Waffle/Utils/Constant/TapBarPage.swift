//
//  TapBarPage.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/06.
//

import Foundation

enum TabBarPage: String, CaseIterable {
    case home, archive, setting //map
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .archive
        case 2: self = .setting
        //case 3: self = .archive
        default: self = .archive
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .archive: return 1
        case .setting: return 2
        //case .map: return 3
        }
    }
    
    func tabIconName() -> String {
        return self.rawValue
    }
}
