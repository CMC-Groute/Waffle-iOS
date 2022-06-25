//
//  DetailPlaceTableViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol DetailPlaceTableViewCellDelegate {
    func didTapLikeButton()
    func didTapConfirmButton()
    func didTapDetailButton()
}

class DetailPlaceTableViewCell: UITableViewCell {
    static var identifier = "DetailPlaceTableViewCell"
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var detailButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var canEditingButton: UIButton!
    let disposeBag = DisposeBag()
    var delegate: DetailPlaceTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        bindUI()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16.0, left: 16, bottom: 16, right: 16))
    }
    
    func setUp() {
        contentView.round(width: nil, color: nil, value: 20)
        self.backgroundColor = Asset.Colors.gray1.color
        contentView.backgroundColor = Asset.Colors.white.color
        canEditingButton.isHidden = true
    }
    
    func configureCell(placeInfo: PlaceInfo) {
        if placeInfo.category.index == -1 {
            canEditingButton.isHidden = false
        }
        
        titleLabel.text = placeInfo.title
        placeLabel.text = placeInfo.place
        if placeInfo.isConfirm {
            //selected Button
            confirmButton.setImage(Asset.Assets.placeCheckSelected.image, for: .normal)
        }else {
            confirmButton.setImage(Asset.Assets.placeCheck.image, for: .normal)
        }
        
        // TO DO : 유저가 좋아요 한 장소인지에 따라 버튼 이미지 바꾸기
        likeButton.setTitle("좋아요 \(placeInfo.likeCount)", for: .normal)
    }
    
    private func bindUI() {
        detailButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.didTapDetailButton()
            }).disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.didTapConfirmButton()
            }).disposed(by: disposeBag)
        
        likeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.didTapLikeButton()
            }).disposed(by: disposeBag)
    }

}
