//
//  ArchivePopUpView.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/18.
//

import Foundation
import UIKit

class ArchivePopUpView: UIView {
    @IBOutlet private weak var addArhiveView: UIView!
    @IBOutlet private weak var inputArhiveView: UIView!
    let coordinator: ArchiveCoordinator!
    
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
        let nib = UINib(nibName: "ArchivePopUpView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func configure() {
        let addGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        let inputGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        addArhiveView.round(width: nil, color: nil, value: 23.5)
        inputArhiveView.round(width: nil, color: nil, value: 23.5)
        addArhiveView.addGestureRecognizer(addGestureRecognizer)
        inputArhiveView.addGestureRecognizer(inputGestureRecognizer)
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        switch gesture.view {
        case addArhiveView:
            
        case inputArhiveView:
            print("click inputArhiveView")
        default:
            break
        }
    }
    
    
    
    
}
