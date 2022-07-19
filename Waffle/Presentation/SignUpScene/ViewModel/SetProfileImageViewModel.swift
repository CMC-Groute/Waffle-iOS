//
//  SetProfileImageViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa

final class SetProfileImageViewModel {

    var signUpInfo: SignUp?
    
    struct Input {
        var nickNameTextField: Observable<String>
        var startButton: Observable<Void>
        var nickNameTextFieldDidTapEvent: ControlEvent<Void>
        var nickNameTextFieldDidEndEvent: ControlEvent<Void>
    }
    
    struct Output {
        var nickNameInvalidMessage = PublishRelay<Bool>()
        var startButtonEnabled = BehaviorRelay<Bool>(value: false)
        var alertMessage = PublishRelay<String>()
    }
    
    private var disposable = DisposeBag()
    private var usecase: LoginSignUsecase
    private var coordinator: SignUpCoordinator!
    var selectedIndex: Int = 0
    
    init(coordinator: SignUpCoordinator, usecase: LoginSignUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.startButton
            .withLatestFrom(input.nickNameTextField)
            .bind(onNext: { nickName in
                let profileImage = WappleType.init(index: self.selectedIndex).wappleName()
                self.signUpInfo?.nickname = nickName
                self.signUpInfo?.profileImage = profileImage
                WappleLog.debug("signUp info \(self.signUpInfo!)")
                self.usecase.signUp(signUp: self.signUpInfo!)
                    .catch { error -> Observable<DefaultIntResponse> in
                        let error = error as! URLSessionNetworkServiceError
                        WappleLog.error("error \(error)")
                        return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
                    }.observe(on: MainScheduler.instance)
                    .subscribe(onNext: { response in
                        if response.status == 200 { // 회원가입 성공시에만 finish
                            self.coordinator.finish()
                        }else if response.status == 403 {
                            print("error occured")
                        }else {
                            //400 중복회원입니다.
                            print("error occured occured")
                            //TO DO 하드코딩 변경하기
                            output.alertMessage.accept("중복 회원입니다.")
                        }
                    }).disposed(by: disposeBag)
    
            }).disposed(by: disposeBag)
        
        input.nickNameTextField
            .distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: { text in
                if text.count == 0 {  output.startButtonEnabled.accept(false) }
                else {
                    if !self.usecase.checkNickNameValid(nickName: text) {
                        output.nickNameInvalidMessage.accept(false)
                        output.startButtonEnabled.accept(false)
                    }else {
                        output.nickNameInvalidMessage.accept(true)
                        output.startButtonEnabled.accept(true)
                    }
                }
            }).disposed(by: disposeBag)
        
        
        return output
    }
    
    func backButton() {
        coordinator.popViewController()
    }
}
