//
//  UserUsecaseProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift

protocol LoginSignUsecaseProtocol {
    func login(email: String, password: String)
    func checkEmailValid(email: String) -> Bool
    func checkPasswordValid(password: String) -> Bool
    func checkNickNameValid(nickName: String) -> Bool
    
    func getTempPassword(email: String) -> Observable<Bool>
    
    func checkEmailValidation(email: String) -> Observable<Bool>
    func checkEmailCode(email: String, code: String) -> Observable<Bool>
    func sendAuthenCode(email: String)
    func signUp(signUp: SignUp) -> Observable<SignUpResponse>
}
