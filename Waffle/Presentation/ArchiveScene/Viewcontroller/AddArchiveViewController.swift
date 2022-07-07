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
    
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    var viewModel: AddArchiveViewModel?
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
        resignForKeyboardNotification()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureUI() {
        archiveNameTextField.changePlaceHolderColor()
        archiveDateTextField.changePlaceHolderColor()
        archiveTimeTextField.changePlaceHolderColor()
        archiveLocationTextField.changePlaceHolderColor()
        
        archiveNameTextField.makeRounded(corner: 10)
        archiveDateTextField.makeRounded(corner: 10)
        archiveTimeTextField.makeRounded(corner: 10)
        archiveLocationTextField.makeRounded(corner: 10)
        
        archiveNameTextField.padding(value: 9, icon: Asset.Assets.errorCircleRounded.name)
        archiveDateTextField.padding(value: 9, icon: "")
        archiveTimeTextField.padding(value: 9, icon: "")
        archiveLocationTextField.padding(value: 9)
        archiveMemoTextView.makeRounded(width: 2, color: Asset.Colors.gray2.name, value: 10)
        archiveMemoTextView.textContainerInset = UIEdgeInsets(top: 16, left: 14, bottom: 16, right: 14)
        archiveMemoTextView.attributedText = archiveMemoTextView.text.setLineHeight(24)
        addArchiveButton.makeRounded(corner: 26)
        
        func setNavigationBar() {
            self.navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
            let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
            navigationItem.leftBarButtonItem = backButton
        }

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
        
        setNavigationBar()
        placeHolderText()
        setToolbar()
        placeHolderText()

    }

    @objc func didTapBackButton() {
        viewModel?.back()
    }
    
    func placeHolderText(defaultValue: Bool = true) {
        if defaultValue {
            let currentDate: String = Date().addArchiveDateToString()
            let currentTime: String = Date().addArhiveTimeToString()
            archiveDateTextField.placeholder = currentDate
            archiveTimeTextField.placeholder = currentTime
        }else {
            archiveDateTextField.placeholder = "토핑이 원하는 날짜로"
            archiveTimeTextField.placeholder = "토핑이 원하는 시간으로"
        }
       
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
                      self.bottonConstraint.constant = -keyboardHeight + self.view.safeAreaInsets.bottom + 4
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

    
    private func bindViewModel() {
        let input = AddArchiveViewModel.Input(nameTextField: self.archiveNameTextField.rx.text.orEmpty.asObservable(), dateTextField: self.archiveDateTextField.rx.text.orEmpty.asObservable(), timeTextField : self.archiveTimeTextField.rx.text.orEmpty.asObservable(), locationTextField: self.archiveLocationTextField.rx.text.orEmpty.asObservable(), memoTextView: self.archiveMemoTextView.rx.text.asObservable(), nameTextFieldDidTapEvent: self.archiveNameTextField.rx.controlEvent(.editingDidBegin), memoTextViewDidTapEvent: self.archiveMemoTextView.rx.didBeginEditing, nameTextFieldDidEndEvent: self.archiveNameTextField.rx.controlEvent(.editingDidEnd), memoTextViewDidEndEvent: self.archiveMemoTextView.rx.didEndEditing, memoTextViewEditing: self.archiveMemoTextView.rx.didChange, dateTimeLaterButton: self.archiveTimeDateLaterButton.rx.tap.asObservable(), locationTextFieldTapEvent: self.archiveLocationTextField.rx.controlEvent(.editingDidBegin), locationLaterButton: self.archiveLocationLaterButton.rx.tap.asObservable(), addArchiveButton: self.addArchiveButton.rx.tap.asObservable())
        
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
                guard let text = self.archiveMemoTextView.text else { return }
                if text == """
                약속에 대한 간략한 정보나 토핑 멤버에게 보내고 싶은 메시지를 작성하면 좋아요
                """ {
                    self.archiveMemoTextView.text = nil
                    self.archiveMemoTextView.textColor = Asset.Colors.black.color
                }
                
                self.archiveMemoTextView.focusingBorder(color: Asset.Colors.orange.name)
            }).disposed(by: disposeBag)
        
        input.memoTextViewDidEndEvent
            .subscribe(onNext: { _ in
                if self.archiveMemoTextView.text.isEmpty || self.archiveMemoTextView.text == nil {
                    self.archiveMemoTextView.textColor = Asset.Colors.gray4.color
                    self.archiveMemoTextView.text = """
                약속에 대한 간략한 정보나 토핑 멤버에게 보내고 싶은 메시지를 작성하면 좋아요
                """    
                }
                self.archiveMemoTextView.focusingBorder(color: Asset.Colors.gray2.name)
            }).disposed(by: disposeBag)
        
        input.memoTextViewEditing
            .subscribe(onNext: { _ in
                let size = CGSize(width: self.view.frame.width, height: .infinity)
                let estimatedSize = self.archiveMemoTextView.sizeThatFits(size)
                self.archiveMemoTextView.translatesAutoresizingMaskIntoConstraints = false
                self.archiveMemoTextView.constraints.forEach { (constraint) in
                  /// 360 이하일때는 더 이상 줄어들지 않게하기
                    if estimatedSize.height <= 360 {
                    
                    }
                    else {
                        if constraint.firstAttribute == .height {
                            constraint.constant = estimatedSize.height
                            self.textViewScrollToBottom()
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        input.locationTextFieldTapEvent // 키보드 내리기
            .subscribe(onNext: {

                self.archiveLocationTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        output?.navigationTitle
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                self.navigationItem.title = title
            }).disposed(by: disposeBag)
        

        let style = NSMutableParagraphStyle()
        let unSelectedAttributes = [ NSAttributedString.Key.foregroundColor: Asset.Colors.gray5.color, NSAttributedString.Key.paragraphStyle:  style, NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 15)]
        let unSelectedString = NSAttributedString(string: "나중에 정할게요", attributes: unSelectedAttributes)
        
        let selectedAttributes = [ NSAttributedString.Key.foregroundColor: Asset.Colors.black.color, NSAttributedString.Key.paragraphStyle:  style, NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 15)]
        let selectedString = NSAttributedString(string: "나중에 정할게요", attributes: selectedAttributes)
        
        input.dateTimeLaterButton
            .subscribe(onNext: { _ in
                if self.archiveTimeDateLaterButton.image(for: .normal) == Asset.Assets.check.image.withRenderingMode(.alwaysOriginal) { // selected
                    self.archiveTimeDateLaterButton.setImage(Asset.Assets.unCheck.image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.archiveTimeDateLaterButton.setAttributedTitle(unSelectedString, for: .normal)
                    self.placeHolderText(defaultValue: true)
                    self.archiveTimeTextField.isEnabled = true
                    self.archiveDateTextField.isEnabled = true
                    output!.dateTimeLaterButtonEnabled.accept(true)
                }else {
                    self.archiveTimeDateLaterButton.setImage(Asset.Assets.check.image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.archiveTimeDateLaterButton.setAttributedTitle(selectedString, for: .normal)
                    self.placeHolderText(defaultValue: false)
                    self.archiveTimeTextField.text?.removeAll()
                    self.archiveDateTextField.text?.removeAll()
                    self.archiveTimeTextField.isEnabled = false
                    self.archiveDateTextField.isEnabled = false
                    output!.dateTimeLaterButtonEnabled.accept(false)
                }
            }).disposed(by: disposeBag)
        
        input.locationLaterButton
            .subscribe(onNext: { _ in
                if self.archiveLocationLaterButton.image(for: .normal) == Asset.Assets.check.image.withRenderingMode(.alwaysOriginal) { // selected
                    self.archiveLocationLaterButton.setImage(Asset.Assets.unCheck.image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.archiveLocationLaterButton.setAttributedTitle(unSelectedString, for: .normal)
                    self.archiveLocationTextField.placeholder = "클릭하면 지역을 선택할 수 있어요"
                    self.archiveLocationTextField.isEnabled = true
                    output!.locationLaterButtonEnabled.accept(true)
                }else {
                    self.archiveLocationLaterButton.setImage(Asset.Assets.check.image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.archiveLocationLaterButton.setAttributedTitle(selectedString, for: .normal)
                    self.archiveLocationTextField.text?.removeAll()
                    self.archiveLocationTextField.placeholder = "토핑이 원하는 위치로"
                    self.archiveLocationTextField.isEnabled = false
                    output!.locationLaterButtonEnabled.accept(false)
                }
            }).disposed(by: disposeBag)
        
        output?.doneButtonEnabled
            .subscribe(onNext: { [weak self] bool in
                guard let self = self else { return }
                bool ? self.addArchiveButton.setEnabled(color: Asset.Colors.black.name) : self.addArchiveButton.setUnEnabled(color: Asset.Colors.gray4.name)
            }).disposed(by: disposeBag)
        
        viewModel?.locationTextField
            .subscribe(onNext: { str in
                self.archiveLocationTextField.addIconLeft(value: 9, icon: UIImage(named: "flagOrange")!, width: 15, height: 17)
                self.archiveLocationTextField.text = str
            }).disposed(by: disposeBag)
        }
    
    private func textViewScrollToBottom() {
        let bottomRange = NSMakeRange(self.archiveMemoTextView.text.count - 1, 1)

        self.archiveMemoTextView.scrollRangeToVisible(bottomRange)
    }
    
    @objc func dDonePressed(_ sender: UIDatePicker) {
        viewModel?.datePickerDate.accept(datePicker.date)
        archiveDateTextField.text = datePicker.date.addArchiveDateToString()
        view.endEditing(true)
    }
    
    @objc func tDonePressed(_ sender: UIDatePicker) {
        viewModel?.timePickerTime.accept(timePicker.date)
        archiveTimeTextField.text = timePicker.date.addArhiveTimeToString()
        view.endEditing(true)
    }
    
    @objc func cancelPressed(_ sender: UIDatePicker) {
        view.endEditing(true)
    }
}
