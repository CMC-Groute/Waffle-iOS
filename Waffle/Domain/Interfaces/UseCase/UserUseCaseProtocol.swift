//
//  ProfileUseCaseProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift
import RxCocoa

struct ProfileInfo {
    var nickName: String
    var email: String
    var profileImage: Data?
}

protocol UserUseCaseProtocol {
    func getProfileInfo() -> Observable<ProfileInfo>
    func setAlarm(state: Bool)
    func checkPasswordValid(password: String) -> Bool
    func checkNickNameValid(nickName: String) -> Bool
    func updatePassword(password: Password)
    
    func quit()
    func logout()
}
