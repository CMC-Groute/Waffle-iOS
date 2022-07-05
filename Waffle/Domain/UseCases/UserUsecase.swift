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
    
    init(repository: UserRepository) {
        self.repository = repository
        password = "spqjf12345"
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
            .catch { error -> Observable<UpdatePasswordResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.debug("error \(error)")
                return .just(UpdatePasswordResponse.errorResponse(code: error.rawValue))
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
            .catch { error -> Observable<UpdatePasswordResponse> in
                let error = error as! URLSessionNetworkServiceError
                print("error \(error)")
                return .just(UpdatePasswordResponse.errorResponse(code: error.rawValue))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                print("updatePassword")
                if response.status == 200 {
                    self.updatePasswordSuccess.accept(true)
                }else {
                    self.updatePasswordSuccess.accept(false)
                }
            }).disposed(by: disposeBag)
            
    }
    
    func quit() {
        
    }
    
    func logout() {
        
    }
    
}
