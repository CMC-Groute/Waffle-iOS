//
//  DetailArchiveViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class DetailArchiveViewController: UIViewController {
    var viewModel: DetailArchiveViewModel?
    var disposeBag = DisposeBag()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var toppingImageView: UIImageView!
    @IBOutlet weak var loadMemoButton: UIButton!
    @IBOutlet weak var participantsButton: UIButton!
    @IBOutlet weak var invitationButton: UIButton!
    @IBOutlet weak var addPlaceButton: UIButton!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        
    }
    
    private func configureUI() {
        addPlaceButton.round(corner: 26)
        func setNavigationBar() {
            self.navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
            self.navigationItem.title = viewModel?.detailArchive?.title
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Asset.Assets.more.name)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapMoreButton))
            let backImage = UIImage(named: Asset.Assets._24pxBtn.name)!.withRenderingMode(.alwaysOriginal)
            UINavigationBar.appearance().backIndicatorImage = backImage
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -80.0), for: .default)
        }
        
        setNavigationBar()
        
    }
    
    @objc
    func didTapMoreButton() {
        print("didTapMoreButton")
        //self.viewModel?.detailArhive()
    }
    
    private func bindViewModel() {
        let input = DetailArchiveViewModel.Input(loadMemoButton: loadMemoButton.rx.tap.asObservable(), invitationButton: invitationButton.rx.tap.asObservable(), addPlaceButton: addPlaceButton.rx.tap.asObservable())
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        
    }
}

