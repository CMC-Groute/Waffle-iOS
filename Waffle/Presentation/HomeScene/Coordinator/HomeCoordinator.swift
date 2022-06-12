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
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .home
    func start() {
        
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
}
