//
//  ChangePWViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift

class ChangePWViewController: UIViewController {

    var viewModel: ChangePWViewModel?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }


    private func configureUI() {
        func setNavigationBar() {
            self.navigationItem.title = "비밀번호 변경" // TO DO 텍스트 폰트 적용
            let backImage = UIImage(named: Asset.Assets.btn.name)!.withRenderingMode(.alwaysOriginal)
            UINavigationBar.appearance().backIndicatorImage = backImage
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -80.0), for: .default)
        }
    }
    
    private func bindViewModel(){
        
    }

}
