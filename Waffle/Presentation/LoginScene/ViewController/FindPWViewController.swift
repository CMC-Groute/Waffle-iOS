//
//  FindPWViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/08.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class FindPWViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var getTempPWButton: UIButton!
    @IBOutlet weak var emailInvalidText: UILabel!
    
    let disposeBag = DisposeBag()
    var viewModel: FindPWViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        keyboardLayout()
        configureUI()

    }
    
    private func configureUI() {
        self.getTempPWButton.round(corner: 25)
        emailTextField.round(corner: 10)
        emailTextField.padding(value: 9, direction: .left, icon: Asset.Assets.errorCircleRounded.name)
    }
    
    private func keyboardLayout() {
        self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.getTempPWButton.bottomAnchor).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func bindViewModel(){
        let input = FindPWViewModel.Input(emailTextField: self.emailTextField.rx.text.orEmpty.asObservable(), emailTextFieldDidTapEvent: self.emailTextField.rx.controlEvent(.editingDidBegin), emailTextFieldDidEndEvent: self.emailTextField.rx.controlEvent(.editingDidEnd), getTempPWButton: self.getTempPWButton.rx.tap.asObservable())
        
        input.emailTextFieldDidTapEvent
            .subscribe(onNext: {
                self.emailTextField.focusingBorder(color: Asset.Colors.orange.name)
            })
            .disposed(by: self.disposeBag)
        
        input.emailTextFieldDidEndEvent
            .subscribe(onNext: {
                self.emailTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
                
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.getTempPWButtonEnabled
            .subscribe(onNext: { bool in
                switch bool {
                case true:
                    self.getTempPWButton.setEnabled(color: Asset.Colors.black.name)
                case false:
                    self.getTempPWButton.setUnEnabled(color: Asset.Colors.gray4.name)
                }
            }).disposed(by: disposeBag)
        
        output?.emailInvalidMessage
            .subscribe(onNext: { [weak self] bool in
                guard let self = self else { return }
                self.emailInvalidText.isHidden = bool
                self.emailTextField.errorBorder(bool: bool)
            }).disposed(by: disposeBag)
        
    }
}
