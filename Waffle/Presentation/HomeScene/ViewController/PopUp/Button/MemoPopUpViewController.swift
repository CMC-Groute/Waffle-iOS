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
    
    private var isOversized = false {
        didSet {
            textView.layoutIfNeeded()
            textView.isScrollEnabled = isOversized
        }
    }
    
    @IBOutlet private weak var frameView: UIView!
    @IBOutlet private weak var wappleImageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    
    var maxHeight: CGFloat = 432
    var oneLineHeight: CGFloat = 34
    var layoutMargin: CGFloat = 10
    
    lazy var transparentView: UIImageView = {
        let image = Asset.Assets.transparentEtc.image
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
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
        textView.isScrollEnabled = false
        textView.isEditable = false
        guard let wappleName = wappleName else { return }
        wappleImageView.image = UIImage(named: wappleName)
        configureHeight()
    }
    
    private func configureHeight() {
        //textView.text = memoText ?? DefaultDetailCardInfo.memo.rawValue
        textView.text = """
        Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum
        """
        
        textView.sizeToFit()
        if textView.contentSize.height >= maxHeight {
            isOversized = true
            addTransparentView()
        }

        if textView.contentSize.height >= oneLineHeight {
            heightConstraint.constant += textView.contentSize.height - layoutMargin
        }
    }
    
    private func addTransparentView() {
        view.addSubview(transparentView)
        transparentView.snp.makeConstraints {
            $0.leading.equalTo(textView.snp.leading)
            $0.trailing.equalTo(textView.snp.trailing)
            $0.bottom.equalTo(textView.snp.bottom)
            $0.width.equalTo(textView.snp.width)
            $0.height.equalTo(30)
        }
    }
    
    private func bindUI() {
        closeButton.rx.tap
            .subscribe(onNext: {
                self.coordinator.popToRootViewController(with: nil, width: nil, height: nil)
            }).disposed(by: disposBag)
    }

}
