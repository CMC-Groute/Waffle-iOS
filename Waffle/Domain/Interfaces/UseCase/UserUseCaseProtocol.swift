//
//  ProfileUseCaseProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift

protocol UserUseCaseProtocol {
    func getProfileInfo() -> Observable<GetUserInfo>
    func setAlarm(state: Bool)
    func checkPasswordValid(password: String) -> Bool
    func checkNickNameValid(nickName: String) -> Bool
    func updatePassword(password: Password)
    
    func quit()
    func logout()
}
