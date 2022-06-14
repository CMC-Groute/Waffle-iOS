//
//  EditSettingViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class EditSettingViewController: UIViewController {
    var viewModel: EditSettingViewModel?
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameInValidText: UILabel!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    let imageList = ["heart.fill", "heart", "heart.fill", "heart", "heart.fill"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        collectionviewSetUp()
        resignForKeyboardNotification()
    }

    
    private func configureUI() {
        profileImage.makeCircleShape()
        doneButton.round(corner: 25)
        doneButton.setUnEnabled(color: Asset.Colors.gray4.name)
        nickNameTextField.round(corner: 10)
        nickNameTextField.padding(value: 9, direction: .left, icon: Asset.Assets.errorCircleRounded.name)
        
        func setNavigationBar() {
            self.navigationItem.title = "프로필 편집" // TO DO 텍스트 폰트 적용
            let backImage = UIImage(named: Asset.Assets._24pxBtn.name)!.withRenderingMode(.alwaysOriginal)
            UINavigationBar.appearance().backIndicatorImage = backImage
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -80.0), for: .default)
        }
        setNavigationBar()
    }
    
    func resignForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    //notification delete
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
                      self.bottonConstraint.constant = -keyboardHeight + self.view.safeAreaInsets.bottom
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
        self.view.endEditing(true)
    }

    
    func collectionviewSetUp() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = false
    }
    
    private func bindViewModel(){
        let input = EditSettingViewModel.Input(nickNameTextField: self.nickNameTextField.rx.text.orEmpty.asObservable(), doneButton: self.doneButton.rx.tap.asObservable(), nickNameTextFieldDidTapEvent: self.nickNameTextField.rx.controlEvent(.editingDidBegin), nickNameTextFieldDidEndEvent: self.nickNameTextField.rx.controlEvent(.editingDidEnd), selectedCell: self.collectionView.rx.itemSelected.asObservable())

        input.nickNameTextFieldDidTapEvent
            .subscribe(onNext: {
                self.nickNameTextField.focusingBorder(color: Asset.Colors.orange.name)
            }).disposed(by: self.disposeBag)
        
        input.nickNameTextFieldDidEndEvent
            .subscribe(onNext: {
                self.nickNameTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
      
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        input.selectedCell
            .subscribe(onNext: { indexpath in
            }).disposed(by: disposeBag)
        
        output?.nickNameInvalidMessage
            .subscribe(onNext: { bool in
                self.nickNameTextField.errorBorder(bool: bool)
                self.nickNameInValidText.isHidden = bool
                if bool {
                    self.nickNameTextField.changeIcon(value: 9, direction: .left, icon: Asset.Assets.checkCircle.name)
                }else {
                    self.nickNameTextField.changeIcon(value: 9, direction: .left, icon: Asset.Assets.errorCircleRounded.name)
                }
            }).disposed(by: disposeBag)
        
        output?.startButtonEnabled
            .subscribe(onNext: { bool in
                if bool {
                    self.doneButton.setEnabled(color: Asset.Colors.black.name)
                }else {
                    self.doneButton.setUnEnabled(color: Asset.Colors.gray4.name)
                }
            }).disposed(by: disposeBag)
    }
}




extension EditSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        cell.makeCircleShape()
        cell.imageview.image = UIImage(systemName: imageList[indexPath.row])
        if indexPath.row == 0 {
            cell.selected(isSelected: true)
            self.profileImage.image = UIImage(systemName: imageList[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! ProfileImageCollectionViewCell

        print("click cell \(indexPath)")
        for i in 0..<5 {
            if indexPath.row == i { continue }
            let deselected: IndexPath = [0, i]
            let deselectedCell = collectionView.cellForItem(at: deselected) as! ProfileImageCollectionViewCell
            deselectedCell.selected(isSelected: false)
        }

        //새로 선택 셀 선택
        cell.selected(isSelected: true)
        self.profileImage.image = UIImage(systemName: imageList[indexPath.row])
    }
}

extension EditSettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 53, height: 53)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let cellWidth: CGFloat = collectionView.frame.width // Your cell width

        let numberOfCells = floor(view.frame.size.width / cellWidth)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)

        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
    }
    
    
    
}