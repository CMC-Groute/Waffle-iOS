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
    
    var repository: HomeRepository!
    var detailArchive = PublishSubject<DetailArhive?>()
    var cardInfo = PublishSubject<[CardInfo]?>()
    var disposeBag = DisposeBag()
    var archiveCode = PublishSubject<String?>()
    
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
            .subscribe(onNext: { [weak self] cardInfo in
                guard let self = self else { return }
                WappleLog.debug("getCardInfo \(cardInfo)")
                self.cardInfo.onNext(cardInfo.data)
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
    
    func deleteCategory(categoryId: Int) { // cardId, categoryId
       //currentCardId
    }
    
    func deleteArchive() { //약속 나가기
        
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

