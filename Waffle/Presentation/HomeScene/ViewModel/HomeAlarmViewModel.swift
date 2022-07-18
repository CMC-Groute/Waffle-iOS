//
//  HomeAlarmViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/19.
//

import Foundation
import RxSwift

class HomeAlarmViewModel {
    var coordinator: HomeCoordinator!
    var usecase: HomeUsecase!
    private var disposeBag = DisposeBag()
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: {
                self.usecase.getAlarms()
            }).disposed(by: disposeBag)
        
        
        
        
    }
}
