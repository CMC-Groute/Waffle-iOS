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
        self.navigationController.setNavigationBarHidden(false, animated: true)
        self.signUpViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
    }
            
    func start() {
        self.signUpViewController.viewModel = SignUpViewModel(coordinator: self, usecase: LoginSignUsecase(repository: LoginSignRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func termsStep() {
        let termsViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        termsViewController.coordinator = self
        self.navigationController.pushViewController(termsViewController, animated: true)
    }
    
    func setProfileImage() {
        let setProfileImageViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SetProfileImageViewController") as! SetProfileImageViewController
        setProfileImageViewController.viewModel = SetProfileImageViewModel(coordinator: self, usecase: LoginSignUsecase(repository: LoginSignRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(setProfileImageViewController, animated: true)
    }
    
}
