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
    let service: URLSessionNetworkService
    var disposBag = DisposeBag()
    
    init(networkService: URLSessionNetworkService) {
        service = networkService
    }
    
    func joinArchiveCode(invitationCode: String) {
        //약속 참여하기
    }
    
    func addArchive(archive: AddArchive) -> Observable<DetaultIntResponse> {
        let api = ArchiveAPI.addArchive(archiveInfo: archive)
        return service.request(api)
            .map ({ response -> DetaultIntResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DetaultIntResponse.self) else { throw LoginSignError.decodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    
}
