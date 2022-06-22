//
//  CardCollectionViewCell.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/22.
//

import UIKit
import CollectionViewPagingLayout

class CardCollectionViewCell: UICollectionViewCell, ScaleTransformView {
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
    
    var scaleOptions: ScaleTransformViewOptions {
       .layout(.linear)
    }
    
    func configureCell(item: CardInfo) {
        self.contentView.round(width: nil, color: nil, value: 20)
        cardView.bindUI(item: item)
    }
    
}
