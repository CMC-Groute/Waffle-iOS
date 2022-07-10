//
//  HomeRepository.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation
import RxSwift

class HomeRepository: HomeRepositoryProtocol {
    let service: URLSessionNetworkService
    var disposBag = DisposeBag()
    
    init(networkService: URLSessionNetworkService) {
        self.service = networkService
    }
    
    func getCardInfo() -> Observable<GetCardResponse> {
        let api = ArchiveAPI.getArchiveCard
        return service.request(api)
            .map ({ response -> GetCardResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: GetCardResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    WappleLog.debug("data \(data.data)")
                    return data
                case .failure(let error):
                    throw error
                }
            })
        }
    
    //약속 조회
    func getArchiveCode(id: Int) -> Observable<GetArchiveCode> {
        let api = ArchiveAPI.getArchiveCode(archiveId: id)
        return service.request(api)
            .map ({ response -> GetArchiveCode in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: GetArchiveCode.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    //약속 상세 조회
    func getDetailArchiveInfo(id: Int) -> Observable<GetDetailArchive> {
        let api = ArchiveAPI.getArchiveDetail(archiveId: id)
        return service.request(api)
            .map ({ response -> GetDetailArchive in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: GetDetailArchive.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func deleteArchive(archiveId: Int) -> Observable<DefaultIntResponse> {
        let api = ArchiveAPI.deleteArchive(archiveId: archiveId)
        return service.request(api)
            .map ({  response -> DefaultIntResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DefaultIntResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    //카테고리 추가
    func addCategory(archiveId: Int, categoryName: [String]) -> Observable<AddCategoryResponse> {
        let api = PlaceAPI.addPlaceCategory(archiveId: archiveId, placeCategory: categoryName)
        return service.request(api)
            .map ({  response -> AddCategoryResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: AddCategoryResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    //카테고리 삭제
    func deleteCategory(archiveId: Int, categoryId: Int) -> Observable<DefaultIntResponse> {
        let api = PlaceAPI.deletePlacCategory(archiveId: archiveId, categoryId: categoryId)
        return service.request(api)
            .map({ response -> DefaultIntResponse in
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
