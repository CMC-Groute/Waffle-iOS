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
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
