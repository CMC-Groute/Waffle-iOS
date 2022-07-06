//
//  DetailArchiveViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class DetailArchiveViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var addPlaceButton: UIButton!
    private var lastOffsetY: CGFloat = .zero
//    @IBOutlet private weak var categoryTopAnchor: NSLayoutConstraint!
//    @IBOutlet private weak var topView: UIView!
//    @IBOutlet private weak var middleView: UIView!

//    @IBOutlet private weak var tableView: UITableView!
    
//    @IBOutlet weak var memoView: UIView!
//    @IBOutlet weak var memoLabel: UILabel!
//
//    @IBOutlet private weak var tableViewHeightConstant: NSLayoutConstraint!
//    var scrollViewContentHeight = 1200 as CGFloat
//    private var screenHeight: Double = UIScreen.main.bounds.height
//    private var categoryHeaderOffset: Double = 0
//    private var isTableView: Bool = false
    
//    var noPlaceView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    var noPlaceLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = Asset.Colors.gray7.color
//        label.text = "아직 확정된 장소가 없어요"
//        label.font = UIFont.fontWithName(type: .semibold, size: 15)
//        return label
//    }()
//
//    var noPlaceImageView: UIImageView = {
//        let noPlaceImage = Asset.Assets.noPlace.image
//        let imageView = UIImageView(image: noPlaceImage)
//        return imageView
//    }()
//
    
    var viewModel: DetailArchiveViewModel?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindViewModel()
        //bindUI()
    }
    
    private func configure() {
        configureUI()
        configureCollectionView()
        configureNavigationBar()
    }
    
    private func configureUI() {
        addPlaceButton.makeRounded(corner: 26)
    }

    
    private func configureNavigationBar() {
        let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
        self.navigationItem.title = viewModel?.detailArchive?.title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Asset.Assets.more.name)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapMoreButton))
    }
    
    private func configureCollectionView() {
        let stickyHeaderLayout = StickyHeaderCollectionViewFlowLayout(stickyIndexPath: IndexPath(item: 0, section: 2))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = stickyHeaderLayout
        collectionView.register(UINib(nibName: "TopDetailArchiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TopDetailArchiveCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "SubDetailArchiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SubDetailArchiveCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "CategoryDetailArchiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CategoryDetailArchiveCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "TableDetailArchiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TableDetailArchiveCollectionViewCell.identifier)
    }
//        configureNoPlaceView()

////        tableView.bounces = false
//        tableView.isScrollEnabled = false

//

//        configureGesture()
//
//    }
//
    
//
    @objc func didTapBackButton() {
        viewModel?.popViewController()
    }
    
//    func configureGesture() {
//        memoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLoadMemo)))
//        let editGesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapEditingMode))
//        editGesture.minimumPressDuration = 1
//        editGesture.delaysTouchesBegan = true
//        collectionView.addGestureRecognizer(editGesture)
//    }
    

//
//    @objc func didTapEditingMode() {
//        isCategoryEditing = true
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.collectionView.reloadData()
//        }
//    }
    
//    private func configureNoPlaceView() {
//        noPlaceView.addSubview(noPlaceImageView)
//        noPlaceView.addSubview(noPlaceLabel)
//
//        noPlaceImageView.snp.makeConstraints {
//            $0.top.equalTo(78)
//            $0.centerX.equalTo(noPlaceView)
//            $0.width.height.equalTo(64)
//        }
//
//        noPlaceLabel.snp.makeConstraints {
//            $0.centerX.equalTo(noPlaceView)
//            $0.top.equalTo(noPlaceImageView.snp.bottom).offset(16)
//        }
//
//        noPlaceView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
//    }
//

    
    @objc
    func didTapMoreButton() {
        self.viewModel?.detailArhive()
    }

    private func bindViewModel() {
        let input = DetailArchiveViewModel.Input(viewDidLoad: Observable<Void>.just(()).asObservable(), loadMemoButton: addPlaceButton.rx.tap.asObservable(), addPlaceButton: addPlaceButton.rx.tap.asObservable())

        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
    }
}

////MARK: Home Category에서 받아온 카테고리 업데이트
extension DetailArchiveViewController: HomeCategoryPopUpDelegate {
    func selectedCategory(category: [Category]) {
        viewModel?.addCategory(category: category)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("DetailArchiveViewController selectedCategory \(category)")
            self.collectionView.reloadSections(IndexSet(integer: 2))
        }
    }
}

extension DetailArchiveViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = collectionView.contentOffset.y
        lastOffsetY = offsetY
    }
}

extension DetailArchiveViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopDetailArchiveCollectionViewCell.identifier, for: indexPath) as! TopDetailArchiveCollectionViewCell
            cell.configureCell(cardInfo: viewModel.detailArchive)
            cell.viewModel = self.viewModel
            return cell
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubDetailArchiveCollectionViewCell.identifier, for: indexPath) as! SubDetailArchiveCollectionViewCell
            cell.configureCell(count: viewModel.detailArchive?.topping.count ?? 1)
            cell.viewModel = self.viewModel
            cell.backgroundColor = .blue
            return cell
        }else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryDetailArchiveCollectionViewCell.identifier, for: indexPath) as! CategoryDetailArchiveCollectionViewCell
            cell.viewModel = self.viewModel
            cell.delegate = self
            cell.backgroundColor = .gray
            return cell
        }else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableDetailArchiveCollectionViewCell.identifier, for: indexPath) as! TableDetailArchiveCollectionViewCell
            let updatePlace = viewModel.placeInfoByCategory()
            cell.configureCell(place: updatePlace)
            cell.backgroundColor = .green
            return cell
        }
        return UICollectionViewCell()
    }
}

extension DetailArchiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        if indexPath.section == 0 {
            return CGSize(width: screenWidth, height: 200)
        }else if indexPath.section == 1 {
            return CGSize(width: screenWidth, height: 41)
        }else if indexPath.section == 2 {
            return CGSize(width: screenWidth, height: 57)
        }else if indexPath.section == 3 {
            return CGSize(width: screenWidth, height: 900)
        }
        return CGSize(width: screenWidth, height: 500)
    }
}

extension DetailArchiveViewController: CategoryDetailArchiveCollectionViewCellDelegate {
    func tableViewLoad() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadSections(.init(integer: 3))

        }
    }
}
