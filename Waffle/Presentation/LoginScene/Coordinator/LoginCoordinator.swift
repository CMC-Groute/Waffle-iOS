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
    
    func start() { 
        self.loginViewController.viewModel = LoginViewModel(loginSignUseCase: LoginSignUsecase(repository: LoginSignRepository(networkService: URLSessionNetworkService())), coordinator: self)
        self.navigationController.viewControllers = [self.loginViewController]
    }
    
    func showSignUpFlow() {
        let signUpCoordinator = SignUpCoordinator(navigationController)
        signUpCoordinator.finishDelegate = self
        self.childCoordinators.append(signUpCoordinator)
        signUpCoordinator.start()
    }
    
    func showFindPWViewController() {
        let findPWViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FindPWViewController") as! FindPWViewController
        findPWViewController.viewModel = FindPWViewModel(usecase: LoginSignUsecase(repository: LoginSignRepository(networkService: URLSessionNetworkService())), coordinator: self)
        self.navigationController.setNavigationBarHidden(false, animated: true)
        self.navigationController.pushViewController(findPWViewController, animated: true)
    }
    
    func popToViewController(with toastMessage: String?, width: CGFloat, height: CGFloat, corner: CGFloat) {
        self.navigationController.popViewController(animated: true)
        if let toastMessage = toastMessage {
            self.navigationController.topViewController?.showToast(message: toastMessage, width: width, height: height, corner: corner)
        }
    }
    
    func popToRootViewController() {
        self.navigationController.popToRootViewController(animated: true)
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}

extension LoginCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .signUp:
            self.navigationController.popToRootViewController(animated: true)
        default:
            print(childCoordinator.type)
        }
    }
}
