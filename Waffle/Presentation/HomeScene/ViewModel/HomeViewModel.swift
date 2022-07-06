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
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        var makeArchiveButton: Observable<Void>
    }
    
    struct Output {
        let isHiddenView = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.makeArchiveButton
            .subscribe(onNext: {
                self.coordinator.archiveFlow(cardInfo: nil)
            }).disposed(by: disposeBag)
        
        input.viewDidLoadEvent
            .subscribe(
                onNext: { [weak self] _ in
                    self?.usecase.getCardInfo()
                    hideView()
                }).disposed(by: disposeBag)
        
        
        func hideView() {
            guard let cardInfo = self.usecase.cardInfo else { return }
            if cardInfo.isEmpty {
                output.isHiddenView.accept(true)
            }else {
                output.isHiddenView.accept(false)
            }
        }
        
        return output
    }
    
    func detailArchive(selectedArchive: CardInfo) {
        self.coordinator.detailArchive(selectedArchive: selectedArchive)
    }
}
