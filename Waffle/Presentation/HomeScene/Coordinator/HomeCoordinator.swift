//
//  HomeCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import UIKit

final class HomeCoordinator: HomeCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var homeViewController: HomeViewController
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .home
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(false, animated: true)
        self.homeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    func start() {
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    func addArchive() {
        
    }
    
    
}
