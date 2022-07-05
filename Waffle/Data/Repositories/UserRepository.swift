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
        service = networkService
    }
    
    func setAlarm(state: Bool) {
        
    }
    
    func getProfileInfo() -> Observable<UserInfoResponse> {
        let api = LoginSignAPI.getUserInfo
        return service.request(api)
            .map ({ response -> UserInfoResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: UserInfoResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
        }
    
    func updateUserInfo(nickName: String, image: String) -> Observable<DetaultIntResponse> {
        let api = LoginSignAPI.updateProfile(nickName: nickName, image: image)
        return service.request(api)
            .map ({ response -> DetaultIntResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DetaultIntResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    
    func updatePassword(password: Password) -> Observable<DetaultIntResponse> {
        let api = LoginSignAPI.updatePassword(password: password)
        return service.request(api)
            .map ({ response -> DetaultIntResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DetaultIntResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func quitUser() -> Observable<DetaultIntResponse> {
        let api = LoginSignAPI.quitUser
        return service.request(api)
            .map ({ response -> DetaultIntResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DetaultIntResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    
    
    
}
