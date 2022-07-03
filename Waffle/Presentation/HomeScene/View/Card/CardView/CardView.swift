//
//  CardView.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/22.
//

import UIKit

final class CardView: UIView {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var wappleLabel: UILabel!
    @IBOutlet weak var toppingLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
        configure()
    }
    
    init() {
        super.init(frame: .zero)
        xibSetup()
        configure()
    }
    
    private func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CardView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    private func configure() {
        topView.roundCorners(value: 20, maskedCorners: [.layerMinXMinYCorner,
            .layerMaxXMinYCorner])
        bottomView.roundCorners(value: 20, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
    }
    
    func bindUI(item: CardInfo) {
        topView.backgroundColor = UIColor(named: CardViewInfoType(index: item.color).colorName())
        cardImageView.image = UIImage(named: "card\(item.color + 1)")
        titleLabel.text = item.title
        placeLabel.text = item.place ?? DefaultDetailCardInfo.where.rawValue
        if let date = item.date {
            let dateArray = Date.getDate(dateString: date)
            timeLabel.text = "\(dateArray[0]) \(dateArray[1])"
        }else {
            timeLabel.text = DefaultDetailCardInfo.when.rawValue
        }
        
        if let memo = item.memo {
            memoLabel.text = memo
        }else {
            memoLabel.text = DefaultDetailCardInfo.archiveMemo.rawValue
        }

        wappleLabel.text = item.wapple
        if item.topping.isEmpty {
            toppingLabel.text = DefaultDetailCardInfo.topping.rawValue
        }else {
            toppingLabel.text = item.topping.joined(separator: ", ")
        }
    }
}

