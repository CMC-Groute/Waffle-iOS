//
//  PaticipantsTableViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/30.
//

import UIKit

enum ParticipantsType: String {
    case wapple, topping
}

class ParticipantsTableViewCell: UITableViewCell {
    @IBOutlet private weak var wappleImageView: UIImageView!
    @IBOutlet private weak var nickNameLabel: UILabel!
    @IBOutlet private weak var typeImageView: UIImageView!
    static let identifier = "ParticipantsTableViewCell"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    func configureUI() {
        wappleImageView.makeCircleShape()
    }
    
    func configureCell(info: ToppingInfo, type: ParticipantsType) {
        wappleImageView.image = UIImage(named: info.profileImage)
        nickNameLabel.text = info.nickName
        typeImageView.image = UIImage(named: "\(type.rawValue)-caption")
    }
}
