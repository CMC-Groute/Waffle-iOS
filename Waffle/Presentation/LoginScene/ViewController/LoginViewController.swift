//
//  LoginViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var findPWButton: UIButton!
    
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var emailInvalidText: UILabel!
    @IBOutlet weak var passwordInvalidText: UILabel!
    @IBOutlet weak var lastButtonView: UIStackView!
    
    var viewModel: LoginViewModel?
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resignForKeyboardNotification()
        bindViewModel()
        configureUI()
    }
    
    func resignForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
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
                  , animations: { //6, 20
                      self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + self.view.safeAreaInsets.bottom)
                  }
              )
        }

      }
      
      @objc func keyboardWillHide(notification: NSNotification) {
          UIView.animate(
              withDuration: 0.3
              , animations: {
                  self.view.transform = CGAffineTransform(translationX: 0, y: 0)
              }
          )
      }
    
    func configureUI() {
        UITextField.appearance().tintColor = UIColor(named: Asset.Colors.orange.name)
        loginButton.makeRounded(corner: 26)
        emailTextField.changePlaceHolderColor()
        emailTextField.makeRounded(corner: 10)
        emailTextField.padding(value: 9, icon: Asset.Assets.errorCircleRounded.name)
        passwordTextField.changePlaceHolderColor()
        passwordTextField.makeRounded(corner: 10)
        passwordTextField.padding(value: 9, icon: Asset.Assets.errorCircleRounded.name)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let backButtonImage = Asset.Assets.btn.image
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: nil, action: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input(emailTextField: self.emailTextField.rx.text.orEmpty.asObservable(), passwordTextField: self.passwordTextField.rx.text.orEmpty.asObservable(), emailTextFieldDidTapEvent: self.emailTextField.rx.controlEvent(.editingDidBegin), passwordTextFieldDidTapEvent: self.passwordTextField.rx.controlEvent(.editingDidBegin), emailTextFieldDidEndEvent: self.emailTextField.rx.controlEvent(.editingDidEnd), passwordTextFieldDidEndEvent: self.passwordTextField.rx.controlEvent(.editingDidEnd), loginButton: self.loginButton.rx.tap.asObservable(), signInButton: self.signUpButton.rx.tap.asObservable(), findPWButton: self.findPWButton.rx.tap.asObservable())
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        output?.emailInvalidMessage
            .subscribe(onNext: { [weak self] bool in
                guard let self = self else { return }
                self.emailInvalidText.isHidden = bool
                self.emailTextField.errorBorder(bool: bool)
            }).disposed(by: disposeBag)
        
        
        output?.passwordInvalidMessage
            .subscribe(onNext: { [weak self] bool in
                guard let self = self else { return }
                self.passwordInvalidText.isHidden = bool
                self.passwordTextField.errorBorder(bool: bool)
            }).disposed(by: disposeBag)
        
        input.emailTextFieldDidTapEvent
            .subscribe(onNext: {
                self.emailTextField.focusingBorder(color: Asset.Colors.orange.name)
                self.passwordTextField.focusingBorder(color: nil)
            })
            .disposed(by: self.disposeBag)
        
        input.passwordTextFieldDidTapEvent
            .subscribe(onNext: {
                self.passwordTextField.focusingBorder(color: Asset.Colors.orange.name)
                self.emailTextField.focusingBorder(color: nil)
            })
            .disposed(by: self.disposeBag)
        
        input.emailTextFieldDidEndEvent
            .subscribe(onNext: {
                self.emailTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
                
        input.passwordTextFieldDidEndEvent
            .subscribe(onNext: {
                self.passwordTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        output?.loginButtonEnabled
            .subscribe(onNext: { bool in

                switch bool {
                case true:
                    self.loginButton.setEnabled(color: Asset.Colors.black.name)
                case false:
                    self.loginButton.setUnEnabled(color: Asset.Colors.gray4.name)
                }
            }).disposed(by: disposeBag)
    }
    
}
