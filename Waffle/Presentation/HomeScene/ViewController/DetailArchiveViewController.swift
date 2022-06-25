//
//  DetailArchiveViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class DetailArchiveViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var toppingImageView: UIImageView!
    @IBOutlet weak var loadMemoButton: UIButton!
    @IBOutlet weak var participantsButton: UIButton!
    @IBOutlet weak var invitationButton: UIButton!
    @IBOutlet weak var addPlaceButton: UIButton!
    @IBOutlet weak var categoryTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: DetailArchiveViewModel?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        bindUI()
        
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
    
    private func bindUI() {
        scrollView.delegate = self
        tableView.register(UINib(nibName: "DetailPlaceTableViewCell", bundle: nil), forCellReuseIdentifier: DetailPlaceTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        print("height \(UITableView.automaticDimension)")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

extension DetailArchiveViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPlaceTableViewCell.identifier, for: indexPath) as! DetailPlaceTableViewCell
        return cell
    }
}

extension DetailArchiveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(16)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(16)
    }
}

extension DetailArchiveViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.adjustedContentInset.top \(scrollView.adjustedContentInset.top)")
        if scrollView.contentOffset.y < -scrollView.adjustedContentInset.top {
            categoryTopAnchor.constant = scrollView.contentOffset.y
        }
    }
}
