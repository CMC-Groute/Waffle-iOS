//
//  LoginUsecase.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift
import RxCocoa

enum SendEmailStatus {
    case already
    case sendEmail
}

enum LoginStatus {
    case login
    case invalidEmail
    case invalidPW
    case unDefined
}

class LoginSignUsecase: LoginSignUsecaseProtocol {
    
    private var repository: LoginSignRepository!
    private let disposeBag = DisposeBag()
    
    let sendEmailSuccess = PublishSubject<SendEmailStatus>()
    let loginSuccess = PublishSubject<LoginStatus>()
    let checkEmailCode = PublishSubject<Bool>()
    
    init(repository: LoginSignRepository) {
        self.repository = repository
    }
    
    func checkEmailValid(email: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: email)
    }
    
    func checkPasswordValid(password: String) -> Bool { // 영문, 숫자, 8자리 이상
        let passwordReg =  ("(?=.*[A-Za-z])(?=.*[0-9]).{8,100}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordReg)
        return passwordtesting.evaluate(with: password)
    }
    
    func checkNickNameValid(nickName: String) -> Bool { //특수문자 제외 6글자 이하
        let nickNameReg = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]{0,6}$"
        let nickNameTest = NSPredicate(format: "SELF MATCHES %@", nickNameReg)
        return nickNameTest.evaluate(with: nickName)
    }
    
    func login(email: String, password: String) {
        print("LoginSignUsecase")
        guard let deviceToken = UserDefaults.standard.string(forKey: UserDefaultKey.deviceToken) else { return }
        let loginInfo = Login(email: email, password: password, deviceToken: deviceToken)
        repository.login(loginInfo: loginInfo)
            .catch { error -> Observable<LoginResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("error \(error)")
                return .just(LoginResponse(status: error.rawValue, data: nil))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                print(response.status)
                if response.status == 200 {
                    self.loginSuccess.onNext(.login)
                    self.storeUserInfo(user: response.data!)
                }else if response.status == 403 {
                    self.loginSuccess.onNext(.invalidPW)
                }else if response.status == 404 {
                    self.loginSuccess.onNext(.invalidEmail)
                }else {
                    self.loginSuccess.onNext(.unDefined)
                }
            }).disposed(by: disposeBag)
    }
    
    func storeUserInfo(user: UserInfo) {
        UserDefaults.standard.set(user.id, forKey: UserDefaultKey.userId)
        UserDefaults.standard.set(user.token, forKey: UserDefaultKey.jwtToken)
    }
    
    func signUp(signUp: SignUp) -> Observable<DefaultIntResponse> {
        return repository.singUp(signUpInfo: signUp)
    }
    
    //임시 비밀번호 발급
    func getTempPassword(email: String) -> Observable<Bool> {
        return repository.getTempPassword(email: email)
            .map { $0.status == 200 }
    }
    
    func checkEmailCode(email: String, code: String) {
        repository.checkEmailCode(email: email, code: code)
            .catch { error -> Observable<DefaultResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("error \(error)")
                return .just(DefaultResponse.errorResponse(code: error.rawValue))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                WappleLog.debug("checkEmailCode \(response.status)")
                if response.status == 200 {
                    self.checkEmailCode.onNext(true)
                }else if response.status == 403  || response.status == 400 {
                    self.checkEmailCode.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func sendEmail(email: String) {
        repository.sendEmail(email: email)
            .catch { error -> Observable<DefaultResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("error \(error)")
                return .just(DefaultResponse.errorResponse(code: error.rawValue))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                if response.status == 200 {
                    self.sendEmailSuccess.onNext(.sendEmail)
                }else {
                    //WappleLog.debug("response.status \(response.status)")
                    self.sendEmailSuccess.onNext(.already)
                }
            }).disposed(by: disposeBag)
    }
    
}
