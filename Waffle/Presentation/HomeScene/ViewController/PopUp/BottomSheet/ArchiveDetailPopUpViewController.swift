//
//  ArchiveDetailPopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class ArchiveDetailPopUpViewController: UIViewController {
    
    @IBOutlet weak var editArchive: UIButton!
    @IBOutlet weak var deleteArchive: UIButton!
    @IBOutlet weak var likeArchice: UIButton!
    
    var coordinator: HomeCoordinator!
    var disposBag = DisposeBag()
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    private func bindUI() {
        editArchive.rx.tap
            .subscribe(onNext: {
                self.coordinator.editArchive()
            }).dispose()
        
        deleteArchive.rx.tap
            .subscribe(onNext: {
                self.coordinator.arhiveDelete()
            }).dispose()
        
        likeArchice.rx.tap
            .subscribe(onNext: {
                self.coordinator.likeSend()
            }).dispose()
        
        
    }
    
}
