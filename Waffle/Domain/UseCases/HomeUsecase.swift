//
//  HomeUseCase.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation
import RxSwift

class HomeUsecase: HomeUsecaseProtocol {
    let categoryList = Category.categoryList
    
    var selectedCategoryList: [Category] = []
    var currentArchive = PublishSubject<CardInfo>()
    
    var repository: HomeRepository!
    var cardInfo: [CardInfo]?
    var disposeBag = DisposeBag()
    
    init(repository: HomeRepository){
        self.repository = repository
    }
    
    func getCardInfo() {
        repository.getCardInfo()
            .catch { error -> Observable<GetCardResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("error \(error)")
                return .just(GetCardResponse.errorResponse(message: "error", data: nil))
            }.subscribe(onNext: { [weak self] cardInfo in
                guard let self = self else { return }
                WappleLog.debug("cardInfo \(cardInfo)")
                self.cardInfo = cardInfo.data
            }).disposed(by: disposeBag)
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

}

