//
//  DetailPlaceTableViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit

protocol DetailPlaceTableViewCellDelegate {
    func didTapLikeButton()
}

class DetailPlaceTableViewCell: UITableViewCell {
    static var identifier = "DetailPlaceTableViewCell"
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var detailButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16.0, left: 16, bottom: 16, right: 16))
    }
    
    func setUp() {
        contentView.round(width: nil, color: nil, value: 20)
        self.backgroundColor = Asset.Colors.gray1.color
        contentView.backgroundColor = Asset.Colors.white.color
    }
    
    func configureCell(placeInfo: PlaceInfo) {
        titleLabel.text = placeInfo.title
        placeLabel.text = placeInfo.place
    }

}
