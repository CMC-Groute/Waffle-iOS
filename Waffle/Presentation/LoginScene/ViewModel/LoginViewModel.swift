//
//  LoginViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    private var disposable = DisposeBag()
    private var usecase: UserUseCase
    private var coordinator: LoginCoordinator!
    
    struct Input {
        var emailTextField: Observable<String>
        var passwordTextField: Observable<String>
        var emailTextFieldDidTapEvent: ControlEvent<Void>
        var passwordTextFieldDidTapEvent: ControlEvent<Void>
        var emailTextFieldDidEndEvent: ControlEvent<Void>
        var passwordTextFieldDidEndEvent: ControlEvent<Void>
        var loginButton: Observable<Void>
        var signInButton: Observable<Void>
        var findPWButton: Observable<Void>
    }

    struct Output {
        var loginButtonEnabled = BehaviorRelay<Bool>(value: false)
        var emailInvalidMessage = PublishRelay<Bool>()
        var passwordInvalidMessage = PublishRelay<Bool>()
    }
    
    init(userUseCase: UserUseCase, coordinator: LoginCoordinator) {
        self.usecase = userUseCase
        self.coordinator = coordinator
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.combineLatest(input.emailTextField, input.passwordTextField)
            .map{ $0.0.count > 0 && $0.1.count > 8 }
            .bind(to: output.loginButtonEnabled)
            .disposed(by: disposeBag)
        
        input.loginButton
            .withLatestFrom(Observable.combineLatest(input.emailTextField, input.passwordTextField))
            .bind(onNext: { email, password in
                if !self.usecase.checkEmailValid(email:  email) { // 이메일 유효성 x
                    output.emailInvalidMessage.accept(false)
                }else {
                    output.emailInvalidMessage.accept(true)
                }
                
                if !self.usecase.checkPasswordValid(password: password) { //패스워드 유효성 x
                    output.passwordInvalidMessage.accept(false)
                }else {
                    output.passwordInvalidMessage.accept(true)
                }
                
                Observable.combineLatest(output.emailInvalidMessage, output.passwordInvalidMessage)
                    .map { $0.0 && $0.1 }
                    .filter { $0 == true }
                    .subscribe(onNext: { _ in
                        self.usecase.login(email: email, password: password)
                        self.coordinator.finish()
                    }).disposed(by: disposeBag)

            }).disposed(by: disposeBag)
           
        
        input.signInButton
            .subscribe(onNext: {
                self.coordinator.showSignUpFlow()
            }).disposed(by: disposeBag)

        input.findPWButton
            .subscribe(onNext: {
                self.coordinator.showFindPWViewController()
            }).disposed(by: disposeBag)
        
        return output
        
    
    }

    
    
}
