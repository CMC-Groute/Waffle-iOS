//
//  SettingViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxCocoa
import RxSwift

class SettingViewModel {
    struct Input {
        let viewWillAppearEvent: Observable<Void> 
        let editButton: Observable<Void>
        let chagePWButton: Observable<Void>
        let setAlarmState: ControlEvent<Void>
        let itemSelected: Observable<IndexPath>
        let quitButton: Observable<Void>
        
    }
    
    struct Output {
        
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
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] _ in
                self?.usecase.getProfileInfo()
            })
            .disposed(by: disposeBag)
        
        input.editButton
            .subscribe(onNext: {
                self.coordinator.editProfile()
            }).disposed(by: disposeBag)
        
        input.chagePWButton
            .subscribe(onNext: {
                self.coordinator.changePassword()
            }).disposed(by: disposeBag)
        
        input.quitButton
            .subscribe(onNext: {
                print("click")
                self.coordinator.quit()
            }).disposed(by: disposeBag)
        
        input.itemSelected
            .subscribe(onNext: { line in
                if line.row == 5 { //logout
                    self.coordinator.logout()
                }
            }).disposed(by: disposeBag)
        
        return output
    }
        
}

