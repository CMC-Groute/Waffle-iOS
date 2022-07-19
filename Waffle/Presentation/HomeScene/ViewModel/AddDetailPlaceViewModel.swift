//
//  AddDetailPlaceViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

final class AddDetailPlaceViewModel {
    var coordinator: HomeCoordinator!
    private var disposeBag = DisposeBag()
    var usecase: HomeUsecase!
    var categoryInfo: [PlaceCategory] = []
    
    //for layout
    let placeViewEnabled = BehaviorRelay<Bool>(value: false)
    var getPlace: PlaceSearch?
    var archiveId: Int?
    
    private let defaultText = "장소에 대한 간략한 정보나 가고 싶은 이유, 추천하는 이유 등을 자유롭게 작성하면 좋아요"
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var categorySelectedItem: Observable<Int?>
        var placeTextFieldTapEvent: ControlEvent<Void>
        // 클릭시 다시 장소 입력 textfield 레이아웃
        var placeViewDeleteButton: Observable<Void>
        var linkTextViewDidTapEvent: ControlEvent<Void>
        var linkTextViewDidEndEvent: ControlEvent<Void>
        
        let memoTextView: Observable<String>
        var memoTextViewDidTapEvent: ControlEvent<Void>
        var memoTextViewDidEndEvent: ControlEvent<Void>
        var memoTextViewEditing: ControlEvent<Void>
        var addButton: Observable<Void>
    }
    
    
    struct Output {
        let addButtonEnabled = BehaviorRelay<Bool>(value: false)
        let linkTextView = BehaviorRelay<String?>(value: nil)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.placeTextFieldTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.searchPlace()
            }).disposed(by: disposeBag)
        
        input.placeViewDeleteButton
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.placeViewEnabled.accept(false)
            }).disposed(by: disposeBag)
        
        //addButtonEnabled button 활성화
        Observable.combineLatest(placeViewEnabled, input.categorySelectedItem)
            .map{ $0.0 == true && $0.1 != nil }
            .bind(to: output.addButtonEnabled)
            .disposed(by: disposeBag)
        
        input.addButton
            .withLatestFrom(Observable.combineLatest(input.categorySelectedItem, input.memoTextView, output.linkTextView))
            .bind(onNext: { [weak self] categoryIndex, memo, link in
                guard let self = self else { return }
                guard let categoryIndex = categoryIndex, let archiveId = self.archiveId else { return }
                let categoryId = self.categoryInfo[categoryIndex].id
                guard let getPlace = self.getPlace else { return }

                var addPlaceInfo = AddPlace(title: getPlace.placeName, roadNameAddress: getPlace.roadAddressName, longitude: getPlace.longitude, latitude: getPlace.latitude )
                if memo != self.defaultText { addPlaceInfo.memo = memo }
                addPlaceInfo.link = link
                self.usecase.addPlace(archiveId: archiveId, categoryId: categoryId, addPlace: addPlaceInfo)
            }).disposed(by: disposeBag)
        
        usecase.addPlaceSuccess
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator.popViewController()
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func back() {
        coordinator.popViewController()
    }
}
