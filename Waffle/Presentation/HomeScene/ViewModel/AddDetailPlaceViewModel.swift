//
//  AddDetailPlaceViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

class AddDetailPlaceViewModel {
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase!
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }
}
