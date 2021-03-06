//
//  CategoryDefailArchiveCollectionViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/06.
//

import UIKit

protocol CategoruDetailArchiveDelegate: AnyObject {
    func showNotDeleteCategoryToastMessage()
}

final class CategoryDetailArchiveCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryDefailArchiveCollectionViewCell"
    @IBOutlet private weak var collectionView: UICollectionView!

    var viewModel: DetailArchiveViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: Private Property
    var isCategoryEditing: Bool = false
    weak var delegate: CategoruDetailArchiveDelegate?
    private var confirmCellCount = 1
    private let confirmCategoryName = "확정"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    private func setUp() {
        configureGesture()
        configureCollectionView()
    }
    
    private func configureGesture() {
        let editGesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapEditingMode))
        editGesture.minimumPressDuration = 0.5
        editGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(editGesture)
    }
    
    
    @objc func didTapEditingMode() {
        isCategoryEditing = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.register(ConfirmCategoryCollectionViewCell.self, forCellWithReuseIdentifier: ConfirmCategoryCollectionViewCell.identifier)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(AddCategoryCollectionViewCell.self, forCellWithReuseIdentifier: AddCategoryCollectionViewCell.identifier)
    }

}

extension CategoryDetailArchiveCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.category.count + confirmCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfirmCategoryCollectionViewCell.identifier, for: indexPath) as! ConfirmCategoryCollectionViewCell
            if viewModel?.selectedCategory.name == confirmCategoryName {
                cell.isSelected = true
                collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .init())
            }else { // 해당 카테고리 선택되어 있게끔 수정
                guard let row = viewModel?.category.firstIndex(where: { $0.name == viewModel?.selectedCategory.name }) else { return cell }
                cell.isSelected = true
                collectionView.selectItem(at: [0, row], animated: true, scrollPosition: .init())
            }
            return cell
        }

        if indexPath.row == viewModel?.category.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCategoryCollectionViewCell.identifier, for: indexPath) as! AddCategoryCollectionViewCell
            cell.configureCell(isEditing: isCategoryEditing)
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configureCell(name: viewModel?.category[indexPath.row].name ?? "", isEditing: isCategoryEditing)
        return cell

    }
}


extension CategoryDetailArchiveCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let viewModel = viewModel else { return }
            if indexPath.row == viewModel.category.count { //마지막 셀 클릭 시
                if isCategoryEditing {
                    isCategoryEditing = false
                    viewModel.isCategoryEditing = false // 상위 뷰 카테고리 false 만들어줌
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.collectionView.reloadData()
                    }
                }else {
                    viewModel.addHomeCategory(without: viewModel.category)
                }
            }else {
                let selectedCategory = viewModel.category[indexPath.row]
                //선택된 카테고리 업데이트
                viewModel.updateSelectedCategory(category: selectedCategory)
            }
        }
}

extension CategoryDetailArchiveCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == viewModel!.category.count || indexPath.row == 0 {
            return CGSize(width: 60, height: 33)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryLabel.text = viewModel!.category[indexPath.row].name
        cell.categoryLabel.sizeToFit()
        var cellWidth = cell.categoryLabel.frame.width + 34
        if isCategoryEditing {
            cellWidth += 12 // 버튼만큼의 너비
        }
        return CGSize(width: cellWidth, height: 33)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(8)
    }
    
}

extension CategoryDetailArchiveCollectionViewCell: CategoryCollectionViewCellDelegate {
    func didTapDeleteButton(cell: CategoryCollectionViewCell) {
        guard let viewModel = viewModel else { return }
        // 확정, 1개만 남았을 경우 삭제 못하게 해야 함
        if viewModel.category.count == 2 {
            delegate?.showNotDeleteCategoryToastMessage()
        }else {
            guard let index = cell.indexPath?.row else { return }
            let currentCategory = viewModel.category[index]
            viewModel.deleteCategory(category: currentCategory)
        }
    }
}
