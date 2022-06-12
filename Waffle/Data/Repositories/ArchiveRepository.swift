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
    private var cancellables = Set<AnyCancellable>()
    var disposBag = DisposeBag()
    
    init(networkService: URLSessionNetworkServiceProtocol) {
        self.urlSessionNetworkService = networkService
    }
}
