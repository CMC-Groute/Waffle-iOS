//
//  SignUpViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import UIKit
import RxSwift

class SignUpViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailAuthenButton: UIButton!
    @IBOutlet weak var emailInValidText: UILabel!
    
    @IBOutlet weak var authenTextField: UITextField!
    @IBOutlet weak var codeAuthenButton: UIButton!
    @IBOutlet weak var authenInValidText: UILabel!
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwInValidText: UILabel!
    
    @IBOutlet weak var pwReTextField: UITextField!
    @IBOutlet weak var pwReInValidText: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    var viewModel: SignUpViewModel?
    let disposeBag = DisposeBag()
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [self.emailTextField, self.authenTextField, self.pwTextField, self.pwReTextField]
        configureUI()
        resignForKeyboardNotification()
        bindViewModel()
        
    }
    
    private func configureUI(){
        emailAuthenButton.makeRounded(corner: 10)
        codeAuthenButton.makeRounded(corner: 10)
        nextButton.makeRounded(corner: 26)
        textFields.forEach {
            $0.makeRounded(corner: 10)
            $0.padding(value: 9, icon: Asset.Assets.errorCircleRounded.name)
        }
        configureNavigationBar()
    }

    func configureNavigationBar() {
        let backImage = Asset.Assets.btn.image.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton

        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let progressOneButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProgressed1.name)
        let progressTwoButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProcess2.name)
        let progreeeThreeButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProcess3.name)
        
        navigationItem.rightBarButtonItems = [progreeeThreeButton, spacer, progressTwoButton, spacer, progressOneButton]
    }
    
    @objc func didTapBackButton() {
        self.viewModel?.backButton()
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
                      self.bottonConstraint.constant = -keyboardHeight + self.view.safeAreaInsets.bottom - 4
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
    
    
    private func bindViewModel() {
        let input = SignUpViewModel.Input(emailTextField: self.emailTextField.rx.text.orEmpty.asObservable(), authenCodeTextField: self.authenTextField.rx.text.orEmpty.asObservable(), passwordTextField: self.pwTextField.rx.text.orEmpty.asObservable(), rePasswordTextField: self.pwReTextField.rx.text.orEmpty.asObservable(), emailTextFieldDidTapEvent: self.emailTextField.rx.controlEvent(.editingDidBegin), authenCodeTextFieldDidTapEvent: self.authenTextField.rx.controlEvent(.editingDidBegin), passwordTextFieldDidTapEvent: self.pwTextField.rx.controlEvent(.editingDidBegin), rePasswordTextFieldDidTapEvent: self.pwReTextField.rx.controlEvent(.editingDidBegin), emailTextFieldDidEndEvent: self.emailTextField.rx.controlEvent(.editingDidEnd), authenCodeTextFieldEndTapEvent: self.authenTextField.rx.controlEvent(.editingDidEnd), passwordTextFieldDidEndEvent: self.pwTextField.rx.controlEvent(.editingDidEnd), rePasswordTextFieldEndTapEvent: self.pwReTextField.rx.controlEvent(.editingDidEnd), emailAuthenButton: self.emailAuthenButton.rx.tap.asObservable(), authenCodeButton: self.codeAuthenButton.rx.tap.asObservable(), nextButton: self.nextButton.rx.tap.asObservable())
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        input.emailTextFieldDidTapEvent
            .subscribe(onNext: {
                self.emailTextField.focusingBorder(color: Asset.Colors.orange.name)
                let tfs = self.textFields.filter { $0 != self.emailTextField }
                self.notFocusingTextFields(with: tfs)
            }).disposed(by: self.disposeBag)
        
        input.authenCodeTextFieldDidTapEvent
            .subscribe(onNext: {
                self.authenTextField.focusingBorder(color: Asset.Colors.orange.name)
                let tfs = self.textFields.filter { $0 != self.authenTextField }
                self.notFocusingTextFields(with: tfs)
            }).disposed(by: self.disposeBag)
        
        input.passwordTextFieldDidTapEvent
            .subscribe(onNext: {
                self.pwTextField.focusingBorder(color: Asset.Colors.orange.name)
                let tfs = self.textFields.filter { $0 != self.pwTextField }
                self.notFocusingTextFields(with: tfs)
            }).disposed(by: self.disposeBag)
        
        input.rePasswordTextFieldDidTapEvent
            .subscribe(onNext: {
                self.pwReTextField.focusingBorder(color: Asset.Colors.orange.name)
                let tfs = self.textFields.filter { $0 != self.pwReTextField }
                self.notFocusingTextFields(with: tfs)
            }).disposed(by: self.disposeBag)
        
        input.emailTextFieldDidEndEvent
            .subscribe(onNext: {
                self.emailTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        input.authenCodeTextFieldEndTapEvent
            .subscribe(onNext: {
                self.authenTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        input.passwordTextFieldDidEndEvent
            .subscribe(onNext: {
                self.pwTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        input.rePasswordTextFieldEndTapEvent
            .subscribe(onNext: {
                self.pwReTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        
        
        // MARK - while editing
        output?.authenEmailButtonEnabled
            .subscribe(onNext: { bool in
                switch bool {
                case true:
                    self.emailAuthenButton.setEnabled(color: Asset.Colors.orange.name)
                case false:
                    self.emailAuthenButton.setUnEnabled(color: Asset.Colors.gray4.name)
                }
            }).disposed(by: disposeBag)
        
        output?.emailInvalidMessage
            .subscribe(onNext: { type in
                if let message = type.0, let color = type.1 {
                    self.emailInValidText.isHidden = false
                    self.emailInValidText.text = message
                    self.emailInValidText.textColor = UIColor(named: color.rawValue)
                    switch color {
                    case .green:
                        self.emailTextField.changeIcon(value: 9, icon: Asset.Assets.checkCircle.name)
                        self.authenTextField.becomeFirstResponder()
                    case .red:
                        self.emailTextField.changeIcon(value: 9, icon: Asset.Assets.errorCircleRounded.name)
                        self.emailTextField.errorBorder(bool: false)
                    default:
                        self.emailTextField.errorBorder(bool: true)
                    }
                }else {
                    self.emailTextField.errorBorder(bool: true)
                    self.emailTextField.focusingBorder(color: Asset.Colors.orange.name)
                    self.emailInValidText.isHidden = true
                }
            }).disposed(by: disposeBag)
        
        output?.authenCodeButtonEnabled
            .subscribe(onNext: { bool in
                switch bool {
                case true:
                    self.codeAuthenButton.setEnabled(color: Asset.Colors.orange.name)
                case false:
                    self.codeAuthenButton.setUnEnabled(color: Asset.Colors.gray4.name)
                }
            }).disposed(by: disposeBag)
        
        output?.isAuthenCodeInValid
            .subscribe(onNext: { bool in
                self.authenInValidText.isHidden = bool
                self.authenTextField.errorBorder(bool: bool)
                self.codeAuthenButton.setDisabled(with: bool, color: Asset.Colors.orange.name)
                if bool {
                    self.authenTextField.changeIcon(value: 9, icon: Asset.Assets.checkCircle.name)
                    self.emailAuthenButton.setDisabled(with: true, color: Asset.Colors.orange.name)
                    self.codeAuthenButton.setTitle("확인 완료", for: .normal)
                }else {
                    self.authenTextField.changeIcon(value: 9, icon: Asset.Assets.errorCircleRounded.name)
                    self.codeAuthenButton.setTitle("확인", for: .normal)
                }
            }).disposed(by: disposeBag)
        
        output?.ispasswordInvalid
            .subscribe(onNext: { bool in
                if let bool = bool {
                    self.pwInValidText.isHidden = bool
                    self.pwTextField.errorBorder(bool: bool)
                    if bool {
                        self.pwTextField.changeIcon(value: 9, icon: Asset.Assets.checkCircle.name)
                    }else {
                        
                        self.pwTextField.changeIcon(value: 9, icon: Asset.Assets.errorCircleRounded.name)
                    }
                }else {
                    self.pwInValidText.isHidden = true
                    self.pwTextField.errorBorder(bool: true)
                    self.pwTextField.focusingBorder(color: Asset.Colors.orange.name)
                }
               
            }).disposed(by: disposeBag)
        
        output?.isRepasswordInvalid
            .subscribe(onNext: { bool in
                if let bool = bool {
                    self.pwReInValidText.isHidden = bool
                    self.pwReTextField.errorBorder(bool: bool)
                    if bool {
                        self.pwReTextField.changeIcon(value: 9, icon: Asset.Assets.checkCircle.name)
                    }else {
                        self.pwReTextField.changeIcon(value: 9, icon: Asset.Assets.errorCircleRounded.name)
                    }
                }else {
                    self.pwReInValidText.isHidden = true
                    self.pwReTextField.errorBorder(bool: true)
                    self.pwReTextField.focusingBorder(color: Asset.Colors.orange.name)
                }
               
            }).disposed(by: disposeBag)
                
        output?.nextButtonEnabled
            .subscribe(onNext: { bool in
                if bool {
                    self.nextButton.setEnabled(color: Asset.Colors.black.name)
                }else {
                    self.nextButton.setEnabled(color: Asset.Colors.black.name)
//                    self.nextButton.setUnEnabled(color: Asset.Colors.gray4.name)
                }
            }).disposed(by: disposeBag)
                
    }
    
    func notFocusingTextFields(with tf: [UITextField]) {
        tf.forEach {
            $0.focusingBorder(color: nil)
        }
    }
}
