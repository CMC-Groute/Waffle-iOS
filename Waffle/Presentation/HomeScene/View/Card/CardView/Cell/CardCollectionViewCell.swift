//
//  CardCollectionViewCell.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/22.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    static var identifier = "CardCollectionViewCell"
    @IBOutlet private var cardView: CardView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CardCollectionViewCell", bundle: nil)
    }

    func configureCell(item: CardInfo) {
        cardView.bindUI(item: item)
    }
    
}
