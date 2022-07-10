//
//  ProfileUseCase.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift
import RxCocoa

class UserUsecase: UserUseCaseProtocol {
    
    private var repository: UserRepository!
    
    var nickName: String?
    var email: String?
    var password: String?
    let disposeBag = DisposeBag()
    var updatePasswordSuccess = PublishRelay<Bool>()
    var updateUserInfoSuccess = PublishRelay<Bool>()
    var userQuitSuccess = PublishRelay<Bool>()
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func getProfileInfo() -> Observable<GetUserInfo> {
        return repository.getProfileInfo()
            .observe(on: MainScheduler.instance)
            .map { $0.data }
    }
    
    func setAlarm(state: Bool) {
        self.repository.setAlarm(state: state)
    }
    
    func checkPasswordValid(password: String) -> Bool { // 영문, 숫자, 8자리 이상
        let passwordReg =  ("(?=.*[A-Za-z])(?=.*[0-9]).{8,100}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordReg)
        return passwordtesting.evaluate(with: password)
    }
    
    func checkPassword(password: String) -> Bool {
        if self.password != password { return false }
        return true
    }
    
    func checkNickNameValid(nickName: String) -> Bool { //특수문자 제외 6글자 이하
        let nickNameReg = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]{0,6}$"
        let nickNameTest = NSPredicate(format: "SELF MATCHES %@", nickNameReg)
        return nickNameTest.evaluate(with: nickName)
    }
    
    func updateUserInfo(nickName: String, image: String) {
        repository.updateUserInfo(nickName: nickName, image: image)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                WappleLog.debug("updateUserInfo \(response)")
                if response.status == 200 {
                    self.updateUserInfoSuccess.accept(true)
                }else {
                    self.updateUserInfoSuccess.accept(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func updatePassword(password: Password) { // 비밀번호 업데이트
        repository.updatePassword(password: password)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("updatePassword error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                WappleLog.debug("updatePassword \(response)")
                if response.status == 200 {
                    self.updatePasswordSuccess.accept(true)
                }else {
                    self.updatePasswordSuccess.accept(false)
                }
            }).disposed(by: disposeBag)
            
    }
    
    func logout() { // userDefault에 있는 값 모두 초기화 deviceToken만 제외
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key == UserDefaultKey.deviceToken { continue }
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
    func quit() {
        repository.quitUser()
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("quit error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                WappleLog.debug("quit user \(response)")
                if response.status == 200 {
                    self.userQuitSuccess.accept(true)
                    self.logout()
                }else {
                    self.userQuitSuccess.accept(false)
                }
            }).disposed(by: disposeBag)
    }
    
}
