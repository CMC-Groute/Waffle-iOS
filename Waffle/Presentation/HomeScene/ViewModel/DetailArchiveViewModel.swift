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
    var detailArchive: CardInfo?
    var category: [Category] = [Category.defaultList]
    var selectedCategory: Category = Category.defaultList // 확정 카테고리
    var placeInfo: [PlaceInfo] = []
    var code: String?
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var viewDidLoad: Observable<Void>
        var loadMemoButton: Observable<Void>
        var addPlaceButton: Observable<Void>
    }
    
    struct Output { }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                //TO DO get place data 
                guard let self = self else { return }
                self.placeInfo = PlaceInfo.dummyPlace
                self.category += Category.dummyList
            }).disposed(by: disposeBag)
        
        input.addPlaceButton
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let placeCategory = self.category.filter { $0.index != -1 }
                self.coordinator.addDetailPlace(category: placeCategory)
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func setArchive(archive: CardInfo) {
        usecase.currentArchive.onNext(archive)
    }
    
    func placeInfoByCategory() -> [PlaceInfo] {
        let place = placeInfo.filter { $0.category.index == selectedCategory.index }
        return place
    }
    
    func detailArhive() { // bottomSheet popUp
        coordinator.detailArchiveBottomSheet(cardInfo: detailArchive)
    }
    
    func detailPlace(place: PlaceInfo, category: Category) {
        let sendCategory = self.category.filter { $0.index != -1 }
        coordinator.detailPlace(detailInfo: place, category: category, categoryInfo: sendCategory)
    }
    
    func participants() {
        self.coordinator.participants(cardInfo: self.detailArchive)
    }
    
    func invitations() {
        self.coordinator.invitationBottomSheet(copyCode: self.code ?? "")
    }
    
    func setCategory(category: Category) {
        //카테고리 클릭시마다 update해줌
        selectedCategory = category
    }
    
    func addCategory(category: [Category]) {
        self.category += category
    }
    
    func addHomeCategory(without category: [Category]) {
        //확정 카테고리 빼고 줌
        let sendCategory = category.filter { $0.index != -1 }
        coordinator.addCategory(category: sendCategory)
    }
    
    func deleteCategory(category: Category) {
        coordinator.deleteCategory(category: category)
    }
    
    func loadMemo() {
        guard let detailArchive = detailArchive else { return }
        guard let memo = detailArchive.memo else { return }
        let cardImageIndex = CardViewInfoType.init(rawValue: detailArchive.cardType)?.cardViewIndex() ?? 0
        coordinator.loadMemo(memo: memo, wapple: "memoWapple-\(cardImageIndex)")
    }
    
    func popViewController() {
        coordinator.popViewController()
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
