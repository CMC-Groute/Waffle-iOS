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
    
    lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.round(corner: 20)
        button.setTitleColor(Asset.Colors.gray7.color, for: .normal)
        button.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 15)
        button.isUserInteractionEnabled = false
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
        contentView.addSubview(categoryButton)
        contentView.round(width: nil, color: nil, value: 17)
        categoryButton.round(corner: 17)
        categoryButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(33)
        }
    }
    
    func configureCell(name: String){
        if name == "확정" {
            self.categoryButton.setTitle("\(name)", for: .normal)
        }else {
            self.categoryButton.setTitle("#\(name)", for: .normal)
        }
    }

}
