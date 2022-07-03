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
    var categoryInfo: [Category] = []
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var locationTextFieldTapEvent: ControlEvent<Void>
        var locationDeleteButton: ControlEvent<Void> // 클릭시 다시 장소 입력 textfield 레이아웃
                                        
        var linkTextFieldDidTapEvent: ControlEvent<Void>
        var linkTextFieldDidEndEvent: ControlEvent<Void> // 링킹으로 만들기
        
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
        input.locationTextFieldTapEvent
            .subscribe(onNext: {
                //self.coordinator.addLocation()
            }).disposed(by: disposeBag)
        return output
    }
    
    func back() {
        coordinator.popViewController()
    }
}
