//
//  LoginRepository.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import RxSwift
import RxCocoa

enum LoginSignError: Error {
    case decodingError
}

class LoginSignRepository: LoginSignRepositoryProtocol {
    
    private func decode<T: Decodable>(data: Data, to target: T.Type) -> T? {
        return try? JSONDecoder().decode(target, from: data)
    }
    
    let service: URLSessionNetworkService
    private var disposedBag = DisposeBag()
    
    init(networkService: URLSessionNetworkService) {
        self.service = networkService
    }
    
    func login(loginInfo: Login) -> Observable<LoginResponse> {
        print("login repository")
        let api = LoginSignAPI.login(login: loginInfo)
        return self.service.request(api)
            .map ({ response -> LoginResponse in
                switch response {
                case .success(let data):
                    guard let data = self.decode(data: data, to: LoginResponse.self) else { throw LoginSignError.decodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
         
    }
    
    func singUp(signUpInfo: SignUp) -> Observable<SignUpResponse>  {
        print("singUp repository")
        let api = LoginSignAPI.signUp(signUp: signUpInfo)
        return self.service.request(api)
            .map ({ response -> SignUpResponse in
                switch response {
                case .success(let data):
                    guard let data = self.decode(data: data, to: SignUpResponse.self) else { throw LoginSignError.decodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
   
    }
    
    func sendEmail(email: String) -> Observable<DefaultResponse>  {
        print("login repository sendEmail")
        let api = LoginSignAPI.sendEmail(email: email)
        return self.service.request(api)
            .map ({ response -> DefaultResponse in
                switch response {
                case .success(let data):
                    guard let data = self.decode(data: data, to: DefaultResponse.self) else { throw LoginSignError.decodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func checkEmailCode(email: String, code: String) -> Observable<DefaultResponse> {
        let api = LoginSignAPI.checkEmailCode(email: email, code: code)
        return self.service.request(api)
            .map ({ response -> DefaultResponse in
                switch response {
                case .success(let data):
                    guard let data = self.decode(data: data, to: DefaultResponse.self) else { throw LoginSignError.decodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func getTempPassword(email: String) -> Observable<DefaultResponse> {
        let api = LoginSignAPI.findPassword(email: email)
        print("login repository getTempPassword")
        return self.service.request(api)
            .map ({ response -> DefaultResponse in
                switch response {
                case .success(let data):
                    guard let data = self.decode(data: data, to: DefaultResponse.self) else { throw LoginSignError.decodingError }
                    return data
                case .failure(let error):
                    throw error
                }
            })
    }
    
}
