//
//  AddCategoryResponse.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/10.
//

import Foundation

struct PlaceCategory: Codable, Equatable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "placeCategoryId"
        case name = "placeCategoryName"
    }
    
    static var confirmCategory = PlaceCategory(id: -1, name: "확정")
    static var categoryList = [PlaceCategory(id: 0, name: "맛집"),
                               PlaceCategory(id: 1, name: "카페"),
                               PlaceCategory(id: 2, name: "아침"),
                               PlaceCategory(id: 3, name: "점심"),
                               PlaceCategory(id: 4, name: "저녁"),
                               PlaceCategory(id: 5, name: "소품샵"),
                               PlaceCategory(id: 6, name: "할거리"),
                               PlaceCategory(id: 7, name: "볼거리"),
                               PlaceCategory(id: 8, name: "기타")
                                ]
}

struct AddCategoryResponse: Codable {
    var status: Int
    var data: [PlaceCategory]?
}
