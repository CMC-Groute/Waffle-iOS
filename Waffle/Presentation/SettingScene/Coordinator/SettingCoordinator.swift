//
//  SettingCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import UIKit

final class SettingCoordinator: SettingCoordinatorProtocol {

    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var settingViewController: SettingViewController
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .setting
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.settingViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        
    }
  
    func start() {
        self.settingViewController.viewModel = SettingViewModel(coordinator: self, usecase: UserUseCase(repository: UserRepository(networkService: URLSessionNetworkService())))
        self.navigationController.setNavigationBarHidden(true, animated: true)
        self.navigationController.viewControllers = [self.settingViewController]
    }
    
    func editProfile() {
        self.navigationController.setNavigationBarHidden(false, animated: true)
        let editSettingViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "EditSettingViewController") as! EditSettingViewController
        editSettingViewController.viewModel = EditSettingViewModel(coordinator: self, usecase: UserUseCase(repository: UserRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(editSettingViewController, animated: true)
    }
    
    func changePassword() {
        self.navigationController.setNavigationBarHidden(false, animated: true)
        let changePWViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "ChangePWViewController") as! ChangePWViewController
        changePWViewController.viewModel = ChangePWViewModel(coordinator: self, usecase: UserUseCase(repository: UserRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(changePWViewController, animated: true)
    }
    
    func logout() {
        let logoutPopUpView = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "LogoutPopUpViewController") as! LogoutPopUpViewController
        logoutPopUpView.coordinator = self
        logoutPopUpView.usecase = UserUseCase(repository: UserRepository(networkService: URLSessionNetworkService()))
        self.navigationController.pushViewController(logoutPopUpView, animated: true)
    }
    
    func quit() {
        let quitPopUpView = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "QuitPopUpViewController") as! QuitPopUpViewController
        quitPopUpView.coordinator = self
        quitPopUpView.usecase = UserUseCase(repository: UserRepository(networkService: URLSessionNetworkService()))
        self.navigationController.pushViewController(quitPopUpView, animated: true)
    }
    
    func popToRootViewController(with toastMessage: String?) {
        self.navigationController.popViewController(animated: true)
        if let toastMessage = toastMessage {
            self.navigationController.topViewController?.showToast(message: toastMessage)
        }
    }
}
