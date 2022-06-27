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
        categoryButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        self.contentView.addSubview(categoryButton)
    }
    
    func configureCell(name: String){
        self.categoryButton.setTitle("#\(name)", for: .normal)
    }

}
