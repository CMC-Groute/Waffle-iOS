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
import CollectionViewPagingLayout

class HomeViewController: UIViewController {
    @IBOutlet weak var cardCountButton: UIButton!
    @IBOutlet weak var emptyView: EmptyCardView!
    var viewModel: HomeViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag = DisposeBag()
    let layout = CollectionViewPagingLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        collectionViewSetUp()
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
        cardCountButton.round(width: 1, color: Asset.Colors.gray3.name, value: 16)
        cardCountButton.setTitle("1/\(viewModel!.usecase.cardInfo.count)", for: .normal)
        self.cardCountButton.setTitleColor(Asset.Colors.gray4.color, for: .normal)
        
        setNavigationBar()
    }
    
    func collectionViewSetUp() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(CardCollectionViewCell.nib(), forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        collectionView.backgroundColor = .red
        collectionView.isScrollEnabled = true
        collectionView.collectionViewLayout = layout
        layout.numberOfVisibleItems = nil
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        
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
        
        //cardView.isHidden = true
    }
    
    func hideEmptyView() {
        emptyView.isHidden = true
        
        //cardView.isHidden = false
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell
        cell.configureCell(item: viewModel!.usecase.cardInfo[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.usecase.cardInfo.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            for cell in collectionView.visibleCells {
                guard let indexPath = collectionView.indexPath(for: cell) else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.cardCountButton.setTitle("\(self.layout.currentPage + 1)/\(self.viewModel!.usecase.cardInfo.count)", for: .normal)
                }
            }
        }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}
