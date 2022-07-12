//
//  HomeUseCase.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation
import RxSwift

class HomeUsecase: HomeUsecaseProtocol {
    //MARK: Private property
    private var repository: HomeRepository!
    private var disposeBag = DisposeBag()
    
    //MARK: Response Subject
    var cardInfo = PublishSubject<[CardInfo]?>()
    var detailArchive = PublishSubject<DetailArhive?>()
    var deleteSuccess = PublishSubject<Bool>()
    var archiveCode = PublishSubject<String?>()
    var addCategory = PublishSubject<[PlaceCategory]?>()
    var deleteCategory = PublishSubject<Bool>()
    var networkError = BehaviorSubject<Bool>(value: false)
    
    var addPlaceSuccess = PublishSubject<Bool>()
    var setComfirmPlaceSuccess = PublishSubject<Bool>() // 장소 확정
    var cancelComfirmPlaceSuccess = PublishSubject<Bool>() // 장소 확정 취소
    var getConfrimPlaceSuccess = PublishSubject<[PlaceInfo]?>() // 확정 장소 조회
    var getPlaceByCategorySuccess = PublishSubject<[PlaceInfo]?>() // 카테고리별 장소 조회
    
    init(repository: HomeRepository){
        self.repository = repository
    }
    
    func getCardInfo() { // 메인페이지 카드 조회
        repository.getCardInfo()
            .catch { error -> Observable<GetCardResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getCardInfo error \(error)")
                return .just(GetCardResponse.errorResponse(status: error.rawValue, data: nil))
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 500 {
                    //network 연결 x
                    self.networkError.onNext(true)
                }else {
                    self.cardInfo.onNext(response.data)
                    WappleLog.debug("getCardInfo \(response.data)")
                }
            }).disposed(by: disposeBag)
        }
    
    func getDetailArchiveInfo(placeId: Int) { // 디테일 페이지 카드 조회
        repository.getDetailArchiveInfo(id: placeId)
            .catch { error -> Observable<GetDetailArchive> in
                WappleLog.error("getDetailArchiveInfo error \(error)")
                let error = error as! URLSessionNetworkServiceError
                return .just(GetDetailArchive(status: error.rawValue, data: nil))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detailArchive in
                guard let self = self else { return }
                WappleLog.debug("getDetailArchiveInfo \(detailArchive)")
                self.detailArchive.onNext(detailArchive.data)
            }).disposed(by: disposeBag)
        }
    
    func deleteCategory(archiveId: Int, categoryId: Int) { // cardId, categoryId
        repository.deleteCategory(archiveId: archiveId, categoryId: categoryId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("deleteCategory error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.deleteCategory.onNext(true)
                }else {
                    self.deleteCategory.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func addCategory(archiveId: Int, categoryName: [String]) {
        repository.addCategory(archiveId: archiveId, categoryName: categoryName)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<AddCategoryResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("addCategory error \(error)")
                return .just(AddCategoryResponse(status: error.rawValue, data: nil))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("addCategory \(response.data)")
                if response.status == 200 {
                    self.addCategory.onNext(response.data)
                }else if response.status == 400 {
                    self.addCategory.onNext(nil)
                }
            }).disposed(by: disposeBag)
    }
    
    func deleteArchive(archiveId: Int) { //약속 나가기
        repository.deleteArchive(archiveId: archiveId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("deleteArchive error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.deleteSuccess.onNext(true)
                }else {
                    self.deleteSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func likeSend() { // 좋아요 조르기
        
    }
    
    // 약속 코드 조회
    func getArchiveCode(archiveId: Int, completion: () -> Void) {
        repository.getArchiveCode(id: archiveId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<GetArchiveCode> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getArchiveCode error \(error)")
                return .just(GetArchiveCode(status: error.rawValue, data: nil))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.archiveCode.onNext(response.data?.code)
            }).disposed(by: disposeBag)
    }

}

//MARK: Place API
extension HomeUsecase {
    //장소 추가
    func addPlace(archiveId: Int, categoryId: Int, addPlace: AddPlace) {
        repository.addPlace(archiveId: archiveId, categoryId: categoryId, placeInfo: addPlace)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("addPlace error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.addPlaceSuccess.onNext(true)
                }else {
                    self.addPlaceSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 확정 장소 조회
    func getConfirmPlace(archiveId: Int) {
        repository.getConfirmPlace(archiveId: archiveId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<GetPlaceByCategoryResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getPlaceByCategory error \(error)")
                return .just(GetPlaceByCategoryResponse(status: error.rawValue, data: nil))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.getPlaceByCategorySuccess.onNext(response.data)
                }else {
                    self.getPlaceByCategorySuccess.onNext(nil)
                }
            }).disposed(by: disposeBag)
    }
    
    //카테고리별 장소 조회
    func getPlaceByCategory(archiveId: Int, categoryId: Int) {
        repository.getPlaceByCategory(archiveId: archiveId, categoryId: categoryId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<GetPlaceByCategoryResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getPlaceByCategory error \(error)")
                return .just(GetPlaceByCategoryResponse(status: error.rawValue, data: nil))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.getPlaceByCategorySuccess.onNext(response.data)
                }else {
                    self.getPlaceByCategorySuccess.onNext(nil)
                }
            }).disposed(by: disposeBag)
    }
    
    //장소 확정
    func setConfirmPlace(archiveId: Int, placeId: Int) {
        repository.setConfirmPlace(archiveId: archiveId, placeId: placeId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("setConfirmPlace error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.setComfirmPlaceSuccess.onNext(true)
                }else {
                    self.setComfirmPlaceSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    //장소 확정 취소
    func cancelConfirmPlace(archiveId: Int, placeId: Int) {
        repository.cancelConfirmPlace(archiveId: archiveId, placeId: placeId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("cancelConfirmPlace error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.cancelComfirmPlaceSuccess.onNext(true)
                }else {
                    self.cancelComfirmPlaceSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func deletePlace(placeId: Int) { //장소 삭제하기
        
    }
    
    func editPlace(placeId: Int) { //장소 수정하기
        
    }
}

