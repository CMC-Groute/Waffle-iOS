//
//  EditProfileViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxCocoa
import RxSwift

class EditSettingViewModel {
    
    struct Input {
        var nickNameTextField: Observable<String>
        var doneButton: Observable<Void>
        var nickNameTextFieldDidTapEvent: ControlEvent<Void>
        var nickNameTextFieldDidEndEvent: ControlEvent<Void>
        var selectedCell: Observable<IndexPath>
    }
    
    struct Output {
        var nickNameInvalidMessage = PublishRelay<Bool>()
        var startButtonEnabled = BehaviorRelay<Bool>(value: false)
    }
    
    private var disposable = DisposeBag()
    private var usecase: UserUseCase
    private var coordinator: SettingCoordinator!
    
    init(coordinator: SettingCoordinator, usecase: UserUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.doneButton
            .subscribe(onNext: {
                self.coordinator.popToRootViewController(with: nil)
            }).disposed(by: disposeBag)
        
        input.nickNameTextField
            .distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: { text in
                print("nickNameTextField")
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
    
}