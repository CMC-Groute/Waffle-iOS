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
    @IBOutlet weak var cardCountLabel: UILabel!
    @IBOutlet weak var emptyView: EmptyCardView!
    var viewModel: HomeViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag = DisposeBag()
    
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
        setNavigationBar()
    }
    
    func collectionViewSetUp() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(CardCollectionViewCell.nib(), forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        collectionView.backgroundColor = .red
        collectionView.isScrollEnabled = true
        let layout = CollectionViewPagingLayout()
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
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}
