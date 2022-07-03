//
//  EditPlaceViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import UIKit
import RxSwift

class EditPlaceViewController: UIViewController {
    var viewModel: EditPlaceViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    lazy var placeFramView: UIView = {
        let view = UIView()
        view.makeRounded(width: 1, color: Asset.Colors.gray2.name, value: 10)
        view.backgroundColor = Asset.Colors.white.color
        return view
    }()
    
    lazy var placeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.black.color
        label.text = "placeTitleLabel"
        label.font = UIFont.fontWithName(type: .medium, size: 17)
        return label
    }()
    
    lazy var placeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.gray5.color
        label.text = "placeTiplaceSubtitleLabeltleLabel"
        label.font = UIFont.fontWithName(type: .regular, size: 13)
        return label
    }()
    
    lazy var placeDeleteButton: UIButton = {
        let button = UIButton()
        let image = Asset.Assets.delete.image.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "클릭하면 장소를 검색할 수 있어요"
        textField.font = UIFont.fontWithName(type: .regular, size: 15)
        textField.backgroundColor = Asset.Colors.gray2.color
        textField.makeRounded(corner: 10)
        textField.padding(value: 9)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureUI() {
        editButton.makeRounded(corner: 26)
        linkTextView.makeRounded(width: nil, color: nil, value: 10)
        memoTextView.makeRounded(width: 2, color: Asset.Colors.gray2.name, value: 10)
        memoTextView.dataDetectorTypes = .link
//        linkTextView.padding(value: 9, icon: Asset.Assets.deleteButton.name)
//        linkTextView.setClearButton(with: Asset.Assets.delete.image, mode: .whileEditing)
        memoTextView.attributedText = memoTextView.text.setLineHeight(24)
        memoTextView.textContainerInset = UIEdgeInsets(top: 16, left: 14, bottom: 16, right: 14)
        configureNavigationBar()
        configureCollectionView()
    }
    
    @objc func didTapBackButton() {
        viewModel?.back()
    }
    
    @objc func didTapTrashButton() {
        viewModel?.deletePlace()
    }
    
    func configureNavigationBar() {
        let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
        self.navigationItem.title = "장소 수정하기"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Asset.Assets.trash.name)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapTrashButton))
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    
    private func textViewScrollToBottom() {
        let bottomRange = NSMakeRange(self.memoTextView.text.count - 1, 1)
        self.memoTextView.scrollRangeToVisible(bottomRange)
    }
    
    private func placeAddLayout() {
        placeTextField.removeFromSuperview()
        
        view.addSubview(placeFramView)
        placeFramView.addSubview(placeTitleLabel)
        placeFramView.addSubview(placeSubtitleLabel)
        placeFramView.addSubview(placeDeleteButton)
        
        placeFramView.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(11)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(linkLabel.snp.top).offset(-32)
            $0.height.equalTo(86)
        }
        
        placeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalToSuperview().offset(14)
        }
        
        placeSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(placeTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-23)
        }
        
        placeDeleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.bottom.equalToSuperview().offset(-23)
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.height.equalTo(40)
        }
        
    }
    
    private func placeInputTextFieldLayout() {
        for subView in placeFramView.subviews {
            subView.removeFromSuperview()
        }
        view.addSubview(placeTextField)
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(11)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(linkLabel.snp.top).offset(-32)
            $0.height.equalTo(50)
        }
        placeFramView.removeFromSuperview()
    }
    
    private func bindViewModel() {
        
    }

}

extension EditPlaceViewController: UICollectionViewDelegate {
    
}

extension EditPlaceViewController: UICollectionViewDataSource {
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

extension EditPlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryLabel.text = viewModel!.categoryInfo[indexPath.row].name
        cell.categoryLabel.sizeToFit()
        let cellWidth = cell.categoryLabel.frame.width + 34

        return CGSize(width: cellWidth, height: 33)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}

