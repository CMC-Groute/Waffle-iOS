//
//  LoginCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import UIKit

class LoginCoordinator: LoginCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    var type: CoordinatorType
    var loginViewController: LoginViewController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.loginViewController = LoginViewController()
    }
    
    func start() { // DI 의존성 주입 할 것
        
    }
    
    func showSignUpFlow() {
        
    }
    
    func showFindIDViewCoontroller() {
        
    }
    
    func showFindPWViewController() {
        
    }
    
}
