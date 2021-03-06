//
//  Login.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/30.
//

import Foundation

//MARK: Login Request
struct Login: Codable {
    var email: String
    var password: String
    var deviceToken: String
}

//MARK: Login Response
struct LoginResponse: Codable {
    var status: Int
    var data: UserInfo?
}

struct UserInfo: Codable {
    var id: Int
    var token: String
    var roles: String
}
