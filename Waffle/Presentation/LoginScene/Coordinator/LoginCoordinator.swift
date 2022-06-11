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
        setNavigationBar()
    }
    
    func setNavigationBar() {
        let backImage = UIImage(named: Asset.Assets.btn.name)!.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -80.0), for: .default)
    }
    
    func start() { // DI 의존성 주입 할 것
        self.loginViewController.viewModel = LoginViewModel(userUseCase: UserUseCase(repository: UserRepository(networkService: URLSessionNetworkService())), coordinator: self)
        self.navigationController.viewControllers = [self.loginViewController]
    }
    
    func showSignUpFlow() {
        let signUpCoordinator = SignUpCoordinator(self.navigationController)
        signUpCoordinator.finishDelegate = self
        self.childCoordinators.append(signUpCoordinator)
        signUpCoordinator.start()
    }
    
    func showFindPWViewController() {
        let findPWViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FindPWViewController") as! FindPWViewController
        findPWViewController.viewModel = FindPWViewModel(usecase: UserUseCase(repository: UserRepository(networkService: URLSessionNetworkService())), coordinator: self)
        self.navigationController.setNavigationBarHidden(false, animated: true)
        self.navigationController.pushViewController(findPWViewController, animated: true)
    }
    
    func popToRootViewController(with toastMessage: String?) {
        self.navigationController.popViewController(animated: true)
        if let toastMessage = toastMessage {
            self.navigationController.topViewController?.showToast(message: toastMessage)
        }
    }
    
    func finish() {
        print("finish method")
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
}

extension LoginCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print(childCoordinator)
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        print("what child \(childCoordinators)")
        childCoordinator.navigationController.popViewController(animated: true)
    }
}
