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
    
    struct LoadSearchPlace {
        static var size = 15
        static var currentPage = 1
    }
    
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase!

    var place: [PlaceSearch] = []
    var filteringPlace: [PlaceSearch] = []
    
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
//                let dummy = PlaceSearchResponse(address: "서울 종로구 신문로2가 108-3", categoryGroupCode: "FD6", categoryGroupName: "음식점 > 간식 > 제과,베이커리", distance: 0, id: "1971663923", phone: "02-737-0050", placeName: "아우어베이커리 광화문디팰리스점", placeUrl: "http://place.map.kakao.com/1971663923", roadAddressName: "서울 종로구 새문안로2길 10", longitude: 126.971982367222, latitude: 37.56870228531)
                self.coordinator.selectPlace(place: place)
            }).disposed(by: disposeBag)
        
        usecase.getSearchedPlaceSuccess
            .subscribe(onNext: { [weak self] place in
                guard let place = place else { return }
                guard let self = self else { return }
                WappleLog.debug("getSearchPlace \(place)")
                self.place = place
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
