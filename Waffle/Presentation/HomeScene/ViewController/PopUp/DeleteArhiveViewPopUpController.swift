//
//  DeleteArhiveViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import UIKit
import RxSwift

class DeleteArhiveViewPopUpController: UIViewController {
    @IBOutlet weak var framwView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var OKButton: UIButton!
    
    //MARK: Private property
    private var disposBag = DisposeBag()
    
    var coordinator: HomeCoordinator!
    var usecase: HomeUsecase!
    var archiveId: Int?
    
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
        self.framwView.makeRounded(width: 0, borderColor: "", value: 20)
        self.cancelButton.makeRounded(corner: 24)
        self.OKButton.makeRounded(corner: 24)
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
                guard let archiveId = self.archiveId else {
                    return
                }
                self.usecase.deleteArchive(archiveId: archiveId)
                self.coordinator.dissmissAndPopToRootViewController()
            }).disposed(by: disposBag)
    }
}

