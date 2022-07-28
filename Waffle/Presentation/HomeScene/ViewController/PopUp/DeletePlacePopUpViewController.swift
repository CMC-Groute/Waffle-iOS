//
//  DeletePlacePopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import UIKit
import RxSwift

final class DeletePlacePopUpViewController: UIViewController {
    
    @IBOutlet private weak var framwView: UIView!
    @IBOutlet private weak var framwBackgroundView: UIView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    private var disposBag = DisposeBag()
    
    
    var coordinator: HomeCoordinator!
    var usecase: HomeUsecase!
    var placeId: Int?
    var archiveId: Int?
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func configureUI(){
        self.framwView.makeRounded(width: 0, borderColor: "", value: 20)
        self.cancelButton.makeRounded(corner: 24)
        self.deleteButton.makeRounded(corner: 24)
    }
    
    private func bindUI(){
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
            }).disposed(by: disposBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let archiveId = self.archiveId, let placeId = self.placeId else {
                    return
                }

                self.usecase.deletePlace(archiveId: archiveId, placeId: placeId)
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
                self.coordinator.popViewController()
            }).disposed(by: disposBag)
    }
}
