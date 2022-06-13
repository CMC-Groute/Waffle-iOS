//
//  ArchiveViewModel.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift
import RxCocoa

class ArchiveViewModel {
    var usecase: ArchiveUseCase!
    var coordinator: ArchiveCoordinator!
    var disposeBag = DisposeBag()
    
    init(usecase: ArchiveUseCase, coordinator: ArchiveCoordinator){
        self.usecase = usecase
        self.coordinator = coordinator
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
