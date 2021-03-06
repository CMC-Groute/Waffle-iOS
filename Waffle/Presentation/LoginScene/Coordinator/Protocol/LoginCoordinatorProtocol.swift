//
//  LoginCoordinatorProtocol.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/06.
//

import Foundation

protocol LoginCoordinatorProtocol: Coordinator {
    func showSignUpFlow()
    func showFindPWViewController()
    func popToRootViewController()
}
