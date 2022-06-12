//
//  ArchiveCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import UIKit

final class ArchiveCoordinator: ArchiveCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var archiveViewController: ArchiveViewController
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .archive
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        archiveViewController = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "ArchiveViewController") as! ArchiveViewController
        
    }
    
    func start() {
        self.navigationController.viewControllers = [archiveViewController]
    }
    
    func addArchive() {
        let addArchiveViewcontroller = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "addArchiveViewController") as! AddArchiveViewController
        self.navigationController.pushViewController(addArchiveViewcontroller, animated: true)
    }
    
    func addLocation() {
        let addLocationViewController = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        self.navigationController.pushViewController(addLocationViewController, animated: true)
    }
    
    
}
