//
//  ArchiveRepository.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift
import RxCocoa

class ArchiveRepository: ArchiveRepositoryProtocol {
    let urlSessionNetworkService: URLSessionNetworkServiceProtocol
    var disposBag = DisposeBag()
    
    init(networkService: URLSessionNetworkServiceProtocol) {
        self.urlSessionNetworkService = networkService
    }
    
    func checkCodeValid(code: String) -> Bool {
        //self.urlSessionNetworkService.request()
        return false
    }
    
    func joinArchiveCode(invitationCode: String) {
        //약속 참여하기
    }
    
    
}
