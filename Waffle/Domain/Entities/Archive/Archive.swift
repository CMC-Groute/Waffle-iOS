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

struct CardInfo: Hashable, Identifiable, Codable {
    var title: String
    var date: String?
    var place: String?
    var memo: String?
    var wapple: String
    var topping: [String]
    var color: Int
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case title, date, wapple, topping, color, id
        case memo = "comment"
        case place = "invitationPlace"
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
