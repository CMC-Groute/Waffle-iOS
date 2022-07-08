//
//  GetPlaceByCategory.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/07.
//

import Foundation

struct GetPlaceByCategoryResponse: Codable {
    var status: Int
    var data: [PlaceByCategory]
}

struct PlaceByCategory: Codable {
    var placeId: Int
    var title: String
    var roadNameAddress: String
    var isConfirm: Bool
    var placeLike: PlaceLike
    
    enum CodingKeys: String, CodingKey {
        case placeId, title, roadNameAddress, placeLike
        case isConfirm = "isDecision"
    }
}

struct PlaceLike: Codable {
    var isPlaceLike: Bool
    var likeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isPlaceLike
        case likeCount = "likeCnt"
    }
}
