//
//  ArchiveRepositoryProtocol.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/12.
//

import Foundation
import RxCocoa
import RxSwift

protocol ArchiveRepositoryProtocol {
    func joinArchiveCode(invitationCode: String) -> Observable<DefaultIntResponse>
    func addArchive(archive: AddArchive) -> Observable<DefaultIntResponse>
    func editArchive(archiveId: Int, archive: AddArchive) -> Observable<DefaultIntResponse>
}
