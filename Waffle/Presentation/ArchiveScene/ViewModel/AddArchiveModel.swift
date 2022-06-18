//
//  AddArchiveModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift
import RxCocoa

class AddArchiveModel {
    var usecase: ArchiveUseCase!
    var coordinator: TabBarCoordinator!
    
    var disposeBag = DisposeBag()
    
    init(usecase: ArchiveUseCase, coordinator: TabBarCoordinator){
        self.usecase = usecase
        self.coordinator = coordinator
    }
    
    let locationTextField = PublishRelay<String>() //외부에서 받아오는 데이터
    
    struct Input {
        var nameTextField: Observable<String>
        
        var dateTextField: Observable<String>
        var timeTextField: Observable<String>
        var locationTextField: Observable<String>
        var memoTextView: Observable<String>
        
        var nameTextFieldDidTapEvent: ControlEvent<Void>
        var memoTextViewDidTapEvent: ControlEvent<Void>
        
        var nameTextFieldDidEndEvent: ControlEvent<Void>
        var memoTextViewDidEndEvent: ControlEvent<Void>
        var memoTextViewEditing: ControlEvent<Void>
        
        var dateTimeLaterButton: Observable<Void>
        
        var locationTextFieldTapEvent: ControlEvent<Void>
        var locationLaterButton: Observable<Void>
        
        var addArchiveButton: Observable<Void>
    }
    
    struct Output {
        let dateTimeLaterButtonEnabled = BehaviorRelay<Bool>(value: false)
        let locationLaterButtonEnabled = BehaviorRelay<Bool>(value: false)
        let doneButtonEnabled = BehaviorRelay<Bool>(value: false)
    }
    
    func maxInputRestricted(length: Int, s: String) -> String {
        return self.usecase.maximumTextLength(length: length, s: s)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.addArchiveButton
            .subscribe(onNext: {
                //TO DO
                //약속 추가 서버
                self.coordinator.popTonavigaionController()
            }).disposed(by: disposeBag)
        
        //done button 활성화
        Observable.combineLatest(input.nameTextField, input.dateTextField, input.timeTextField, output.dateTimeLaterButtonEnabled, input.locationTextField, output.locationLaterButtonEnabled)
            .map{ !$0.0.isEmpty && ((!$0.1.isEmpty && !$0.2.isEmpty) || $0.3 == false) && (!$0.4.isEmpty || $0.5 == false) } //false = 토핑이 원하는 위치로
            .bind(to: output.doneButtonEnabled)
            .disposed(by: disposeBag)
        
        input.locationTextFieldTapEvent
            .subscribe(onNext: {
                self.coordinator.addLocation()
            }).disposed(by: disposeBag)
        
        return output
    }
    
    
}
