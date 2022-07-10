//
//  ArchiveRepositoryProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxCocoa
import RxSwift

protocol ArchiveRepositoryProtocol {
    func joinArchiveCode(invitationCode: String) -> Observable<DefaultIntResponse>
    func addArchive(archive: AddArchive) -> Observable<DefaultIntResponse>
}
