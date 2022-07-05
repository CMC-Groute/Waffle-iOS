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

class SetProfileImageViewModel {

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
                print("signUp info \(self.signUpInfo!)")
                self.usecase.signUp(signUp: self.signUpInfo!)
                    .subscribe(on: MainScheduler.instance)
                    .catch { error  in
                            .just(SignUpResponse(message: error.localizedDescription, data: 0))
                    }.subscribe(onNext: { response in
                        if response.message == "success" { // 회원가입 성공시에만 finish
                            self.coordinator.finish()
                        }else if response.message == "error" {
                            print("error occured")
                        }else {
                            //400 중복회원입니다.
                            print("error occured occured")
                            print(response.message)
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
