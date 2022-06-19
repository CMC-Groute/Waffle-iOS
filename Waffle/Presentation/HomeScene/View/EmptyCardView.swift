//
//  EmtpyCardView.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation
import UIKit

class EmptyCardView: UIView {
    @IBOutlet weak var makeArchiveButton: UIButton!
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
        let nib = UINib(nibName: "EmptyCardView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func configure() {
        makeArchiveButton.round(corner: 20)
        makeArchiveButton.layer.borderColor = Asset.Colors.orange.color.cgColor
        makeArchiveButton.layer.borderWidth = 1
    }
}
