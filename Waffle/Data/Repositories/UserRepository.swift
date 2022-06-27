//
//  UserRepository.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import Combine
import RxSwift

class UserRepository: UserRepositoryProtocol {
    
    let urlSessionNetworkService: URLSessionNetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    var disposBag = DisposeBag()
    
    init(networkService: URLSessionNetworkServiceProtocol) {
        self.urlSessionNetworkService = networkService
    }
    
    func getProfileInfo() -> Observable<ProfileInfo> {
        return Observable.of(ProfileInfo(nickName: "uri", email: "jouureee@gmail.com", profileImage: nil))
    }
    
    func setAlarm(state: Bool) {
        
    }
    
    func editProfile(profile: EditProfile) {
        
    }
    
    func changePassword(password: Password) {
        
    }
    
    
}
