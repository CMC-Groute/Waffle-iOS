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
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .archive
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {}
    
    func addArchive() {
        let addArchiveViewcontroller = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "AddArchiveViewController") as! AddArchiveViewController
        addArchiveViewcontroller.viewModel = AddArchiveModel(usecase: ArchiveUseCase(repository: ArchiveRepository(networkService: URLSessionNetworkService())), coordinator: self)
        self.navigationController.pushViewController(addArchiveViewcontroller, animated: true)
    }
    
    func addLocation() {
        let addLocationViewController = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        self.navigationController.pushViewController(addLocationViewController, animated: true)
    }
    
    func inputCodeArchive() {
        let inputArchiveCodeViewController = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "InputArchiveCodeViewController") as! InputArchiveCodeViewController
        inputArchiveCodeViewController.viewModel = InputArchiveCodeViewModel(usecase: ArchiveUseCase(repository: ArchiveRepository(networkService: URLSessionNetworkService())), coordinator: self)
        self.navigationController.pushViewController(inputArchiveCodeViewController, animated: true)

    }
    
    func popTonavigaionController() {
        self.navigationController.popViewController(animated: true)
    }
    
    
}
