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
    private var usecase: UserUsecase
    private var coordinator: SettingCoordinator!
    var selectedIndex: Int = 0
    
    init(coordinator: SettingCoordinator, usecase: UserUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.doneButton
            .withLatestFrom(input.nickNameTextField)
            .bind(onNext: { nickName in
                let profileImage = WappleType.init(index: self.selectedIndex).wappleName()
                WappleLog.debug("\(nickName) \(profileImage)")
                self.usecase.updateUserInfo(nickName: nickName, image: profileImage)
                self.coordinator.popToRootViewController(with: nil, width: nil, height: nil)
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
    
    func back() {
        self.coordinator.popToRootViewController(with: nil, width: nil, height: nil)
    }
    
}
