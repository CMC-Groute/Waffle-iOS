//
//  TopDetialArchiveCollectionViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/06.
//

import UIKit

protocol ViewTappedDelegate: AnyObject {
    func viewTapped(_ photo : String)
  }


class TopDetailArchiveCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    static let identifier = "TopDetailArchiveCollectionViewCell"
    @IBOutlet weak var frameView: UIView!
    @IBOutlet private weak var whenLabel: UILabel!
    @IBOutlet private weak var whereLabel: UILabel!
    @IBOutlet private weak var toppingImageView: UIImageView!
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoLabel: UILabel!
    
    @IBAction func buttonTap(_ sender: Any) {
        print("Button tap")
    }
    var viewModel: DetailArchiveViewModel?
    weak var delegate : ViewTappedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    private func setUp() {
        memoView.makeRounded(width: nil, color: nil, value: 20)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                            action: #selector(handleTap(recognizer:)))
                    tapGesture.delegate = self
        memoView.isUserInteractionEnabled = true
        memoView.addGestureRecognizer(tapGesture)
        
//        let loadMemoTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLoadMemo))
//        loadMemoTapGesture.delegate = self
//        memoView.isUserInteractionEnabled = true
//        memoView.addGestureRecognizer(loadMemoTapGesture)
    }
    
    @objc func handleTap(recognizer:UITapGestureRecognizer) {
                //Call Delegate method from here...
        print("handleTap")
        delegate?.viewTapped("")
            }
    
    @objc func didTapLoadMemo() {
        print("didTapLoadMemo")
        viewModel?.loadMemo(memo: memoLabel.text ?? DefaultDetailCardInfo.archiveMemo.rawValue)
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
