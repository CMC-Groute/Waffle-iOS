//
//  TermsViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/11.
//

import Foundation
import UIKit
import RxSwift

enum TemsMandatory {
    case none,required
}

class TermsViewController: UIViewController {
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var allCheckButton: UIButton!
    @IBOutlet weak var serviceAgreeButton: UIButton!
    @IBOutlet weak var privacyCollectAgreeButton: UIButton!
    @IBOutlet weak var useForMaketingAgreeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    var coordinator: SignUpCoordinator!
    
    let disposeBag = DisposeBag()
    
    var buttons: [UIButton] = []
    struct Terms: Identifiable {
        var id = UUID()
        var title: String
        var isMandatory: TemsMandatory
    }
    
    var terms = [
            [Terms(title: "전체 동의", isMandatory: .none)],
            [
                Terms(title: "서비스 이용약관 동의(필수)", isMandatory: .required),
                Terms(title: "개인정보 수집 및 이용 동의(필수)", isMandatory: .required),
                Terms(title: "마케팅 활용 동의(선택)", isMandatory: .none)
            ]
        ]
    
    convenience init(coordinator: SignUpCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    func configureUI() {
        nextButton.round(corner: 25)
        nextButton.setUnEnabled(color: Asset.Colors.gray4.name)
        boxView.round(width: 3, color: Asset.Colors.gray4.name, value: 10)
        func setProgressNavigationBar() { // TO DO selected state
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            let progressOneButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProgressed1.name)
            let progressTwoButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProgressed2.name)
            let progreeeThreeButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProcess3.name)
            
            self.navigationItem.rightBarButtonItems = [progreeeThreeButton, spacer, progressTwoButton, spacer, progressOneButton]
        }
        
        setProgressNavigationBar()
    }
    
    func bindUI(){
        self.buttons = [allCheckButton, serviceAgreeButton, privacyCollectAgreeButton, useForMaketingAgreeButton]
        self.buttons.forEach {
            $0.setImage(UIImage(named: Asset.Assets.check.name), for: .selected)
            $0.setImage(UIImage(named: Asset.Assets.unCheck.name), for: .normal)
        }
        
        allCheckButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let state = self.allCheckButton.isSelected ? false : true
                self.buttons.forEach {
                    $0.isSelected = state
                }
                self.check()
            }).disposed(by: disposeBag)
        
        serviceAgreeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.serviceAgreeButton.isSelected = !self.serviceAgreeButton.isSelected
                self.check()
            }).disposed(by: disposeBag)
        
        privacyCollectAgreeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.privacyCollectAgreeButton.isSelected = !self.privacyCollectAgreeButton.isSelected
                self.check()
            }).disposed(by: disposeBag)
        
        useForMaketingAgreeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.useForMaketingAgreeButton.isSelected = !self.useForMaketingAgreeButton.isSelected
                self.check()
            }).disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(onNext: {  _ in
                self.coordinator.setProfileImage()
            }).disposed(by: disposeBag)
            
 
        
    }
    
    func check() {
        if serviceAgreeButton.isSelected && privacyCollectAgreeButton.isSelected {
            nextButton.setEnabled(color: Asset.Colors.black.name)
        }else {
            nextButton.setUnEnabled(color: Asset.Colors.gray4.name)
        }
    }
}

