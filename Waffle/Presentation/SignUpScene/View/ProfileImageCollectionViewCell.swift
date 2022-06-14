//
//  ProfileImageCollectionViewCell.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import SnapKit

class ProfileImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileImageCollectionViewCell"

    lazy var imageview: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        //image.image = UIImage(named: Asset.Assets.joinProcessed3.name)
        return image
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
        imageview.addSubview(selectedButton)
        selectedButton.isHidden = true
        
        self.imageview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.selectedButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func selected(isSelected: Bool){
        self.selectedButton.isHidden = isSelected ? false : true
    }
    
}
