//
//  LikeSendPopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import UIKit
import RxSwift

final class LikeSendPopUpViewController: UIViewController {
    @IBOutlet private weak var framwView: UIView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    private var disposeBag = DisposeBag()
    
    var coordinator: HomeCoordinator!
    var usecase: HomeUsecase!
    var archiveId: Int?

    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func configureUI(){
        framwView.makeRounded(width: 0, borderColor: "", value: 20)
        cancelButton.makeRounded(corner: 24)
        sendButton.makeRounded(corner: 24)
    }
    

    private func bindUI(){
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator.popToViewController(with: nil, width: nil, height: nil)
            }).disposed(by: disposeBag)
        
        sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                WappleLog.debug("좋아요 조르기 archiveId \(self?.archiveId)")
                guard let archiveId = self?.archiveId else {
                    return
                }
                self?.usecase.likeSend(archiveId: archiveId)
            }).disposed(by: disposeBag)
        
        usecase.likeSendSuccess
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.coordinator.popToViewController(with: nil, width: nil, height: nil)
                }
            }).disposed(by: disposeBag)
    }
}
