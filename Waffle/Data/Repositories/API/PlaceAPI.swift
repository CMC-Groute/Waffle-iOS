//
//  PlaceAPI.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/07.
//

import Foundation

enum PlaceAPI: NetworkRequestBuilder {
    case addPlace(archiveId: Int, categoryId: Int, place: AddPlace)
    case setConfirmPlace(archiveId: Int, placeId: Int)
    case cancelConfirmPlace(archiveId: Int, placeId: Int)
    case getConfirmPlace(archiveId: Int)
    case getConfirmSequence(archiveId: Int, placeSequence: GetPlaceSequence)
    case getPlaceByCategory(archiveId: Int, categoryId: Int)
    case getDetailPlace(archiveId: Int, placeId: Int)
    case editPlace(archiveId: Int, placeId: Int, place: AddPlace)
    case placeSearch
    case deletePlace(archiveId: Int, placeId: Int)
}

extension PlaceAPI {
    var baseURL: URL? {
        return URL(string: Config.baseURL)
    }
    
    var path: String? {
        switch self {
        case .addPlace(let archiveId, let categoryId, _):
            return "/invitations/\(archiveId)/placeCategory/\(categoryId)/place"
        case .setConfirmPlace(let archiveId, let placeId):
            return "/invitations/\(archiveId)/place/\(placeId)/decide"
        case .cancelConfirmPlace(let archiveId, let placeId):
            return "/invitations/\(archiveId)/place/\(placeId)"
        case .getConfirmPlace(let archiveId):
            return "/invitations/\(archiveId)/place"
        case .getConfirmSequence(let archiveId, _):
            return "/invitations/\(archiveId)"
        case .getPlaceByCategory(let archiveId, let categoryId):
            return "invitations/\(archiveId)/placeCategory/\(categoryId)/place"
        case .getDetailPlace(let archiveId, let placeId):
            return "/invitations/\(archiveId)/place/\(placeId)"
        case .editPlace(let archiveId, let placeId, _):
            return "/invitations/\(archiveId)/place/\(placeId)"
        case .placeSearch:
            return "/place/search"
        case .deletePlace(let archiveId, let placeId):
            return "/invitations/\(archiveId)/place/\(placeId)"
        }
    }
    
    var parameters: [String : String]? {
        return nil
    }
    
    var method: HttpMethod {
        switch self {
        case .addPlace(_, _, _):
            return .post
        case .setConfirmPlace(_, _), .cancelConfirmPlace(_, _), .getConfirmSequence(_, _), .editPlace(_, _, _):
            return .put
        case .getConfirmPlace(_), .getPlaceByCategory(_, _), .getDetailPlace(_, _), .placeSearch:
            return .get
        case .deletePlace(_, _):
            return .delete
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getConfirmPlace(_),  .getPlaceByCategory(_, _), .getDetailPlace(_, _), .placeSearch, .deletePlace(_, _), .setConfirmPlace(_, _), .cancelConfirmPlace(_, _):
            return nil
        case .addPlace(_, _, let place):
            return place.dictionary
        case .getConfirmSequence(_, let placeSequence):
            return placeSequence.dictionary
        case .editPlace(_, _, let place):
            return place.dictionary
        }
    }
    
    var headers: [String : String]? {
        let defaultHeader = ["Content-Type" : "application/json"]
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else { return defaultHeader }
        return ["token": jwtToken, "Content-Type" : "application/json"]
    }
}
