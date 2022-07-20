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
        self.settingViewController.viewModel = SettingViewModel(coordinator: self, usecase: UserUsecase(repository: UserRepository(networkService: URLSessionNetworkService())))
        self.navigationController.setNavigationBarHidden(true, animated: true)
        self.navigationController.viewControllers = [self.settingViewController]
    }
    
    func editProfile(nickName: String, selectedIndex: Int) {
        self.navigationController.setNavigationBarHidden(false, animated: true)
        let editSettingViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "EditSettingViewController") as! EditSettingViewController
        editSettingViewController.viewModel = EditSettingViewModel(coordinator: self, usecase: UserUsecase(repository: UserRepository(networkService: URLSessionNetworkService())))
        editSettingViewController.viewModel?.nickName = nickName
        editSettingViewController.viewModel?.selectedIndex = selectedIndex
        self.navigationController.pushViewController(editSettingViewController, animated: true)
    }
    
    func changePassword() {
        self.navigationController.setNavigationBarHidden(false, animated: true)
        let changePWViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "ChangePWViewController") as! ChangePWViewController
        changePWViewController.viewModel = ChangePWViewModel(coordinator: self, usecase: UserUsecase(repository: UserRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(changePWViewController, animated: true)
    }
    
    func logout() {
        let logoutPopUpView = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "LogoutPopUpViewController") as! LogoutPopUpViewController
        logoutPopUpView.coordinator = self
        logoutPopUpView.usecase = UserUsecase(repository: UserRepository(networkService: URLSessionNetworkService()))
        logoutPopUpView.modalPresentationStyle = .overFullScreen
        logoutPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(logoutPopUpView, animated: false)
    }
    
    func quit() {
        let quitPopUpView = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "QuitPopUpViewController") as! QuitPopUpViewController
        quitPopUpView.coordinator = self
        quitPopUpView.usecase = UserUsecase(repository: UserRepository(networkService: URLSessionNetworkService()))
        quitPopUpView.modalPresentationStyle = .overFullScreen
        quitPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(quitPopUpView, animated: false)
    }
    
    func popToRootViewController(with toastMessage: String?, width: CGFloat?, height: CGFloat?) {
        self.navigationController.popToRootViewController(animated: true)
        if let toastMessage = toastMessage, let width = width, let height = height {
            self.navigationController.topViewController?.showToast(message: toastMessage, width: width, height: height, corner: 17)
        }
    }
    
    func dismissViewController(with toastMessage: String?) {
        self.navigationController.dismiss(animated: true)
        if let toastMessage = toastMessage {
            self.navigationController.topViewController?.showToast(message: toastMessage, width: 110, height: 55)
        }
    }
    
    func finish() {
        self.navigationController.modalTransitionStyle = .flipHorizontal
        self.navigationController.dismiss(animated: true)
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
