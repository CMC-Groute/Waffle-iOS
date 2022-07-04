//
//  Common.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/04.
//

import Foundation

struct DefaultResponse: Codable {
    var message: String
    var data: String
}

struct SignUpResponse: Codable {
    var message: String
    var data: Int
}
