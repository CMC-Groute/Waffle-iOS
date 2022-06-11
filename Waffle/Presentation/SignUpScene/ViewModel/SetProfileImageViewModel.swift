//
//  SetProfileImageViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxRelay
import RxSwift

class SetProfileImageViewModel {
    struct Input {
        
    }
    
    struct Output {
        var profileImage = BehaviorRelay<UIImage?>(value: UIImage(named: "") ?? nil)
    }
    
    private var disposable = DisposeBag()
    private var usecase: UserUseCase
    private var coordinator: SignUpCoordinator!
    
    init(coordinator: SignUpCoordinator, usecase: UserUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }
}
