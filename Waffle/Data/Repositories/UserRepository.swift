//
//  UserRepository.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift

class UserRepository: UserRepositoryProtocol {
    
    let service: URLSessionNetworkService
    var disposBag = DisposeBag()
    
    init(networkService: URLSessionNetworkService) {
        self.service = networkService
    }
    
    func getProfileInfo() -> Observable<ProfileInfo> {
        return Observable.of(ProfileInfo(nickName: "uri", email: "jouureee@gmail.com", profileImage: nil))
    }
    
    func setAlarm(state: Bool) {
        
    }
    
    func editProfile(profile: EditProfile) {
        
    }
    
    func updatePassword(password: Password) -> Observable<UpdatePasswordResponse> {
        let api = LoginSignAPI.updatePassword(password: password)
        return self.service.request(api)
            .map ({ response -> UpdatePasswordResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: UpdatePasswordResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    
    
    
}
