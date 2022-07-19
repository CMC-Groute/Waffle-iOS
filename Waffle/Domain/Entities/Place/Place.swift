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
    var longitude: String?
    var latitude: String?
    
    enum CodingKeys: String, CodingKey {
        case placeId, title, seq
        case roadNameAddress, placeLike = "placeLikesDto"
        case isConfirm = "isDecision"
        case longitude, latitude
    }
}

struct DetailPlaceResponse: Codable {
    var status: Int
    var data: DetailPlaceInfo?
}

struct DetailPlaceInfo: Codable {
    var link: String?
    var memo: String?
    var category: PlaceCategory
    
    enum CodingKeys: String, CodingKey {
        case link, memo = "comment"
        case category = "placeCategoryDto"
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

//MARK: 장소 검색
struct PlaceSearchRequest: Codable {
    var keyword: String
    var currentPage: Int
    var pageSize: Int
}

struct PlaceSearchResponse: Codable {
    var documents: [PlaceSearch]
    var meta: PlaceSearchMeta?
}

struct PlaceSearch: Codable {
    var address: String
    var categoryGroupCode: String
    var categoryGroupName: String
    var categoryName: String
    var distance: String
    var id: String
    var phone: String
    var placeName: String
    var placeUrl: String
    var roadAddressName: String
    var longitude: String
    var latitude: String
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeUrl = "place_url"
        case roadAddressName = "road_address_name"
        case longitude = "x"
        case latitude = "y"
        
    }
}

struct PlaceSearchMeta: Codable {
    var isEnd: Bool
    var pageableCount: Int
    var sameName: PlaceSearchSameName
    var totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case sameName = "same_name"
        case totalCount = "total_count"
    }
}

struct PlaceSearchSameName: Codable {
    var keyword: String
    var region: [String]
    var selectedRegion: String
    
    enum CodingKeys: String, CodingKey {
        case keyword, region
        case selectedRegion = "selected_region"
    }
}

//MARK: 장소 추가
struct AddPlace: Codable {
    var title: String
    var memo: String?
    var link: String?
    var roadNameAddress: String
    var longitude: String
    var latitude: String
    
    
    enum CodingKeys: String, CodingKey {
        case title, link, roadNameAddress
        case longitude, latitude
        case memo = "comment"
    }
}

//MARK: 장소 수정
struct EditPlace: Codable {
    var title: String
    var memo: String?
    var link: String?
    var roadNameAddress: String
    var longitude: String?
    var latitude: String?
    var placeCategoryId: Int
    
    enum CodingKeys: String, CodingKey {
        case title, link, roadNameAddress
        case longitude, latitude, placeCategoryId
        case memo = "comment"
    }
}

//MARK: 장소 순서 조회
struct GetPlaceSequence: Codable {
    var placeSequences: [PlaceSequence]
    
    enum CodingKeys: String, CodingKey {
        case placeSequences = "placeSeqDtos"
    }
}

struct PlaceSequence: Codable {
    var placeId: Int
    var seq: Int
}

