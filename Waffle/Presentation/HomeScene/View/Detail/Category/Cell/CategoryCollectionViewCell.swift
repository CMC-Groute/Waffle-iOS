//
//  CategoryCollectionViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/27.
//

import UIKit
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static var identifier = "CategoryCollectionViewCell"
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.gray7.color
        label.font = UIFont.fontWithName(type: .regular, size: 15)
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        return label
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Assets.deleteButton.image, for: .normal)
        return button
    }()
    
    override var isSelected: Bool {
        didSet {
            isSelected ? selectedUI() : deseletedUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        contentView.addSubview(categoryLabel)
        contentView.addSubview(deleteButton)
        contentView.round(width: nil, color: nil, value: 17)
        contentView.layer.borderColor = Asset.Colors.gray4.color.cgColor
        contentView.layer.borderWidth = 1
//        categoryLabel.backgroundColor = .green
//        deleteButton.backgroundColor = .blue
        defaultLayout()
        addObserver()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(editMode(_:)), name: Notification.Name.userEditMode, object: nil)
    }
    
    @objc func editMode(_ notification: Notification) {
        print("edit mode")
    }
    
    func configureCell(name: String, isEditing: Bool){
        categoryLabel.text = "#\(name)"
        if isEditing {
            editLayout()
        }else {
            defaultLayout()
        }
    }
    
    func defaultLayout() {
        deleteButton.isHidden = true
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
        }
    }
    
    func editLayout() {
        deleteButton.isHidden = false
        categoryLabel.snp.removeConstraints()
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-8)
        }
        deleteButton.snp.removeConstraints()
        deleteButton.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(4)
            $0.top.equalToSuperview().offset(8)
            $0.width.equalTo(10)
            $0.height.equalTo(16)
            $0.trailing.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func selectedUI() {
        categoryLabel.font = UIFont.fontWithName(type: .semibold, size: 15)
        contentView.backgroundColor = Asset.Colors.gray7.color
        categoryLabel.textColor = Asset.Colors.white.color
        contentView.layer.borderColor = .none
        contentView.layer.borderWidth = 0
        deleteButton.setImage(Asset.Assets.deleteSelectedButton.image, for: .normal)
    }
    
    func deseletedUI() {
        categoryLabel.font = UIFont.fontWithName(type: .regular, size: 15)
        contentView.backgroundColor = Asset.Colors.white.color
        categoryLabel.textColor = Asset.Colors.gray7.color
        contentView.layer.borderColor = Asset.Colors.gray4.color.cgColor
        contentView.layer.borderWidth = 1
        deleteButton.setImage(Asset.Assets.deleteButton.image, for: .normal)
    }

}
