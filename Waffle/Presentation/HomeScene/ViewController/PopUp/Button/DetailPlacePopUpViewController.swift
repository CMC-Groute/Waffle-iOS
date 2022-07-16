//
//  DetailPlacePopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

protocol DetailPlacePopUpViewDelegate: AnyObject {
    func setConfirm(placeId: Int)
    func cancelConfirm(placeId: Int)
    func addLike(placeId: Int)
    func deleteLike(placeId: Int)
    func dismiss()
}

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
    
    //MARK: Private property
    private var bottomSheetPanMinTopConstant: CGFloat = 34
    private var defaultHeight:CGFloat = 395
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant
    private var disposBag = DisposeBag()
    
    var coordinator: HomeCoordinator!
    var detailPlaceInfo: DetailPlaceInfo? //link, memo
    var placeInfo: PlaceInfo?
    
    var category: PlaceCategory!
    var categories: [PlaceCategory] = []
    weak var delegate: DetailPlacePopUpViewDelegate?
   
    var archiveId: Int?

    private var updatedLikeCount: Int = 0
    
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
        confirmButton.makeRounded(corner: 26)
        draggingView.makeRounded(width: nil, color: nil, value: 3)
        bottomSheetView.roundCorners(value: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        likeCountButton.setImage(Asset.Assets.heartSelected.image, for: .selected)
        configureGesture()
    }
    
    private func bindUI() {
        guard let detailInfo = detailPlaceInfo, var placeInfo = placeInfo else {
            return
        }
        updatedLikeCount = placeInfo.placeLike.likeCount
        
        self.titleLabel.text = placeInfo.title
        self.linkLabel.text = detailInfo.link ?? DefaultDetailCardInfo.link.rawValue
        self.memoTextView.text = detailInfo.memo ?? DefaultDetailCardInfo.placeMemo.rawValue
        self.categoryLabel.text = "#\(category.name)"
        self.placeLabel.text = placeInfo.roadNameAddress
        if placeInfo.placeLike.isPlaceLike {
            likeCountButton.isSelected = true
        }
        
        updateConfirm(isConfirm: placeInfo.isConfirm)
        self.likeCountButton.setTitle("\(updatedLikeCount)", for: .normal)
        
        self.likeCountButton
            .rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if placeInfo.placeLike.isPlaceLike { // 좋아요 누른 상태
                    self.likeCountButton.isSelected = false
                    self.delegate?.deleteLike(placeId: placeInfo.placeId)
                }else {
                    self.likeCountButton.isSelected = true
                    self.delegate?.addLike(placeId: placeInfo.placeId)
                }
                placeInfo.placeLike.isPlaceLike.toggle()
                
                updateLikeCount()
            }).disposed(by: disposBag)
        
        self.editButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                guard let archiveId = self.archiveId else {
                    return
                }

                
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
                self.coordinator.editPlace(archiveId: archiveId, placeId: placeInfo.placeId, category: self.categories, place: placeInfo, detailPlace: detailInfo, selectedCategory: self.category)
            }).disposed(by: disposBag)
        
        func updateLikeCount() {
            if likeCountButton.isSelected {
                updatedLikeCount += 1
                self.likeCountButton.setTitle("\(updatedLikeCount)", for: .normal)
            }else {
                if self.updatedLikeCount > 0 {
                    self.updatedLikeCount -= 1
                    self.likeCountButton.setTitle("\(updatedLikeCount)", for: .normal)
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
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if placeInfo.isConfirm { //
                    self.delegate?.cancelConfirm(placeId: placeInfo.placeId)
                }else {
                    self.delegate?.setConfirm(placeId: placeInfo.placeId)
                }
                placeInfo.isConfirm.toggle()
                updateConfirm(isConfirm: placeInfo.isConfirm)
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
            self.dismiss(animated: true) {
                self.delegate?.dismiss()
            }
        })
    }
    
    func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }

}
