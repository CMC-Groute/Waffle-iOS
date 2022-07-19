//
//  HomeUsecaseProtocol.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation

protocol HomeUsecaseProtocol {
    func getCardInfo()
    func deletePlace(archiveId: Int, placeId: Int)
    func getDetailArchiveInfo(archiveId: Int)
    func editPlace(archiveId: Int, placeId: Int, editPlace: EditPlace)
    func addPlace(archiveId: Int, categoryId: Int, addPlace: AddPlace)
    //MARK: Archive
    func deleteArchive(archiveId: Int)
}
