//
//  LoginCoordinatorProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/06.
//

import Foundation

protocol LoginCoordinatorProtocol: Coordinator {
    func showSignUpFlow()
    func showFindIDViewCoontroller()
    func showFindPWViewController()
}
