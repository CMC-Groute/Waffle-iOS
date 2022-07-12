//
//  HomeCoordinatorProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

protocol HomeCoordinatorProtocol: Coordinator {
    func detailArchive(archiveId: Int)
    func addDetailPlace(category: [PlaceCategory])
    
    //MARK: load BottomSheet View
    func detailArchiveBottomSheet(detailArchive: DetailArhive?, archiveId: Int)
    func invitationBottomSheet(copyCode: String)
    
    //MARK: Button Click
    func addCategory(archiveId: Int, category: [PlaceCategory])
    func loadMemo(memo: String, wapple: String)
    func participants(detailArchive: DetailArhive?)
    func detailPlace(detailInfo: PlaceInfo, category: PlaceCategory, categoryInfo: [PlaceCategory])
    
    //MARK: POPUP View click
    func deleteCategory(archiveId: Int, category: PlaceCategory)
    func arhiveDelete(archiveId: Int)
    func likeSend()
    func deletePlace(placeId: Int)
    
    //MARK: Archive
    func addArchive()
    func inputCodeArchive()
    func addLocation()
    func editArchive(detailArchive: DetailArhive?)
}
