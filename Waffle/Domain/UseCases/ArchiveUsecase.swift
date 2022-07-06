//
//  ArchiveUsecase.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift
import RxCocoa

class ArchiveUsecase: ArchiveUsecaseProtocol {
   
    var repository: ArchiveRepository!
    var disposeBag = DisposeBag()
    var addArchiveSuccess = PublishRelay<Bool>()
    
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
    
    func checkCodeValid(code: String) -> Bool {
        return repository.checkCodeValid(code: code)
            
    }
    
    func addArchive(archive: AddArchive) {
        return repository.addArchive(archive: archive)
            .catch { error -> Observable<DetaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("addArchive \(error)")
                return .just(DetaultIntResponse.errorResponse(code: error.rawValue))
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
    
}
