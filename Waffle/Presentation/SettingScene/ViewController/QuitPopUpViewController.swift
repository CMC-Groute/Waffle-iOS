//
//  QuitPopUpViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import RxSwift

class QuitPopUpViewController: UIViewController {
    @IBOutlet weak var framwView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var OKButton: UIButton!
    
    var coordinator: SettingCoordinator!
    var usecase: UserUseCase!
    var disposBag = DisposeBag()
    
    convenience init(coordinator: SettingCoordinator, usecase: UserUseCase){
        self.init()
        self.coordinator = coordinator
        self.usecase = usecase
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
                self.usecase.quit()
                exit(0)
            }).disposed(by: disposBag)
    }
    

}
