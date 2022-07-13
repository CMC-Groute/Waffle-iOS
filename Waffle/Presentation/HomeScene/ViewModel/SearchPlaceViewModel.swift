//
//  SearchPlaceViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import Foundation
import RxSwift
import RxCocoa

struct LoadSearchPlace {
    static var size = 15
    static var currentPage = 1
}

class SearchPlaceViewModel {
    
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase!

    var place: [PlaceSearch] = []
    var filteringPlace: [PlaceSearch] = []
    var loadedItemCount: Int = 0
    var isLoading: Bool = true
    var updateRows: Int = 0
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let selectedItem: Observable<Int>
        let selectButton: Observable<Void>
    }
    
    struct Output {
        var loadData = PublishSubject<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.viewDidLoadEvent
            .subscribe(onNext: {
                self.filteringPlace = self.place
            }).disposed(by: disposeBag)

        input.selectButton
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(input.selectedItem)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                let place = self.place[index]
                self.coordinator.selectPlace(place: place)
            }).disposed(by: disposeBag)
        
        usecase.getSearchedPlaceSuccess
            .subscribe(onNext: { [weak self] place in
                guard let self = self else { return }
                WappleLog.debug("getSearchPlace \(place)")
                self.place = place.documents
                output.loadData.onNext(true)
            }).disposed(by: disposeBag)
        return output
    }
    
    func getPlace(for searchText: String) {
        usecase.getSearcPlace(searchText: searchText, page: LoadSearchPlace.currentPage, size: LoadSearchPlace.size)
    }
    
    
    func back() {
        coordinator.popViewController()
    }
    
}
