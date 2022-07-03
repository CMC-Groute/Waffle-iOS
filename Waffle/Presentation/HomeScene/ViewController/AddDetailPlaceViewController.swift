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
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "장소 추가하기"
        let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
    }
    
    @objc func didTapBackButton() {
        viewModel?.back()
    }

}
