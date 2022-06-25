//
//  PlaceInfo.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/25.
//

import Foundation

struct PlaceInfo: Codable {
    var title: String
    var place: String
    var isDesive: Bool
    var category: Category
    var likeCount: Int
}
