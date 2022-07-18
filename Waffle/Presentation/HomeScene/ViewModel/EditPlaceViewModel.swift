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
    var usecase: HomeUsecase!
    private var disposeBag = DisposeBag()
    var placeId: Int?
    var categoryInfo: [PlaceCategory] = []
    var archiveId: Int?
    var detailPlace: DetailPlaceInfo?
    var place: PlaceInfo?
    var selectedCategory: PlaceCategory?
    var selectedCategoryIndex: Int?
    
    let defaultMemoText = "장소에 대한 간략한 정보나 가고 싶은 이유, 추천하는 이유 등을 자유롭게 작성하면 좋아요"
    let defaultLinkText = "장소와 관련된 링크 주소를 입력해요"
    
    var getPlace: PlaceSearch?
    let placeViewEnabled = BehaviorRelay<Bool>(value: true)
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var placeViewDeleteButton: Observable<Void>
        var placeTextFieldTapEvent: ControlEvent<Void>
        var linkTextViewDidTapEvent: ControlEvent<Void>
        var linkTextViewDidEndEvent: ControlEvent<Void>
        
        var memoTextViewDidTapEvent: ControlEvent<Void>
        var memoTextViewEditing: ControlEvent<Void>
        var memoTextViewDidEndEvent: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        selectedCategoryIndex = categoryInfo.firstIndex(where: { $0.name == selectedCategory?.name })
        
        input.placeTextFieldTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.searchPlace()
            }).disposed(by: disposeBag)
        
        input.placeViewDeleteButton
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.placeViewEnabled.accept(false)
            }).disposed(by: disposeBag)
        
        usecase.editPlaceSuccess
            .subscribe(onNext: { bool in
                if bool {
                    WappleLog.debug("editPlaceSuccess 장소 편집 성공")
                    self.coordinator.popViewController()
                }else {
                    WappleLog.error("장소를 편집 하는데 실패하였습니다.")
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func back() {
        coordinator.popViewController()
    }
    
    func deletePlace() {
        guard let archiveId = self.archiveId, let placeId = self.placeId else { return }
        coordinator.deletePlace(archiveId: archiveId, placeId: placeId)
    }
    
    func updateSelectedCategory(category: PlaceCategory) {
        WappleLog.debug("Update selectedCategory place \(category)")
        selectedCategory = category
    }
    
    func editPlaceButton(editPlace: EditPlace) {
        guard let archiveId = archiveId, let placeId = placeId else { return }
        usecase.editPlace(archiveId: archiveId, placeId: placeId, editPlace: editPlace)
    }
}
