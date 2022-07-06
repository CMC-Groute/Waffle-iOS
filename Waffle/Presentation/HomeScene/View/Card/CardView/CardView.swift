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
        let backgroundColor = WappleType.init(rawValue: item.cardType)?.wappleColor().rawValue
        topView.backgroundColor = UIColor(named: backgroundColor ?? "")
        let wappleIndex = WappleType.init(rawValue: item.cardType)?.wappleIndex() ?? 0
        cardImageView.image = UIImage(named: "card-\(wappleIndex)")
        titleLabel.text = item.title
        placeLabel.text = item.place ?? DefaultDetailCardInfo.where.rawValue
        if let date = item.date {
            //let dateArray = Date.getDate(dateString: date) "\(dateArray[0]) \(dateArray[1])"
            timeLabel.text = date
        }else {
            timeLabel.text = DefaultDetailCardInfo.when.rawValue
        }
        
        if let memo = item.memo {
            memoLabel.text = memo
        }else {
            memoLabel.text = DefaultDetailCardInfo.archiveMemo.rawValue
        }
        let wapple = item.topping.filter { $0.userId == item.wappleId }.first
        let topping = item.topping.filter { $0.userId != item.wappleId }
        wappleLabel.text = wapple?.nickName
        if item.topping.isEmpty {
            toppingLabel.text = DefaultDetailCardInfo.topping.rawValue
        }else {
            if topping.isEmpty {
                toppingLabel.text = DefaultDetailCardInfo.topping.rawValue
            }else {
                let toppingName = topping.map { $0.nickName }.joined(separator: ", ")
                toppingLabel.text = toppingName
            }
        }
    }
}

