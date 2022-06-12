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
        
        return output
    }
    
}
