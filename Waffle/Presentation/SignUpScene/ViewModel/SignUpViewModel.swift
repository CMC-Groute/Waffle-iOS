//
//  SignUpViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift
import RxCocoa

enum EmailValidType {
    case none, notValid, needValid, aready, checkEmail, valid
}

enum EmailValidColor: String {
    case red, green, orange
}

class SignUpViewModel {
    struct Input {
        var emailTextField: Observable<String>
        var authenCodeTextField: Observable<String>
        var passwordTextField: Observable<String>
        var rePasswordTextField: Observable<String>
        
        var emailTextFieldDidTapEvent: ControlEvent<Void>
        var authenCodeTextFieldDidTapEvent: ControlEvent<Void>
        var passwordTextFieldDidTapEvent: ControlEvent<Void>
        var rePasswordTextFieldDidTapEvent: ControlEvent<Void>
        
        var emailTextFieldDidEndEvent: ControlEvent<Void>
        var authenCodeTextFieldEndTapEvent: ControlEvent<Void>
        var passwordTextFieldDidEndEvent: ControlEvent<Void>
        var rePasswordTextFieldEndTapEvent: ControlEvent<Void>
        
        var emailAuthenButton: Observable<Void>
        var authenCodeButton: Observable<Void>
        var nextButton: Observable<Void>
    }
    
    struct Output {
        var authenEmailButtonEnabled = BehaviorRelay<Bool>(value: false)
        var authenCodeButtonEnabled = BehaviorRelay<Bool>(value: false)
        var nextButtonEnabled = BehaviorRelay<Bool>(value: false)
        var isEmailInvalid = PublishRelay<EmailValidType>()
        var emailInvalidMessage = PublishRelay<(String?, EmailValidColor?)>()
        var isAuthenCodeInValid = PublishRelay<Bool>()
        var ispasswordInvalid = PublishRelay<Bool?>()
        var isRepasswordInvalid = PublishRelay<Bool?>()
    }
    
    private var disposable = DisposeBag()
    private var usecase: LoginSignUsecase
    private var coordinator: SignUpCoordinator!
    
    init(coordinator: SignUpCoordinator, usecase: LoginSignUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        //nextButton 활성화
        Observable.combineLatest(output.isEmailInvalid, output.isAuthenCodeInValid, output.ispasswordInvalid, output.isRepasswordInvalid)
            .map{ $0.0 == .checkEmail && $0.1 == true && $0.2 == true && $0.3 == true } //유효 메세지 없다면
            .bind(to: output.nextButtonEnabled)
            .disposed(by: disposeBag)
        
        input.nextButton
            .subscribe(onNext: {
                self.coordinator.termsStep()
            }).disposed(by: disposeBag)
        
        input.emailTextField
            .distinctUntilChanged()
            .subscribe(onNext: { email in
                if email.count == 0 {
                    output.isEmailInvalid.accept(.none)
                }else {
                    if !self.usecase.checkEmailValid(email: email) {
                        output.authenEmailButtonEnabled.accept(false) // 버튼 비 활성화
                        output.isEmailInvalid.accept(.notValid) // invalide message show
                    }else {
                        output.authenEmailButtonEnabled.accept(true) // 버튼 활성화
                        output.isEmailInvalid.accept(.needValid) // valid message show
                    }
                }
                
            }).disposed(by: disposeBag)
        
        output.isEmailInvalid
            .subscribe(onNext: { type in
                var message: String?
                var color: EmailValidColor?
                switch type {
                case .notValid:
                    message = "이메일 형식이 올바르지 않아요."
                    color = .red
                case .needValid:
                    message = "이메일을 인증해 주세요."
                    color = .orange
                case .aready:
                    message = "이미 가입된 이메일이에요."
                    color = .red
                case .checkEmail:
                    message = "이메일에서 인증번호를 확인해 주세요."
                    color = .green
                default:
                    break
                    
                }
                output.emailInvalidMessage.accept((message ?? nil, color ?? nil))
            }).disposed(by: disposeBag)
        
        input.emailAuthenButton // 중복 이메일 검사 TO DO
            .withLatestFrom(input.emailTextField)
            .bind(onNext: { [weak self] email in
                guard let self = self else { return }
                self.usecase.checkEmailValidation(email: email)
                    .subscribe(onNext: { bool in
                        if bool {
                            output.isEmailInvalid.accept(.aready) // 중복임
                        }else {
                            self.usecase.sendAuthenCode() // 이메일 보냄
                            output.isEmailInvalid.accept(.checkEmail)
                        }
                    }).disposed(by: disposeBag)
            }).disposed(by: disposeBag)
        
        
        
        
        // MARK - authenTextField
        input.authenCodeTextField
            .subscribe(onNext: { text in
                if text.count >= 6 {
                    output.authenCodeButtonEnabled.accept(true)
                }else {
                    output.authenCodeButtonEnabled.accept(false)
                }
            }).disposed(by: disposeBag)
        
        input.authenCodeButton
            .withLatestFrom(input.authenCodeTextField)
            .subscribe(onNext: { text in
                if !(self.usecase.authenCode == text) { // 인증번호 같지 x
                    output.isAuthenCodeInValid.accept(false)
                }else {
                    output.isAuthenCodeInValid.accept(true)
                }
            }).disposed(by: disposeBag)
        
        // MARK - passwordTextField
        input.passwordTextField
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                if text.count == 0 {
                    output.ispasswordInvalid.accept(nil)
                }else {
                    if !self.usecase.checkPasswordValid(password: text) {
                        output.ispasswordInvalid.accept(false)
                    }else {
                        output.ispasswordInvalid.accept(true)
                    }
                }
                
            }).disposed(by: disposeBag)
        
        input.rePasswordTextField
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                if text.count == 0 {
                    output.isRepasswordInvalid.accept(nil)
                }else {
                    if !self.usecase.checkPasswordValid(password: text) {
                        output.isRepasswordInvalid.accept(false)
                    }else {
                        output.isRepasswordInvalid.accept(true)
                    }
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
}
