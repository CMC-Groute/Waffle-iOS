//
//  LoginRepositoryProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import Combine

protocol LoginSignRepositoryProtocol {
    //MARK: FROM
    func singUp(signUpInfo: SignUp)
    func sendEmail(email: String) -> AnyPublisher<DefaultResponse, Error>
    func checkEmailCode(email: String, code: String)
    func findPW(email: String)
    func login(loginInfo: Login) -> AnyPublisher<LoginResponse, Error>

}
