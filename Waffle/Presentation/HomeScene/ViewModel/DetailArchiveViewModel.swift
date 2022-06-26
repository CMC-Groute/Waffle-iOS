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
    var category: Category = Category.defaultList
    var placeInfo: [PlaceInfo] = []
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var viewDidLoad: Observable<Void>
        var loadMemoButton: Observable<Void>
        var invitationButton: Observable<Void>
        var addPlaceButton: Observable<Void>
    }
    
    struct Output {
//        var whenLabel = PublishSubject<String>()
//        var whereLabel = PublishSubject<String>()
//        var memoLabel = PublishSubject<String>()
//        var participantsCount = PublishSubject<String>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                //get place data
                self?.placeInfo = [PlaceInfo.dummyPlace, PlaceInfo.dummyPlace, PlaceInfo.dummyPlace]
            }).disposed(by: disposeBag)
        
        input.addPlaceButton
            .subscribe(onNext: {
                // 장소 추가
            }).disposed(by: disposeBag)
        
        input.loadMemoButton
            .subscribe(onNext: {
                self.coordinator.loadMemo()
            }).disposed(by: disposeBag)
        
        input.invitationButton
            .subscribe(onNext: {
                self.coordinator.invitationBottomSheet()
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func setArchive(archive: CardInfo) {
        self.usecase.currentArchive.onNext(archive)
    }
    
    func detailArhive() { // bottomSheet popUp
        self.coordinator.detailArchiveBottomSheet(cardInfo: detailArchive)
    }
    
    func invitationArhive() {
        self.coordinator.invitationBottomSheet()
    }
    
    func detailPlace(place: PlaceInfo, category: Category) {
        self.coordinator.detailPlace(detailInfo: place, category: category)
    }
    
    func setCategory(category: Category) {
        //카테고리 클릭시마다 update해줌
        self.category = category
    }
    
    

    
    
}
