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
        self.navigationController.setNavigationBarHidden(true, animated: true)
    }
  
    func start() {
        
        self.navigationController.pushViewController(settingViewController, animated: true)
    }
    
    func editProfile() {
        
    }
    
    func changePassword() {
        
    }
    
    func logout() {
        
    }
    
    func quit() {
        
    }
    
   
    
    
}
