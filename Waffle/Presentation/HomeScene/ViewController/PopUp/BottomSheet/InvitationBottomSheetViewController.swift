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
    var archiveCode: String?
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func configureUI() {
        frameView.roundCorners(value: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        cancelButton.makeRounded(width: 1, color: Asset.Colors.gray5.name, value: 26)
    }
    
    private func bindUI() {
        copyCodeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                UIPasteboard.general.string = self.archiveCode
                self.coordinator.popToViewController(with: "약속코드가 복사되었어요\n함께할 토핑들에게 공유해봐요", width: 184, height: 56)
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
