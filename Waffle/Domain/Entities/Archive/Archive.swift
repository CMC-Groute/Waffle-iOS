//
//  Archive.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation

struct CardInfo: Hashable, Identifiable, Codable {
    var title: String
    var date: String
    var place: String
    var memo: String
    var waffle: String
    var topping: [String]
    var color: Int
    var id = UUID()
}
