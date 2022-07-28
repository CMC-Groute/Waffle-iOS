//
//  ArchiveDetailPopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class ArchiveDetailPopUpViewController: UIViewController {
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var frameBackgroundView: UIView!
    @IBOutlet weak var editArchiveButton: UIButton!
    @IBOutlet weak var deleteArchiveButton: UIButton!
    @IBOutlet weak var likeArchiceButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var usecase: HomeUsecase?
    var detailArchive: DetailArhive?
    var archiveId: Int?
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        bindViewModel()
        configureUI()
    }
    
    private func configureUI() {
        frameView.roundCorners(value: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        cancelButton.makeRounded(width: 1, borderColor: Asset.Colors.gray5.name, value: 26)
    }
    
    private func bindUI() {
        editArchiveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let archiveId = self.archiveId else {
                    return
                }

                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
                self.coordinator.editArchive(archiveId: archiveId, detailArchive: self.detailArchive)
            }).disposed(by: disposeBag)
        
        deleteArchiveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let archiveId = self.archiveId else {
                    return
                }
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
                self.coordinator.arhiveDelete(archiveId: archiveId)
            }).disposed(by: disposeBag)
        
        likeArchiceButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let archiveId = self.archiveId, let usecase = self.usecase else { return }
                if UserDefaults.standard.bool(forKey: UserDefaultKey.isFirstLikeSendPopUpShow) == true {
                    usecase.likeSend(archiveId: archiveId)
                    self.coordinator.popToViewController(with: "좋아요 조르기 알림이 발송되었어요", width: 210, height: 34, corner: 17)
                }else {
                    self.coordinator.popToViewController(with: nil, width: nil, height: nil)
                    self.coordinator.likeSend(archiveId: archiveId)
                    UserDefaults.standard.set(true, forKey: UserDefaultKey.isFirstLikeSendPopUpShow)
                }
            }).disposed(by: disposeBag)
        
        
    }
    
    private func bindViewModel() {
        
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    
}
