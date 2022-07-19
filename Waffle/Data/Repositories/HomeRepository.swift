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
    
    //MARK: 메인 카드 조회
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
    
    //MARK: 약속 조회
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
    
    //MARK: 약속 상세 조회
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
    
    //MARK: 약속 나가기
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
    
    //MARK: 카테고리 추가
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
    
    //MARK: 카테고리 삭제
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

//MARK: Place API
extension HomeRepository {
    
    //MARK: 장소 추가
    func addPlace(archiveId: Int, categoryId: Int, placeInfo: AddPlace) -> Observable<DefaultIntResponse> {
        let api = PlaceAPI.addPlace(archiveId: archiveId, categoryId: categoryId, place: placeInfo)
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
    
    //MARK: 장소 확정
    func setConfirmPlace(archiveId: Int, placeId: Int) -> Observable<DefaultIntResponse> {
        let api = PlaceAPI.setConfirmPlace(archiveId: archiveId, placeId: placeId)
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
    
    //MARK: 장소 확정 취소
    func cancelConfirmPlace(archiveId: Int, placeId: Int)  -> Observable<DefaultIntResponse> {
        let api = PlaceAPI.cancelConfirmPlace(archiveId: archiveId, placeId: placeId)
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
    
    //MARK: 확정 장소 조회
    func getConfirmPlace(archiveId: Int) -> Observable<GetPlaceByCategoryResponse> {
        let api = PlaceAPI.getConfirmPlace(archiveId: archiveId)
        return service.request(api)
            .map({ response -> GetPlaceByCategoryResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: GetPlaceByCategoryResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    //MARK: 카테고리별 장소 조회
    func getPlaceByCategory(archiveId: Int, categoryId: Int) -> Observable<GetPlaceByCategoryResponse> {
        let api = PlaceAPI.getPlaceByCategory(archiveId: archiveId, categoryId: categoryId)
        return service.request(api)
            .map({ response -> GetPlaceByCategoryResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: GetPlaceByCategoryResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    //MARK: 장소 수정
    func editPlace(archiveId: Int, placeId: Int, editPlace: EditPlace) -> Observable<DefaultIntResponse> {
        let api = PlaceAPI.editPlace(archiveId: archiveId, placeId: placeId, place: editPlace)
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
    
    //MARK: 장소 검색
    func getSearchedPlace(searchText: String, page: Int, size: Int) -> Observable<PlaceSearchResponse> {
        let searchInfo = PlaceSearchRequest(keyword: searchText, currentPage: page, pageSize: size)
        let api = PlaceAPI.placeSearch(searchInfo: searchInfo)
        return service.request(api)
            .map({ response -> PlaceSearchResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: PlaceSearchResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func getDetailPlace(archiveId: Int, placeId: Int) -> Observable<DetailPlaceResponse> {
        let api = PlaceAPI.getDetailPlace(archiveId: archiveId, placeId: placeId)
        return service.request(api)
            .map({ response -> DetailPlaceResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DetailPlaceResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    //MARK: 좋아요 누르기
    func addLike(placeId: Int) -> Observable<DefaultIntResponse> {
        let api = PlaceAPI.addLike(placeId: placeId)
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
    
    //MARK: 좋아요 취소
    func deleteLike(placeId: Int) -> Observable<DefaultIntResponse> {
        let api = PlaceAPI.deleteLike(placeId: placeId)
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
    
    //MARK: 확정 장소 순서 변경
    func changeConfirmSquence(archiveId: Int, placeSequence: GetPlaceSequence)  -> Observable<GetPlaceByCategoryResponse> {
        let api = PlaceAPI.getConfirmSequence(archiveId: archiveId, placeSequence: placeSequence)
        return service.request(api)
            .map({ response -> GetPlaceByCategoryResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: GetPlaceByCategoryResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    //MARK: 장소 삭제
    func deletePlace(archiveId: Int, placeId: Int) -> Observable<DefaultIntResponse> {
        let api = PlaceAPI.deletePlace(archiveId: archiveId, placeId: placeId)
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
    
    func likeSend(archiveId: Int) -> Observable<DefaultResponse> {
        let api = AlarmAPI.likeSend(archiveId: archiveId)
        return service.request(api)
            .map({response -> DefaultResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DefaultResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }

    
    //MARK: 알람 가져오기
    func getAlarms() -> Observable<GetAlarm> {
        let api = AlarmAPI.getAlarm
        return service.request(api)
            .map({response -> GetAlarm in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: GetAlarm.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    //MARK: 알람 읽었는지 값 변경
    func isReadAlarm(alarmId: Int, isRead: Bool) -> Observable<DefaultIntResponse> {
        let api = AlarmAPI.isReadAlarm(alarmId: alarmId, isRead: isRead)
        return service.request(api)
            .map({response -> DefaultIntResponse in
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
