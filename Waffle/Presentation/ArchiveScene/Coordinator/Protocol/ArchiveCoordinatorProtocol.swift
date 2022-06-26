//
//  ArchiveCoordinatorProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

protocol ArchiveCoordinatorProtocol: Coordinator {
    func addArchive(isEditing: Bool, cardInfo: CardInfo?)
    func inputCodeArchive()
    func addLocation()
}
