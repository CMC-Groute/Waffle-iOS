//
//  TabBarCoordinator.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/06.
//

import UIKit

class TabBarCoordinator: TabBarCoordinatorProtocol {
    
    var tabBarController: TabBarViewController
    var navigationController: UINavigationController

    var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: true)
        self.tabBarController = TabBarViewController()
    }
    
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map({
            self.createTabNavigationController(of: $0)
        })
        self.configureTabBarController(with: controllers)
    }
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        self.navigationController.pushViewController(tabBarController, animated: true)

        self.tabBarController.view.backgroundColor = .none
        self.tabBarController.tabBar.backgroundColor = .none
        self.tabBarController.tabBar.layer.borderColor = Asset.Colors.gray2.color.cgColor
        self.tabBarController.tabBar.layer.borderWidth = 1
        self.tabBarController.tabBar.tintColor = .black
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
        tabNavigationController.setNavigationBarHidden(true, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
        self.startTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }
    
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        let tabBar = UITabBarItem(
            title: nil,
            image: UIImage(named: page.tabIconName())?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "\(page.tabIconName())-selected")?.withRenderingMode(.alwaysOriginal))
        tabBar.tag = page.pageOrderNumber()
        return tabBar
        
    }
    
    func startTabCoordinator(of page: TabBarPage, to navigationVewController: UINavigationController) {
        switch page {
//        case .map:
//            let mapCoordinator = MapCoordinator(navigationVewController)
//            mapCoordinator.finishDelegate = self
//            self.childCoordinators.append(mapCoordinator)
//            mapCoordinator.start()
        case .home:
            let homeCoordinator = HomeCoordinator(navigationVewController)
            tabBarController.coordinator = homeCoordinator
            homeCoordinator.finishDelegate = self
            self.childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .archive:
            WappleLog.debug("archive")
            
        case .setting:
            let settingCoordinator = SettingCoordinator(navigationVewController)
            settingCoordinator.finishDelegate = self
            self.childCoordinators.append(settingCoordinator)
            settingCoordinator.start()
       }
    }
    
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        self.navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .setting: // setting ๋๋๋ฉด ๋ก๊ทธ์ธ์ผ๋ก ๊ฐ
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)

        default:
            break
        }
    }
}
