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
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var draggingView: UIView!
    var bottomSheetPanMinTopConstant: CGFloat = 34
    var defaultHeight:CGFloat = 395
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant

    
    
    var coordinator: HomeCoordinator!
    var disposBag = DisposeBag()
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Pan Gesture Recognizer를 view controller의 view에 추가하기 위한 코드
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생함
        // 우리는 드래그 제스쳐가 바로 발생하길 원하기 때문에 딜레이가 없도록 아래와 같이 설정
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }
    
    private func configureUI() {
        draggingView.round(width: nil, color: nil, value: 3)
        bottomSheetView.roundCorners(value: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
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
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            topConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        } else {
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
