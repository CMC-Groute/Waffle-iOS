//
//  AlarmAPI.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/19.
//

import Foundation

enum AlarmAPI: NetworkRequestBuilder {
    case likeSend(archiveId: Int)
    case getAlarm
    case isReadAlarm(alarmId: Int, isRead: Bool)
}

extension AlarmAPI {
    var baseURL: URL? {
        return URL(string: Config.baseURL)
    }
    
    var path: String? {
        switch self {
        case .likeSend(let archiveId):
            return "/invitation/\(archiveId)/push/likes"
        case .getAlarm:
            return "/push"
        case .isReadAlarm(let alarmId):
            return "/push/\(alarmId)"
        }
    }
    
    var parameters: [String : String]? {
        return nil
    }
    
    var method: HttpMethod {
        switch self {
        case .likeSend(_):
            return .post
        case .getAlarm:
            return .get
        case .isReadAlarm(_, _):
            return .patch
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .likeSend(_), .getAlarm, .isReadAlarm(_, _):
            return nil
        }
    }
    
    var headers: [String : String]? {
        let defaultHeader = ["Content-Type" : "application/json"]
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else { return defaultHeader }
        return ["token": jwtToken, "Content-Type" : "application/json"]
    }
}
