//
//  SignUpViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        resignForKeyboardNotification()
    }
    
    private func configureUI(){
        emailTextField.round(corner: 10)
        emailAuthenButton.round(corner: 10)
        authenTextField.round(corner: 10)
        codeAuthenButton.round(corner: 10)
        pwTextField.round(corner: 10)
        pwReTextField.round(corner: 10)
        nextButton.round(corner: 25)
        
        func setProgressNavigationBar() { // TO DO selected state 
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            let progressOneButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProgressed1.name)
            let progressTwoButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProcess2.name)
            let progreeeThreeButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProcess3.name)
            
            self.navigationItem.rightBarButtonItems = [progreeeThreeButton, spacer, progressTwoButton, spacer, progressOneButton]
        }
        
        setProgressNavigationBar()

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
                      self.bottonConstraint.constant = -keyboardHeight + self.view.safeAreaInsets.bottom
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
}
