//
//  ChangePWViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxCocoa
import RxSwift

class ChangePWViewModel {
    
    struct Input {
        let passwordTextField: Observable<String>
        let newPasswordTextField: Observable<String>
        let newRePasswordTextField: Observable<String>
        
        let passwordTextFieldDidTapEvent: ControlEvent<Void>
        let passwordTextFieldDidEndEvent: ControlEvent<Void>
        
        let newPasswordTextFieldDidTapEvent: ControlEvent<Void>
        let newPasswordTextFieldDidEndEvent: ControlEvent<Void>
        
        let newRePasswordTextFieldDidTapEvent: ControlEvent<Void>
        let newRePasswordTextFieldDidEndEvent: ControlEvent<Void>
        
        let doneButton: Observable<Void>
        
    }
    
    struct Output {
        let doneButtonEnabled = BehaviorRelay<Bool>(value: false)
        let passwordInValid = PublishRelay<Bool?>()
        let newPasswordInValid = PublishRelay<Bool?>()
        let newRePasswordInValid = PublishRelay<Bool?>()
    }
    
    private var disposable = DisposeBag()
    private var usecase: UserUsecase
    private var coordinator: SettingCoordinator!
    
    init(coordinator: SettingCoordinator, usecase: UserUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        //nextButton 활성화
        Observable.combineLatest(output.passwordInValid, output.newPasswordInValid, output.newRePasswordInValid)
            .map{ $0.0 == true && $0.1 == true && $0.2 == true } //유효 메세지 없다면
            .bind(to: output.doneButtonEnabled)
            .disposed(by: disposeBag)
        
        input.doneButton
            .subscribe(onNext: {
                self.coordinator.popToRootViewController(with: "새 비밀번호로 변경되었어요")
            }).disposed(by: disposeBag)
        
        input.passwordTextField
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                if text.count == 0 {
                    output.passwordInValid.accept(nil)
                }else {
                    if !self.usecase.checkPassword(password: text) {
                        output.passwordInValid.accept(false)
                    }else {
                        output.passwordInValid.accept(true)
                    }
                }
            }).disposed(by: disposeBag)
        
        input.newPasswordTextField
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                if text.count == 0 {
                    output.newPasswordInValid.accept(nil)
                }else {
                    if !self.usecase.checkPasswordValid(password: text) {
                        output.newPasswordInValid.accept(false)
                    }else {
                        output.newPasswordInValid.accept(true)
                    }
                }
            }).disposed(by: disposeBag)
        
        // new, re 같은지 확인
        Observable.combineLatest(input.newPasswordTextField, input.newRePasswordTextField)
            .bind(onNext: { pw, rePw in
                if rePw.count == 0 {
                    output.newRePasswordInValid.accept(nil)
                }else {
                    if pw != rePw {
                        output.newRePasswordInValid.accept(false)
                    }else {
                        output.newRePasswordInValid.accept(true)
                    }
                }
            }).disposed(by: disposeBag)
            
//        input.newRePasswordTextField
//            .distinctUntilChanged()
//            .subscribe(onNext: { text in
//                if text.count == 0 {
//                    output.newRePasswordInValid.accept(nil)
//                }else {
//                    if !self.usecase.checkPasswordValid(password: text) {
//                        output.newRePasswordInValid.accept(false)
//                    }else {
//                        output.newRePasswordInValid.accept(true)
//                    }
//                }
//            }).disposed(by: disposeBag)
    
        
        return output
    }
    
}
