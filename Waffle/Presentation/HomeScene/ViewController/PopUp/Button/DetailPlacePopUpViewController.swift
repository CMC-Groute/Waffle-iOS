//
//  DetailPlacePopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class DetailPlacePopUpViewController: UIViewController {
    enum BottomSheetViewState {
        case expanded
        case normal
    }
    
    @IBOutlet private weak var bottomSheetView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var draggingView: UIView!
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var linkLabel: UILabel!
    @IBOutlet private weak var memoTextView: UITextView!
    @IBOutlet private weak var likeCountButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!
    
    var bottomSheetPanMinTopConstant: CGFloat = 34
    var defaultHeight:CGFloat = 395
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant

    
    
    var coordinator: HomeCoordinator!
    var disposBag = DisposeBag()
    var detailInfo: PlaceInfo?
    var category: Category!
    
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
        confirmButton.round(corner: 26)
        draggingView.round(width: nil, color: nil, value: 3)
        bottomSheetView.roundCorners(value: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        likeCountButton.setImage(Asset.Assets.heartSelected.image, for: .selected)
        configureGesture()
    }
    
    private func bindUI() {
        guard var detailInfo = detailInfo else {
            return
        }

        self.titleLabel.text = detailInfo.title
        self.categoryLabel.text = "#\(category.name)"
        self.placeLabel.text = detailInfo.place
        if detailInfo.likeSelected {
            likeCountButton.isSelected = true
        }
        
        updateConfirm(isConfirm: detailInfo.isConfirm)
        self.likeCountButton.setTitle("\(detailInfo.likeCount)", for: .normal)
        
        self.likeCountButton
            .rx.tap.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.likeCountButton.isSelected.toggle()
                updateLikeCount()
            }).disposed(by: disposBag)
        
        func updateLikeCount() {
            if likeCountButton.isSelected {
                self.likeCountButton.setTitle("\(detailInfo.likeCount + 1)", for: .normal)
            }else {
                if detailInfo.likeCount > 0 {
                    self.likeCountButton.setTitle("\(detailInfo.likeCount)", for: .normal)
                }
            }
        }
        
        func updateConfirm(isConfirm: Bool) {
            if isConfirm {
                self.confirmButton.backgroundColor = Asset.Colors.green.color
                self.confirmButton.setTitle("확정이 완료되었어요", for: .normal)
            }else {
                self.confirmButton.backgroundColor = Asset.Colors.gray4.color
                self.confirmButton.setTitle("확정할래요", for: .normal)
            }
           
        }
        
        confirmButton.rx.tap
            .subscribe(onNext: {
                detailInfo.isConfirm.toggle()
                updateConfirm(isConfirm: detailInfo.isConfirm)
            }).disposed(by: disposBag)
    }
    

    
    private func configureGesture() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        bottomSheetView.addGestureRecognizer(viewPan)
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)
        let velocity = panGestureRecognizer.velocity(in: view)
        switch panGestureRecognizer.state {
            case .began:
                bottomSheetPanStartingTopConstant = topConstraint.constant
            case .changed:
                if bottomSheetPanStartingTopConstant + translation.y > bottomSheetPanMinTopConstant {
                    topConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
                }
            case .ended:
                if velocity.y > 1500 {
                    hideBottomSheet()
                   return
                }
                let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
                let bottomPadding = view.safeAreaInsets.bottom
                let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
                let nearestValue = nearest(to: topConstraint.constant, inValues: [bottomSheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
                if nearestValue == bottomSheetPanMinTopConstant {
                    showBottomSheet(atState: .expanded)
                } else if nearestValue == defaultPadding {
                    showBottomSheet(atState: .normal)
                } else {
                    hideBottomSheet()
                }
            default:
                break
            }
    }
    
    private func showBottomSheet(atState: BottomSheetViewState = .normal) {
        if atState == .normal {
            scrollView.isScrollEnabled = false
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            topConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        } else {
            scrollView.isScrollEnabled = true
            topConstraint.constant = bottomSheetPanMinTopConstant
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheet() {
        topConstraint.constant = view.frame.height
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.dismiss(animated: true)
        })
    }
    
    func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }

}