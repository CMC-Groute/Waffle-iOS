//
//  SignUpCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/10.
//

import Foundation
import UIKit

final class SignUpCoordinator: SignUpCoordinatorProtocol {
   
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var signUpViewController: SignUpViewController
    
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .signUp
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.signUpViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "signUpViewController") as! SignUpViewController
    }
            
    func start() {
        self.signUpViewController.viewModel = SignUpViewModel()
        self.navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func termsStep() {
        
    }
    
    func setProfileImage() {
        
    }
    
}
