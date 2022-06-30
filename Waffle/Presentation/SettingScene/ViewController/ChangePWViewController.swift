//
//  ChangePWViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift

class ChangePWViewController: UIViewController {
    
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var PWTextField: UITextField!
    @IBOutlet weak var PWTextInValidText: UILabel!
    
    @IBOutlet weak var newPWTextField: UITextField!
    @IBOutlet weak var newPWTextInValidText: UILabel!
    
    @IBOutlet weak var newRePWTextField: UITextField!
    @IBOutlet weak var newRePWTextInValidText: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    var textFields: [UITextField] = []
    var viewModel: ChangePWViewModel?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        resignForKeyboardNotification()
    }


    private func configureUI() {
        textFields = [PWTextField, newPWTextField, newRePWTextField]
        textFields.forEach {
            $0.makeRounded(corner: 10)
            $0.padding(value: 9, icon: Asset.Assets.errorCircleRounded.name)
        }
        doneButton.makeRounded(corner: 26)
        
        func setNavigationBar() {
            self.navigationController?.navigationBar.titleTextAttributes = Common.navigationBarTitle()
            self.navigationItem.title = "비밀번호 변경"
            let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
            navigationItem.leftBarButtonItem = backButton
        }
        setNavigationBar()
    }
    
    @objc func didTapBackButton() {
        viewModel?.back()
    }
    
    func resignForKeyboardNotification() {
        hideKeyboardWhenTappedAround()
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
                      self.bottonConstraint.constant = -keyboardHeight + self.view.safeAreaInsets.bottom - 4 //keyboardHeight 부호 따라가기
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
    
    private func bindViewModel(){
        let input = ChangePWViewModel.Input(passwordTextField: self.PWTextField.rx.text.orEmpty.asObservable(), newPasswordTextField: self.newPWTextField.rx.text.orEmpty.asObservable(), newRePasswordTextField: self.newRePWTextField.rx.text.orEmpty.asObservable(), passwordTextFieldDidTapEvent: self.PWTextField.rx.controlEvent(.editingDidBegin), passwordTextFieldDidEndEvent: self.PWTextField.rx.controlEvent(.editingDidEnd), newPasswordTextFieldDidTapEvent: self.newPWTextField.rx.controlEvent(.editingDidBegin), newPasswordTextFieldDidEndEvent: self.newPWTextField.rx.controlEvent(.editingDidEnd), newRePasswordTextFieldDidTapEvent: self.newRePWTextField.rx.controlEvent(.editingDidBegin), newRePasswordTextFieldDidEndEvent: self.newRePWTextField.rx.controlEvent(.editingDidEnd), doneButton: self.doneButton.rx.tap.asObservable())
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        input.passwordTextFieldDidTapEvent
            .subscribe(onNext: {
                self.PWTextField.focusingBorder(color: Asset.Colors.orange.name)
                let tfs = self.textFields.filter { $0 != self.PWTextField }
                self.notFocusingTextFields(with: tfs)
            }).disposed(by: self.disposeBag)
        
        input.newPasswordTextFieldDidTapEvent
            .subscribe(onNext: {
                self.newPWTextField.focusingBorder(color: Asset.Colors.orange.name)
                let tfs = self.textFields.filter { $0 != self.newPWTextField }
                self.notFocusingTextFields(with: tfs)
            }).disposed(by: self.disposeBag)
        
        input.newRePasswordTextFieldDidTapEvent
            .subscribe(onNext: {
                self.newRePWTextField.focusingBorder(color: Asset.Colors.orange.name)
                let tfs = self.textFields.filter { $0 != self.newRePWTextField }
                self.notFocusingTextFields(with: tfs)
            }).disposed(by: self.disposeBag)
        
        
        input.passwordTextFieldDidEndEvent
            .subscribe(onNext: {
                self.PWTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        input.newPasswordTextFieldDidEndEvent
            .subscribe(onNext: {
                self.newPWTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        input.newRePasswordTextFieldDidEndEvent
            .subscribe(onNext: {
                self.newRePWTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        output?.doneButtonEnabled
            .subscribe(onNext: { bool in
                if bool {
                    self.doneButton.setEnabled(color: Asset.Colors.black.name)
                }else {
                    self.doneButton.setUnEnabled(color: Asset.Colors.gray4.name)
                }
            }).disposed(by: disposeBag)
        
        output?.passwordInValid
            .subscribe(onNext: { bool in
                if let bool = bool {
                    self.PWTextInValidText.isHidden = bool
                    self.PWTextField.errorBorder(bool: bool)
                    if bool {
                        self.PWTextField.changeIcon(value: 9, icon: Asset.Assets.checkCircle.name)
                    }else {
                        
                        self.PWTextField.changeIcon(value: 9, icon: Asset.Assets.errorCircleRounded.name)
                    }
                }else {
                    self.PWTextInValidText.isHidden = true
                    self.PWTextField.errorBorder(bool: true)
                    self.PWTextField.focusingBorder(color: Asset.Colors.orange.name)
                }
               
            }).disposed(by: disposeBag)
        
        output?.newPasswordInValid
            .subscribe(onNext: { bool in
                if let bool = bool {
                    self.newPWTextInValidText.isHidden = bool
                    self.newPWTextField.errorBorder(bool: bool)
                    if bool {
                        self.newPWTextField.changeIcon(value: 9, icon: Asset.Assets.checkCircle.name)
                    }else {
                        
                        self.newPWTextField.changeIcon(value: 9, icon: Asset.Assets.errorCircleRounded.name)
                    }
                }else {
                    self.newPWTextInValidText.isHidden = true
                    self.newPWTextField.errorBorder(bool: true)
                    self.newPWTextField.focusingBorder(color: Asset.Colors.orange.name)
                }
               
            }).disposed(by: disposeBag)
        
        output?.newRePasswordInValid
            .subscribe(onNext: { bool in
                if let bool = bool {
                    self.newRePWTextInValidText.isHidden = bool
                    self.newRePWTextField.errorBorder(bool: bool)
                    if bool {
                        self.newRePWTextField.changeIcon(value: 9, icon: Asset.Assets.checkCircle.name)
                    }else {
                        
                        self.newRePWTextField.changeIcon(value: 9, icon: Asset.Assets.errorCircleRounded.name)
                    }
                }else {
                    self.newRePWTextInValidText.isHidden = true
                    self.newRePWTextField.errorBorder(bool: true)
                    self.newRePWTextField.focusingBorder(color: Asset.Colors.orange.name)
                }
               
            }).disposed(by: disposeBag)
    }
    
    func notFocusingTextFields(with tf: [UITextField]) {
        tf.forEach {
            $0.focusingBorder(color: nil)
        }
    }

}
