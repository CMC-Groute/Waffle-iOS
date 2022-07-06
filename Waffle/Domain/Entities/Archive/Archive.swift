//
//  Archive.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation

//MARK: 약속 만들기
struct ArchiveInfo: Codable {
    var title: String
    var date: String?
    var time: String?
    var memo: String?
    var location: String?
    
    enum CodingKeys: String, CodingKey {
        case title, date, time
        case memo = "comment"
        case location = "invitationPlace"
    }
}

//MARK: 약속
struct DetailArhive: Codable {
    var title: String
    var date: String?
    var memo: String?
    var wappleId: Int
    var member: [Participants]?
    var category: [PlaceCategory]?
    var decidedPlace: [DecidedPlace]?
    
    enum CodingKeys: String, CodingKey {
        case title, date, wappleId
        case memo = "comment"
        case member = "invitationMemberDto"
        case category = "placeCategoryDto"
        case decidedPlace = "decidedPlaceDetailResponses"
    }
}

struct Participants: Codable {
    var userId: Int
    var nickName: String
}

struct GetCardResponse: Codable {
    var message: String
    var data: [CardInfo]?
    
    static func errorResponse(message: String, data:[CardInfo]? = nil) -> GetCardResponse {
        return GetCardResponse(message: message, data: data)
    }
}

struct CardInfo: Codable {
    var id: Int
    var title: String
    var date: String?
    var place: String?
    var memo: String?
    var wappleId: Int
    var topping: [ToppingInfo]
    var cardType: String
    
    enum CodingKeys: String, CodingKey {
        case id = "invitationId"
        case title, date
        case place = "invitationPlace"
        case memo = "comment"
        case wappleId = "waffleId"
        case topping = "invitationMemberDto"
        case cardType = "invitationImageCategory"
    }
}

struct ToppingInfo: Codable {
    var userId: Int
    var nickName: String
    var profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case nickName = "nickname"
        case userId, profileImage
    }
}

struct ArhiveInfo: Codable {
    var title: String
    var date: String
    var memo: String
    var location: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case memo = "comment"
        case location = "invitationPlace"
    }
}

struct AddCategory: Codable {
    var category: [String]
    
    enum CodingKeys: String, CodingKey {
        case category = "placeCategories"
    }
}

struct GetCategory: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "placeCategoryId"
        case name
    }
}

struct PlaceCategory: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "placeCategoryId"
        case name = "placeCategoryName"
    }
}

struct DecidedPlace: Codable {
    var title: String
    var seq: Int // 순서
}
