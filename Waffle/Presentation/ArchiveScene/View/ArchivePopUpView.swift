//
//  ArchivePopUpView.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/18.
//

import Foundation
import UIKit

protocol ArchivePopUpViewDelegate: AnyObject {
    func didTapAddArchiveView()
    func didTapInputArchiveView()
    func didTapFrameView()
}

class ArchivePopUpView: UIView {
    @IBOutlet private weak var addArhiveView: UIView!
    @IBOutlet private weak var inputArhiveView: UIView!
    @IBOutlet private weak var frameView: UIView!
    
    weak var delegate: ArchivePopUpViewDelegate?
    
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
        let frameGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        addArhiveView.makeRounded(width: nil, borderColor: nil, value: 23.5)
        inputArhiveView.makeRounded(width: nil, borderColor: nil, value: 23.5)
        addArhiveView.addGestureRecognizer(addGestureRecognizer)
        inputArhiveView.addGestureRecognizer(inputGestureRecognizer)
        frameView.addGestureRecognizer(frameGestureRecognizer)
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        switch gesture.view {
        case addArhiveView:
            delegate?.didTapAddArchiveView()
        case inputArhiveView:
            delegate?.didTapInputArchiveView()
        case frameView:
            delegate?.didTapFrameView()
        default:
            break
        }
    }
    
    
    
    
}
