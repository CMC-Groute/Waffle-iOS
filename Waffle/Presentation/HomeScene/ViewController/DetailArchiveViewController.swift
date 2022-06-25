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
    
    var noPlaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    var noPlaceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.gray7.color
        label.text = "아직 확정된 장소가 없어요"
        label.font = UIFont.fontWithName(type: .semibold, size: 15)
        return label
    }()
    
    var noPlaceImageView: UIImageView = {
        let noPlaceImage = Asset.Assets.noPlace.image
        let imageView = UIImageView(image: noPlaceImage)
        return imageView
    }()
    
    
    var viewModel: DetailArchiveViewModel?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        bindUI()
        
    }
    
    private func configureUI() {
        configureNoPlaceView()
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
    
    private func configureNoPlaceView() {
        self.noPlaceView.addSubview(noPlaceImageView)
        self.noPlaceView.addSubview(noPlaceLabel)
        
        noPlaceImageView.snp.makeConstraints {
            $0.top.equalTo(78)
            $0.centerX.equalTo(noPlaceView)
            $0.width.height.equalTo(64)
        }
        
        noPlaceLabel.snp.makeConstraints {
            $0.centerX.equalTo(noPlaceView)
            $0.top.equalTo(noPlaceImageView.snp.bottom).offset(16)
        }

        noPlaceView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
    }
    
    private func bindUI() {
        scrollView.delegate = self
        tableView.register(UINib(nibName: "DetailPlaceTableViewCell", bundle: nil), forCellReuseIdentifier: DetailPlaceTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        print("height \(UITableView.automaticDimension)")
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    @objc
    func didTapMoreButton() {
        print("didTapMoreButton")
        //self.viewModel?.detailArhive()
    }
    
    private func bindViewModel() {
        let input = DetailArchiveViewModel.Input(viewDidLoad: Observable<Void>.just(()).asObservable(), loadMemoButton: loadMemoButton.rx.tap.asObservable(), invitationButton: invitationButton.rx.tap.asObservable(), addPlaceButton: addPlaceButton.rx.tap.asObservable())
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        
    }
}

extension DetailArchiveViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0}
        if viewModel.placeInfo.isEmpty {
            tableView.backgroundView  = noPlaceView
            return 0
        }
        tableView.backgroundView = nil
        return 1
        //return viewModel.placeInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPlaceTableViewCell.identifier, for: indexPath) as! DetailPlaceTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configureCell(placeInfo: viewModel!.placeInfo[indexPath.row])
        return cell
    }
}

extension DetailArchiveViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(182)
    }
}

extension DetailArchiveViewController: DetailPlaceTableViewCellDelegate {
    func didTapLikeButton() {
        print("didTapLikeButton")
    }
    
    func didTapConfirmButton() {
        print("didTapConfirmButton")
    }
    
    func didTapDetailButton() {
        self.viewModel?.detailPlace()
    }
    
    
}

extension DetailArchiveViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < -scrollView.adjustedContentInset.top {
//            categoryTopAnchor.constant = scrollView.contentOffset.y
//        }
    }
}
