//
//  AddPlaceSearchTableViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import UIKit
import SnapKit

class AddPlaceSearchTableViewCell: UITableViewCell {
    static var identifider = "AddPlaceSearchTableViewCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.black.color
        label.font = UIFont.fontWithName(type: .medium, size: 17)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.gray5.color
        label.font = UIFont.fontWithName(type: .regular, size: 13)
        return label
    }()
    
    lazy var flagImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.Assets.flagWhite.image
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            isSelected ? selectedUI() : deseletedUI()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    
    func setUp() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(flagImage)
        flagImage.isHidden = true
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-52)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-52)
            $0.bottom.equalToSuperview().offset(12)
        }
        
        flagImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-24)
        }
    }
    
    func configureCell(title: String, address: String) {
        titleLabel.text = title
        addressLabel.text = address
    }
    
    func selectedUI() {
        flagImage.isHidden = false
        let selectedColor = Asset.Colors.white.color
        titleLabel.textColor = selectedColor
        addressLabel.textColor = selectedColor
    }
    
    func deseletedUI() {
        flagImage.isHidden = true
        titleLabel.textColor = Asset.Colors.black.color
        addressLabel.textColor = Asset.Colors.gray5.color
    }

}
