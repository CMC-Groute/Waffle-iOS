//
//  LogoutPopUpViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import RxSwift

final class LogoutPopUpViewController: UIViewController {
    
    @IBOutlet weak var framwView: UIView!
    @IBOutlet weak var frameBackgroundView: UIView!
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
        self.framwView.makeRounded(width: 0, borderColor: "", value: 20)
        self.cancelButton.makeRounded(corner: 24)
        self.OKButton.makeRounded(corner: 24)
        let frameGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        frameBackgroundView.addGestureRecognizer(frameGestureRecognizer)
    }
    
    @objc private func didTapView(gesture: UITapGestureRecognizer) {
           switch gesture.view {
           case frameBackgroundView:
               self.coordinator.dismissViewController(with: nil)
            default:
                break
            }
       }
    

    private func bindUI(){
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator.dismissViewController(with: nil)
            }).disposed(by: disposBag)
        
        OKButton.rx.tap
            .subscribe(onNext: {
                self.usecase.logout()
                self.coordinator.finish() // go to loinCoordinator
            }).disposed(by: disposBag)
    }

}
