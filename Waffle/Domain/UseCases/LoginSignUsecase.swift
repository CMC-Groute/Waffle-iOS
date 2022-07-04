//
//  LoginUsecase.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift
import RxCocoa

class LoginSignUsecase: LoginSignUsecaseProtocol {
    
    private var repository: LoginSignRepository!
    let disposeBag = DisposeBag()
    let authenCodeSuccess = PublishSubject<Bool>()
    
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
            
    }
    
    func signUp(email: String, password: String, profile: String, nickName: String, isAgreedMarketing: Bool) {
        let signInfo = SignUp(email: email, password: password, nickname: nickName, isAgreedMarketing: false, profileImage: profile)
        repository.singUp(signUpInfo: signInfo)
    }
    
    func getTempPassword(email: String) {
        
    }
    
    func checkEmailValidation(email: String, code: String) -> Observable<Bool> {
        repository.checkEmailCode(email: email, code: code)
            
        return Observable.of(false)
    }
    
    func sendAuthenCode(email: String) {
        repository.sendEmail(email: email)
            .subscribe(onNext: { response in
                if response.message == "success" {
                    //메세지 전송 성공
                    self.authenCodeSuccess.onNext(true)
                }else {
                    self.authenCodeSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
}
