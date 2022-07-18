//
//  User.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/27.
//

import Foundation

struct UserInfoResponse: Codable {
    var status: Int
    var data: GetUserInfo
}

struct GetUserInfo: Codable {
    var nickName: String
    var email: String
    var profileImage: String
    var isAgreedAlarm: Bool
    
    enum CodingKeys: String, CodingKey {
        case nickName = "nickname"
        case email, profileImage
        case isAgreedAlarm
    }
}

struct Password: Codable {
    var nowPassword: String
    var newPassword: String
}
