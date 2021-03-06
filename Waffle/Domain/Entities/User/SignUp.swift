//
//  SignUp.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/27.
//

import Foundation

struct SignUp: Codable {
    var email: String
    var password: String
    var nickname: String
    var profileImage: String
    var isAgreedMarketing: Bool
}

