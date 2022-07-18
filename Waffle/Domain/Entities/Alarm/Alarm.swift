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
    
    enum CodingKeys: String, CodingKey {
        case archiveId = "invitationId"
        case archiveTitle = "invitationTitle"
        case nickName, pushType
    }
}
