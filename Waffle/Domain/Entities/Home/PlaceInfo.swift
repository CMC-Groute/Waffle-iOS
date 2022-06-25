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

struct Category: Codable {
    var name: String
    var index: Int
    var selected: Bool = false
    
    static var categoryList = [Category(name: "맛집", index: 0),
                               Category(name: "카페", index: 1),
                               Category(name: "아침", index: 2),
                               Category(name: "점심", index: 3),
                               Category(name: "저녁", index: 4),
                               Category(name: "소품샵", index: 5),
                               Category(name: "할거리", index: 6),
                               Category(name: "볼거리", index: 7),
                               Category(name: "기타", index: 8)]
}
