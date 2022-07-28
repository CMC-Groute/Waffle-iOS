//
//  CategoryDeletePopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import UIKit
import RxSwift

protocol HomeCategoryDeleteDelegate {
    func deleteCategory(categoryId: Int)
}

final class CategoryDeletePopUpViewController: UIViewController {
    
    @IBOutlet weak var framwView: UIView!
    @IBOutlet weak var frameBackgroundView: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var OKButton: UIButton!
    
    var coordinator: HomeCoordinator!
    var usecase: HomeUsecase!
    var selectedCategory: PlaceCategory?
    var archiveId: Int?
    var delegate: HomeCategoryDeleteDelegate?
    
    private var disposBag = DisposeBag()
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func configureUI(){
        self.titleText.text = "\(selectedCategory?.name ?? "") 카테고리를 정말로 삭제할까요?"
        self.titleText.font = UIFont.higlightTextFont()
        self.framwView.makeRounded(width: 0, borderColor: "", value: 20)
        self.cancelButton.makeRounded(corner: 24)
        self.OKButton.makeRounded(corner: 24)
        let frameGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        frameBackgroundView.addGestureRecognizer(frameGestureRecognizer)
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
            switch gesture.view {
            case frameBackgroundView:
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
             default:
                 break
             }
        }
    

    private func bindUI(){
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
            }).disposed(by: disposBag)
        
        OKButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let archiveId = self.archiveId, let selectedCategory = self.selectedCategory else {
                    return
                }
                WappleLog.debug("deletePopUp Delegate \(selectedCategory.name) \(archiveId)")
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
                self.delegate?.deleteCategory(categoryId: selectedCategory.id)
            }).disposed(by: disposBag)
    }
}
