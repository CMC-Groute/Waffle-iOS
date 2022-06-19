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
    var authenCode: String = "111111"
    
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
    
    func login(email: String, password: String) -> Observable<String> {
        return Observable.of("TO DO")
    }
    
    func signUp(email: String, password: String, profile: Int, nickName: String) {
        
    }
    
    func getTempPassword(email: String) {
        
    }
    
    func checkEmailValidation(email: String) -> Observable<Bool> {
        return Observable.of(false)
    }
    
    func sendAuthenCode() {
        self.authenCode = "111111"
    }

    
    
    
    
}
