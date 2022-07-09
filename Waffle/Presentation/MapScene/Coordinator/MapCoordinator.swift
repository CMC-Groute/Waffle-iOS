//
//  MapCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

//import Foundation
//import UIKit
//
//final class MapCoordinator: MapCoordinatorProtocol {
//    var finishDelegate: CoordinatorFinishDelegate?
//
//    var navigationController: UINavigationController
//    var mapViewController: MapViewController
//    var childCoordinators: [Coordinator] = []
//
//    var type: CoordinatorType = .map
//
//    init(_ navigationController: UINavigationController) {
//        self.navigationController = navigationController
//        self.navigationController.setNavigationBarHidden(false, animated: true)
//        self.mapViewController = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//    }
//
//    func start() {
//        self.navigationController.pushViewController(mapViewController, animated: true)
//    }
//
//
//}
