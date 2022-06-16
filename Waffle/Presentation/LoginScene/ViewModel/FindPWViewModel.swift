//
//  FindPWViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/11.
//

import Foundation
import RxSwift
import RxCocoa

class FindPWViewModel {
    
    struct Input {
        var emailTextField: Observable<String>
        var emailTextFieldDidTapEvent: ControlEvent<Void>
        var emailTextFieldDidEndEvent: ControlEvent<Void>
        var getTempPWButton: Observable<Void>
    }
    
    struct Output {
        var getTempPWButtonEnabled = BehaviorRelay<Bool>(value: false)
        var emailInvalidMessage = PublishRelay<Bool>()
    }
    
    var usecase: LoginSignUseCase
    var coordinator: LoginCoordinator
    
    init(usecase: LoginSignUseCase, coordinator: LoginCoordinator) {
        self.usecase = usecase
        self.coordinator = coordinator
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.emailTextField
            .distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: { [weak self] email in
                guard let self = self else { return }
                if !self.usecase.checkEmailValid(email: email) { // 유효 x
                    output.emailInvalidMessage.accept(false)
                }else {
                    output.emailInvalidMessage.accept(true)
  
                }
            }).disposed(by: disposeBag)
        
        input.getTempPWButton
            .withLatestFrom(input.emailTextField)
            .bind(onNext: { [weak self] email in
                guard let self = self else { return }
                if !self.usecase.checkEmailValid(email: email) { // 유효 x
                    output.emailInvalidMessage.accept(false)
                }else {
                    output.emailInvalidMessage.accept(true)
                    self.usecase.getTempPassword(email: email)
                    self.coordinator.popToRootViewController(with: "임시 비밀번호가 발급되었어요.로그인 후 비밀번호를 변경해 주세요.")
                }
            }).disposed(by: disposeBag)
            
        output.emailInvalidMessage
            .subscribe(onNext: { bool in
                if bool {
                    output.getTempPWButtonEnabled.accept(true)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
}
