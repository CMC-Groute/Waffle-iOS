//
//  CategoryDeletePopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import UIKit
import RxSwift

class CategoryDeletePopUpViewController: UIViewController {
    @IBOutlet weak var framwView: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var OKButton: UIButton!
    
    var coordinator: HomeCoordinator!
    var usecase: HomeUsecase!
    var disposBag = DisposeBag()
    var selectedCategoryId: Int = 0
    var selectedCategoryName: String = ""
    
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
        self.titleText.text = "\(selectedCategoryName) 카테고리를 정말로 삭제할까요?"
        self.titleText.font = UIFont.titleFont()
        self.framwView.round(width: 0, color: "", value: 20)
        self.cancelButton.round(corner: 24)
        self.OKButton.round(corner: 24)
    }
    

    private func bindUI(){
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.coordinator.popToRootViewController(with: nil)
            }).disposed(by: disposBag)
        
        OKButton.rx.tap
            .subscribe(onNext: {
                self.usecase.deleteCategory(categoryId: self.selectedCategoryId)
            }).disposed(by: disposBag)
    }
}
