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
    var viewModel: LoginViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
