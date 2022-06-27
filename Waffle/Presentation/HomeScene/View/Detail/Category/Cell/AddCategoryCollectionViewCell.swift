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
        addButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        self.contentView.addSubview(addButton)
    }
    
}
