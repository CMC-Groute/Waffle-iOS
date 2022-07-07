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
    var isDecision: Bool
    var placeLike: PlaceLike
}

struct PlaceLike: Codable {
    var isPlaceLike: Bool
    var likeCnt: Int
}
