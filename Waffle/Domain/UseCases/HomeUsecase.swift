//
//  HomeUseCase.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation
import RxSwift

class HomeUsecase: HomeUsecaseProtocol {
    //let categoryList = Category.categoryList
    //var selectedCategoryList: [Category] = []
    
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
    
    func getPlaceByCategory(placeId: Int, categoris: [PlaceCategory]) {
        for i in categoris {
            repository
        }
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
    
    func deletePlace(placeId: Int) { //장소 삭제하기
        
    }
    
    func editPlace(placeId: Int) { //장소 수정하기
        
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

