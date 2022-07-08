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
    let disposeBag = DisposeBag()
    let sendEmailSuccess = PublishSubject<SendEmailStatus>()
    let loginSuccess = PublishSubject<LoginStatus>()
    
    init(repository: LoginSignRepository) {
        self.repository = repository
        print("create \(repository)")
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
        let loginInfo = Login(email: email, password: password)
        repository.login(loginInfo: loginInfo)
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
    
    func signUp(signUp: SignUp) -> Observable<SignUpResponse> {
        return repository.singUp(signUpInfo: signUp)
    }
    
    //임시 비밀번호 발급
    func getTempPassword(email: String) -> Observable<Bool> {
        return repository.getTempPassword(email: email)
            .map { $0.status == 200 }
    }
    
    func checkEmailCode(email: String, code: String) -> Observable<Bool> {
        return repository.checkEmailCode(email: email, code: code)
            .map { $0.status == 200 }
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
                    self.sendEmailSuccess.onNext(.already)
                }
            }).disposed(by: disposeBag)
    }
    
}
