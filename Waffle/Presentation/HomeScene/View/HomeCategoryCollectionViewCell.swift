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
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeCategoryCollectionViewCell", bundle: nil)
    }

    func setUp() {
        titleButton.round(corner: 20)
        self.contentView.addSubview(titleButton)
        titleButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func configureCell(category: Category) {
        titleButton.setTitle(category.name, for: .normal)
        self.setSelected(category.selected)
    }
    
    func setSelected(_ value: Bool) {
        if value == true { // 선택 되어 있는 셀 비활성화, 클릭 x
            self.isUserInteractionEnabled = false
            //UI
            self.titleButton.isUserInteractionEnabled = false
            self.selectedUI()
            self.titleButton.layer.opacity = 0.7
        }else {
            self.isUserInteractionEnabled = true
            self.titleButton.isUserInteractionEnabled = true
            //UI
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