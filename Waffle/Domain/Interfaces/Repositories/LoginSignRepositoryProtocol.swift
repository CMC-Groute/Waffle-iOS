//
//  LoginRepositoryProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift
protocol LoginSignRepositoryProtocol {
    //MARK: FROM
//    func singUp(signUpInfo: SignUp)
//    func sendEmail(email: String) -> AnyPublisher<DefaultResponse, Error>
//    func checkEmailCode(email: String, code: String) -> -> AnyPublisher<DefaultResponse, Error>
//    func findPW(email: String)
    func login(loginInfo: Login) -> Observable<LoginResponse>
    func getTempPassword(email: String) -> Observable<DefaultResponse>

}
