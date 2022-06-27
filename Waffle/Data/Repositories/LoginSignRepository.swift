//
//  LoginRepository.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import Combine

class LoginSignRepository: LoginSignRepositoryProtocol {
    let urlSessionNetworkService: URLSessionNetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: URLSessionNetworkServiceProtocol) {
        self.urlSessionNetworkService = networkService
    }
    
    func login(email: String, password: String) -> AnyPublisher<Bool, Never> {
        let subject = PassthroughSubject<Bool, Never>()
        subject.send(true)
        return subject.eraseToAnyPublisher()
    }
    
    func singUp(signUpInfo: SignUp) {
        
    }
    
    func sendEmail(email: String) {
        
    }
    
    func checkEmailCode(email: String, code: String) {
        
    }
    
    func findPW(email: String) {
        
    }
    
}
