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
    var archiveId: Int
    var archiveTitle: String
    var nickName: String
    var pushType: String
    var placeImage: String
    var isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case archiveId = "invitationId"
        case archiveTitle = "invitationTitle"
        case placeImage = "invitationImageCategory"
        case nickName, pushType, isRead = "read"
    }
}
