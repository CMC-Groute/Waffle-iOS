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
    func checkNickNameValid(nickName: String) -> Bool
    
    func getTempPassword(email: String)
    
    func checkEmailCode(email: String, code: String)
    func sendEmail(email: String) 
    func signUp(signUp: SignUp) -> Observable<DefaultIntResponse>
}
