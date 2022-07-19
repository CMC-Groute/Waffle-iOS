//
//  LoginViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    private var disposable = DisposeBag()
    private var usecase: LoginSignUsecase
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
        var loginButtonEnabled = BehaviorRelay<Bool>(value: true) // for develop
        var emailInvalidMessage = PublishRelay<Bool>()
        var passwordInvalidMessage = PublishRelay<Bool>()
        var alertMessage = PublishRelay<String>()
    }
    
    init(loginSignUseCase: LoginSignUsecase, coordinator: LoginCoordinator) {
        self.usecase = loginSignUseCase
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
            .bind(onNext: { [weak self] email, password in
                guard let self = self else { return }
                self.usecase.login(email: email, password: password)
            }).disposed(by: disposeBag)
           
        //loginSuccess true인 경우만 로그인 허용
        usecase.loginSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { status in
                WappleLog.debug("status \(status)")
                //403 존재하지 않는 비밀번호 입니다.
                //404 존재하지 않는 사용자입니다.
                if status == .login {
                    self.coordinator.finish()
                }else if status == .invalidPW {
                    output.passwordInvalidMessage.accept(true)
                }else if status == .invalidEmail {
                    output.emailInvalidMessage.accept(true)
                }
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
