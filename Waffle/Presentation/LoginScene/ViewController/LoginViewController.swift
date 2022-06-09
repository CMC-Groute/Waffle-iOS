//
//  LoginViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation
import UIKit
import Combine

class LoginViewController: UIViewController {
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
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
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //keyboardLayout()
        resignForKeyboardNotification()
        bindViewModel()
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
//              print("bottom")
//              bottomConstant.constant = -keyboardHeight + self.view.safeAreaInsets.bottom
//            self.view.layoutIfNeeded()
              
              UIView.animate(
                  withDuration: 0.3
                  , animations: {
                      self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
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
    
    private func keyboardLayout() {
        self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func bindViewModel() {
        
        self.findPWButton.publisher
            .sink { [weak self] _ in
                guard let self = self else { return }
               
            }.store(in: &self.cancellables)
        
        self.signUpButton.publisher
            .sink { [weak self] _ in
                guard let self = self else { return }
               
            }.store(in: &self.cancellables)
    }
    
    private func configureUI(){
        
    }
}
