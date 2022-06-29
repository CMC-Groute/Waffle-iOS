//
//  HomeCoordinatorProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

protocol HomeCoordinatorProtocol: Coordinator {
    func archiveFlow(cardInfo: CardInfo?)
    func editArchive(cardInfo: CardInfo?)
    func detailArchive(selectedArchive: CardInfo)
    func addDetailPlace()
    
    //MARK: load BottomSheet View
    func detailArchiveBottomSheet(cardInfo: CardInfo?)
    func invitationBottomSheet(copyCode: String)
    
    //MARK: Button Click
    func addCategory(category: [Category])
    func loadMemo(memo: String, wapple: String)
    func participants()
    func detailPlace(detailInfo: PlaceInfo, category: Category)
    
    //MARK: POPUP View click
    func deleteCategory(category: Category)
    func arhiveDelete()
    func likeSend()
    
    
}
