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
    
    //약속 참여하기
    func joinArchiveCode(invitationCode: String) -> Observable<DefaultIntResponse> {
        let api = ArchiveAPI.joinArchive(code: invitationCode)
        return service.request(api)
            .map ({ response -> DefaultIntResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DefaultIntResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    //약속 추가하기
    func addArchive(archive: AddArchive) -> Observable<DefaultIntResponse> {
        let api = ArchiveAPI.addArchive(archiveInfo: archive)
        return service.request(api)
            .map ({ response -> DefaultIntResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DefaultIntResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    // 약속 편집하기
    func editArchive(archiveId: Int, archive: AddArchive) -> Observable<DefaultIntResponse> {
        let api = ArchiveAPI.editArchive(archiveId: archiveId, editArchive: archive)
        return service.request(api)
            .map ({ response -> DefaultIntResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DefaultIntResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    
}
