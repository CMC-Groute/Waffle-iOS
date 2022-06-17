//
//  TabBarCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import UIKit

class TabBarCoordinator: TabBarCoordinatorProtocol {
    
    var tabBarController: UITabBarController
    var navigationController: UINavigationController

    var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map({
            self.createTabNavigationController(of: $0)
        })
        self.configureTabBarController(with: controllers)
    }
    
    
    func currentPage() -> TabBarPage? {
        TabBarPage(index: self.tabBarController.selectedIndex)
    }
    
    func selectPage(_ page: TabBarPage) {
        self.tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        self.tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
        self.startTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }
    
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        return UITabBarItem(
            title: nil,
            image: UIImage(named: page.tabIconName())?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "\(page.tabIconName())-selected")?.withRenderingMode(.alwaysOriginal))
        
    }
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        self.navigationController.pushViewController(tabBarController, animated: true)
        
        self.tabBarController.view.backgroundColor = .none
        self.tabBarController.tabBar.backgroundColor = .none
        self.tabBarController.tabBar.tintColor = .black
        
    }
    
    func startTabCoordinator(of page: TabBarPage, to navigationVewController: UINavigationController) {
        switch page {
        case .map:
            let mapCoordinator = MapCoordinator(navigationVewController)
            mapCoordinator.finishDelegate = self
            self.childCoordinators.append(mapCoordinator)
            mapCoordinator.start()
        case .home:
            let homeCoordinator = HomeCoordinator(navigationVewController)
            homeCoordinator.finishDelegate = self
            self.childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .setting:
            let settingCoordinator = SettingCoordinator(navigationVewController)
            settingCoordinator.finishDelegate = self
            self.childCoordinators.append(settingCoordinator)
            settingCoordinator.start()
        case .archive:
            let archiveCoordinator = ArchiveCoordinator(navigationVewController)
            archiveCoordinator.finishDelegate = self
            self.childCoordinators.append(archiveCoordinator)
            archiveCoordinator.start()
        
       }
        
        
    }
    
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        self.navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .setting: // setting 끝나면 로그인으로 감
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)

        default:
            break
        }
    }
}
