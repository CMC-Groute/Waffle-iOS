//
//  LoginCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import UIKit

final class LoginCoordinator: LoginCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    var loginViewController: LoginViewController
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .login
    
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() { // DI 의존성 주입 할 것
        self.loginViewController.viewModel = LoginViewModel(userUseCase: UserUseCase(repository: UserRepository(networkService: URLSessionNetworkService())), coordinator: self)
        self.navigationController.viewControllers = [self.loginViewController]
    }
    
    func showSignUpFlow() {
        
    }
    
    func showFindPWViewController() {
        
    }
    
}
