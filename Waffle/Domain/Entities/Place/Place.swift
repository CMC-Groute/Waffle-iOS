//
//  Place.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import Foundation

struct GetPlaceResponse: Codable {
    var message: String
    var data: [PlaceByCategory]
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
    var longitude: Double?
    var latitude: Double?
    var categoryId: Int
    
    enum CodingKeys: String, CodingKey {
        case title, link, roadNameAddress, longitude, latitude
        case memo = "comment"
        case categoryId = "placeCategoryId"
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

