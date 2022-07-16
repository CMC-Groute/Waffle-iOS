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

final class TermsViewController: UIViewController {
    enum TermsLink: String {
        case serviceAgreeText = "서비스 이용약관 동의(필수)"
        case privacyCollectText = "개인정보 수집 및 이용 동의(필수)"
        case useForMarketingAgreeText = "마케팅 활용 동의(선택)"
        
        case serviceAgreeLink = "https://imminent-tuna-9bf.notion.site/8e3f0dce21d349638c921b5fbc9b9de5"
        case privacyCollectionLink = "https://imminent-tuna-9bf.notion.site/bda407df49f045978aa0366b20695e49"
        case useForMarketingLink = "https://imminent-tuna-9bf.notion.site/a82d1f2a9d244413bd14ebb0e60485b8"
    }
    @IBOutlet private weak var boxView: UIView!
    @IBOutlet private weak var allCheckButton: UIButton!
    @IBOutlet private weak var serviceAgreeButton: UIButton!
    @IBOutlet private weak var privacyCollectAgreeButton: UIButton!
    @IBOutlet private weak var useForMaketingAgreeButton: UIButton!
    
    @IBOutlet private weak var serviceAgreeTextButton: UIButton!
    @IBOutlet private weak var privacyCollectTextButton: UIButton!
    @IBOutlet private weak var useForMarketingAgreeTextButton: UIButton!
    
    @IBOutlet private weak var nextButton: UIButton!
    var coordinator: SignUpCoordinator!
    var signUp: SignUp?
    
    private var disposeBag = DisposeBag()
    private var selectedImage = Asset.Assets.check.image.withRenderingMode(.alwaysOriginal)
    private var unSelectedImage = Asset.Assets.unCheck.image.withRenderingMode(.alwaysOriginal)
    private var buttons: [UIButton] = []
    private var isMarketingAgree: Bool = false
    

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
        nextButton.makeRounded(corner: 26)
        nextButton.setUnEnabled(color: Asset.Colors.gray4.name)
        boxView.makeRounded(width: 3, color: Asset.Colors.gray4.name, value: 10)
        serviceAgreeTextButton.setAttributedTitle(TermsLink.serviceAgreeText.rawValue.underBarLine(length: TermsLink.serviceAgreeText.rawValue.count - 4), for: .normal)
        privacyCollectTextButton.setAttributedTitle(TermsLink.privacyCollectText.rawValue.underBarLine(length: TermsLink.privacyCollectText.rawValue.count - 4), for: .normal)
        useForMarketingAgreeTextButton.setAttributedTitle(TermsLink.useForMarketingAgreeText.rawValue.underBarLine(length: TermsLink.useForMarketingAgreeText.rawValue.count - 4), for: .normal)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let backImage = Asset.Assets.btn.image.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let progressOneButton = self.navigationItem.rightBarButton(self, level: Asset.Assets.joinProgressed1.name)
        let progressTwoButton = self.navigationItem.rightBarButton(self, level: Asset.Assets.joinProgressed2.name)
        let progreeeThreeButton = self.navigationItem.rightBarButton(self, level: Asset.Assets.joinProcess3.name)
        
        navigationItem.rightBarButtonItems = [progreeeThreeButton, spacer, progressTwoButton, spacer, progressOneButton]
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func bindUI(){
        allCheckButton.setTitle(.none, for: .normal)
        self.buttons = [allCheckButton, serviceAgreeButton, privacyCollectAgreeButton, useForMaketingAgreeButton]
        
        allCheckButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.allCheckButton.image(for: .normal) == self.selectedImage {
                    self.buttons.forEach {
                        $0.setTitle(.none, for: .normal)
                        $0.setImage(self.unSelectedImage, for: .normal)
                    }
                    self.isMarketingAgree = true
                }else {
                    self.buttons.forEach {
                        $0.setTitle(.none, for: .normal)
                        $0.setImage(self.selectedImage, for: .normal)
                    }
                    self.isMarketingAgree = false
                }
                
                self.check()
            }).disposed(by: disposeBag)
        
        serviceAgreeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.serviceAgreeButton.setTitle(.none, for: .normal)
                if self.serviceAgreeButton.image(for: .normal) == self.selectedImage {
                    self.serviceAgreeButton.setImage(self.unSelectedImage, for: .normal)
                }else {
                    self.serviceAgreeButton.setImage(self.selectedImage, for: .normal)
                }
                self.check()
            }).disposed(by: disposeBag)
        
        privacyCollectAgreeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.privacyCollectAgreeButton.setTitle(.none, for: .normal)
                if self.privacyCollectAgreeButton.image(for: .normal) == self.selectedImage {
                    self.privacyCollectAgreeButton.setImage(self.unSelectedImage, for: .normal)
                }else {
                    self.privacyCollectAgreeButton.setImage(self.selectedImage, for: .normal)
                }
                self.check()
            }).disposed(by: disposeBag)
        
        useForMaketingAgreeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.useForMaketingAgreeButton.setTitle(.none, for: .normal)
                if self.useForMaketingAgreeButton.image(for: .normal) == self.selectedImage {
                    self.useForMaketingAgreeButton.setImage(self.unSelectedImage, for: .normal)
                    self.isMarketingAgree = false
                }else {
                    self.useForMaketingAgreeButton.setImage(self.selectedImage, for: .normal)
                    self.isMarketingAgree = true
                }
                self.check()
            }).disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(onNext: {  [weak self] in
                guard let self = self else { return }
                self.signUp?.isAgreedMarketing = self.isMarketingAgree
                self.coordinator.setProfileImage(signUpInfo: self.signUp!)
            }).disposed(by: disposeBag)
        
        landingPolicyButton()
        
        func landingPolicyButton() {
            serviceAgreeTextButton
                .rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                .subscribe(onNext: {
                    if let url = URL(string: TermsLink.serviceAgreeLink.rawValue) {
                        UIApplication.shared.open(url)
                    }
                    
                }).disposed(by: disposeBag)
            
            privacyCollectTextButton
                .rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                .subscribe(onNext: {
                    if let url = URL(string: TermsLink.privacyCollectionLink.rawValue) {
                        UIApplication.shared.open(url)
                    }
                }).disposed(by: disposeBag)
            
            useForMarketingAgreeTextButton
                .rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                .subscribe(onNext: {
                    if let url = URL(string: TermsLink.useForMarketingLink.rawValue) {
                        UIApplication.shared.open(url)
                    }
                }).disposed(by: disposeBag)
        }
            
 
        
    }
    
    func check() {
        if serviceAgreeButton.currentImage == self.selectedImage && privacyCollectAgreeButton.currentImage == self.selectedImage {
            nextButton.setEnabled(color: Asset.Colors.black.name)
        }else {
            nextButton.setUnEnabled(color: Asset.Colors.gray4.name)
        }
    }
}

