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
        button.round(corner: 20)
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
        contentView.addSubview(addButton)
        contentView.round(width: nil, color: nil, value: 17)
        addButton.round(corner: 17)
        addButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(33)
        }
    }
    
}
