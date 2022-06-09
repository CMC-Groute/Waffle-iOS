//
//  LoginRepository.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import Combine

class UserRepository: UserRepositoryProtocol {
    
    let urlSessionNetworkService: URLSessionNetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: URLSessionNetworkServiceProtocol) {
        self.urlSessionNetworkService = networkService
    }
    
    func login(email: String, password: String) -> AnyPublisher<Bool, Never> {
        print("UserRepository login method")
        let subject = PassthroughSubject<Bool, Never>()
        subject.send(true)
        return subject.eraseToAnyPublisher()
    }
}
