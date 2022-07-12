//
//  AddDetailPlaceViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

class AddDetailPlaceViewModel {
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase!
    var categoryInfo: [PlaceCategory] = []
    
    //for layout
    let placeViewEnabled = BehaviorRelay<Bool>(value: false)
    var getPlace: PlaceSearch?
    
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
        
        var memoTextViewDidTapEvent: ControlEvent<Void>
        var memoTextViewDidEndEvent: ControlEvent<Void>
        var memoTextViewEditing: ControlEvent<Void>
        var addButton: Observable<Void>
        
    }
    
    struct Output {
        let addButtonEnabled = BehaviorRelay<Bool>(value: false)
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
        
        
        return output
    }
    
    func back() {
        coordinator.popViewController()
    }
}
