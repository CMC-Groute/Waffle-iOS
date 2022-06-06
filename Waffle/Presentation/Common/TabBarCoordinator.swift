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
        let mapTabItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        let homeTabItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        let settingTabItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        return UITabBarItem(title: nil, image: UIImage(named: page.tabIconName()), tag: page.pageOrderNumber())
    }
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        self.navigationController.pushViewController(tabBarController, animated: true)
    }
    
    func startTabCoordinator(of page: TabBarPage, to navigationVewController: UINavigationController) {
//        switch page {
//        case .map:
//        case .home:
//        case .setting
//        }
        
        
    }
    
}
