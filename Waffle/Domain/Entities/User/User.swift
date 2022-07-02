//
//  User.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/27.
//

import Foundation

struct EditProfile: Codable {
    var nickName: String
    var progileImage: Data
}

struct Password: Codable {
    var nowPassword: String
    var newPassword: String
}
