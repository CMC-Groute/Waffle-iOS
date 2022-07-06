//
//  DetailArchiveViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class DetailArchiveViewController: UIViewController {
//    @IBOutlet private weak var whenLabel: UILabel!
//    @IBOutlet private weak var whereLabel: UILabel!
//    @IBOutlet private weak var toppingImageView: UIImageView!
//    @IBOutlet private weak var loadMemoButton: UIButton!
//    @IBOutlet private weak var participantsButton: UIButton!
//    @IBOutlet private weak var invitationButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var addPlaceButton: UIButton!
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
//    var isCategoryEditing: Bool = false
    
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
        //configureUI()
        //bindViewModel()
        //bindUI()
    }

    
    private func configureUI() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        let stickyHeaderLayout = StickyHeaderCollectionViewFlowLayout(stickyIndexPath: IndexPath(item: 0, section: 2))
        collectionView.collectionViewLayout = stickyHeaderLayout
    }
//        configureNoPlaceView()
//        addPlaceButton.makeRounded(corner: 26)
//        memoView.makeRounded(width: nil, color: nil, value: 20)
//        //memoLabel.addTrailing(with: "...", moreText: "더보기", moreTextFont: UIFont.fontWithName(type: .regular, size: 14), moreTextColor: Asset.Colors.gray5.color)
//        scrollView.bounces = false
////        tableView.bounces = false
//        tableView.isScrollEnabled = false
//        func setNavigationBar() {
//            let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
//            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
//            navigationItem.leftBarButtonItem = backButton
//            self.navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
//            self.navigationItem.title = viewModel?.detailArchive?.title
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Asset.Assets.more.name)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapMoreButton))
//            configureGesture()
//        }
//
//        setNavigationBar()
//        configureGesture()
//
//    }
//
    
//
//    @objc func didTapBackButton() {
//        viewModel?.popViewController()
//    }
    
//    func configureGesture() {
//        memoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLoadMemo)))
//        let editGesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapEditingMode))
//        editGesture.minimumPressDuration = 1
//        editGesture.delaysTouchesBegan = true
//        collectionView.addGestureRecognizer(editGesture)
//    }
    
