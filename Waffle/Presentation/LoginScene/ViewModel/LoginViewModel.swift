//
//  LoginViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation
import Combine

//protocol LoginViewModelInput {
//    func inputEmailTextField()
//    func inputPWTextField()
//
//    func didTapSignButton()
//    func didTapFindPWButton()
//}
//
//protocol LoginViewModelOutput {
//    var emailValidPublisher: AnyPublisher<Bool, Never> { get }
//    var passwordValidPublisher: AnyPublisher<Bool, Never> { get }
//
//}

//typealias LoginViewModelProtocol = LoginViewModelInput & LoginViewModelOutput


class LoginViewModel {
    @Published var emailText: String? = nil
    @Published var passwordText: String? = nil
    private var cancellables: Set<AnyCancellable> = []
    
    private var loginUsecase: LoginUseCase
    private var coordinator: LoginCoordinator!
    
    init(loginUseCase: LoginUseCase, coordinator: LoginCoordinator) {
        self.loginUsecase = loginUseCase
        self.coordinator = coordinator
    }

    
    
}
