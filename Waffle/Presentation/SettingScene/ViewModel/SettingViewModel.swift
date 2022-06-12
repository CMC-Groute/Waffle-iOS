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
        let viewWillAppearEvent: Observable<Void> // self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in }
        
    }
    
    struct Output {
        
    }
    
    private var disposable = DisposeBag()
    private var usecase: LoginSignUseCase
    private var coordinator: SettingCoordinator!
    
    init(coordinator: SettingCoordinator, usecase: LoginSignUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }
        
}

