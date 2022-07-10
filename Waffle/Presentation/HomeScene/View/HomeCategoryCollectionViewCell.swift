//
//  HomeCategoryCollectionViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import SnapKit

class HomeCategoryCollectionViewCell: UICollectionViewCell {
    static var identifier = "HomeCategoryCollectionViewCell"
    
    lazy var titleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Asset.Colors.gray7.color, for: .normal)
        button.isUserInteractionEnabled = false
        button.backgroundColor = Asset.Colors.gray2.color
        button.titleLabel?.font = UIFont.homeCategoryTitle()
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
        titleButton.makeRounded(corner: 20)
        self.addSubview(titleButton)
        titleButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(93)
            $0.height.equalTo(40)
        }
    }
    
    func configureCell(category: PlaceCategory, selectedCategoryList: [PlaceCategory]) {
        titleButton.setTitle(category.name, for: .normal)
        let selectedCategory = selectedCategoryList.filter {
            let name = CategoryType.init(rawValue: $0.name)?.format() ?? ""
            //WappleLog.debug("selectedCategory \(name) category \(category)")
            return name == category.name
        }
        
        if !selectedCategory.isEmpty { //선택된 카테고리라면
            self.isUserInteractionEnabled = false
            self.selectedUI()
            self.titleButton.layer.opacity = 0.3
        }else {
            self.titleButton.layer.opacity = 1.0
            self.unSelectedUI()
        }
    }
    
    func selectedUI() {
        self.titleButton.setTitleColor(Asset.Colors.white.color, for: .normal)
        self.titleButton.backgroundColor = Asset.Colors.orange.color
    }
    
    func unSelectedUI() {
        self.titleButton.setTitleColor(Asset.Colors.gray7.color, for: .normal)
        self.titleButton.backgroundColor = Asset.Colors.gray2.color
    }
    
    
}
