//
//  DetailArchiveViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import Foundation
import RxSwift
import RxCocoa

enum LoadIndexPathType {
    case all
    case category
    case tableView
}

class DetailArchiveViewModel {
    
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase!
    var category: [PlaceCategory] = [PlaceCategory.confirmCategory]
    var selectedCategory: PlaceCategory = PlaceCategory.confirmCategory // 확정 카테고리
    var placeInfo: [PlaceInfo]?
    var detailArchive: DetailArhive?
    private var confirmCategoryName = "확정"
    var detailPlaceInfo: DetailPlaceInfo?
    var archiveId: Int = 0
    var archiveCode: String?
    var currentPlace: PlaceInfo?
    
    var loadData = PublishSubject<LoadIndexPathType>()
    var idFromDelete: Bool = false
    
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
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.usecase.getDetailArchiveInfo(placeId: self.archiveId)
                WappleLog.debug("detailArchiveVieModel archiveId \(self.archiveId)")
                self.getArchiveCode()
            }).disposed(by: disposeBag)
        
        input.addPlaceButton
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.addDetailPlace(archiveId: self.archiveId, category: self.loadCategoryWithoutConfirm())
            }).disposed(by: disposeBag)
        
        bindUsecase()
        
        func bindUsecase() {
            usecase.detailArchive
                .subscribe(onNext: { [weak self] detailArchive in
                        guard let self = self else { return }
                    if let detailArchive = detailArchive {
                        WappleLog.debug("DetailArchiveViewModel detailArchive \(detailArchive)")
                        self.detailArchive = detailArchive // 전체 약속 데이터
                        self.placeInfo = detailArchive.placeInfo
                        let category = detailArchive.category?.compactMap { category in
                            return PlaceCategory(id: category.id, name: CategoryType.init(rawValue: category.name)?.format() ?? "") }
                        //Delete시 cell 초기화
                        if self.idFromDelete {
                            self.category = [PlaceCategory.confirmCategory]
                            self.idFromDelete = false
                            self.loadData.onNext(.category)
                        }else {
                            self.category = [PlaceCategory.confirmCategory]
                            self.category += category ?? [] // 카테고리
                            self.loadData.onNext(.all)
                        }
                        
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
                    WappleLog.debug("DetailArchiveViewModel addCategory \(addCategory)")
                    guard let addCategory = addCategory else { return }
                    let category = addCategory.compactMap { category in
                        return PlaceCategory(id: category.id, name: CategoryType.init(rawValue: category.name)?.format() ?? "") }
                    self?.category += category
                    self?.loadData.onNext(.category)
                }).disposed(by: disposeBag)
            
            usecase.deleteCategory
                .subscribe(onNext: { [weak self] bool in
                    guard let self = self else { return }
                    WappleLog.debug("DetailArchiveViewModel deleteCategory \(bool)")
                    self.idFromDelete = true
                    self.usecase.getDetailArchiveInfo(placeId: self.archiveId)
                }).disposed(by: disposeBag)
            
            usecase.getPlaceByCategorySuccess
                .subscribe(onNext: { [weak self] place in
                    guard let self = self else { return }
                    guard let place = place else {
                        return
                    }
                    WappleLog.debug("getPlaceByCategorySuccess \(place)")
                    self.placeInfo = place
                    self.loadData.onNext(.tableView)
                }).disposed(by: disposeBag)
            
            usecase.getDetailPlaceSuccess //링크, 메모로 데이터 받아와 이동
                .subscribe(onNext: {  [weak self] detailPlace in
                    guard let self = self else { return }
                    guard let currentPlace = self.currentPlace else { return }
                    self.detailPlaceInfo = detailPlace
                    self.coordinator.detailPlace(archiveId: self.archiveId, detailInfo: detailPlace, placeInfo: currentPlace, category: self.selectedCategory, categoryInfo: self.loadCategoryWithoutConfirm())
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
    
    func detailArhive() { // bottomSheet popUp
        coordinator.detailArchiveBottomSheet(detailArchive: detailArchive, archiveId: self.archiveId)
    }
    
    func detailPlace(place: PlaceInfo, category: PlaceCategory) {
        //선택된 장소 업데이트
        self.currentPlace = place
        usecase.getDetailPlace(archiveId: archiveId, placeId: place.placeId)
    }
    
    func participants() {
        self.coordinator.participants(detailArchive: detailArchive)
    }
    
    func invitations() {
        self.coordinator.invitationBottomSheet(archiveId: archiveId, copyCode: archiveCode ?? "")
    }
    
    func updateSelectedCategory(category: PlaceCategory) {
        WappleLog.debug("Update selectedCategory \(category)")
        selectedCategory = category
        if category.name == confirmCategoryName {
            usecase.getConfirmPlace(archiveId: archiveId)
        }else {
            usecase.getPlaceByCategory(archiveId: archiveId, categoryId: category.id)
        }
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
    
    func addCategories(archiveId: Int, categoryName: [String]) {
        usecase.addCategory(archiveId: archiveId, categoryName: categoryName)
    }
    
    func deleteCategories(categoryId: Int) {
        usecase.deleteCategory(archiveId: archiveId, categoryId: categoryId)
    }

}

extension DetailArchiveViewModel {
    func cancelConfirm(placeId: Int) {
        usecase.cancelConfirmPlace(archiveId: archiveId, placeId: placeId)
    }
    
    func setConfirm(placeId: Int) {
        usecase.setConfirmPlace(archiveId: archiveId, placeId: placeId)
    }
    
    func addLike(placeId: Int) {
        usecase.addLike(placeId: placeId)
    }
    
    func deletLike(placeId: Int) {
        usecase.deleteLike(placeId: placeId)
    }
    
    func changeConfirmSequence(placeSequence:GetPlaceSequence) {
        usecase.changeConfirmSquence(archiveId: archiveId, placeSequence: placeSequence)
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
