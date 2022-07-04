//
//  LoginRepository.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import Combine

class LoginSignRepository: LoginSignRepositoryProtocol {
    let service: URLSessionNetworkService
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: URLSessionNetworkService) {
        self.service = networkService
    }
    
    func login(loginInfo: Login) -> AnyPublisher<LoginResponse, Error> {
        print("login repository")
        let api = LoginSignAPI.login(login: loginInfo)
        return service.request(api, responseType: LoginResponse.self)
            .eraseToAnyPublisher()
    }
    
    func singUp(signUpInfo: SignUp) {
        print("singUp repository")
        let api = LoginSignAPI.signUp(signUp: signUpInfo)
        service.request(api, responseType: SignUp.self)
   
    }
    
    func sendEmail(email: String) -> AnyPublisher<DefaultResponse, Error> {
        print("login repository sendEmail")
        return service.defaultRequest(LoginSignAPI.sendEmail(email: email))
            .eraseToAnyPublisher()
    }
    
    func checkEmailCode(email: String, code: String) {
        
    }
    
    func findPW(email: String) {
        
    }
    
}
