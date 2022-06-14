//
//  LocationRightTableViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/14.
//

import UIKit
import SnapKit

class LocationRightTableViewCell: UITableViewCell {
    static var identifier = "LocationRightTableViewCell"
    
    lazy var flagImge: UIImageView = { // for selected
        let image = UIImage(named: "flag")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.labelTitleFont()
        label.textColor = Asset.Colors.black.color
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configureUI()
        // Configure the view for the selected state
    }
    
    func configureUI() {
        self.contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(23)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }

}
