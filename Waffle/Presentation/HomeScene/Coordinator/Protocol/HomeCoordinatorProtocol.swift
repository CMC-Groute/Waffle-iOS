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
    
    //MARK: load BottomSheet View
    func detailArchiveBottomSheet(cardInfo: CardInfo?)
    func invitationBottomSheet(copyCode: String)
    
    //MARK: Button Click
    func category()
    func loadMemo()
    func participants()
    func detailPlace(detailInfo: PlaceInfo, category: Category)
    
    //MARK: POPUP View click
    func deleteCategory()
    func arhiveDelete()
    func likeSend()
    
    
}
