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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
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
            let bellButton = UIBarButtonItem(image: Asset.Assets.bell.image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapBellButton))
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = bellButton
        }
        cardCountButton.makeRounded(width: 1, color: Asset.Colors.gray3.name, value: 16)
        cardCountButton.setTitleColor(Asset.Colors.gray4.color, for: .normal)
        
        setNavigationBar()
    }
    
    @objc func didTapBellButton() {
        viewModel?.homeAlarm()
    }
    
    func collectionViewSetUp() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardCollectionViewCell.nib(), forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        collectionView.configureForPeekingBehavior(behavior: behavior)
    }
    
    func bindViewModel() {
        let input = HomeViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in }, makeArchiveButton: emptyView.makeArchiveButton.rx.tap.asObservable())

        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        output?.isHiddenView
            .subscribe(onNext: { [weak self] bool in
                guard let self = self else { return }
                
                self.collectionView.reloadData()
                self.updateButtonCount()
                if bool {
                    self.hideCardView()
                }else {
                    self.hideEmptyView()
                }
            }).disposed(by: disposeBag)
        
        output?.networkErrorMessage
            .subscribe(onNext: { str in
                self.presentAlert(withTitle: "연결 실패", message: str)
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
        cardCountButton.isHidden = false
        updateButtonCount()
    }
    
    func updateButtonCount() {
        guard let cardInfo = viewModel?.cardInfo else { return }
        let firstLoadCount = "1"
        let countText = "\(firstLoadCount)/\(cardInfo.count)"
        let mutableString = NSMutableAttributedString(string: countText)
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: Asset.Colors.gray5.color, range: (countText as NSString).range(of: firstLoadCount))
        cardCountButton.setAttributedTitle(mutableString, for: .normal)
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cardInfo = viewModel?.cardInfo else { return 0 }
        return cardInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell
        guard let cardInfo =  viewModel?.cardInfo else { return cell }
        cell.configureCell(item: cardInfo[indexPath.row])
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        guard let cardInfo = viewModel?.cardInfo else { return }
        let countText = "\(self.behavior.currentIndex + 1)/\(cardInfo.count)"
        let mutableString = NSMutableAttributedString(string: countText)
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: Asset.Colors.gray5.color, range: (countText as NSString).range(of: "\(self.behavior.currentIndex + 1)"))
        self.cardCountButton.setAttributedTitle(mutableString, for: .normal)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //viewModel과 바인딩
        guard let selectedArchive = viewModel?.cardInfo else { return }
        self.viewModel?.detailArchive(selectedArchive: selectedArchive[indexPath.row] )
    }
}


