//
//  UserUsecaseProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

protocol LoginSignUsecaseProtocol {
    func login(email: String, password: String)
    func checkEmailValid(email: String) -> Bool
    func checkPasswordValid(password: String) -> Bool
    func checkNickNameValid(nickName: String) -> Bool

    func signUp(email: String, password: String, profile: String, nickName: String, isAgreedMarketing: Bool) 
    func getTempPassword(email: String)
    
    func checkEmailValidation(email: String) -> Observable<Bool>
    func sendAuthenCode(email: String)
}
