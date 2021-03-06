//
//  LocationLeftTableviewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/14.
//

import UIKit

class LocationLeftTableviewCell: UITableViewCell {
    static let identifier = "LocationLeftTableviewCell"

    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.labelTitleFont()
        label.textColor = Asset.Colors.black.color
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configureUI()
    }
    
    func configureUI() {
        self.contentView.addSubview(label)
//        self.contentView.backgroundColor = Asset.Colors.gray2.color
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(23)
            $0.trailing.equalToSuperview().offset(-26)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func selected(isSelected: Bool){
        self.contentView.backgroundColor = isSelected ? Asset.Colors.gray2.color : Asset.Colors.yellow.color
    }

}
