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
        var invitationButton: Observable<Void>
        var participantsButton: Observable<Void>
        var addPlaceButton: Observable<Void>
    }
    
    struct Output {
        var whenTextLabel = BehaviorRelay<String>(value: DefaultDetailCardInfo.when.rawValue)
        var whereTextLabel = BehaviorRelay<String>(value: DefaultDetailCardInfo.where.rawValue)
        var memoTextLabel = BehaviorRelay<String>(value: DefaultDetailCardInfo.archiveMemo.rawValue)
        var frameViewColor = BehaviorRelay<String>(value: "")
        var frameImageView = BehaviorRelay<UIImage>(value: UIImage(named: Asset.Assets.detailWapple1.name)!)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                //TO DO get place data 
                guard let self = self else { return }
                self.placeInfo = PlaceInfo.dummyPlace
                guard let detailArchive = self.detailArchive else {
                   return
               }
               if let date = detailArchive.date {
                   let dateString = Date.getDate(dateString: date)
                   output.whenTextLabel.accept("\(dateString.joined(separator: " "))")
               }
               output.whereTextLabel.accept(detailArchive.place ?? DefaultDetailCardInfo.where.rawValue)
               output.frameImageView.accept(UIImage(named: "detailWapple-\(detailArchive.color + 1)")!)
               output.frameViewColor.accept(CardViewInfoType(index: detailArchive.color).colorName())
                output.memoTextLabel.accept(detailArchive.memo ?? DefaultDetailCardInfo.archiveMemo.rawValue)
                self.category += Category.dummyList
            }).disposed(by: disposeBag)
        
        input.addPlaceButton
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let placeCategory = self.category.filter { $0.index != -1 }
                self.coordinator.addDetailPlace(category: placeCategory)
            }).disposed(by: disposeBag)
        
        input.participantsButton
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.participants(cardInfo: self.detailArchive)
            }).disposed(by: disposeBag)
        
        input.invitationButton
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.invitationBottomSheet(copyCode: self.code ?? "")
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func setArchive(archive: CardInfo) {
        usecase.currentArchive.onNext(archive)
    }
    
    func placeInfoByCategory() -> [PlaceInfo] {
        return placeInfo.filter { $0.category.index == selectedCategory.index }
    }
    
    func detailArhive() { // bottomSheet popUp
        coordinator.detailArchiveBottomSheet(cardInfo: detailArchive)
    }
    
    func detailPlace(place: PlaceInfo, category: Category) {
        coordinator.detailPlace(detailInfo: place, category: category, categoryInfo: self.category)
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
        coordinator.loadMemo(memo: memo, wapple: "memoWapple-\(detailArchive.color + 1)")
    }
    
    func popViewController() {
        coordinator.popViewController()
    }

}
