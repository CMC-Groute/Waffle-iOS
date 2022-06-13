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
    var coordinator: ArchiveCoordinator!
    
    var disposeBag = DisposeBag()
    
    init(usecase: ArchiveUseCase, coordinator: ArchiveCoordinator){
        self.usecase = usecase
        self.coordinator = coordinator
    }
    
    struct Input {
        var nameTextField: Observable<String>
        var memoTextView: Observable<String>
        
        var nameTextFieldDidTapEvent: ControlEvent<Void>
        var memoTextViewDidTapEvent: ControlEvent<Void>
        
        var nameTextFieldDidEndEvent: ControlEvent<Void>
        var memoTextViewDidEndEvent: ControlEvent<Void>
        
        var dateTextFieldTapEvent: ControlEvent<Void>
        var timeTextFieldTapEvent: ControlEvent<Void>
        
        var dateTimeLaterButton: Observable<Void>
        
        var locationTextFieldTapEvent: ControlEvent<Void>
        var locationLaterButton: Observable<Void>
        
        var addArchiveButton: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }
}
