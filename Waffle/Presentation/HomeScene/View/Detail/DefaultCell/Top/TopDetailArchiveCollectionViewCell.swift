//
//  TopDetialArchiveCollectionViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/06.
//

import UIKit

class TopDetailArchiveCollectionViewCell: UICollectionViewCell {
    static let identifier = "TopDetailArchiveCollectionViewCell"
    @IBOutlet weak var frameView: UIView!
    @IBOutlet private weak var whenLabel: UILabel!
    @IBOutlet private weak var whereLabel: UILabel!
    @IBOutlet private weak var toppingImageView: UIImageView!
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoLabel: UILabel!
    
    var viewModel: DetailArchiveViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    private func setUp() {
        memoView.makeRounded(width: nil, color: nil, value: 20)
        //memoLabel.addTrailing(with: "...", moreText: "더보기", moreTextFont: UIFont.fontWithName(type: .regular, size: 14), moreTextColor: Asset.Colors.gray5.color)
        memoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLoadMemo)))
        
    }
    
    @objc func didTapLoadMemo() {
        print("didTapLoadMemo")
        viewModel?.loadMemo()
    }
    
    func configureCell(cardInfo: CardInfo?) {
        guard let cardInfo = cardInfo else { return }

        let wappleIndex = WappleType.init(rawValue: cardInfo.cardType)?.wappleIndex() ?? 0
        print("wappleIndex \(wappleIndex) \(cardInfo.cardType)")
        toppingImageView.image = UIImage(named: "detailWapple-\(wappleIndex)")
        let cardColor = WappleType.init(rawValue: cardInfo.cardType)?.wappleColor().colorName() ?? "lightPurple"
        frameView.backgroundColor = UIColor(named: cardColor)
        whenLabel.text = cardInfo.date ?? DefaultDetailCardInfo.when.rawValue
        whereLabel.text = cardInfo.place ?? DefaultDetailCardInfo.where.rawValue
        memoLabel.text = cardInfo.memo ?? DefaultDetailCardInfo.archiveMemo.rawValue
    }

}
