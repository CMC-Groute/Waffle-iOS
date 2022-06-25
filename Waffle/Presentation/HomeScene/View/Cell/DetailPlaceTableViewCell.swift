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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(placeInfo: PlaceInfo) {
        titleLabel.text = placeInfo.title
        placeLabel.text = placeInfo.place
    }

}
