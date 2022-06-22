//
//  CardView.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/22.
//

import UIKit

final class CardView: UIView {
    enum CardViewInfoType: String, CaseIterable {
        case lightPurple, lightPink, lightMelon, lightMint, yellow
        
        init(index: Int) {
            switch index {
            case 0: self = .lightPurple
            case 1: self = .lightPink
            case 2: self = .lightMelon
            case 3: self = .lightMint
            case 4: self = .yellow
            default: self = .lightPurple
            }
        }
        
        func colorName() -> String {
            return self.rawValue
        }
    }
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
        
        self.topView.backgroundColor = UIColor(named: CardViewInfoType(index: item.color).colorName())
        self.cardImageView.image = UIImage(named: "card\(item.color + 1)")
        self.titleLabel.text = item.title
        self.placeLabel.text = item.place
        self.timeLabel.text = item.date
        self.memoLabel.text = item.memo
        self.wappleLabel.text = item.waffle
        self.toppingLabel.text = item.topping.joined(separator: ", ")
    }
}

