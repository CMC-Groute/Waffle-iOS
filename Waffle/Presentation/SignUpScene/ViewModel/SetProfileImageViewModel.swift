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
                self.usecase.signUp(signUp: self.signUpInfo!)
                self.coordinator.finish()
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
