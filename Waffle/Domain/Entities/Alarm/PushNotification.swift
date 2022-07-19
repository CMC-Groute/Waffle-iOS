//
//  PushNotification.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/19.
//

import Foundation


struct PushNotification: Codable {
    var alert: PushInfo
    var archiveId: Int
    var sound: String?
    
    enum CodingKeys: String, CodingKey {
        case alert = "alert"
        case archiveId = "invitationId"
        case sound
    }
}

struct PushInfo: Codable {
    var title: String
}
