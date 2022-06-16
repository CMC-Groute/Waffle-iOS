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
    
    var viewModel: InputArchiveViewModel?
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
      
    }
    
    private func bindViewModel() {
        let input = InputArchiveViewModel.Input(codeTextField: self.codeTextField.rx.text.orEmpty.asObservable(), codeTextFieldDidTapEvent: self.codeTextField.rx.controlEvent(.editingDidBegin), codeTextFieldDidEndEvent: self.codeTextField.rx.controlEvent(.editingDidEnd), joinButton: self.joinButton.rx.tap.asObservable())
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
    }
    

}
