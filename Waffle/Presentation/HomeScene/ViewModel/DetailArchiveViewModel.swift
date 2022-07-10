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
    var category: [PlaceCategory] = [PlaceCategory.confirmCategory]
    var selectedCategory: PlaceCategory = PlaceCategory.confirmCategory // 확정 카테고리
    var placeInfo: [DecidedPlace]?
    var detailArchive: DetailArhive?
    var confirmCategoryName = "확정"
    var archiveId: Int = 0
    var archiveCode: String?
    
    init(coordinator: HomeCoordinator, usecase: HomeUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        var viewWillAppearEvent: Observable<Void>
        var loadMemoButton: Observable<Void>
        var addPlaceButton: Observable<Void>
    }
    
    struct Output {
        var loadData = PublishSubject<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.usecase.getDetailArchiveInfo(placeId: self.archiveId)
                WappleLog.debug("detailArchiveVieModel archiveId - \(self.archiveId)")
                self.getArchiveCode()
            }).disposed(by: disposeBag)
        
        input.addPlaceButton
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.addDetailPlace(category: self.loadCategoryWithoutConfirm())
            }).disposed(by: disposeBag)
        
        bindUsecase()
        
        func bindUsecase() {
            usecase.detailArchive
                .subscribe(onNext: { [weak self] detailArchive in
                        guard let self = self else { return }
                    if let detailArchive = detailArchive {
                        self.detailArchive = detailArchive // 전체 약속 데이터
                        self.placeInfo = detailArchive.decidedPlace // 확정 장소
                        let category = detailArchive.category?.compactMap { category in
                            return PlaceCategory(id: category.id, name: CategoryType.init(rawValue: category.name)?.format() ?? "") }
                        self.category += category ?? [] // 카테고리
                        output.loadData.onNext(true)
                    }
                }).disposed(by: disposeBag)
            
            usecase.archiveCode
                .subscribe(onNext: { [weak self] code in
                    guard let self = self else { return }
                    self.archiveCode = code
                    WappleLog.debug("DetailArchiveViewModel archiveCode \(code ?? "")")
                }).disposed(by: disposeBag)
            
            usecase.addCategory
                .subscribe(onNext: { [weak self] addCategory in
                    guard let addCategory = addCategory else { return }
                    WappleLog.debug("DetailArchiveViewModel addCategory \(addCategory)")
//                    viewWillApear에서 해줘서 안해도 되나 확인 필요
//                    self?.category += addCategory
//                    output.loadData.onNext(true)
                }).disposed(by: disposeBag)
            
            usecase.deleteCategory
                .subscribe(onNext: { [weak self] deleteCategory in
                    WappleLog.debug("DetailArchiveViewModel deleteCategory \(deleteCategory)")
                    //viewWillApear에서 해줘서 안해도 되나 확인 필요
                    //self?.category += addCategory
                    //output.loadData.onNext(true)
                }).disposed(by: disposeBag)
        }
        
        return output
    }
    
    func getArchiveCode() {
        usecase.getArchiveCode(archiveId: archiveId) {}
    }
    
    func loadCategoryWithoutConfirm() -> [PlaceCategory] {
        return category.filter { $0.name != confirmCategoryName }
    }
    
    
    // 카테고리로 필터링된 place들
    func placeInfoByCategory() -> [PlaceByCategory] {
        //let place = placeInfo.filter { $0.category.index == selectedCategory.index }
        return []
    }
    
    func detailArhive() { // bottomSheet popUp
        coordinator.detailArchiveBottomSheet(detailArchive: detailArchive, archiveId: self.archiveId)
    }
    
    func detailPlace(place: PlaceByCategory, category: PlaceCategory) {
        coordinator.detailPlace(detailInfo: place, category: category, categoryInfo: loadCategoryWithoutConfirm())
        }
    
    func participants() {
        self.coordinator.participants(detailArchive: detailArchive)
    }
    
    func invitations() {
        self.coordinator.invitationBottomSheet(copyCode: archiveCode ?? "")
    }
    
    func setCategory(category: PlaceCategory) {
        //카테고리 클릭시마다 update해줌
        selectedCategory = category
    }
    
    func addCategory(category: [PlaceCategory]) {
        self.category += category
    }
    
    func addHomeCategory(without category: [PlaceCategory]) {
        coordinator.addCategory(archiveId: archiveId, category: loadCategoryWithoutConfirm())
    }
    
    func deleteCategory(category: PlaceCategory) {
        coordinator.deleteCategory(archiveId: archiveId, category: category)
    }
    
    func loadMemo() {
        guard let detailArchive = detailArchive else { return }
        guard let memo = detailArchive.memo else { return }
        let cardImageIndex = CardViewInfoType.init(rawValue: detailArchive.placeImage)?.cardViewIndex() ?? 0
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
