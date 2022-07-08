//
//  HomeViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ObservableObject {
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase!
    var cardInfo: [CardInfo]?
    var archiveId: Int = -1
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var viewWillAppearEvent: Observable<Void>
        var makeArchiveButton: Observable<Void>
    }
    
    struct Output {
        let isHiddenView = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.makeArchiveButton
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator.addArchive()
            }).disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .subscribe(
                onNext: { [weak self] _ in
                    self?.usecase.getCardInfo()
                }).disposed(by: disposeBag)
        
        usecase.cardInfo
            .subscribe(onNext: { [weak self] cardInfo in
                guard let self = self else { return }
                if let cardInfo = cardInfo {
                    self.cardInfo = cardInfo
                    output.isHiddenView.accept(false)
                }else {
                    output.isHiddenView.accept(true)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func detailArchive(selectedArchive: CardInfo) {
        coordinator.detailArchive(selectedArchive: selectedArchive)
    }
}
