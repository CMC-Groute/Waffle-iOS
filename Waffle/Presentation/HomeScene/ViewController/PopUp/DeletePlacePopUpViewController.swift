//
//  DeletePlacePopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import UIKit
import RxSwift

class DeletePlacePopUpViewController: UIViewController {
    var coordinator: HomeCoordinator!
    var disposBag = DisposeBag()
    var usecase: HomeUsecase!
    var placeId: Int!
    
    @IBOutlet weak var framwView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
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
        self.framwView.makeRounded(width: 0, color: "", value: 20)
        self.cancelButton.makeRounded(corner: 24)
        self.deleteButton.makeRounded(corner: 24)
    }
    

    private func bindUI(){
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
            }).disposed(by: disposBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: {
                self.usecase.deletePlace(placeId: self.placeId)
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
                self.coordinator.popViewController()
            }).disposed(by: disposBag)
    }
}
