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
    }
    
    func singUp(signUpInfo: SignUp) {
        print("singUp repository")
        let api = LoginSignAPI.signUp(signUp: signUpInfo)
        service.request(api, responseType: SignUp.self)
    }
    
    func sendEmail(email: String) {
        print("login repository sendEmail")
        service.defaultRequest(LoginSignAPI.sendEmail(email: email))
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { (error) in
                print("failed: \(String(describing: error))")
            }, receiveValue: { (result) in
                print("login \(result)")
            }).store(in: &cancellables)
            
    }
    
    func checkEmailCode(email: String, code: String) {
        
    }
    
    func findPW(email: String) {
        
    }
    
}
