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
    case none, notValid, needValid, aready, checkEmail, valid, loadFalse
}

enum EmailValidColor: String {
    case red, green, orange
}

final class SignUpViewModel {

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
        var isAuthenCodeInValid = PublishRelay<Bool?>()
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
        Observable.combineLatest(output.isEmailInvalid, output.isAuthenCodeInValid, output.ispasswordInvalid, output.isRepasswordInvalid, input.passwordTextField, input.rePasswordTextField)
            .map{ ($0.0 == .checkEmail || $0.0 == .loadFalse) && $0.1 == true && $0.2 == true && $0.3 == true &&  ($0.4 == $0.5) } //유효 메세지 없다면, 비밀번호가 일치한다면
            .bind(to: output.nextButtonEnabled)
            .disposed(by: disposeBag)
        
        input.nextButton
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(input.emailTextField, input.passwordTextField))
            .bind(onNext: { email, password in
                let signUpInfo = SignUp(email: email, password: password, nickname: "", profileImage: "", isAgreedMarketing: false)
                self.coordinator.termsStep(signUpInfo: signUpInfo)
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
                case .none:
                    color = .red
                    //message = "알수 없는 에러가 발생했습니다."
                default:
                    break
                }
                output.emailInvalidMessage.accept((message ?? nil, color ?? nil))
            }).disposed(by: disposeBag)
        
        input.emailAuthenButton
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .withLatestFrom(input.emailTextField)
            .bind(onNext: { [weak self] email in
                guard let self = self else { return }
                //MARK: email send
                self.usecase.sendEmail(email: email)
                output.isEmailInvalid.accept(.checkEmail)
            }).disposed(by: disposeBag)
        
        //MARK: - authenTextField
        input.authenCodeTextField
            .subscribe(onNext: { text in
                if text.count == 0 {
                    output.isAuthenCodeInValid.accept(nil)
                }
                if text.count >= 6 {
                    output.authenCodeButtonEnabled.accept(true)
                }else {
                    output.authenCodeButtonEnabled.accept(false)
                }
            }).disposed(by: disposeBag)
                        
        //MARK: 인증 코드 같은지 체크
        input.authenCodeButton
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(input.emailTextField, input.authenCodeTextField))
            .bind(onNext: { email, code in
                self.usecase.checkEmailCode(email: email, code: code)
            }).disposed(by: disposeBag)
        
        //MARK: - passwordTextField
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
        
        //MARK: Binding Usecase
        usecase.sendEmailSuccess
            .subscribe(onNext: { status in
                switch status {
                case .sendEmail:
                    WappleLog.debug("sendEmailSuccess \(status)")
                case .already:
                    output.isEmailInvalid.accept(.aready)
                case .undefined:
                    WappleLog.debug("sendEmailSuccess undefined \(status)")
                    output.isEmailInvalid.accept(.loadFalse)
                }
            }).disposed(by: disposeBag)
        
        usecase.checkEmailCodeSuccess
            .subscribe(onNext: { bool in
                    output.isAuthenCodeInValid.accept(bool)
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func backButton() {
        coordinator.popViewController()
    }
    
}
