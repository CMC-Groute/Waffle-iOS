//
//  ArchiveDetailPopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class ArchiveDetailPopUpViewController: UIViewController {
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var editArchiveButton: UIButton!
    @IBOutlet weak var deleteArchiveButton: UIButton!
    @IBOutlet weak var likeArchiceButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        bindViewModel()
        configureUI()
    }
    
    private func configureUI() {
        frameView.roundCorners(value: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        cancelButton.round(width: 1, color: Asset.Colors.gray5.name, value: 26)
    }
    
    private func bindUI() {
        editArchiveButton.rx.tap
            .subscribe(onNext: {
                self.coordinator.editArchive()
            }).dispose()
        
        deleteArchiveButton.rx.tap
            .subscribe(onNext: {
                self.coordinator.arhiveDelete()
            }).dispose()
        
        likeArchiceButton.rx.tap
            .subscribe(onNext: {
                self.coordinator.likeSend()
            }).dispose()
        
        
    }
    
    private func bindViewModel() {
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    
}
