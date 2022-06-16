//
//  SetProfileImageViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/11.
//

import Foundation
import UIKit
import RxSwift

class SetProfileImageViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameInValidText: UILabel!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    var viewModel: SetProfileImageViewModel?
    var disposeBag = DisposeBag()

    let imageList = ["heart.fill", "heart", "heart.fill", "heart", "heart.fill"]
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        collectionviewSetUp()
        resignForKeyboardNotification()
    }
    
    func configureUI() {
        profileImage.makeCircleShape()
        startButton.round(corner: 25)
        startButton.setUnEnabled(color: Asset.Colors.gray4.name)
        nickNameTextField.round(corner: 10)
        nickNameTextField.padding(value: 9, direction: .left, icon: Asset.Assets.errorCircleRounded.name)
        
        func setProgressNavigationBar() { // TO DO selected state
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            let progressOneButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProgressed1.name)
            let progressTwoButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProgressed2.name)
            let progreeeThreeButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProcessed3.name)
            
            self.navigationItem.rightBarButtonItems = [progreeeThreeButton, spacer, progressTwoButton, spacer, progressOneButton]
        }
        
        setProgressNavigationBar()
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
    
    private func bindViewModel() {
        let input = SetProfileImageViewModel.Input(nickNameTextField: self.nickNameTextField.rx.text.orEmpty.asObservable(), startButton: self.startButton.rx.tap.asObservable(), nickNameTextFieldDidTapEvent: self.nickNameTextField.rx.controlEvent(.editingDidBegin), nickNameTextFieldDidEndEvent: self.nickNameTextField.rx.controlEvent(.editingDidEnd), selectedCell: self.collectionView.rx.itemSelected.asObservable())
        
        
        
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
                print("selectedCell \(indexpath)")
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
                print("startButtonEnabled \(bool)")
                if bool {
                    self.startButton.setEnabled(color: Asset.Colors.black.name)
                }else {
                    self.startButton.setUnEnabled(color: Asset.Colors.gray4.name)
                }
            }).disposed(by: disposeBag)
        
    }
}

extension SetProfileImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

extension SetProfileImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 53, height: 53)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//           return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let cellWidth: CGFloat = collectionView.frame.width // Your cell width

        let numberOfCells = floor(view.frame.size.width / cellWidth)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)

        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
    }
    
    
    


    
}
