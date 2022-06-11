//
//  LoginUseCase.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift
import RxCocoa

class UserUseCase: UserUseCaseProtocol {
    
    private var repository: UserRepository!
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func checkEmailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func checkPasswordValid(password: String) -> Bool { // 영문, 숫자, 8자리 이상
        let passwordreg =  ("(?=.*[A-Za-z])(?=.*[0-9]).{8,100}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: password)
    }
    
    func login(email: String, password: String) -> Observable<String> {
        return Observable.of("TO DO")
    }
    
    func signUp(email: String, password: String, profile: Int, nickName: String) {
        
    }
    
    
}
