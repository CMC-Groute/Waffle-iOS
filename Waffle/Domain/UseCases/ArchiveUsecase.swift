//
//  ArchiveUsecase.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift
import RxCocoa

enum JoinArchiveStatus {
    case success
    case inValid
    case already
}

class ArchiveUsecase: ArchiveUsecaseProtocol {
   
    var repository: ArchiveRepository!
    var disposeBag = DisposeBag()

    var addArchiveSuccess = PublishRelay<Bool>()
    var joinArhicveSuccess = PublishRelay<JoinArchiveStatus>()
    var code: String?
    
    init(repository: ArchiveRepository){
        self.repository = repository
    }
    
    func maximumTextLength(length: Int, s: String) -> String {
        if s.count > length {
            let index = s.index(s.startIndex, offsetBy: length)
            return String(s[..<index])
        }
        return s
    }
    
    func addArchive(archive: AddArchive) {
        return repository.addArchive(archive: archive)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("addArchive \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                WappleLog.debug("addArchive \(response)")
                if response.status == 200 {
                    self.addArchiveSuccess.accept(true)
                }else {
                    self.addArchiveSuccess.accept(false)
                }
            }).disposed(by: disposeBag)
    }
    
    // 약속 편집하기
    func editArchive(archiveId: Int, archive: AddArchive) {
        
    }
    
    func joinArchive(code: String) {
        return repository.joinArchiveCode(invitationCode: code)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("joinArchive \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                WappleLog.debug("joinArchive \(response)")
                if response.status == 400 { // 이미 가입
                    self.joinArhicveSuccess.accept(.already)
                }else if response.status == 404 {
                    self.joinArhicveSuccess.accept(.inValid)
                }else {
                    self.joinArhicveSuccess.accept(.success)
                }
            }).disposed(by: disposeBag)
    }
    
}
