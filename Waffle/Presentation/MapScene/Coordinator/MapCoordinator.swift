//
//  MapCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import UIKit

final class MapCoordinator: MapCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .map
    
    func start() {
        
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
}
