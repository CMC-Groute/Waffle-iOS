//
//  DetailArchiveCollectionViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/10.
//

import UIKit

class DetailArchiveCollectionViewCell: UICollectionViewCell {
    static let identifier = "DetailArchiveCollectionViewCell"
    
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var frameView: UIView!
    @IBOutlet private weak var whenLabel: UILabel!
    @IBOutlet private weak var whereLabel: UILabel!
    @IBOutlet private weak var toppingImageView: UIImageView!
    @IBOutlet weak var memoLabel: UILabel!
    var viewModel: DetailArchiveViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    private func setUp() {
        memoView.makeRounded(width: nil, borderColor: nil, value: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loadMemo(recognizer:)))
        memoView.isUserInteractionEnabled = true
        memoView.addGestureRecognizer(tapGesture)
    }
    
    @objc func loadMemo(recognizer:UITapGestureRecognizer) {
        viewModel?.loadMemo(memo: memoLabel.text ?? DefaultDetailCardInfo.archiveMemo.rawValue)
    }
    
    func configureCell(detailArchive: DetailArhive?) {
        guard let cardInfo = detailArchive else { return }
        let wappleIndex = WappleType.init(rawValue: cardInfo.placeImage)?.wappleIndex() ?? 0
        toppingImageView.image = UIImage(named: "detailWapple-\(wappleIndex)")
        let cardColor = WappleType.init(rawValue: cardInfo.placeImage)?.wappleColor().colorName() ?? "lightPurple"
        frameView.backgroundColor = UIColor(named: cardColor)
        if let date = cardInfo.date, let time = cardInfo.time {
            whenLabel.text = "\(Date().detailDateString(date: date)) \(time.amPmChangeFormat())"
        }else {
            whenLabel.text = DefaultDetailCardInfo.when.rawValue
        }
        whereLabel.text = cardInfo.place ?? DefaultDetailCardInfo.where.rawValue
        memoLabel.text = cardInfo.memo ?? DefaultDetailCardInfo.archiveMemo.rawValue
    }

}
