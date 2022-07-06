//
//  SubDetailArchiveCollectionViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/06.
//

import UIKit
import RxSwift

class SubDetailArchiveCollectionViewCell: UICollectionViewCell {
    static let identifier = "SubDetailArchiveCollectionViewCell"
    
    @IBOutlet private weak var participantsButton: UIButton!
    @IBOutlet private weak var invitationButton: UIButton!
    var viewModel: DetailArchiveViewModel?
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(count: Int) {
        participantsButton.setTitle("\(count)명", for: .normal)
        participantsButton
            .rx.tap.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel?.participants()
            }).disposed(by: disposeBag)
        
        invitationButton
            .rx.tap.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel?.invitations()
            }).disposed(by: disposeBag)
    }

}
