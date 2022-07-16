//
//  HomeCoordinatorProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

protocol HomeCoordinatorProtocol: Coordinator {
    //MARK: Place
    func detailArchive(archiveId: Int) // 장소 조회
    func addDetailPlace(archiveId: Int, category: [PlaceCategory]) // 장소 추가
    func deletePlace(archiveId: Int, placeId: Int) // 장소 삭제
    func editPlace(archiveId: Int, placeId: Int, category: [PlaceCategory], place: PlaceInfo, detailPlace: DetailPlaceInfo, selectedCategory: PlaceCategory) // 장소 편집
    func detailPlace(archiveId: Int, detailInfo: DetailPlaceInfo?, placeInfo: PlaceInfo, category: PlaceCategory, categoryInfo: [PlaceCategory]) // 세부 장소 조회
    
    //MARK: load BottomSheet View
    func detailArchiveBottomSheet(detailArchive: DetailArhive?, archiveId: Int)
    func invitationBottomSheet(archiveId: Int, copyCode: String)
    
    //MARK: Category
    func addCategory(archiveId: Int, category: [PlaceCategory])
    func deleteCategory(archiveId: Int, category: PlaceCategory)
    
    //MARK: Button
    func loadMemo(memo: String, wapple: String)
    func participants(detailArchive: DetailArhive?)
   
    
    //MARK: POPUP View click
    func likeSend(archiveId: Int) //좋아요 조르기 popup

    
    //MARK: Archive
    func addArchive()
    func arhiveDelete(archiveId: Int)
    func inputCodeArchive()
    func addLocation()
    func editArchive(archiveId: Int, detailArchive: DetailArhive?)
    
    func selectPlace(place: PlaceSearch)
}
