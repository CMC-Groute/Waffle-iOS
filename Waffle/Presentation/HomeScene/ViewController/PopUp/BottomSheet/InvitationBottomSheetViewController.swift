//
//  InvitationViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//


import UIKit
import RxSwift

class InvitationBottomSheetViewController: UIViewController {
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet private weak var shareWithKakaoTalkButton: UIButton!
    @IBOutlet weak var copyCodeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    private func configureUI() {
        frameView.roundCorners(value: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        cancelButton.round(width: 1, color: Asset.Colors.gray5.name, value: 26)
    }
    
    private func bindViewModel() {
        copyCodeButton.rx.tap
            .subscribe(onNext: {
                // TO DO
                self.coordinator.popToRootViewController(with: "약속코드가 복사되었어요\n함께할 토핑들에게 공유해봐요", width: 184, height: 56)
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
