//
//  DetailArchiveViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import Foundation
import RxSwift
import RxCocoa

class DetailArchiveViewModel {
    
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase!
    var detailArchive: CardInfo?
    var placeInfo: [PlaceInfo] = []
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var loadMemoButton: Observable<Void>
        var invitationButton: Observable<Void>
        var addPlaceButton: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.addPlaceButton
            .subscribe(onNext: {
                self.coordinator.archiveFlow()
            }).disposed(by: disposeBag)
        
        input.loadMemoButton
            .subscribe(onNext: {
                self.coordinator.loadMemo()
            }).disposed(by: disposeBag)
        
        input.invitationButton
            .subscribe(onNext: {
                self.coordinator.participants()
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func setArchive(archive: CardInfo) {
        self.usecase.currentArchive.onNext(archive)
    }
    
    func detailArhive() { // bottomSheet popUp
        self.coordinator.detailArchiveBottomSheet()
    }
    
    func invitationArhive() {
        self.coordinator.invitationBottomSheet()
    }
    
    

    
    
}
