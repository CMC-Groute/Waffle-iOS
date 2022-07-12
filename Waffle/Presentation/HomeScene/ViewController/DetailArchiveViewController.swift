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

    var viewModel: DetailArchiveViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindViewModel()
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Asset.Assets.more.name)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapMoreButton))
    }
    
    private func configureCollectionView() {
        let stickyHeaderLayout = StickyHeaderCollectionViewFlowLayout(stickyIndexPath: IndexPath(item: 0, section: 2))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = stickyHeaderLayout
        collectionView.register(UINib(nibName: "DetailArchiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DetailArchiveCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "SubDetailArchiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SubDetailArchiveCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "CategoryDetailArchiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CategoryDetailArchiveCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "TableDetailArchiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TableDetailArchiveCollectionViewCell.identifier)
    }

    @objc func didTapBackButton() {
        viewModel?.popViewController()
    }

    @objc
    func didTapMoreButton() {
        self.viewModel?.detailArhive()
    }

    private func bindViewModel() {
        let input = DetailArchiveViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in }, loadMemoButton: addPlaceButton.rx.tap.asObservable(), addPlaceButton: addPlaceButton.rx.tap.asObservable())

        let _ = viewModel?.transform(from: input, disposeBag: disposeBag)
        viewModel?.loadData
            .subscribe(onNext: { [weak self] indexPathType in
                guard let self = self else { return }
                self.navigationItem.title = self.viewModel?.detailArchive?.title
                switch indexPathType {
                case .all:
                    self.collectionView.reloadData()
                case .category:
                    self.collectionView.reloadSections(.init(integer: 2))
                case .tableView:
                    self.collectionView.reloadSections(.init(integer: 3))
                }
            }).disposed(by: disposeBag)
    }
}

//MARK: Home Category에서 받아온 카테고리 업데이트
extension DetailArchiveViewController: HomeCategoryPopUpDelegate {
    func selectedCategory(archiveId: Int, categoryName: [String]) {
        viewModel?.addCategories(archiveId: archiveId, categoryName: categoryName)
    }
}

//MARK: Home Category delete PopUp 에서 받아온 카테고리 업데이트
extension DetailArchiveViewController: HomeCategoryDeleteDelegate {
    func deleteCategory(categoryId: Int) {
        viewModel?.deleteCategories(categoryId: categoryId)
    }
    
    
}

extension DetailArchiveViewController: UICollectionViewDelegate { }

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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailArchiveCollectionViewCell.identifier, for: indexPath) as! DetailArchiveCollectionViewCell
            cell.backgroundColor = .red
            cell.configureCell(detailArchive: viewModel.detailArchive)
            cell.viewModel = self.viewModel
            return cell
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubDetailArchiveCollectionViewCell.identifier, for: indexPath) as! SubDetailArchiveCollectionViewCell
            cell.configureCell(count: viewModel.detailArchive?.member.count ?? 1)
            cell.viewModel = self.viewModel
            cell.backgroundColor = .blue
            return cell
        }else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryDetailArchiveCollectionViewCell.identifier, for: indexPath) as! CategoryDetailArchiveCollectionViewCell
            cell.viewModel = viewModel
            cell.backgroundColor = .gray
            return cell
        }else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableDetailArchiveCollectionViewCell.identifier, for: indexPath) as! TableDetailArchiveCollectionViewCell
            let updatePlace = viewModel.placeInfo ?? []
            WappleLog.debug("updatePlace \(updatePlace)")
            cell.viewModel = viewModel
            //cell.configureCell(place: updatePlace, selectedCategory: viewModel.selectedCategory)
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

extension DetailArchiveViewController: DetailPlacePopUpViewDelegate {
    func addLike(placeId: Int) {
        viewModel?.addLike(placeId: placeId)
    }
    
    func deleteLike(placeId: Int) {
        viewModel?.deletLike(placeId: placeId)
    }
    
    func setConfirm(placeId: Int) {
        viewModel?.setConfirm(placeId: placeId)
    }
    
    func cancelConfirm(placeId: Int) {
        viewModel?.cancelConfirm(placeId: placeId)
        
    }

}
