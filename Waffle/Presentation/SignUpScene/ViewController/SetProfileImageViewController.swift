//
//  SetProfileImageViewController.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/11.
//

import Foundation
import UIKit
import RxSwift

final class SetProfileImageViewController: UIViewController {
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var nickNameTextField: UITextField!
    @IBOutlet private weak var nickNameInValidText: UILabel!
    @IBOutlet private weak var bottonConstraint: NSLayoutConstraint!
    
    var viewModel: SetProfileImageViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resignForKeyboardNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        collectionviewSetUp()
    }
    
    func configureUI() {
        profileImage.layer.borderWidth = 0
        profileImage.makeCircleShape()
        startButton.makeRounded(corner: 26)
        startButton.setUnEnabled(color: Asset.Colors.gray4.name)
        nickNameTextField.changePlaceHolderColor()
        nickNameTextField.makeRounded(corner: 10)
        nickNameTextField.padding(value: 9, icon: Asset.Assets.errorCircleRounded.name)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let backImage = Asset.Assets.btn.image.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let progressOneButton = self.navigationItem.rightBarButton(self, level: Asset.Assets.joinProgressed1.name)
        let progressTwoButton = self.navigationItem.rightBarButton(self, level: Asset.Assets.joinProgressed2.name)
        let progreeeThreeButton = self.navigationItem.rightBarButton(self, level: Asset.Assets.joinProcessed3.name)
        
        self.navigationItem.rightBarButtonItems = [progreeeThreeButton, spacer, progressTwoButton, spacer, progressOneButton]
    }
    
    @objc func didTapBackButton() {
        self.viewModel?.backButton()
    }
    
    func resignForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
          if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
              let keyboardReactangle = keyboardFrame.cgRectValue
              let keyboardHeight = keyboardReactangle.height
              UIView.animate(
                  withDuration: 0.3
                  , animations: {
                      self.bottonConstraint.constant = -keyboardHeight + self.view.safeAreaInsets.bottom - 4
                  }
              )
        }

      }
      
      @objc func keyboardWillHide(notification: NSNotification) {
          UIView.animate(
              withDuration: 0.3
              , animations: {
                  self.bottonConstraint.constant = 0
              }
          )
      }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func collectionviewSetUp() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = false
    }
    
    private func bindViewModel() {
        let input = SetProfileImageViewModel.Input(nickNameTextField: nickNameTextField.rx.text.orEmpty.asObservable(), startButton: startButton.rx.tap.asObservable(), nickNameTextFieldDidTapEvent: nickNameTextField.rx.controlEvent(.editingDidBegin), nickNameTextFieldDidEndEvent: nickNameTextField.rx.controlEvent(.editingDidEnd))
        
        
        
        input.nickNameTextFieldDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.nickNameTextField.focusingBorder(color: Asset.Colors.orange.name)
            }).disposed(by: self.disposeBag)
        
        input.nickNameTextFieldDidEndEvent
            .subscribe(onNext: { [weak self] in
                self?.nickNameTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
      
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        output?.nickNameInvalidMessage
            .subscribe(onNext: { [weak self] bool in
                guard let self = self else { return }
                
                self.nickNameInValidText.isHidden = bool
                let nickName = self.nickNameTextField.text ?? ""
                if bool {
                    self.nickNameTextField.focusingBorder(color: Asset.Colors.orange.name)
                    self.nickNameTextField.changeIcon(value: 9, icon: Asset.Assets.checkCircle.name)
                    if nickName.isEmpty {
                        self.nickNameTextField.rightView = nil
                    }
                }else {
                    self.nickNameTextField.errorBorder(bool: false)
                    self.nickNameTextField.changeIcon(value: 9, icon: Asset.Assets.errorCircleRounded.name)
                }
            }).disposed(by: disposeBag)
        
        output?.startButtonEnabled
            .subscribe(onNext: { bool in
                if bool {
                    self.startButton.setEnabled(color: Asset.Colors.black.name)
                }else {
                    self.startButton.setUnEnabled(color: Asset.Colors.gray4.name)
                }
            }).disposed(by: disposeBag)
        
        output?.alertMessage
            .filter { !$0.isEmpty }
            .subscribe(onNext: { alert in
                self.presentAlert(withTitle: "ํ์๊ฐ์ ์คํจ", message: alert)
            }).disposed(by: disposeBag)
        
    }
}

extension SetProfileImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        cell.makeCircleShape()
        cell.imageview.image = UIImage(named: "wapple-\(indexPath.row)")
        if indexPath.row == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            
            self.profileImage.image = UIImage(named: "wapple-\(indexPath.row)")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.selectedIndex = indexPath.row
        self.profileImage.image = UIImage(named: "wapple-\(indexPath.row)")
    }
}

extension SetProfileImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 47, height: 47)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let cellWidth: CGFloat = collectionView.frame.width // Your cell width

        let numberOfCells = floor(view.frame.size.width / cellWidth)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    
    


    
}
