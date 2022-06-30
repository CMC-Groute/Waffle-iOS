//
//  ParticiPopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class ParticiPopUpViewController: UIViewController {
    var coordinator: HomeCoordinator!
    var disposBag = DisposeBag()
    
    @IBOutlet private weak var frameView: UIView!
    @IBOutlet private weak var countLabel: UIView!
    @IBOutlet private weak var tableVuew: UITableView!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        tableVuew.delegate = self
        tableVuew.dataSource = self
    }

}


extension ParticiPopUpViewController: UITableViewDelegate {
    
}

extension ParticiPopUpViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
}
