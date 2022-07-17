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
    var editArchiveSuccess = PublishRelay<Bool>()
    var joinArhicveSuccess = PublishRelay<(JoinArchiveStatus, Int?)>() // 상태, archiveId
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
    
    //MARK: 약속 생성하기
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
    
    //MARK: 약속 편집하기
    func editArchive(archiveId: Int, archive: AddArchive) {
        return repository.editArchive(archiveId: archiveId, archive: archive)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("editArchive \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                WappleLog.debug("editArchive \(response)")
                if response.status == 200 {
                    self.editArchiveSuccess.accept(true)
                }else {
                    self.editArchiveSuccess.accept(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func addArchiveId(archiveId: Int) { // 약속 코드로 참여시 add 해주기
        guard var archiveIdList = UserDefaults.standard.array(forKey: UserDefaultKey.joinArchiveId) as? [Int] else { return }
        archiveIdList.append(archiveId)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: 약속 코드로 가입
    func joinArchive(code: String) {
        return repository.joinArchiveCode(invitationCode: code)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("joinArchive \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                WappleLog.debug("joinArchive \(response)")
                if response.status == 400 { // 이미 참여
                    self.joinArhicveSuccess.accept((.already, response.data))
                }else if response.status == 404 {
                    self.joinArhicveSuccess.accept((.inValid, response.data))
                }else {
                    self.addArchiveId(archiveId: response.data)
                    self.joinArhicveSuccess.accept((.success, response.data))
                }
            }).disposed(by: disposeBag)
    }
    
}
