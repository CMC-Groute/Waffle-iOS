//
//  HomeCoordinatorProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

protocol HomeCoordinatorProtocol: Coordinator {
    func archiveFlow()
    func editArchive()
    func detailArchive()
    
    //MARK: POPUP View
    func deleteCategory()
    func arhiveDelete()
    func likeSend()
}
