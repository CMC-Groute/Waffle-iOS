//
//  DetailArchiveViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import Foundation
import RxSwift
import RxCocoa

class DetailArchiveViewModel {
    
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase!
    var cardInfo: CardInfo?
    var category: [PlaceCategory] = [PlaceCategory.confirmCategory]
    var selectedCategory: PlaceCategory = PlaceCategory.confirmCategory // 확정 카테고리
    var placeInfo: [DecidedPlace]?
    var confirmCategoryIndex = -1
    var id: Int = 0
    var code: String?
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var viewWillAppearEvent: Observable<Void>
        var loadMemoButton: Observable<Void>
        var addPlaceButton: Observable<Void>
    }
    
    struct Output { }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let id = self.cardInfo?.id else { return }
                self.usecase.getDetailArchiveInfo(placeId: id)
            }).disposed(by: disposeBag)
        
        input.addPlaceButton
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.addDetailPlace(category: self.loadCategoryWithoutConfirm())
            }).disposed(by: disposeBag)
        
        usecase.detailArchive
            .subscribe(onNext: { detailArchive in
                if let detailArchive = detailArchive {
                    self.placeInfo = detailArchive.decidedPlace
                    self.category += detailArchive.category ?? []
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func loadCategoryWithoutConfirm() -> [PlaceCategory] {
        return category.filter { $0.id != confirmCategoryIndex }
    }
    
    
    // 카테고리로 필터링된 place들
    func placeInfoByCategory() -> [PlaceByCategory] {
        //let place = placeInfo.filter { $0.category.index == selectedCategory.index }
        return place
    }
    
    func detailArhive() { // bottomSheet popUp
        coordinator.detailArchiveBottomSheet(cardInfo: cardInfo)
    }
    
    func detailPlace(place: PlaceInfo, category: PlaceCategory) {
        coordinator.detailPlace(detailInfo: place, category: loadCategoryWithoutConfirm(), categoryInfo: category)
        }
    
    func participants() {
        self.coordinator.participants(cardInfo: self.cardInfo)
    }
    
    func invitations() {
        self.coordinator.invitationBottomSheet(copyCode: self.usecase.code ?? "")
    }
    
    func setCategory(category: PlaceCategory) {
        //카테고리 클릭시마다 update해줌
        selectedCategory = category
    }
    
    func addCategory(category: [PlaceCategory]) {
        self.category += category
    }
    
    func addHomeCategory(without category: [PlaceCategory]) {
        coordinator.addCategory(category: loadCategoryWithoutConfirm())
    }
    
    func deleteCategory(category: PlaceCategory) {
        coordinator.deleteCategory(category: category)
    }
    
    func loadMemo() {
        guard let detailArchive = cardInfo else { return }
        guard let memo = detailArchive.memo else { return }
        let cardImageIndex = CardViewInfoType.init(rawValue: detailArchive.cardType)?.cardViewIndex() ?? 0
        coordinator.loadMemo(memo: memo, wapple: "memoWapple-\(cardImageIndex)")
    }
    
    func popViewController() {
        coordinator.popViewController()
    }
    
    func getArchiveCode() {
       
    }

}

extension DetailArchiveViewModel {
    enum Section: Int, CaseIterable {
        case topView
        case subView
        case categoryView
        case tableView
    }
    
    var numberOfSections: Int {
        return Section.allCases.count
    }
}
