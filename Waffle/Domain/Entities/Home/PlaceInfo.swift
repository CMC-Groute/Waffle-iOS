//
//  PlaceInfo.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/25.
//

import Foundation

struct PlaceInfo: Codable {
    var placeId: Int
    var title: String
    var place: String
    var isConfirm: Bool
    var category: Category
    var likeCount: Int
    var likeSelected: Bool
    var memo: String
    
    static let dummyPlace = [PlaceInfo(placeId: 0, title: "이성당0", place: "대구 수성구", isConfirm: true, category: Category(name: "확정", index: -1), likeCount: 4, likeSelected: false, memo: "이성당 빵집 가서 꼭 야채빵 사기"), PlaceInfo(placeId: 0, title: "토이스토리", place: "서울 송파구", isConfirm: false, category: Category(name: "확정", index: -1), likeCount: 10, likeSelected: true, memo: "이성당 빵집 가서 꼭 야채빵 사기"), PlaceInfo(placeId: 0, title: "이성당2", place: "대구 수성구", isConfirm: true, category:  Category(name: "아침", index: 2), likeCount: 4, likeSelected: false, memo: "이성당 빵집 가서 꼭 야채빵 사기"), PlaceInfo(placeId: 0, title: "이성당2", place: "대구 수성구", isConfirm: true, category: Category(name: "할거리", index: 6), likeCount: 2, likeSelected: true, memo: "이성당 빵집 가서 꼭 야채빵 사기"), ]
}

struct Category: Codable {
    var name: String
    var index: Int
    var selected: Bool = false
    static var defaultList = Category(name: "확정", index: -1)
    static var dummyList = [Category(name: "아침", index: 2), Category(name: "할거리", index: 6)]
    static var categoryList = [Category(name: "맛집", index: 0),
                               Category(name: "카페", index: 1),
                               Category(name: "아침", index: 2),
                               Category(name: "점심", index: 3),
                               Category(name: "저녁", index: 4),
                               Category(name: "소품샵", index: 5),
                               Category(name: "할거리", index: 6),
                               Category(name: "볼거리", index: 7),
                               Category(name: "기타", index: 8)]
}
