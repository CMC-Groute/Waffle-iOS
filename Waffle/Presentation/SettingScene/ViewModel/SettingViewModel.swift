//
//  SettingViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxCocoa
import RxSwift

final class SettingViewModel {
    
    var isAgreedAlarm = PublishRelay<Bool>()
    
    struct Input {
        let viewWillAppearEvent: Observable<Void> 
        let editButton: Observable<Void>
        let chagePWButton: Observable<Void>
        let setAlarmState: ControlEvent<Void>
        let itemSelected: Observable<IndexPath>
        let quitButton: Observable<Void>
        
    }
    
    struct Output {
        let userNickName = PublishRelay<String>()
        let userEmail = PublishRelay<String>()
        let userImage = PublishRelay<String>()
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
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] _ in
                self?.usecase.getProfileInfo()
                    .subscribe(onNext: { user in
                        output.userNickName.accept(user.nickName)
                        output.userEmail.accept(user.email)
                        output.userImage.accept(user.profileImage)
                        self?.isAgreedAlarm.accept(user.isAgreedAlarm)
                    }).disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.editButton
            .withLatestFrom(output.userNickName)
            .subscribe(onNext: { [weak self] nickName in
                self?.coordinator.editProfile(nickName: nickName)
            }).disposed(by: disposeBag)
        
        input.chagePWButton
            .subscribe(onNext: {
                self.coordinator.changePassword()
            }).disposed(by: disposeBag)
        
        input.quitButton
            .subscribe(onNext: {
                self.coordinator.quit()
            }).disposed(by: disposeBag)
        
        usecase.userQuitSuccess
            .subscribe(onNext: { bool in
                if bool {
                    WappleLog.debug("quit success")
                }
            }).disposed(by: disposeBag)
        
        input.itemSelected
            .subscribe(onNext: { line in
                if line.row == 5 { //logout
                    self.coordinator.logout()
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func setAlarm(isOn: Bool) {
        usecase.setAlarm(state: isOn)
    }
        
}

