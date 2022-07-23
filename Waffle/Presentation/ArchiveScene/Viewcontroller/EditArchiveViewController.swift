//
//  EditArchiveViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/07.
//

import UIKit
import RxSwift
import RxCocoa

final class EditArchiveViewController: UIViewController {
    @IBOutlet weak var archiveNameTextField: UITextField!
    @IBOutlet weak var archiveDateTextField: UITextField!
    @IBOutlet weak var archiveTimeTextField: UITextField!
    
    @IBOutlet weak var archiveTimeDateLaterButton: UIButton!
    
    @IBOutlet weak var archiveLocationTextField: UITextField!
    @IBOutlet weak var archiveLocationLaterButton: UIButton!
    @IBOutlet weak var archiveMemoTextView: UITextView!
    @IBOutlet weak var addArchiveButton: UIButton!
    
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    var viewModel: EditArchiveViewModel?
    private var disposeBag = DisposeBag()
    let style = NSMutableParagraphStyle()
    
    //For validation
    private var isArchiveTimeDateLaterButton: Bool = false
    private var isArchiveLocationDateLaterButton: Bool = false
    
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
        resignForKeyboardNotification()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            self.navigationItem.title = "약속 편집하기"
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
    
    func validation() {
        let name = archiveNameTextField.text ?? ""
        let date = archiveDateTextField.text ?? ""
        let time = archiveTimeTextField.text ?? ""
        let location = archiveLocationTextField.text ?? ""
        if !name.isEmpty && ((!date.isEmpty && !time.isEmpty) || isArchiveTimeDateLaterButton == true) && (!location.isEmpty || isArchiveLocationDateLaterButton == true) {
            addArchiveButton.setEnabled(color: Asset.Colors.black.name)
        }else {
            addArchiveButton.setUnEnabled(color: Asset.Colors.gray4.name)
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
    
    @objc func didTapEditArchiveButton() {
        let title = archiveNameTextField.text ?? ""
        let date = archiveDateTextField.text ?? nil
        let time = archiveTimeTextField.text ?? nil
        let memo = archiveMemoTextView.text == viewModel?.defaultMemoText ? nil : archiveMemoTextView.text
        let location = archiveLocationTextField.text == "" ? nil :  archiveLocationTextField.text
        
        let archive = AddArchive(title: title, date: date?.toDate()?.sendDataFormat(), time: time?.toTime()?.sendTimeFormat(), memo: memo, location: location)
        viewModel?.editButton(archiveInfo: archive)
    }
    
    

    
    func tapLocationLaterButton() {
        let unSelectedAttributes = [ NSAttributedString.Key.foregroundColor: Asset.Colors.gray5.color, NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 15)]
        let unSelectedString = NSAttributedString(string: "나중에 정할게요", attributes: unSelectedAttributes)
        let selectedAttributes = [ NSAttributedString.Key.foregroundColor: Asset.Colors.black.color, NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 15)]
        let selectedString = NSAttributedString(string: "나중에 정할게요", attributes: selectedAttributes)
        if self.archiveLocationLaterButton.image(for: .normal) == Asset.Assets.check.image.withRenderingMode(.alwaysOriginal) { // selected
            self.archiveLocationLaterButton.setImage(Asset.Assets.unCheck.image.withRenderingMode(.alwaysOriginal), for: .normal)
            self.archiveLocationLaterButton.setAttributedTitle(unSelectedString, for: .normal)
            self.archiveLocationTextField.placeholder = "클릭하면 지역을 선택할 수 있어요"
            self.archiveLocationTextField.isEnabled = true
            self.isArchiveLocationDateLaterButton = false
            //viewModel?.locationLaterButtonEnabled.accept(true)
        }else {
            self.archiveLocationLaterButton.setImage(Asset.Assets.check.image.withRenderingMode(.alwaysOriginal), for: .normal)
            self.archiveLocationLaterButton.setAttributedTitle(selectedString, for: .normal)
            self.archiveLocationTextField.text?.removeAll()
            self.archiveLocationTextField.placeholder = "토핑이 원하는 위치로"
            self.archiveLocationTextField.leftView = nil
            self.archiveLocationTextField.padding(value: 9)
            self.archiveLocationTextField.isEnabled = false
            self.isArchiveLocationDateLaterButton = true
            //viewModel?.locationLaterButtonEnabled.accept(false)
        }
        self.validation()
    }
    
