//
//  AppCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import UIKit

class AppCoordinator: AppCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .app }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) != nil {
            self.showTabBarFlow()
        } else {
            self.showLoginFlow()
        }
    }
    
    func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator) // add dependency
    }
    
    func showTabBarFlow() {
        let tabBarCoordinator = TabBarCoordinator(self.navigationController)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
    
}

extension AppCoordinator: CoordinatorFinishDelegate { // 로그인 coordinator 끝나고 다른 coordinator로 이동
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        self.navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .tab:
            self.showLoginFlow()
        case .login:
            self.showTabBarFlow()
        
        default:
            break
        }
    }
}
