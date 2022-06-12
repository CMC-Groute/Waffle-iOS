//
//  AddArchiveViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import RxSwift
import RxCocoa

class AddArchiveViewController: UIViewController {
    @IBOutlet weak var archiveNameTextField: UITextField!
    @IBOutlet weak var archiveDateTextField: UITextField!
    @IBOutlet weak var archiveTimeTextField: UITextField!
    
    @IBOutlet weak var archiveTimeDateLaterButton: UIButton!
    
    @IBOutlet weak var archiveLocationTextField: UITextField!
    @IBOutlet weak var archiveLocationLaterButton: UIButton!
    @IBOutlet weak var archiveMemoTextView: UITextView!
    @IBOutlet weak var addArchiveButton: UIButton!
    
    var viewModel: AddArchiveModel?
    var disposBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardWhenTappedAround()
        bindViewModel()
    }
    
    private func configureUI() {
        archiveNameTextField.round(corner: 10)
        archiveDateTextField.round(corner: 10)
        archiveTimeTextField.round(corner: 10)
        archiveLocationTextField.round(corner: 10)
        
        archiveNameTextField.padding(value: 9, direction: .left, icon: Asset.Assets.errorCircleRounded.name)
        archiveDateTextField.padding(value: 9, direction: .left, icon: "")
        archiveTimeTextField.padding(value: 9, direction: .left, icon: "")
        archiveLocationTextField.padding(value: 9, direction: .left, icon: "")
        
        archiveMemoTextView.round(width: 2, color: Asset.Colors.gray2.name, value: 10)
        addArchiveButton.round(corner: 25)
        
        func setNavigationBar() {
            self.navigationItem.title = "약속 만들기" // TO DO 텍스트 폰트 적용
            let backImage = UIImage(named: Asset.Assets._24pxBtn.name)!.withRenderingMode(.alwaysOriginal)
            UINavigationBar.appearance().backIndicatorImage = backImage
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -80.0), for: .default)
        }
        
        func placeHolderText() {
            let currentDate: String = Date().addArchiveDateToString()
            let currentTime: String = Date().addArhiveTimeToString()
            archiveDateTextField.placeholder = currentDate
            archiveTimeTextField.placeholder = currentTime
        }
        
        setNavigationBar()
        placeHolderText()
        
        
    }

    
    private func bindViewModel(){
        
    }
}
