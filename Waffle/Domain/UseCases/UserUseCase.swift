//
//  ProfileUseCase.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift

class UserUseCase: UserUseCaseProtocol {
    
    private var repository: UserRepository!
    var nickName: String?
    var email: String?
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func getProfileInfo() -> Observable<ProfileInfo> {
        return repository.getProfileInfo()
    }
    
    func setAlarm(state: Bool) {
        self.repository.setAlarm(state: state)
    }
    
    func checkPasswordValid(password: String) -> Bool { // 영문, 숫자, 8자리 이상
        let passwordReg =  ("(?=.*[A-Za-z])(?=.*[0-9]).{8,100}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordReg)
        return passwordtesting.evaluate(with: password)
    }
    
    func checkNickNameValid(nickName: String) -> Bool { //특수문자 제외 6글자 이하
        let nickNameReg = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]{0,6}$"
        let nickNameTest = NSPredicate(format: "SELF MATCHES %@", nickNameReg)
        return nickNameTest.evaluate(with: nickName)
    }
    
    
}
