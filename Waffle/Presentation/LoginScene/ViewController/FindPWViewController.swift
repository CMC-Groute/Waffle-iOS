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
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    var viewModel: FindPWViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureUI()
        resignForKeyboardNotification()

    }
    
    private func configureUI() {
        self.getTempPWButton.round(corner: 25)
        emailTextField.round(corner: 10)
        emailTextField.padding(value: 9, direction: .left, icon: Asset.Assets.errorCircleRounded.name)
    }
    
    func resignForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    //notification delete
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
          if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
              let keyboardReactangle = keyboardFrame.cgRectValue
              let keyboardHeight = keyboardReactangle.height
              UIView.animate(
                  withDuration: 0.3
                  , animations: {
                      self.bottonConstraint.constant = -keyboardHeight //+ //self.view.safeAreaInsets.bottom
                      print(self.bottonConstraint.constant)
                  }
              )
        }

      }
      
      @objc func keyboardWillHide(notification: NSNotification) {
          UIView.animate(
              withDuration: 0.3
              , animations: {
                  self.bottonConstraint.constant = 0
              }
          )
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
