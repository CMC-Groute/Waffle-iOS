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
    @IBOutlet private var cardView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CardCollectionViewCell", bundle: nil)
    }
    
    private func setup() {
        cardView.backgroundColor = .red
    }
    
    var scaleOptions = ScaleTransformViewOptions(
        minScale: 0.6,
        scaleRatio: 0.4,
        translationRatio: CGPoint(x: 0.66, y: 0.2),
        maxTranslationRatio: CGPoint(x: 2, y: 0)
    )
    
}


extension CardCollectionViewCell: TransformableView {
    func transform(progress: CGFloat) {
        let alpha = 1 - abs(progress)
        contentView.alpha = alpha
    }
}
