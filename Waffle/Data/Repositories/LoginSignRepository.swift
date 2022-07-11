//
//  LoginRepository.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift
import RxCocoa

class LoginSignRepository: LoginSignRepositoryProtocol {
    let service: URLSessionNetworkService
    private var disposedBag = DisposeBag()
    
    init(networkService: URLSessionNetworkService) {
        service = networkService
    }
    
    func login(loginInfo: Login) -> Observable<LoginResponse> {
        WappleLog.debug("login repository")
        let api = LoginSignAPI.login(login: loginInfo)
        return service.request(api)
            .map ({ response -> LoginResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: LoginResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func singUp(signUpInfo: SignUp) -> Observable<DefaultIntResponse>  {
        WappleLog.debug("singUp repository")
        let api = LoginSignAPI.signUp(signUp: signUpInfo)
        return service.request(api)
            .map ({ response -> DefaultIntResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DefaultIntResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
   
    }
    
    func sendEmail(email: String) -> Observable<DefaultResponse>  {
        WappleLog.debug("login repository sendEmail")
        let api = LoginSignAPI.sendEmail(email: email)
        return service.request(api)
            .map ({ response -> DefaultResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DefaultResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func checkEmailCode(email: String, code: String) -> Observable<DefaultResponse> {
        let api = LoginSignAPI.checkEmailCode(email: email, code: code)
        WappleLog.debug("login repository checkEmailCode")
        return service.request(api)
            .map ({ response -> DefaultResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DefaultResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func getTempPassword(email: String) -> Observable<DefaultResponse> {
        let api = LoginSignAPI.findPassword(email: email)
        WappleLog.debug("login repository getTempPassword")
        return service.request(api)
            .map ({ response -> DefaultResponse in
                switch response {
                case .success(let data):
                    guard let data = JSON.decode(data: data, to: DefaultResponse.self) else { throw URLSessionNetworkServiceError.responseDecodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
}
