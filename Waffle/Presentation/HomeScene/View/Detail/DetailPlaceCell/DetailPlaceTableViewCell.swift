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
    func didTapDeleteLikeButton(cell: DetailPlaceTableViewCell)
    
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
    private var updatedLikeCount: Int = 0
    
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
        contentView.makeRounded(width: nil, borderColor: nil, value: 20)
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
        longGesture.minimumPressDuration = 0.5
        canEditingButton.addGestureRecognizer(longGesture)
        let tapGestureTitle = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(recognizer:)))
        let tapGestureAddress = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(recognizer:)))
            
        titleLabel.addGestureRecognizer(tapGestureTitle)
        placeLabel.addGestureRecognizer(tapGestureAddress)
    }
    
    @objc func longGesture() {
        delegate?.canEditingButton(cell: self)
    }
    
    @objc func didTapLabel(recognizer: UITapGestureRecognizer) {
        WappleLog.debug("didTapLabel")
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
            confirmButton.setTitle("확정됨", for: .normal)
        }else {
            confirmButton.isSelected = false
            confirmButton.setTitle("확정하기", for: .normal)
        }
        
        if placeInfo.placeLike.isPlaceLike {
            likeButton.isSelected = true
        }else {
            likeButton.isSelected = false
        }
        
        updatedLikeCount = placeInfo.placeLike.likeCount
        likeButton.setTitle("좋아요 \(updatedLikeCount)", for: .normal)
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
                if self.likeButton.isSelected {
                    self.likeButton.isSelected = false
                    self.delegate?.didTapDeleteLikeButton(cell: self)
                }else {
                    self.likeButton.isSelected = true
                    self.delegate?.didTapLikeButton(cell: self)
                }
                updateLikeCount(bool: self.likeButton.isSelected)
            }).disposed(by: disposeBag)
        
        func updateLikeCount(bool: Bool) {
            if bool == false { // delete like count
                if self.updatedLikeCount > 0 {
                    self.updatedLikeCount -= 1
                }
            }else {
                self.updatedLikeCount += 1
            }
            self.likeButton.setTitle("좋아요 \(updatedLikeCount)", for: .normal)
        }
    }

}
