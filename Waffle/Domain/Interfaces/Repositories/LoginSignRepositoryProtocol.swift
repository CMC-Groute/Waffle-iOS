//
//  LoginRepositoryProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import Combine

protocol LoginSignRepositoryProtocol {
    func login(email: String, password: String) -> AnyPublisher<Bool, Never>
}
