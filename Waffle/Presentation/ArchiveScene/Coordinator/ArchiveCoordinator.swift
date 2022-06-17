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
        archiveViewController.viewModel = ArchiveViewModel(usecase: ArchiveUseCase(repository: ArchiveRepository(networkService: URLSessionNetworkService())), coordinator: self)
        self.navigationController.viewControllers = [archiveViewController]
    }
    
    func inputArchive() {
        let inputArchiveCodeViewController = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "InputArchiveViewController") as! InputArchiveCodeViewController
        inputArchiveCodeViewController.viewModel = InputArchiveViewModel(usecase: ArchiveUseCase(repository: ArchiveRepository(networkService: URLSessionNetworkService())), coordinator: self)
        self.navigationController.pushViewController(inputArchiveCodeViewController, animated: true)
        
    }
    
    func addArchive() {
        let addArchiveViewcontroller = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "AddArchiveViewController") as! AddArchiveViewController
        addArchiveViewcontroller.viewModel = AddArchiveModel(usecase: ArchiveUseCase(repository: ArchiveRepository(networkService: URLSessionNetworkService())), coordinator: self)
        self.navigationController.pushViewController(addArchiveViewcontroller, animated: true)
    }
    
    func addLocation() {
        let addLocationViewController = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        self.navigationController.pushViewController(addLocationViewController, animated: true)
    }
    
    func popTonavigaionController() {
        self.navigationController.popViewController(animated: true)
    }
    
    
}
