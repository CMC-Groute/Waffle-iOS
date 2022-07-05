//
//  InputArchiveCodeViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/16.
//

import UIKit
import RxSwift
import RxCocoa

class InputArchiveCodeViewController: UIViewController {
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var inValidCodeMessageText: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    var viewModel: InputArchiveCodeViewModel?
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resignForKeyboardNotification()
        bindViewModel()
        configureUI()
      
    }
    
    func resignForKeyboardNotification() {
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
          if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
              let keyboardReactangle = keyboardFrame.cgRectValue
              let keyboardHeight = keyboardReactangle.height
              UIView.animate(
                  withDuration: 0.3
                  , animations: {
                      self.bottonConstraint.constant = keyboardHeight - self.view.safeAreaInsets.bottom + 4
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
    
    func configureUI() {
        codeTextField.changePlaceHolderColor()
        codeTextField.makeRounded(corner: 10)
        codeTextField.becomeFirstResponder()
        codeTextField.padding(value: 9, icon: Asset.Assets.errorCircleRounded.name)
        joinButton.makeRounded(corner: 26)
        
        func setNavigationBar() {
            self.navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
            self.navigationItem.title = "약속 추가하기"
//            let backImage = Asset.Assets.btn.image.withRenderingMode(.alwaysOriginal)
//            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
//            navigationItem.leftBarButtonItem = backButton
        }
    }
    
//    @objc func didTapBackButton() {
//        viewModel?.back()
//    }
    
    private func bindViewModel() {
        let input = InputArchiveCodeViewModel.Input(codeTextField: self.codeTextField.rx.text.orEmpty.asObservable(), codeTextFieldDidTapEvent: self.codeTextField.rx.controlEvent(.editingDidBegin), codeTextFieldDidEndEvent: self.codeTextField.rx.controlEvent(.editingDidEnd), joinButton: self.joinButton.rx.tap.asObservable())
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        input.codeTextFieldDidTapEvent
            .subscribe(onNext: { _ in
                self.codeTextField.focusingBorder(color: Asset.Colors.orange.name)
            }).disposed(by: disposeBag)
        
        
        input.codeTextFieldDidEndEvent
            .subscribe(onNext: { _ in
                self.codeTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        output?.joinButtonEnabled
            .subscribe(onNext: { bool in
                if bool {
                    self.joinButton.setEnabled(color: Asset.Colors.black.name)
                }else {
                    self.joinButton.setUnEnabled(color: Asset.Colors.gray4.name)
                }
            }).disposed(by: disposeBag)
        
        output?.inValidCodeMessage
            .subscribe(onNext: { bool in
                self.inValidCodeMessageText.isHidden = !bool
                self.codeTextField.errorBorder(bool: !bool)
            }).disposed(by: disposeBag)
        
        
    }
    

}