//    @objc func didTapLoadMemo() {
//        viewModel?.loadMemo()
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
//    private func bindUI() {
//        scrollView.delegate = self
//        tableView.register(UINib(nibName: "DetailPlaceTableViewCell", bundle: nil), forCellReuseIdentifier: DetailPlaceTableViewCell.identifier)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.estimatedRowHeight = UITableView.automaticDimension
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.allowsSelection = true
//        collectionView.register(ConfirmCategoryCollectionViewCell.self, forCellWithReuseIdentifier: ConfirmCategoryCollectionViewCell.identifier)
//        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
//        collectionView.register(AddCategoryCollectionViewCell.self, forCellWithReuseIdentifier: AddCategoryCollectionViewCell.identifier)
//    }
//
//    @objc
//    func didTapMoreButton() {
//        self.viewModel?.detailArhive()
//    }
//
//    private func bindViewModel() {
//        let input = DetailArchiveViewModel.Input(viewDidLoad: Observable<Void>.just(()).asObservable(),loadMemoButton: loadMemoButton.rx.tap.asObservable(), invitationButton: invitationButton.rx.tap.asObservable(), participantsButton: participantsButton.rx.tap.asObservable(), addPlaceButton: addPlaceButton.rx.tap.asObservable())
//
//        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
//
//        output?.whenTextLabel
//            .bind(to: self.whenLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        output?.whereTextLabel
//            .bind(to: self.whereLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        output?.memoTextLabel
//            .bind(to: self.memoLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        output?.frameViewColor
//            .subscribe(onNext: { colorName in
//                self.topView.backgroundColor = UIColor(named: colorName)
//            }).disposed(by: disposeBag)
//
//        output?.frameImageView
//            .subscribe(onNext: { wapple in
//                self.toppingImageView.image = wapple
//            }).disposed(by: disposeBag)
//
//        let count = viewModel?.detailArchive?.topping.count ?? 0 + 1
//        participantsButton.setTitle("\(count)명", for: .normal)
//
//    }
//}
//
//extension DetailArchiveViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let viewModel = viewModel else { return 0 }
//        if viewModel.placeInfoByCategory().isEmpty {
//            tableView.backgroundView  = noPlaceView
//            return 0
//        }
//        tableView.backgroundView = nil
//        return viewModel.placeInfoByCategory().count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPlaceTableViewCell.identifier, for: indexPath) as! DetailPlaceTableViewCell
//        cell.selectionStyle = .none
//        cell.delegate = self
//        cell.setPlaceId(index: indexPath.row)
//        guard let place = viewModel?.placeInfoByCategory() else { return cell }
//        cell.configureCell(placeInfo: place[indexPath.row])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//       return true
//    }
//
//    // Move Row Instance Method
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        var place = viewModel!.placeInfoByCategory()
//        //print("\(sourceIndexPath.row) -> \(destinationIndexPath.row)")
//        let moveCell = place[sourceIndexPath.row]
//        place.remove(at: sourceIndexPath.row)
//        place.insert(moveCell, at: destinationIndexPath.row)
//        tableView.dragInteractionEnabled = false
//    }
//}
//
//extension DetailArchiveViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(182)
//    }
//}
//
////MARK: Drag And Drop
//extension DetailArchiveViewController: UITableViewDragDelegate {
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//            return [UIDragItem(itemProvider: NSItemProvider())]
//        }
//}
//
//extension DetailArchiveViewController: UITableViewDropDelegate {
//    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
//        if session.localDragSession != nil {
//            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//        }
//        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
//    }
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//    }
//}
//
//extension DetailArchiveViewController: DetailPlaceTableViewCellDelegate {
//    func canEditingButton(cell: DetailPlaceTableViewCell) {
//        //TO DO
//        //tableView drag and drop
//        tableView.dragInteractionEnabled = true
//        tableView.dragDelegate = self
//        tableView.dropDelegate = self
//    }
//
//    func didTapLikeButton(cell: DetailPlaceTableViewCell) {
//        print("didTapLikeButton")
////        print(cell.likeButton.isSelected)
////        print(cell.placeId)
//        if cell.likeButton.isSelected {
//            viewModel?.placeInfo[cell.placeId].likeCount += 1
//        }else {
//            if (viewModel?.placeInfo[cell.placeId].likeCount)! > 0 {
//                viewModel?.placeInfo[cell.placeId].likeCount -= 1
//            }
//        }
//        viewModel?.placeInfo[cell.placeId].likeSelected = cell.likeButton.isSelected
//        tableView.reloadRows(at: [[0, cell.placeId]], with: .none)
//    }
//
//    func didTapConfirmButton(cell: DetailPlaceTableViewCell) {
//        print("didTapConfirmButton")
////        print(cell.confirmButton.isSelected)
////        print(cell.placeId)
//    }
//
//    func didTapDetailButton(cell: DetailPlaceTableViewCell) {
//        guard let placeInfo = viewModel?.placeInfo[cell.placeId] else { return }
//        guard let category = viewModel?.category else { return }
//        self.viewModel!.detailPlace(place: placeInfo, category: category[cell.placeId])
//    }
//
//
//}
//
//extension DetailArchiveViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if categoryHeaderOffset == 0 {
//            categoryHeaderOffset = collectionView.frame.minY // 238
//            //print("update \(categoryHeaderOffset)")
//        }
//
//        if isTableView == false {
//            if scrollView.contentOffset.y >= categoryHeaderOffset && scrollView == self.scrollView {
//                //print("tableview")
//                categoryTopAnchor.constant = scrollView.contentOffset.y - categoryHeaderOffset
//                self.scrollView.isScrollEnabled = false
//                self.tableView.isScrollEnabled = true
//                isTableView = true
//            }
//            else {
//                //print("scrollview")
//                categoryTopAnchor.constant = 0
//                self.scrollView.isScrollEnabled = true
//                self.tableView.isScrollEnabled = false
//            }
//        }
//
//        if scrollView == self.tableView && scrollView.contentOffset.y <= 0 {
//            //처음 지점으로 돌아온다면
//            //print("처음 지점")
//            categoryTopAnchor.constant = 0
//            self.scrollView.isScrollEnabled = true
//            self.tableView.isScrollEnabled = false
//            isTableView = false
//        }
//
//        //print("offset \(scrollView.contentOffset.y)")
//
//    }
//}
//
//extension DetailArchiveViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel!.category.count + 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfirmCategoryCollectionViewCell.identifier, for: indexPath) as! ConfirmCategoryCollectionViewCell
//            if viewModel?.selectedCategory.index == -1 {
//                cell.isSelected = true
//                collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .init())
//            }
//            return cell
//        }
//
//        if indexPath.row == viewModel!.category.count {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCategoryCollectionViewCell.identifier, for: indexPath) as! AddCategoryCollectionViewCell
//            cell.configureCell(isEditing: isCategoryEditing)
//            return cell
//        }
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
//        if 0...8 ~= viewModel!.selectedCategory.index {
//            cell.isSelected = true
//            collectionView.selectItem(at: [0, viewModel!.selectedCategory.index], animated: true, scrollPosition: .init())
//        }
//        cell.delegate = self
//        cell.indexPath = indexPath
//        cell.configureCell(name: viewModel!.category[indexPath.row].name, isEditing: isCategoryEditing)
//        return cell
//
//    }
//
//
//}
//
//extension DetailArchiveViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let viewModel = viewModel else { return }
//        if indexPath.row == viewModel.category.count { //마지막 셀 클릭 시
//            if isCategoryEditing {
//                isCategoryEditing = false
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
//                    self.collectionView.reloadData()
//                }
//            }else {
//                viewModel.addHomeCategory(without: viewModel.category)
//            }
//        }else {
//            let selectedCategory = viewModel.category[indexPath.row]
//            viewModel.setCategory(category: selectedCategory)
//            tableView.reloadData()
//        }
//    }
//}
//
//extension DetailArchiveViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row == viewModel!.category.count || indexPath.row == 0 {
//            return CGSize(width: 60, height: 33)
//        }
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
//        cell.categoryLabel.text = viewModel!.category[indexPath.row].name
//        cell.categoryLabel.sizeToFit()
//        var cellWidth = cell.categoryLabel.frame.width + 34
//        if isCategoryEditing {
//            cellWidth += 12 // 버튼만큼의 너비
//        }
//        return CGSize(width: cellWidth, height: 33)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
//    }
//}
//
//extension DetailArchiveViewController: CategoryCollectionViewCellDelegate {
//    func didTapDeleteButton(cell: CategoryCollectionViewCell) {
//        guard let viewModel = viewModel else { return }
//        let currentCategory = viewModel.category[cell.indexPath!.row]
//        viewModel.deleteCategory(category: currentCategory)
//    }
//}
//
////MARK: Home Category에서 받아온 카테고리 업데이트
//extension DetailArchiveViewController: HomeCategoryPopUpDelegate {
//    func selectedCategory(category: [Category]) {
//        viewModel?.addCategory(category: category)
//        DispatchQueue.main.async { [weak self] in
//            print("selectedCategory \(category)")
//            guard let self = self else { return }
//            self.collectionView.reloadData()
//        }
//    }
//}
    
}

extension DetailArchiveViewController: UICollectionViewDelegate {
    
}

extension DetailArchiveViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let viewModel = viewModel else { return }
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            
        }
    }
}
