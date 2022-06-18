//
//  InputArchiveViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/16.
//

import Foundation
import RxSwift
import RxCocoa

class InputArchiveCodeViewModel {
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
        input.codeTextField
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                if !text.isEmpty { // 조건 : 한글자 이상 입력
                    output.joinButtonEnabled.accept(true)
                    output.inValidCodeMessage.accept(false)
                }else {
                    output.joinButtonEnabled.accept(false)
                }
            }).disposed(by: disposeBag)
        
        input.joinButton
            .withLatestFrom(input.codeTextField)
            .subscribe(onNext: { [weak self] code in
                guard let self = self else { return }
                if self.usecase.checkCodeValid(code: code) {
                    // self.coordinator. 약속 참여하기
                }else {
                    output.inValidCodeMessage.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
