//
//  DetailArchiveViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class DetailArchiveViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var whenLabel: UILabel!
    @IBOutlet private weak var whereLabel: UILabel!
    @IBOutlet private weak var toppingImageView: UIImageView!
    @IBOutlet private weak var loadMemoButton: UIButton!
    @IBOutlet private weak var participantsButton: UIButton!
    @IBOutlet private weak var invitationButton: UIButton!
    @IBOutlet private weak var addPlaceButton: UIButton!
    @IBOutlet private weak var categoryTopAnchor: NSLayoutConstraint!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var middleView: UIView!
    @IBOutlet private weak var categoryView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstant: NSLayoutConstraint!
    var scrollViewContentHeight = 1200 as CGFloat
    private var screenHeight: Double = UIScreen.main.bounds.height
    private var categoryHeaderOffset: Double = 0
    private var isTableView: Bool = false
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //tableViewHeightConstant.constant = tableView.contentSize.height
//        print("tableViewHeightConstant \(tableViewHeightConstant.constant)")
//        print(tableView.contentSize.height + categoryView.frame.height + topView.frame.height + middleView.frame.height)
//        scrollViewContentHeight = tableView.contentSize.height + categoryView.frame.height + topView.frame.height + middleView.frame.height
//        print(scrollView.contentSize.height)
    }
    
    private func configureUI() {
        configureNoPlaceView()
        addPlaceButton.round(corner: 26)
        scrollView.bounces = false
//        tableView.bounces = false
        tableView.isScrollEnabled = false
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
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    @objc
    func didTapMoreButton() {
        print("didTapMoreButton")
        //self.viewModel?.detailArhive()
    }
    
    private func bindViewModel() {
        let input = DetailArchiveViewModel.Input(viewDidLoad: Observable<Void>.just(()).asObservable(),loadMemoButton: loadMemoButton.rx.tap.asObservable(), invitationButton: invitationButton.rx.tap.asObservable(), addPlaceButton: addPlaceButton.rx.tap.asObservable())
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        whenLabel.text = viewModel?.detailArchive?.date ?? ""
        whereLabel.text = viewModel?.detailArchive?.place ?? ""
        let count = viewModel?.detailArchive?.topping.count ?? 0 + 1
        participantsButton.setTitle("\(count)명", for: .normal)
        
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
        return viewModel.placeInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPlaceTableViewCell.identifier, for: indexPath) as! DetailPlaceTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.setPlaceId(index: indexPath.row)
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
    func didTapLikeButton(cell: DetailPlaceTableViewCell) {
        print("didTapLikeButton")
//        print(cell.likeButton.isSelected)
//        print(cell.placeId)
        if cell.likeButton.isSelected {
            viewModel?.placeInfo[cell.placeId].likeCount += 1
        }else {
            if (viewModel?.placeInfo[cell.placeId].likeCount)! > 0 {
                viewModel?.placeInfo[cell.placeId].likeCount -= 1
            }
        }
        viewModel?.placeInfo[cell.placeId].likeSelected = cell.likeButton.isSelected
        tableView.reloadRows(at: [[0, cell.placeId]], with: .none)
    }
    
    func didTapConfirmButton(cell: DetailPlaceTableViewCell) {
        print("didTapConfirmButton")
//        print(cell.confirmButton.isSelected)
//        print(cell.placeId)
    }
    
    func didTapDetailButton(cell: DetailPlaceTableViewCell) {
        guard let placeInfo = viewModel?.placeInfo[cell.placeId] else { return }
        guard let category = viewModel?.category else { return }
        self.viewModel!.detailPlace(place: placeInfo, category: category)
    }
    
    
}

extension DetailArchiveViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if categoryHeaderOffset == 0 {
            categoryHeaderOffset = categoryView.frame.minY // 238
            //print("update \(categoryHeaderOffset)")
        }
        
        if isTableView == false {
            if scrollView.contentOffset.y >= categoryHeaderOffset && scrollView == self.scrollView {
                //print("tableview")
                categoryTopAnchor.constant = scrollView.contentOffset.y - categoryHeaderOffset
                self.scrollView.isScrollEnabled = false
                self.tableView.isScrollEnabled = true
                isTableView = true
            }
            else {
                //print("scrollview")
                categoryTopAnchor.constant = 0
                self.scrollView.isScrollEnabled = true
                self.tableView.isScrollEnabled = false
            }
        }
        
        if scrollView == self.tableView && scrollView.contentOffset.y <= 0 {
            //처음 지점으로 돌아온다면
            //print("처음 지점")
            categoryTopAnchor.constant = 0
            self.scrollView.isScrollEnabled = true
            self.tableView.isScrollEnabled = false
            isTableView = false
        }

        //print("offset \(scrollView.contentOffset.y)")
      
    }
}
