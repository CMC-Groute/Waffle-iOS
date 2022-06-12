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
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .setting
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        
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