    func tapDateTimeLaterButton() {
        let unSelectedAttributes = [ NSAttributedString.Key.foregroundColor: Asset.Colors.gray5.color, NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 15)]
        let unSelectedString = NSAttributedString(string: "나중에 정할게요", attributes: unSelectedAttributes)
        let selectedAttributes = [ NSAttributedString.Key.foregroundColor: Asset.Colors.black.color, NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 15)]
        let selectedString = NSAttributedString(string: "나중에 정할게요", attributes: selectedAttributes)
        
        if self.archiveTimeDateLaterButton.image(for: .normal) == Asset.Assets.check.image.withRenderingMode(.alwaysOriginal) { // selected
            self.archiveTimeDateLaterButton.setImage(Asset.Assets.unCheck.image.withRenderingMode(.alwaysOriginal), for: .normal)
            self.archiveTimeDateLaterButton.setAttributedTitle(unSelectedString, for: .normal)
            self.placeHolderText(defaultValue: true)
            self.archiveTimeTextField.isEnabled = true
            self.archiveDateTextField.isEnabled = true
            self.isArchiveTimeDateLaterButton = false
            //viewModel?.dateTimeLaterButtonEnabled.accept(true)
        }else {
            self.archiveTimeDateLaterButton.setImage(Asset.Assets.check.image.withRenderingMode(.alwaysOriginal), for: .normal)
            self.archiveTimeDateLaterButton.setAttributedTitle(selectedString, for: .normal)
            self.placeHolderText(defaultValue: false)
            self.archiveTimeTextField.text?.removeAll()
            self.archiveDateTextField.text?.removeAll()
            self.archiveTimeTextField.isEnabled = false
            self.archiveDateTextField.isEnabled = false
            self.isArchiveTimeDateLaterButton = true
            //viewModel?.dateTimeLaterButtonEnabled.accept(false)
        }
        self.validation()
    }
    

    
    
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        guard let detailArchive = viewModel.detailArchive else { return }
        
        archiveNameTextField.text = detailArchive.title
        if let dateString = detailArchive.date, let timeString = detailArchive.time {
            self.archiveDateTextField.text = dateString
            self.archiveTimeTextField.text = timeString.amPmChangeFormat()
            self.isArchiveTimeDateLaterButton = false
        }else {
            tapDateTimeLaterButton() // 나중에 선택하기 버튼 활성화
            self.isArchiveTimeDateLaterButton = true
        }
        if let location = detailArchive.place {
            self.archiveLocationTextField.addIconLeft(value: 9, icon: UIImage(named: "flagOrange")!, width: 15, height: 17)
            self.archiveLocationTextField.text = location
            self.isArchiveLocationDateLaterButton = false
        }else {
            tapLocationLaterButton()
            self.isArchiveLocationDateLaterButton = true
        }
        if let memo = detailArchive.memo {
            archiveMemoTextView.text = memo
            archiveMemoTextView.textColor = Asset.Colors.black.color
        }
        
        self.addArchiveButton.addTarget(self, action: #selector(didTapEditArchiveButton), for: .touchUpInside)
        bindViewsModel()
    }

    
    private func bindViewsModel() {
        let input = EditArchiveViewModel.Input(nameTextFieldDidTapEvent: self.archiveNameTextField.rx.controlEvent(.editingDidBegin), memoTextViewDidTapEvent: self.archiveMemoTextView.rx.didBeginEditing, nameTextFieldDidEndEvent: self.archiveNameTextField.rx.controlEvent(.editingDidEnd), memoTextViewDidEndEvent: self.archiveMemoTextView.rx.didEndEditing, nameTextFieldEditing: archiveNameTextField.rx.controlEvent(.editingChanged), memoTextViewEditing: self.archiveMemoTextView.rx.didChange, dateTimeLaterButton: self.archiveTimeDateLaterButton.rx.tap.asObservable(), locationTextFieldTapEvent: self.archiveLocationTextField.rx.controlEvent(.editingDidBegin), locationLaterButton: self.archiveLocationLaterButton.rx.tap.asObservable(), editArchiveButton: self.addArchiveButton.rx.tap.asObservable())

        let _ = viewModel?.transform(from: input, disposeBag: disposeBag)
        guard let viewModel = viewModel else {
            return
        }

//        editDataBinding()
        
//        output?.title
//            .bind(to: self.archiveNameTextField.rx.text)
//            .disposed(by: self.disposeBag)
//
//        output?.title
//            .subscribe(onNext: { text in
//                let restrictedStr = self.viewModel?.maxInputRestricted(length: 10, s: text)
//                self.archiveNameTextField.text = restrictedStr
//            }).disposed(by: disposeBag)
        
        input.nameTextFieldDidTapEvent
            .subscribe(onNext: { _ in
                self.archiveNameTextField.focusingBorder(color: Asset.Colors.orange.name)
            }).disposed(by: disposeBag)
        
        input.nameTextFieldDidEndEvent
            .subscribe(onNext: { _ in
                self.archiveNameTextField.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        input.nameTextFieldEditing
            .subscribe(onNext: { _ in
                let text = self.archiveNameTextField.text ?? ""
                let restrictedStr = self.viewModel?.maxInputRestricted(length: 10, s: text)
                self.archiveNameTextField.text = restrictedStr
                self.validation()
            }).disposed(by: disposeBag)
        
        input.dateTimeLaterButton
            .subscribe(onNext: { _ in
                self.tapDateTimeLaterButton()
            }).disposed(by: disposeBag)
        
        input.locationLaterButton
            .subscribe(onNext: { _ in
                self.tapLocationLaterButton()
            }).disposed(by: disposeBag)
        
        input.memoTextViewDidTapEvent
            .subscribe(onNext: { _ in
                guard let text = self.archiveMemoTextView.text else { return }
                if text == viewModel.defaultMemoText {
                    self.archiveMemoTextView.text = nil
                    self.archiveMemoTextView.textColor = Asset.Colors.black.color
                }
                
                self.archiveMemoTextView.focusingBorder(color: Asset.Colors.orange.name)
            }).disposed(by: disposeBag)
        
        input.memoTextViewDidEndEvent
            .subscribe(onNext: { _ in
                if self.archiveMemoTextView.text.isEmpty || self.archiveMemoTextView.text == nil {
                    self.archiveMemoTextView.textColor = Asset.Colors.gray4.color
                    self.archiveMemoTextView.text = viewModel.defaultMemoText
                }
                self.archiveMemoTextView.focusingBorder(color: Asset.Colors.gray2.name)
            }).disposed(by: disposeBag)
        
        input.memoTextViewEditing
            .subscribe(onNext: { _ in
                let size = CGSize(width: self.view.frame.width, height: .infinity)
                let estimatedSize = self.archiveMemoTextView.sizeThatFits(size)
                self.archiveMemoTextView.translatesAutoresizingMaskIntoConstraints = false
                self.archiveMemoTextView.constraints.forEach { (constraint) in
                    if estimatedSize.height >= 152 {
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
        
        
//        func editDataBinding() {
//            guard let viewModel = viewModel else {
//                return
//            }
//            if let date = viewModel.detailArchive?.date, let time = viewModel.detailArchive?.time {
//                self.archiveDateTextField.text = date
//                self.archiveTimeTextField.text = time.amPmChangeFormat()
//            }else {
//                tapDateTimeLaterButton()
//            }
//            self.archiveNameTextField.text = self.viewModel?.detailArchive?.title
//
//            if let memo = viewModel.detailArchive?.memo {
//                archiveMemoTextView.text = memo
//                archiveMemoTextView.textColor = Asset.Colors.black.color
//            }
//            if let place = viewModel.detailArchive?.place  {
//                self.archiveLocationTextField.text = place
//                self.archiveLocationTextField.addIconLeft(value: 9, icon: Asset.Assets.flagOrange.image, width: 15, height: 17)
//            }
//
//            self.addArchiveButton.setEnabled(color: Asset.Colors.black.name)
//            self.addArchiveButton.setTitle("편집 완료", for: .normal)
//        }
        
//        output?.doneButtonEnabled
//            .subscribe(onNext: { bool in
//                self.addArchiveButton.setEnabled(color: Asset.Colors.black.name)
//            }).disposed(by: disposeBag)
    
//        viewModel?.locationTextField
//            .subscribe(onNext: { [weak self] str in
//                guard let self = self else { return }
//                if str != nil {
//                    self.archiveLocationTextField.addIconLeft(value: 9, icon: UIImage(named: "flagOrange")!, width: 15, height: 17)
//                    self.archiveLocationTextField.text = str
//                }
//            }).disposed(by: disposeBag)
    }
    
    private func textViewScrollToBottom() {
        let bottomRange = NSMakeRange(self.archiveMemoTextView.text.count - 1, 1)

        self.archiveMemoTextView.scrollRangeToVisible(bottomRange)
    }
    
    @objc func dDonePressed(_ sender: UIDatePicker) {
        //viewModel?.datePickerDate.accept(datePicker.date)
        archiveDateTextField.text = datePicker.date.addArchiveDateToString()
        self.validation()
        view.endEditing(true)
    }
    
    @objc func tDonePressed(_ sender: UIDatePicker) {
        //viewModel?.timePickerTime.accept(timePicker.date)
        archiveTimeTextField.text = timePicker.date.addArhiveTimeToString()
        self.validation()
        view.endEditing(true)
    }
    
    @objc func cancelPressed(_ sender: UIDatePicker) {
        self.validation()
        view.endEditing(true)
    }
}
