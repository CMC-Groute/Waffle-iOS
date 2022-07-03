//
//  Place.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import Foundation

struct PlaceSearchInfo: Codable {
    var address: String
    var categoryGroupCode: String
    var categoryGroupName: String
    var distance: Double
    var id: String
    var phone: String
    var placeName: String
    var placeUrl: String
    var roadAddressName: String
    var longitude: Double
    var latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeUrl = "place_url"
        case roadAddressName = "road_address_name"
        case longitude = "x"
        case latitude = "y"
        
    }

}
