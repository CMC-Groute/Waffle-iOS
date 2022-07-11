//
//  DefaultResponse.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/10.
//

import Foundation

struct DefaultResponse: Codable {
    var status: Int
    var data: String
    
    static func errorResponse(code: Int) -> DefaultResponse {
        return DefaultResponse(status: code, data: "error")
    }
}

struct DefaultIntResponse: Codable {
    var status: Int
    var data: Int
    
    static func errorResponse(code: Int) -> DefaultIntResponse {
        return DefaultIntResponse(status: code, data: 0)
    }
}
