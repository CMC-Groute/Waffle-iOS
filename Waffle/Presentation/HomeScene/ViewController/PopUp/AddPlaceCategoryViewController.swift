//
//  AddPlaceCategoryViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class AddPlaceCategoryViewController: UIViewController {
    var coordinator: HomeCoordinator!
    var disposBag = DisposeBag()
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}