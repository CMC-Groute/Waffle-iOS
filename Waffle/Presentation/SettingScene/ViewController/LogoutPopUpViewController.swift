//
//  LogoutPopUpViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import RxSwift

class LogoutPopUpViewController: UIViewController {
    @IBOutlet weak var framwView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var OKButton: UIButton!
    
    var coordinator: SettingCoordinator!
    var usecase: UserUsecase!
    var disposBag = DisposeBag()
    
    convenience init(coordinator: SettingCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func configureUI(){
        self.framwView.round(width: 0, color: "", value: 20)
        self.cancelButton.round(corner: 24)
        self.OKButton.round(corner: 24)
    }
    

    private func bindUI(){
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.coordinator.popToRootViewController(with: nil)
            }).disposed(by: disposBag)
        
        OKButton.rx.tap
            .subscribe(onNext: {
                self.usecase.logout()
                self.coordinator.finish() // go to loinCoordinator
            }).disposed(by: disposBag)
    }

}
