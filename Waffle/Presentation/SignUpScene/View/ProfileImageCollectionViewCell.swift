//
//  ProfileImageCollectionViewCell.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProfileImageCollectionViewCell"
    
    override var isSelected: Bool {
        didSet {
            self.frameView.isHidden = isSelected ? false : true
        }
    }
    
    lazy var imageview: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        return image
    }()
    
    var frameView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.Colors.black.color
        view.layer.opacity = 0.7
        return view
    }()
    
    var selectedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Asset.Assets.check.name), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    
    private func configureUI() {
        self.addSubview(self.imageview)
        imageview.addSubview(frameView)
        frameView.addSubview(selectedButton)
        frameView.isHidden = true
        
        self.imageview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.frameView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.selectedButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
