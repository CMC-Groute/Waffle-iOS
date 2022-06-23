//
//  HomeUseCase.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation
import RxSwift

struct Category {
    var name: String
    var index: Int
    var selected: Bool = false
    
    static var categoryList = [Category(name: "맛집", index: 0),
                               Category(name: "카페", index: 1),
                               Category(name: "아침", index: 2),
                               Category(name: "점심", index: 3),
                               Category(name: "저녁", index: 4),
                               Category(name: "소품샵", index: 5),
                               Category(name: "할거리", index: 6),
                               Category(name: "볼거리", index: 7),
                               Category(name: "기타", index: 8)]
}

class HomeUsecase: HomeUsecaseProtocol {
    let categoryList = Category.categoryList
    
    var selectedCategoryList: [Category] = []
    var currentArchive = PublishSubject<CardInfo>()
    
    var repository: HomeRepository!
    @Published var cardInfo: [CardInfo] = []
    var disposeBag = DisposeBag()
    
    init(repository: HomeRepository){
        self.repository = repository
    }
    
    func getCardInfo() {
        repository.getCardInfo()
            .subscribe(onNext: { [weak self] cardInfo in
                guard let self = self else { return }
                self.cardInfo = cardInfo
            }).disposed(by: disposeBag)
    }
    
    func deleteCategory(categoryId: Int) { // cardId, categoryId
       //currentCardId
    }
    
    func deleteArchive() { //약속 나가기
        
    }
    
    func likeSend() { // 좋아요 조르기
        
    }


}

