//
//  Alarm.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/17.
//

import Foundation

struct GetAlarm: Codable {
    var status: Int
    var data: [Alarm]
}

struct Alarm: Codable {
    var id: Int
    var archiveId: Int
    var archiveTitle: String
    var nickName: String
    var pushType: String
    var placeImage: String
    var date: String
    var isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case archiveId = "invitationId"
        case archiveTitle = "invitationTitle"
        case placeImage = "invitationImageCategory"
        case date = "createAt"
        case nickName, pushType, isRead = "read"
    }
}
