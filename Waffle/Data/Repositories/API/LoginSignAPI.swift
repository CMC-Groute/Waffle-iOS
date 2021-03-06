//
//  LoginSignAPI.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/02.
//

import Foundation

enum LoginSignAPI: NetworkRequestBuilder {
    case login(login: Login)
    case signUp(signUp: SignUp)
    case sendEmail(email: String)
    case checkEmailCode(email: String, code: String)
    case findPassword(email: String)
    case updateProfile(nickName: String, image: String)
    case updatePassword(password: Password)
    case getUserInfo
    case quitUser
    case setAlarm(isOn: Bool)
    
}

extension LoginSignAPI {
    var baseURL: URL? {
        return URL(string: Config.baseURL)
    }
    
    var path: String? {
        switch self {
        case .login(_):
            return "/users/login"
        case .signUp(_), .getUserInfo, .quitUser, .setAlarm(_):
            return "/users"
        case .sendEmail(_):
            return "/email"
        case .checkEmailCode(_, _):
            return "email/verify-code"
        case .findPassword(_):
            return "/email/findPw"
        //MARK: profile API
        case .updateProfile(_, _):
            return "/users"
        case .updatePassword(_):
            return "/users/password"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .getUserInfo:
            return .get
        case .login(_), .signUp(_), .sendEmail(_), .checkEmailCode(_, _), .findPassword(_):
            return .post
        case .updatePassword(_), .updateProfile(_, _):
            return .put
        case .quitUser:
            return .delete
        case .setAlarm(_):
            return .patch
        }
    }
    
    var parameters: [String : String]? {
        return nil
    }
    
    var body: [String : Any]? {
        switch self {
        case .getUserInfo, .quitUser:
            return nil
        case .login(let login):
            return login.dictionary
        case .signUp(let signUp):
            return signUp.dictionary
        case .sendEmail(let email):
            return ["email": email]
        case .checkEmailCode(let email, let code):
            return ["email": email, "code" : code]
        case .findPassword(let email):
            return ["email" : email]
        case .updateProfile(let nickName, let image):
            return ["nickname": nickName, "profileImage": image]
        case .updatePassword(let password):
            return password.dictionary
        case .setAlarm(let isOn):
            return ["isAgreedAlarm" : isOn]
        }
        
    }

    
    var headers: [String : String]? {
        let defaultHeader = ["Content-Type" : "application/json"]
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else { return defaultHeader }
        switch self {
        case .updatePassword(_), .updateProfile(_, _), .getUserInfo, .quitUser, .setAlarm(_):
            return ["token": jwtToken, "Content-Type" : "application/json"]
        default:
            return defaultHeader
        }
    }
    
}
