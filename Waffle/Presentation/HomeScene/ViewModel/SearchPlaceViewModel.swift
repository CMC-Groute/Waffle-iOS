//
//  SearchPlaceViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import Foundation
import RxSwift
import RxCocoa

class SearchPlaceViewModel {
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase!
    
    // TO DO PlaceSearchInfo
    var place: [String] = ["first 장소", "second 장소", "second 장소", "second 장소", "Third 장소"]
    var filteringPlace: [String] = []
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let selectedItem: Observable<Int>
        let selectButton: Observable<Void>
    }
    
    struct Output { }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.viewDidLoadEvent
            .subscribe(onNext: {
                // TO DO get data
                self.filteringPlace = self.place
            }).disposed(by: disposeBag)

        input.selectButton
            .withLatestFrom(input.selectedItem)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                let place = self.place[index]
                self.coordinator.selectPlace(place: place)
            }).disposed(by: disposeBag)
        
        return output
    }
    
    
    func back() {
        coordinator.popViewController()
    }
    
}
