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
    
    @IBOutlet weak var serviceAgreeText: UILabel!
    @IBOutlet weak var privacyCollectText: UILabel!
    @IBOutlet weak var useForMaketingAgreeText: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    var coordinator: SignUpCoordinator!
    
    let disposeBag = DisposeBag()
    private var selectedImage = Asset.Assets.check.image.withRenderingMode(.alwaysOriginal)
    private var unSelectedImage = Asset.Assets.unCheck.image.withRenderingMode(.alwaysOriginal)
    
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
        nextButton.makeRounded(corner: 26)
        nextButton.setUnEnabled(color: Asset.Colors.gray4.name)
        boxView.makeRounded(width: 3, color: Asset.Colors.gray4.name, value: 10)
        let saText = "서비스 이용약관 동의(필수)"
        let pcText = "개인정보 수집 및 이용 동의(필수)"
        let umText = "마케팅 활용 동의(선택)"
        serviceAgreeText.attributedText = saText.underBarLine(length: pcText.count - 4)
        privacyCollectText.attributedText = pcText.underBarLine(length: pcText.count - 4)
        useForMaketingAgreeText.attributedText = umText.underBarLine(length: umText.count - 4)
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
//        self.buttons.forEach {
//            $0.setImage(UIImage(named: Asset.Assets.check.name), for: .selected)
//            $0.setImage(UIImage(named: Asset.Assets.unCheck.name), for: .normal)
//        }
        
        allCheckButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.allCheckButton.image(for: .normal) == self.selectedImage {
                    self.buttons.forEach {
                        $0.setTitle(.none, for: .normal)
                        $0.setImage(self.unSelectedImage, for: .normal)
                    }
                }else {
                    self.buttons.forEach {
                        $0.setTitle(.none, for: .normal)
                        $0.setImage(self.selectedImage, for: .normal)
                    }
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
                }else {
                    self.useForMaketingAgreeButton.setImage(self.selectedImage, for: .normal)
                }
                self.check()
            }).disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(onNext: {  _ in
                self.coordinator.setProfileImage()
            }).disposed(by: disposeBag)
            
 
        
    }
    
    func check() {
        if serviceAgreeButton.currentImage == self.selectedImage && privacyCollectAgreeButton.currentImage == self.selectedImage {
            nextButton.setEnabled(color: Asset.Colors.black.name)
        }else {
            nextButton.setUnEnabled(color: Asset.Colors.gray4.name)
        }
    }
}

