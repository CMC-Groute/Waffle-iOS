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
        self.navigationController.pushViewController(archiveViewController, animated: true)
    }
    
    
}
