//
//  InputArchiveViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/16.
//

import Foundation
import RxSwift
import RxCocoa

class InputArchiveViewModel {
    var usecase: ArchiveUseCase!
    var coordinator: TabBarCoordinator!
    
    var disposeBag = DisposeBag()
    
    init(usecase: ArchiveUseCase, coordinator: TabBarCoordinator){
        self.usecase = usecase
        self.coordinator = coordinator
    }
    
    struct Input {
        let codeTextField: Observable<String>
        let codeTextFieldDidTapEvent: ControlEvent<Void>
        let codeTextFieldDidEndEvent: ControlEvent<Void>
        let joinButton: Observable<Void>
    }
    
    struct Output {
        let inValidCodeMessage = BehaviorRelay<Bool>(value: false)
        let joinButtonEnabled = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }
}
