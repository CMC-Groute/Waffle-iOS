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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var findPWButton: UIButton!
    
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var emailInvalidText: UILabel!
    @IBOutlet weak var passwordInvalidText: UILabel!
    
    var viewModel: LoginViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
    }
    
    private func configureUI(){
        
    }
}
