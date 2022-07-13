//
//  EditPlaceViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import Foundation
import RxSwift
import RxCocoa

class EditPlaceViewModel {
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase!
    var placeId: Int?
    var categoryInfo: [PlaceCategory] = []
    var archiveId: Int?
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var linkTextViewDidTapEvent: ControlEvent<Void>
        var linkTextViewDidEndEvent: ControlEvent<Void>
    }
    
    struct Output {
        let placeViewEnabled = BehaviorRelay<Bool>(value: true)
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }
    
    func back() {
        coordinator.popViewController()
    }
    
    func deletePlace() {
        guard let archiveId = self.archiveId, let placeId = self.placeId else {
            return
        }
        coordinator.deletePlace(archiveId: archiveId, placeId: placeId)
    }
}
