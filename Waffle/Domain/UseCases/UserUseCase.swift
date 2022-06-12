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
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func getProfileInfo() -> Observable<ProfileInfo> {
        return repository.getProfileInfo()
    }
    
    func setAlarm(state: Bool) {
        self.repository.setAlarm(state: state)
    }
    
    
}
