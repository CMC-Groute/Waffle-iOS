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
    var archiveId: Int = 0
    var code: String?
    
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
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getDetailArchiveInfo error \(error)")
                return .just(GetDetailArchive(status: error.rawValue, data: nil))
            }
            .observe(on: MainScheduler.instance)
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
    
    func getArchiveCode() {
        repository.getArchiveCode(id: archiveId)
            .catch { error -> Observable<GetArchiveCode> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("error \(error)")
                return .just(GetArchiveCode(status: error.rawValue, data: nil))
            }.subscribe(onNext: { response in
                self.code = response.data?.code
            }).disposed(by: disposeBag)
    }

}

