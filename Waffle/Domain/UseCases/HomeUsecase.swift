//
//  HomeUseCase.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation
import RxSwift

class HomeUsecase: HomeUsecaseProtocol {

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

