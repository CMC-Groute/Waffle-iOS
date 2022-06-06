//
//  LoginRepository.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import Combine

class LoginRepository: LoginRepositoryProtocol {
    private let urlSessionNetworkService: URLSessionNetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: URLSessionNetworkServiceProtocol) {
        self.urlSessionNetworkService = networkService
    }
    
    
}
