//
//  HomeViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift

class HomeViewModel: ObservableObject {
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
   // var useCase: HomeUseCase!
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        var makeArchiveButton: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.makeArchiveButton
            .subscribe(onNext: {
                print("makeArchiveButton")
                self.coordinator.archiveFlow()
            }).disposed(by: disposeBag)
        
        input.viewDidLoadEvent
            .subscribe(
                onNext: { [weak self] _ in
                })
            .disposed(by: disposeBag)
        
        return output
    }
    
}
