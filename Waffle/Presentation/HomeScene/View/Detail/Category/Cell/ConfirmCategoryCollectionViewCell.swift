//
//  ConfirmCategoryCollectionViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/27.
//

import UIKit

class ConfirmCategoryCollectionViewCell: UICollectionViewCell {
    static var identifier = "ConfirmCategoryCollectionViewCell"
    
    lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.round(corner: 20)
        button.setTitleColor(Asset.Colors.gray7.color, for: .normal)
        button.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 15)
        button.isUserInteractionEnabled = false
        button.layer.borderColor = Asset.Colors.gray4.color.cgColor
        button.layer.borderWidth = 1
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
        contentView.addSubview(categoryButton)
        contentView.round(width: nil, color: nil, value: 17)
        categoryButton.round(corner: 17)
        categoryButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(33)
        }
        self.categoryButton.setTitle("확정", for: .normal)
    }
    
    func selectedUI() {
        categoryButton.titleLabel?.font = UIFont.fontWithName(type: .semibold, size: 15)
        categoryButton.backgroundColor = Asset.Colors.green.color
        categoryButton.setTitleColor(Asset.Colors.white.color, for: .normal)
        categoryButton.layer.borderColor = .none
        categoryButton.layer.borderWidth = 0
    }
    
    func deseletedUI() {
        categoryButton.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 15)
        categoryButton.backgroundColor = Asset.Colors.white.color
        categoryButton.setTitleColor(Asset.Colors.gray7.color, for: .normal)
        categoryButton.layer.borderColor = Asset.Colors.gray4.color.cgColor
        categoryButton.layer.borderWidth = 1
    }
}
