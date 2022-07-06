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
import MSPeekCollectionViewDelegateImplementation

class HomeViewController: UIViewController {
    @IBOutlet weak var cardCountButton: UIButton!
    @IBOutlet weak var emptyView: EmptyCardView!
    var viewModel: HomeViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag = DisposeBag()
    var behavior = MSCollectionViewPeekingBehavior(cellSpacing: 16)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        collectionViewSetUp()
    }
    
    func configureUI() {
        func setNavigationBar() {
            let image = Asset.Assets.wapple.image.withRenderingMode(.alwaysOriginal)
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 26
            let calendarButton = self.navigationItem.rightBarButton(self, level: Asset.Assets.calendar.name)
            let bellButton = self.navigationItem.rightBarButton(self, level: Asset.Assets.bell.name)
            
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [bellButton, spacer, calendarButton]
        }
        cardCountButton.makeRounded(width: 1, color: Asset.Colors.gray3.name, value: 16)
        cardCountButton.setTitleColor(Asset.Colors.gray4.color, for: .normal)
        setNavigationBar()
    }
    
    func collectionViewSetUp() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardCollectionViewCell.nib(), forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        collectionView.configureForPeekingBehavior(behavior: behavior)
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
            }).disposed(by: disposeBag)
        
    }
    
    func hideCardView() {
        emptyView.isHidden = false
        collectionView.isHidden = true
        cardCountButton.isHidden = true
    }
    
    func hideEmptyView() {
        emptyView.isHidden = true
        collectionView.isHidden = false
        guard let viewModel = viewModel else { return }
        guard let cardInfo = viewModel.usecase.cardInfo else { return }
        cardCountButton.setTitle("1/\(cardInfo.count)", for: .normal)
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cardInfo =  viewModel?.usecase.cardInfo else { return 0 }
        return cardInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell
        guard let cardInfo =  viewModel?.usecase.cardInfo else { return cell }
        cell.configureCell(item: cardInfo[indexPath.row])
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        guard let cardInfo = viewModel?.usecase.cardInfo else { return }
        self.cardCountButton.setTitle("\(self.behavior.currentIndex + 1)/\(cardInfo.count)", for: .normal)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //viewModel과 바인딩
        guard let selectedArchive = viewModel?.usecase.cardInfo else { return }
        self.viewModel?.detailArchive(selectedArchive: selectedArchive[indexPath.row] )
    }
}


