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
                let dummy = PlaceSearchResponse(address: "서울 종로구 신문로2가 108-3", categoryGroupCode: "FD6", categoryGroupName: "음식점 > 간식 > 제과,베이커리", distance: 0, id: "1971663923", phone: "02-737-0050", placeName: "아우어베이커리 광화문디팰리스점", placeUrl: "http://place.map.kakao.com/1971663923", roadAddressName: "서울 종로구 새문안로2길 10", longitude: 126.971982367222, latitude: 37.56870228531)
                self.coordinator.selectPlace(place: dummy)
            }).disposed(by: disposeBag)
        
        return output
    }
    
    
    func back() {
        coordinator.popViewController()
    }
    
}
