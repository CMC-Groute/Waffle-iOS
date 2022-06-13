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
    var disposeBag = DisposeBag()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    let timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = Locale(identifier: "ko-KR")
        timePicker.datePickerMode = .time
        return timePicker
    }()
    
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
        archiveMemoTextView.textContainerInset = UIEdgeInsets(top: 16, left: 14, bottom: 16, right: 14)
        archiveMemoTextView.attributedText = archiveMemoTextView.text.setLineHeight(24)
        addArchiveButton.round(corner: 25)
        
        func setToolbar() {
            let dToolBar = UIToolbar()
            let tToolBar = UIToolbar()
            dToolBar.sizeToFit()
            tToolBar.sizeToFit()

            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let dCancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(cancelPressed(_:)))
            let dDoneButton = UIBarButtonItem(title: "선택", style: .done, target: nil, action: #selector(dDonePressed(_:)))
            
            let tCancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(cancelPressed(_:)))
            let tDoneButton = UIBarButtonItem(title: "선택", style: .done, target: nil, action: #selector(tDonePressed(_:)))
            dToolBar.setItems([spacer, dCancelButton, dDoneButton], animated: true)
            tToolBar.setItems([spacer, tCancelButton, tDoneButton], animated: true)
            archiveDateTextField.inputView = datePicker
            archiveDateTextField.inputAccessoryView = dToolBar
            
            archiveTimeTextField.inputView = timePicker
            archiveTimeTextField.inputAccessoryView = tToolBar
            
        }

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
        
        func setButtonState() {
            archiveTimeDateLaterButton.setTitleColor(UIColor(named: Asset.Colors.black.name), for: .selected)
            archiveTimeDateLaterButton.setTitleColor(UIColor(named: Asset.Colors.gray5.name), for: .normal)
            archiveTimeDateLaterButton.setImage(UIImage(named: Asset.Assets.unCheck.name), for: .normal)
            archiveTimeDateLaterButton.setImage(UIImage(named: Asset.Assets.check.name), for: .selected)
                                                     
            
        }
        
        setNavigationBar()
        placeHolderText()
        setToolbar()
        setButtonState()

    }

    
    private func bindViewModel() {
        let input = AddArchiveModel.Input(nameTextField: self.archiveNameTextField.rx.text.orEmpty.asObservable(), memoTextView: self.archiveMemoTextView.rx.text.orEmpty.asObservable(), nameTextFieldDidTapEvent: self.archiveNameTextField.rx.controlEvent(.editingDidBegin), memoTextViewDidTapEvent: self.archiveMemoTextView.rx.didBeginEditing, nameTextFieldDidEndEvent: self.archiveNameTextField.rx.controlEvent(.editingDidEnd), memoTextViewDidEndEvent: self.archiveMemoTextView.rx.didEndEditing, dateTimeLaterButton: self.archiveTimeDateLaterButton.rx.tap.asObservable(), locationTextFieldTapEvent: self.archiveLocationTextField.rx.controlEvent(.editingDidBegin), locationLaterButton: self.archiveLocationLaterButton.rx.tap.asObservable(), addArchiveButton: self.addArchiveButton.rx.tap.asObservable())
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        input.nameTextField
            .subscribe(onNext: { text in
                let restrictedStr = self.viewModel?.maxInputRestricted(length: 10, s: text)
                self.archiveNameTextField.text = restrictedStr
            }).disposed(by: disposeBag)
        
        input.nameTextFieldDidTapEvent
            .subscribe(onNext: { _ in
                self.archiveNameTextField.focusingBorder(color: Asset.Colors.orange.name)
            }).disposed(by: disposeBag)
        
        input.nameTextFieldDidEndEvent
            .subscribe(onNext: { _ in
                self.archiveNameTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        input.memoTextViewDidTapEvent
            .subscribe(onNext: { _ in
                print("memoTextViewDidTapEvent")
                self.archiveMemoTextView.focusingBorder(color: Asset.Colors.orange.name)
            }).disposed(by: disposeBag)
        
        input.memoTextViewDidEndEvent
            .subscribe(onNext: { _ in
                print("memoTextViewDidEndEvent")
                self.archiveMemoTextView.focusingBorder(color: Asset.Colors.gray2.name)
            }).disposed(by: disposeBag)
        
        input.locationTextFieldTapEvent // 키보드 내리기
            .subscribe(onNext: {
                self.archiveLocationTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
           
        input.dateTimeLaterButton
            .subscribe(onNext: {
                self.archiveTimeDateLaterButton.isSelected = self.archiveTimeDateLaterButton.isSelected ? false : true
            }).disposed(by: disposeBag)
        
        }
    
    @objc func dDonePressed(_ sender: UIDatePicker) {
        self.archiveDateTextField.text = datePicker.date.addArchiveDateToString()
        self.view.endEditing(true)
    }
    
    @objc func tDonePressed(_ sender: UIDatePicker) {
        self.archiveTimeTextField.text = timePicker.date.addArhiveTimeToString()
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed(_ sender: UIDatePicker) {
        self.view.endEditing(true)
    }
}
