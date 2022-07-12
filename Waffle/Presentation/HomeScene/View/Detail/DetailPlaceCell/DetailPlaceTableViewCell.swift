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
    func didTapLikeButton(cell: DetailPlaceTableViewCell)
    func didTapsetConfirmButton(cell: DetailPlaceTableViewCell)
    func didTapcancelConfirmButton(cell: DetailPlaceTableViewCell)
    func didTapDetailButton(cell: DetailPlaceTableViewCell)
    func canEditingButton(cell: DetailPlaceTableViewCell)
}

class DetailPlaceTableViewCell: UITableViewCell {
    static var identifier = "DetailPlaceTableViewCell"
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet private weak var detailButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet private weak var canEditingButton: UIButton!
    var placeId: Int = 0
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
        contentView.makeRounded(width: nil, color: nil, value: 20)
        self.backgroundColor = Asset.Colors.gray1.color
        contentView.backgroundColor = Asset.Colors.white.color
        canEditingButton.isHidden = false
        likeButton.setImage(Asset.Assets.heart.image, for: .normal)
        likeButton.setImage(Asset.Assets.heartSelected.image, for: .selected)
        confirmButton.setImage(Asset.Assets.placeCheck.image, for: .normal)
        confirmButton.setImage(Asset.Assets.placeCheckSelected.image, for: .selected)
        configureGesture()
    }
    
    //MARK: Drag and Drop
    private func configureGesture() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGesture))
        longGesture.minimumPressDuration = 1
        canEditingButton.addGestureRecognizer(longGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(recognizer:)))
            
        titleLabel.addGestureRecognizer(tapGesture)
        placeLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func longGesture() {
        delegate?.canEditingButton(cell: self)
    }
    
    @objc func didTapLabel(recognizer: UITapGestureRecognizer) {
        print("didTapLabel ")
        delegate?.didTapDetailButton(cell: self)
    }
    
    func setPlaceId(index: Int) {
        self.placeId = index
    }
    
    func configureCell(placeInfo: PlaceInfo, selectedCategory: PlaceCategory) {
        if selectedCategory.id == -1 { // 확정 장소 일때만
            canEditingButton.isHidden = false
        }else {
            canEditingButton.isHidden = true
        }
        
        titleLabel.text = placeInfo.title
        placeLabel.text = placeInfo.roadNameAddress
        if placeInfo.isConfirm {
            confirmButton.isSelected = true
        }else {
            confirmButton.isSelected = false
        }
        
        if placeInfo.placeLike.isPlaceLike {
            likeButton.isSelected = true
        }else {
            likeButton.isSelected = false
        }
        // TO DO : 유저가 좋아요 한 장소인지에 따라 버튼 이미지 바꾸기
        likeButton.setTitle("좋아요 \(placeInfo.placeLike.likeCount)", for: .normal)
    }
    
    private func bindUI() {
        detailButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.didTapDetailButton(cell: self)
            }).disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.confirmButton.isSelected {
                    self.confirmButton.isSelected = false
                    self.delegate?.didTapcancelConfirmButton(cell: self)
                }else {
                    self.confirmButton.isSelected = true
                    self.delegate?.didTapsetConfirmButton(cell: self)
                }
            }).disposed(by: disposeBag)
        
        likeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.didTapLikeButton(cell: self)
                self.likeButton.isSelected.toggle()
            }).disposed(by: disposeBag)
    }

}
