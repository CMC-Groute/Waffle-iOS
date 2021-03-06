//
//  Archive.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation

//MARK: 약속 만들기, 약속 편집
struct AddArchive: Codable {
    var title: String
    var date: String? = nil
    var time: String? = nil
    var memo: String? = nil
    var location: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case title, date, time
        case memo = "comment"
        case location = "invitationPlace"
    }
}

//MARK: 약속 상세
struct GetDetailArchive: Codable {
    var status: Int
    var data: DetailArhive?
}

struct DetailArhive: Codable {
    var title: String
    var date: String?
    var time: String?
    var memo: String?
    var wappleId: Int
    var place: String?
    var placeImage: String
    var member: [Participants]
    var category: [PlaceCategory]?
    var placeInfo: [PlaceInfo]
    
    enum CodingKeys: String, CodingKey {
        case memo = "comment"
        case title, date, wappleId = "waffleId", time
        case place = "invitationPlace"
        case placeImage = "invitationImageCategory"
        case member = "invitationMemberDto"
        case category = "placeCategoryDto"
        case placeInfo = "decidedPlaceDetailResponses"
    }
}

struct Participants: Codable {
    var userId: Int
    var nickName: String
    var profileImage: String

    enum CodingKeys: String, CodingKey {
        case userId
        case nickName = "nickname"
        case profileImage
    }
}

struct GetCardResponse: Codable {
    var status: Int
    var data: [CardInfo]?
    
    static func errorResponse(status: Int, data:[CardInfo]? = nil) -> GetCardResponse {
        return GetCardResponse(status: status, data: data)
    }
}

//MARK: get code
struct GetArchiveCode: Codable {
    var status: Int
    var data: DataGetArchiveCode?
}

struct DataGetArchiveCode: Codable {
    var code: String
}


struct CardInfo: Codable {
    var id: Int
    var title: String
    var date: String?
    var time: String?
    var place: String?
    var memo: String?
    var wappleId: Int
    var topping: [ToppingInfo]
    var cardType: String
    
    enum CodingKeys: String, CodingKey {
        case id = "invitationId"
        case title, date, time
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
