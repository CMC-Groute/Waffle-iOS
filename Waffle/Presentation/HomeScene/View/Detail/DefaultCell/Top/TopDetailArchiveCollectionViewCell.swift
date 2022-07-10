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
        frameView.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        memoView.makeRounded(width: nil, color: nil, value: 20)
        let loadMemoTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLoadMemo))
        memoView.isUserInteractionEnabled = true
        memoView.addGestureRecognizer(loadMemoTapGesture)
    }
    
    @objc func didTapLoadMemo() {
        print("didTapLoadMemo")
        viewModel?.loadMemo()
    }
    
    func configureCell(detailArchive: DetailArhive?) {
        guard let cardInfo = detailArchive else { return }
        let wappleIndex = WappleType.init(rawValue: cardInfo.placeImage)?.wappleIndex() ?? 0
        toppingImageView.image = UIImage(named: "detailWapple-\(wappleIndex)")
        let cardColor = WappleType.init(rawValue: cardInfo.placeImage)?.wappleColor().colorName() ?? "lightPurple"
        frameView.backgroundColor = UIColor(named: cardColor)
        whenLabel.text = cardInfo.date ?? DefaultDetailCardInfo.when.rawValue
        whereLabel.text = cardInfo.place ?? DefaultDetailCardInfo.where.rawValue
        memoLabel.text = cardInfo.memo ?? DefaultDetailCardInfo.archiveMemo.rawValue
    }

}
