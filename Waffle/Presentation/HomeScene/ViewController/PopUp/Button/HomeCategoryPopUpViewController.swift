//
//  HomeCategoryPopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

protocol HomeCategoryPopUpDelegate {
    func selectedCategory(category: [Category])
}

class HomeCategoryPopUpViewController: UIViewController {
    var coordinator: HomeCoordinator!
    
    var selectedCategoryList: [Category] = [Category(name: "맛집", index: 0), Category(name: "소품샵", index: 5)]
    var enableCategoryList = Category.categoryList
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var delegate: HomeCategoryPopUpDelegate?
    
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
        addButton.round(corner: 24)
        addButton.setUnEnabled(color: Asset.Colors.gray4.name)
    }
    
    private func filterEnabledCategory() {
        for i in selectedCategoryList {
            enableCategoryList[i.index].selected = true
        }
    }
    
    private func collectionViewSetup() {
        collectionView.register(HomeCategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeCategoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
    }
    
    private func bindUI() {
        addButton.rx.tap
        .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            var items: [Category] = []
            for i in self.collectionView.indexPathsForSelectedItems! {
                items.append(self.enableCategoryList[i.row])
            }
            
            self.delegate?.selectedCategory(category: items)
            self.coordinator.popToRootViewController(with: nil)
        }).disposed(by: disposeBag)
    }
    
    func checkItem() { // 버튼 활성화
        guard let items = collectionView.indexPathsForSelectedItems else { return }
        if !items.isEmpty {
            addButton.setEnabled(color: Asset.Colors.black.name)
        }else {
            addButton.setEnabled(color: Asset.Colors.black.name)
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
        cell.configureCell(category: enableCategoryList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // 선택
        checkItem()
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCategoryCollectionViewCell
        cell.selectedUI()
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) { // 선택 해제
        checkItem()
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCategoryCollectionViewCell
        cell.unSelectedUI()
        collectionView.reloadItems(at: [indexPath])
    }
    
    
}

extension HomeCategoryPopUpViewController: UICollectionViewDelegateFlowLayout {
    
}
