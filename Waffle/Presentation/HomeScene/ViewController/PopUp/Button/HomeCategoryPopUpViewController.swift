//
//  HomeCategoryPopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

protocol HomeCategoryPopUpDelegate: AnyObject {
    func selectedCategory(archiveId: Int, categoryName: [String])
}

class HomeCategoryPopUpViewController: UIViewController {
    var coordinator: HomeCoordinator!
    var usecase: HomeUsecase!
    
    var selectedCategoryList: [PlaceCategory] = [] // 선택된 카테고리 리스트
    var enableCategoryList = PlaceCategory.categoryList
    var archiveId: Int?
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet private weak var frameView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!
    weak var delegate: HomeCategoryPopUpDelegate?
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        collectionViewSetup()
        bindUI()
    }
    
    private func configureUI() {
        closeButton.setImage(Asset.Assets.delete.image.withRenderingMode(.alwaysOriginal), for: .normal)
        frameView.makeRounded(width: nil, color: nil, value: 20)
        addButton.makeRounded(corner: 24)
        addButton.setUnEnabled(color: Asset.Colors.gray4.name)
    }
    
//    private func filterEnabledCategory() {
//        print("get selectedCategoryList \(selectedCategoryList)")
//        for i in selectedCategoryList {
//            enableCategoryList[i.index].isSelected = true
//        }
//    }
    
    private func collectionViewSetup() {
        //filterEnabledCategory()
        collectionView.register(HomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: HomeCategoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
    }
    
    private func bindUI() {
        closeButton.rx.tap
            .subscribe(onNext: {
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
            }).disposed(by: disposeBag)
        
        addButton.rx.tap
        .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard let archiveId = self.archiveId else { return }

            var items: [PlaceCategory] = []
            for i in self.collectionView.indexPathsForSelectedItems! {
                items.append(self.enableCategoryList[i.row])
            }
            
            let name = items.map { $0.name }
                .map { SendCategory.dictionary[$0] ?? "" }
            
            print("selected item \(name)")
            
            self.coordinator.popToViewController(with: nil, width: nil, height: nil)
            self.delegate?.selectedCategory(archiveId: archiveId, categoryName: name)
        }).disposed(by: disposeBag)
    }
    
    func checkItem() { // 버튼 활성화
        guard let items = collectionView.indexPathsForSelectedItems else { return }
        if !items.isEmpty {
            addButton.setEnabled(color: Asset.Colors.black.name)
        }else {
            addButton.setUnEnabled(color: Asset.Colors.gray4.name)
        }
    }
}

extension HomeCategoryPopUpViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return enableCategoryList.count
    }
}

extension HomeCategoryPopUpViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCollectionViewCell.identifier, for: indexPath) as! HomeCategoryCollectionViewCell
        cell.configureCell(category: enableCategoryList[indexPath.row], selectedCategoryList: selectedCategoryList)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // 선택
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCategoryCollectionViewCell
        cell.selectedUI()
        checkItem()
        //collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) { // 선택 해제
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCategoryCollectionViewCell
        cell.unSelectedUI()
        checkItem()
        //collectionView.reloadItems(at: [indexPath])
    }
    
    
}

extension HomeCategoryPopUpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 93, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
