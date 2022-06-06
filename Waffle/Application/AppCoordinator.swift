//
//  AppCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation

class AppCoordinator: AppCoordinatorProtocol {

    func start() {
        if UserDefaults.standard.bool(forKey: UserDefaultKey.isLoggedIn) {
            self.showTabBarFlow()
        } else {
            self.showLoginFlow()
        }
    }
    
    func showLoginFlow() {
        <#code#>
    }
    
    func showTabBarFlow() {
        <#code#>
    }
    
    
}
