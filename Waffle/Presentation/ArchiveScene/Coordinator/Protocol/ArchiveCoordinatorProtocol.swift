//
//  ArchiveCoordinatorProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

protocol ArchiveCoordinatorProtocol: Coordinator {
    func addArchive()
    func inputCodeArchive()
    func addLocation()
    func editArchive(cardInfo: CardInfo?)
}
