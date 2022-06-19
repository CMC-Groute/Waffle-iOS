//
//  HomeViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    @IBOutlet weak var cardCountLabel: UILabel!
    @IBOutlet weak var emptyView: EmptyCardView!
    var viewModel: HomeViewModel?
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var cardView: UIView!
    @IBSegueAction func embedCardView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: CardView(UIState: UIStateModel()).environmentObject(viewModel!))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    func configureUI() {
        func setNavigationBar() {
            var image = Asset.Assets.wapple.image.withRenderingMode(.alwaysOriginal)
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 26
            let calendarButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.calendar.name)
            let bellButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.bell.name)
            
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [bellButton, spacer, calendarButton]
        }
        setNavigationBar()
    }
    
    func bindViewModel() {
        let input = HomeViewModel.Input(viewDidLoadEvent: Observable<Void>.just(()).asObservable(), makeArchiveButton: emptyView.makeArchiveButton.rx.tap.asObservable())

        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        output?.isHiddenView
            .subscribe(onNext: { [weak self] bool in
                print(bool)
                guard let self = self else { return }
                print(bool)
                if bool {
                    self.hideCardView()
                }else {
                    self.hideEmptyView()
                }
                print(bool)
            }).disposed(by: disposeBag)
        
    }
    
    func hideCardView() {
        emptyView.isHidden = false
        
        cardView.isHidden = true
    }
    
    func hideEmptyView() {
        emptyView.isHidden = true
        
        cardView.isHidden = false
    }
    
    
}
