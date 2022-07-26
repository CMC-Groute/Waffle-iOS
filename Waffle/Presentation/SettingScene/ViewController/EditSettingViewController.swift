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

final class EditSettingViewController: UIViewController {
    var viewModel: EditSettingViewModel?
    private var disposeBag = DisposeBag()
    
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var nickNameTextField: UITextField!
    @IBOutlet private weak var nickNameInValidText: UILabel!
    @IBOutlet private weak var bottonConstraint: NSLayoutConstraint!
    
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
    
    private func configureUI() {
        nickNameTextField.changePlaceHolderColor()
        profileImage.makeCircleShape()
        doneButton.makeRounded(corner: 26)
        doneButton.setUnEnabled(color: Asset.Colors.gray4.name)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        nickNameTextField.makeRounded(corner: 10)
        nickNameTextField.padding(value: 9, icon: Asset.Assets.errorCircleRounded.name)
        func setNavigationBar() {
            let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
            navigationItem.leftBarButtonItem = backButton
            self.navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
            self.navigationItem.title = "프로필 편집"
        }
        setNavigationBar()
    }
    
    @objc func didTapBackButton() {
        viewModel?.back()
    }
    
    @objc func didTapDoneButton() {
        guard let viewModel = viewModel else { return }
        let selectedIndex = viewModel.updateIndex ?? viewModel.selectedIndex
        viewModel.updateUserInfo(nickName: nickNameTextField.text!, selectedIndex: selectedIndex)
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
        self.view.endEditing(true)
    }

    
    private func collectionviewSetUp() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
    private func bindViewModel(){
        let input = EditSettingViewModel.Input(doneButton: self.doneButton.rx.tap.asObservable(), nickNameTextFieldDidTapEvent: self.nickNameTextField.rx.controlEvent(.editingDidBegin), nickNameTextFieldDidEndEvent: self.nickNameTextField.rx.controlEvent(.editingDidEnd),nickNameTextFieldEditing: self.nickNameTextField.rx.controlEvent(.editingChanged), selectedCell: self.collectionView.rx.itemSelected.asObservable())
        
        input.nickNameTextFieldDidTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.nickNameTextField.focusingBorder(color: Asset.Colors.orange.name)
            }).disposed(by: disposeBag)
        
        input.nickNameTextFieldDidEndEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.nickNameTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        input.nickNameTextFieldEditing
            .subscribe(onNext: {
                self.validating()
            }).disposed(by: disposeBag)
      
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        nickNameTextField.text = viewModel?.nickName
        

        viewModel?.nickNameInvalidMessage
            .subscribe(onNext: { [weak self] bool in
                guard let self = self else { return }
                self.nickNameInValidText.isHidden = bool
                if bool {
                    self.nickNameTextField.layer.borderColor = .none
                    self.nickNameTextField.layer.borderWidth = 0
                    self.nickNameTextField.rightViewMode = .always
                    self.nickNameTextField.changeIcon(value: 9, icon: Asset.Assets.checkCircle.name)
                }else {
                    self.nickNameTextField.errorBorder(bool: false)
                    self.nickNameTextField.changeIcon(value: 9, icon: Asset.Assets.errorCircleRounded.name)
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
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        cell.makeCircleShape()
        cell.imageview.image = UIImage(named: "wapple-\(indexPath.row)")
        if indexPath.row  == viewModel?.selectedIndex {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            self.profileImage.image = UIImage(named: "wapple-\(indexPath.row)")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.updateIndex = indexPath.row
        self.profileImage.image = UIImage(named: "wapple-\(indexPath.row)")
        validating()
    }
}

extension EditSettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 47, height: 47)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let cellWidth: CGFloat = collectionView.frame.width // Your cell width
        let numberOfCells = floor(view.frame.size.width / cellWidth)
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}

extension EditSettingViewController: UITextFieldDelegate {
    func validating() {
        guard let viewModel = viewModel else { return }
        if nickNameTextField.text == "" { // 비어 있을때
            nickNameTextField.rightView = nil
            doneButton.setUnEnabled(color: Asset.Colors.gray4.name)
        }else if !viewModel.checkNickNameValid(nickName: nickNameTextField.text!) { // 유효 x
            viewModel.nickNameInvalidMessage.accept(false)
        }else {
            viewModel.nickNameInvalidMessage.accept(true)
        }
        if nickNameTextField.text == viewModel.nickName {
            if viewModel.updateIndex == nil || (viewModel.selectedIndex == viewModel.updateIndex) {
                nickNameTextField.rightView = nil
                doneButton.setUnEnabled(color: Asset.Colors.gray4.name)
            }else {
                doneButton.setEnabled(color: Asset.Colors.black.name)
            }
        }else {
            doneButton.setEnabled(color: Asset.Colors.black.name)
        }
    }

}
