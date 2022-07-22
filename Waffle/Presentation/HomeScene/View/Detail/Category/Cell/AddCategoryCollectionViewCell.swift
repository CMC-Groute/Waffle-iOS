//
//  AddCategoryCollectionViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/27.
//

import UIKit
import SnapKit

class AddCategoryCollectionViewCell: UICollectionViewCell {
    static var identifier = "AddCategoryCollectionViewCell"
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Assets.addCategory.image, for: .normal)
        button.makeRounded(corner: 20)
        button.layer.borderColor = Asset.Colors.gray4.color.cgColor
        button.isUserInteractionEnabled = false
        button.layer.borderWidth = 1.5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        contentView.backgroundColor = Asset.Colors.white.color
        contentView.addSubview(addButton)
        contentView.makeRounded(width: nil, color: nil, value: 17)
        addButton.makeRounded(corner: 17)
        addButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(33)
        }
    }
    
    func configureCell(isEditing: Bool) {
        isEditing ? editingUI() : defaultUI()
    }
    
    func defaultUI() {
        addButton.setImage(Asset.Assets.addCategory.image, for: .normal)
        addButton.setTitle(.none, for: .normal)
        addButton.layer.borderColor = Asset.Colors.gray4.color.cgColor
        addButton.layer.borderWidth = 1.5
    }
    
    func editingUI() {
        addButton.setImage(.none, for: .normal)
        addButton.setTitle("완료", for: .normal)
        addButton.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 15)
        addButton.setTitleColor(Asset.Colors.orange.color, for: .normal)
        addButton.layer.borderColor = Asset.Colors.orange.color.cgColor
        addButton.layer.borderWidth = 1
    }
    
}
