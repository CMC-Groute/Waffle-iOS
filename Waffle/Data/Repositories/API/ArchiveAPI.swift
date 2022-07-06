//
//  ArchiveAPI.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/05.
//

import Foundation

enum ArchiveAPI: NetworkRequestBuilder {
    case addArchive(archiveInfo: AddArchive)
    case joinArchive(code: String)
    case getArchiveCode(archiveId: Int)
    case getArchiveCard
    case getArchiveDetail(archiveId: Int)
    case deleteArchive(archiveId: Int)
}

extension ArchiveAPI {
    var baseURL: URL? {
        return URL(string: Config.baseURL)
    }
    
    var path: String? {
        switch self {
        case .addArchive(_), .getArchiveCard:
            return "/invitations"
        case .joinArchive(_):
            return "/invitations/code"
        case .getArchiveCode(let id):
            return "/invitations/\(id)/code"
        case .getArchiveDetail(let id):
            return "/invitations/\(id)"
        case .deleteArchive(let id):
            return "/invitations/\(id)/invitationMember"
        }
    }
    
    var parameters: [String : String]? {
        return nil
    }
    
    var method: HttpMethod {
        switch self {
        case .getArchiveCard, .getArchiveDetail(_), .getArchiveCode(_):
            return .get
        case .joinArchive(_), .addArchive(_):
            return .post
        case .deleteArchive(_):
            return .delete
        }
    }
    
    var headers: [String : String]? {
        let defaultHeader = ["Content-Type" : "application/json"]
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else { return defaultHeader }
        return ["token": jwtToken, "Content-Type" : "application/json"]
    }
    
    var body: [String : Any]? {
        switch self {
            case .getArchiveCard, .getArchiveCode(_), .getArchiveDetail(_), .deleteArchive(_):
                return nil
            case .joinArchive(let code):
                return code.dictionary
            case .addArchive(let archive):
                return archive.dictionary
            }
    }
    
}
