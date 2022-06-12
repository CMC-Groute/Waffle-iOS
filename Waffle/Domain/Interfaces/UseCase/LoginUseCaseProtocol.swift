//
//  UserUseCaseProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserUseCaseProtocol {
    func login(email: String, password: String) -> Observable<String>
    func checkEmailValid(email: String) -> Bool
    func checkPasswordValid(password: String) -> Bool
    func checkNickNameValid(nickName: String) -> Bool

    func signUp(email: String, password: String, profile: Int, nickName: String)
    
    func getTempPassword(email: String)
    
    func checkEmailValidation(email: String) -> Observable<Bool>
    func sendAuthenCode()
}
