//
//  MemoPopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class MemoPopUpViewController: UIViewController {
    var coordinator: HomeCoordinator!
    var disposBag = DisposeBag()
    
    var memoText: String?
    var wappleName: String?
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var frameView: UIView!
    @IBOutlet private weak var wappleImageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var closeButton: UIButton!
    
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    var maxHeight: CGFloat = 432
    
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
        frameView.round(width: nil, color: nil, value: 20)
        guard let wappleName = wappleName else { return }
        print("wappleName \(wappleName)")
        wappleImageView.image = UIImage(named: wappleName)
    }
    
    private func bindUI() {
        closeButton.rx.tap
            .subscribe(onNext: {
                self.coordinator.popToRootViewController(with: nil, width: nil, height: nil)
            }).disposed(by: disposBag)
    }

}
