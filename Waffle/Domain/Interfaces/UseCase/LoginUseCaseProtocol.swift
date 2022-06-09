//
//  LoginUseCaseProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import Combine

protocol LoginUseCaseProtocol {
    func login(with email: String, password: String)
    func checkEmailValid(with email: String) -> Bool
    func checkPasswordValid(with password: String) -> Bool
}
