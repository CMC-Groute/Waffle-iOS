//
//  SignUpCoordinatorProtocol.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/10.
//

import Foundation

protocol SignUpCoordinatorProtocol: Coordinator {
    func termsStep(signUpInfo: SignUp)
    func setProfileImage(signUpInfo: SignUp)
}
