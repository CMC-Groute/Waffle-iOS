//
//  HomeCoordinatorProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

protocol HomeCoordinatorProtocol: Coordinator {
    func detailArchive(selectedArchive: CardInfo)
    func addDetailPlace(category: [PlaceCategory])
    
    //MARK: load BottomSheet View
    func detailArchiveBottomSheet(cardInfo: CardInfo?)
    func invitationBottomSheet(copyCode: String)
    
    //MARK: Button Click
    func addCategory(category: [PlaceCategory])
    func loadMemo(memo: String, wapple: String)
    func participants(cardInfo: CardInfo?)
    func detailPlace(detailInfo: PlaceByCategory, category: PlaceCategory, categoryInfo: [PlaceCategory])
    
    //MARK: POPUP View click
    func deleteCategory(category: PlaceCategory)
    func arhiveDelete()
    func likeSend()
    func deletePlace(placeId: Int)
    
    //MARK: Archive
    func addArchive()
    func inputCodeArchive()
    func addLocation()
    func editArchive(cardInfo: CardInfo?)
}
