//
//  EditProfileViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxCocoa
import RxSwift

final class EditSettingViewModel {
    var nickName: String?
    var selectedIndex: Int = 0
    var updateNickName: String?
    var updateIndex: Int?
    
    var nickNameInvalidMessage = PublishRelay<Bool>()
    
    struct Input {
        var doneButton: Observable<Void>
        var nickNameTextFieldDidTapEvent: ControlEvent<Void>
        var nickNameTextFieldDidEndEvent: ControlEvent<Void>
        var nickNameTextFieldEditing: ControlEvent<Void>
        var selectedCell: Observable<IndexPath>
    }
    
    struct Output {
        var nickNameTextField = PublishRelay<String>()
        
        var startButtonEnabled = BehaviorRelay<Bool>(value: false)
    }
    
    private var disposable = DisposeBag()
    private var usecase: UserUsecase
    private var coordinator: SettingCoordinator!
    
    init(coordinator: SettingCoordinator, usecase: UserUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func checkNickNameValid(nickName: String) -> Bool { //특수문자 제외 6글자 이하
        let nickNameReg = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]{0,6}$"
        let nickNameTest = NSPredicate(format: "SELF MATCHES %@", nickNameReg)
        return nickNameTest.evaluate(with: nickName)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

//        input.doneButton
//            .withLatestFrom(output.nickNameTextField)
//            .bind(onNext: { nickName in
//                let profileImage = WappleType.init(index: self.selectedIndex).wappleName()
//                self.usecase.updateUserInfo(nickName: nickName, image: profileImage)
//                self.coordinator.popToRootViewController(with: nil, width: nil, height: nil)
//            }).disposed(by: disposeBag)
//
//        
//        
//        output.nickNameTextField
//            .distinctUntilChanged()
//            .skip(1)
//            .subscribe(onNext: { text in
//                if !self.usecase.checkNickNameValid(nickName: text) {
//                    output.nickNameInvalidMessage.accept(false)
//                }else {
//                    output.nickNameInvalidMessage.accept(true)
//                }
//            }).disposed(by: disposeBag)
//        
//        Observable.combineLatest(output.nickNameTextField, input.selectedCell)
//            .bind(onNext: { nickName, index in
//                if nickName == self.nickName && index.row == self.selectedIndex {
//                    //전에꺼랑 변화된게 없다면
//                    output.startButtonEnabled.accept(false)
//                }else {
//                    output.startButtonEnabled.accept(true)
//                }
//            }).disposed(by: disposeBag)
        usecase.updateUserInfoSuccess
            .subscribe(onNext: { _ in 
                self.back()
            }).disposed(by: disposeBag)
        return output
    }
    
    func updateUserInfo(nickName: String, selectedIndex: Int) {
        let profileImage = WappleType.init(index: selectedIndex).wappleName()
        WappleLog.debug("updateUserInfo \(nickName) \(profileImage)")
        usecase.updateUserInfo(nickName: nickName, image: profileImage)
        
    }
    
    func back() {
        self.coordinator.popToRootViewController(with: nil, width: nil, height: nil)
    }
    
}
