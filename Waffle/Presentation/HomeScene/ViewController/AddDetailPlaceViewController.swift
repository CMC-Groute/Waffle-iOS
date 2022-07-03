//
//  DetailPlaceViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/28.
//

import UIKit

class AddDetailPlaceViewController: UIViewController {
    var viewModel: AddDetailPlaceViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    
    lazy var placeFramView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var placeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.black.color
        label.font = UIFont.fontWithName(type: .medium, size: 17)
        return label
    }()
    
    lazy var placeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.gray5.color
        label.font = UIFont.fontWithName(type: .regular, size: 13)
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        let image = Asset.Assets.deleteButton.image.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
      
    }
    
    private func configureUI() {
        addButton.makeRounded(corner: 26)
        placeTextField.makeRounded(corner: 10)
        linkTextField.makeRounded(corner: 10)
        memoTextView.makeRounded(width: 2, color: Asset.Colors.gray2.name, value: 10)

        linkTextField.padding(value: 9, icon: Asset.Assets.deleteButton.name)
        linkTextField.setClearButton(with: Asset.Assets.delete.image, mode: .whileEditing)
        placeTextField.padding(value: 9)
        memoTextView.attributedText = memoTextView.text.setLineHeight(24)
        memoTextView.textContainerInset = UIEdgeInsets(top: 16, left: 14, bottom: 16, right: 14)
        
        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "장소 추가하기"
        let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    
    @objc func didTapBackButton() {
        viewModel?.back()
    }

}

extension AddDetailPlaceViewController: UICollectionViewDelegate {
    
}

extension AddDetailPlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let category = viewModel?.categoryInfo else { return 0 }
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        guard let categoryName = viewModel?.categoryInfo else { return cell }
        cell.configureCell(name: categoryName[indexPath.row].name, isEditing: false)
        return cell
        
    }
}

extension AddDetailPlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryLabel.text = viewModel!.categoryInfo[indexPath.row].name
        cell.categoryLabel.sizeToFit()
        let cellWidth = cell.categoryLabel.frame.width + 34

        return CGSize(width: cellWidth, height: 33)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}
