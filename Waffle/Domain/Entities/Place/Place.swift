//
//  Place.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import Foundation

//MARK: 디테일 -> 장소 조회
struct GetPlaceResponse: Codable {
    var status: Int
    var data: [PlaceInfo]?
}

struct PlaceInfo: Codable {
    var placeId: Int
    var title: String
    var seq: Int?
    var roadNameAddress: String?
    var isConfirm: Bool
    var placeLike: PlaceLike
    
    enum CodingKeys: String, CodingKey {
        case placeId, title, seq
        case roadNameAddress, placeLike = "placeLikesDto"
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

//MARK: 카테고리별 장소 조회
struct GetPlaceByCategoryResponse: Codable {
    var status: Int
    var data: [PlaceInfo]?
}

struct PlaceSearchRequest: Codable {
    var keyword: String
    var currentPage: Int
    var pageSize: Int
}

struct PlaceSearchResponse: Codable {
    var address: String
    var categoryGroupCode: String
    var categoryGroupName: String
    var distance: Double
    var id: String
    var phone: String
    var placeName: String
    var placeUrl: String
    var roadAddressName: String
    var longitude: Double
    var latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeUrl = "place_url"
        case roadAddressName = "road_address_name"
        case longitude = "x"
        case latitude = "y"
        
    }
}

//MARK: 장소 추가
struct AddPlace: Codable {
    var title: String
    var memo: String?
    var link: String?
    var roadNameAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case title, link, roadNameAddress
        case memo = "comment"
    }
}

//MARK: 장소 순서 조회
struct GetPlaceSequence: Codable {
    var placeSequences: [PlaceSequence]
}

struct PlaceSequence: Codable {
    var placeId: Int
    var seq: Int
}

