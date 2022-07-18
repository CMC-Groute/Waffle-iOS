//
//  EditPlaceViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import UIKit
import RxSwift

class EditPlaceViewController: UIViewController {
    var viewModel: EditPlaceViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var linkDeleteButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    lazy var placeFramView: UIView = {
        let view = UIView()
        view.makeRounded(width: 1, color: Asset.Colors.gray2.name, value: 10)
        view.backgroundColor = Asset.Colors.white.color
        return view
    }()
    
    lazy var placeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.black.color
        label.text = "placeTitleLabel"
        label.font = UIFont.fontWithName(type: .medium, size: 17)
        return label
    }()
    
    lazy var placeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.gray5.color
        label.text = "placeTiplaceSubtitleLabeltleLabel"
        label.font = UIFont.fontWithName(type: .regular, size: 13)
        return label
    }()
    
    lazy var placeDeleteButton: UIButton = {
        let button = UIButton()
        let image = Asset.Assets.delete.image.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "클릭하면 장소를 검색할 수 있어요"
        textField.font = UIFont.fontWithName(type: .regular, size: 15)
        textField.backgroundColor = Asset.Colors.gray2.color
        textField.makeRounded(corner: 10)
        textField.changePlaceHolderColor()
        textField.padding(value: 9)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureUI() {
        linkDeleteButton.isHidden = true
        editButton.makeRounded(corner: 26)
        linkTextView.makeRounded(width: nil, color: nil, value: 10)
        linkTextView.isEditable = false
        linkTextView.isSelectable = true
        linkTextView.delegate = self
        linkTextView.isUserInteractionEnabled = true
        linkTextView.textContainerInset = UIEdgeInsets(top: 15, left: 14, bottom: 15, right: 48)
        
        
        memoTextView.makeRounded(width: 2, color: Asset.Colors.gray2.name, value: 10)
        memoTextView.dataDetectorTypes = .link
        memoTextView.attributedText = memoTextView.text.setLineHeight(24)
        memoTextView.textContainerInset = UIEdgeInsets(top: 16, left: 14, bottom: 16, right: 14)
        configureNavigationBar()
        configureCollectionView()
        configureGesture()
    }
    
    @objc func didTapBackButton() {
        viewModel?.back()
    }
    
    @objc func didTapTrashButton() {
        viewModel?.deletePlace()
    }
    
    func configureNavigationBar() {
        let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
        navigationItem.title = "장소 수정하기"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Asset.Assets.trash.name)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapTrashButton))
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    
    private func configureGesture() {
        let tapTextViewGesture = UITapGestureRecognizer(target: self, action: #selector(textViewDidTapped))
        linkTextView.addGestureRecognizer(tapTextViewGesture)
    }
    
    private func textViewScrollToBottom() {
        let bottomRange = NSMakeRange(self.memoTextView.text.count - 1, 1)
        self.memoTextView.scrollRangeToVisible(bottomRange)
    }
    
    private func placeAddLayout() {
        placeTextField.removeFromSuperview()
        
        view.addSubview(placeFramView)
        placeFramView.addSubview(placeTitleLabel)
        placeFramView.addSubview(placeSubtitleLabel)
        placeFramView.addSubview(placeDeleteButton)
        
        placeFramView.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(11)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(linkLabel.snp.top).offset(-32)
            $0.height.equalTo(86)
        }
        
        placeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalToSuperview().offset(14)
        }
        
        placeSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(placeTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-23)
        }
        
        placeDeleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.bottom.equalToSuperview().offset(-23)
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.height.equalTo(40)
        }
        
    }
    
    private func placeInputTextFieldLayout() {
        for subView in placeFramView.subviews {
            subView.removeFromSuperview()
        }
        view.addSubview(placeTextField)
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(11)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(linkLabel.snp.top).offset(-32)
            $0.height.equalTo(50)
        }
        placeFramView.removeFromSuperview()
    }
    
    private func bindViewModel() { //rx 없이 연결
        guard let viewModel = viewModel, let place = viewModel.place else {
            return
        }

        placeTitleLabel.text = place.title
        placeSubtitleLabel.text = place.roadNameAddress
        if let link = viewModel.detailPlace?.link {
            linkTextView.text = link
        }else { //placeHolder
            originLinkText()
        }
        
        if let memo = viewModel.detailPlace?.memo {
            memoTextView.text = memo
            memoTextView.textColor = Asset.Colors.black.color
        }
        
        
        bindViewModels()
        
    }
    
    private func bindViewModels() {
        let input = EditPlaceViewModel.Input(linkTextViewDidTapEvent: self.linkTextView.rx.didBeginEditing, linkTextViewDidEndEvent: self.linkTextView.rx.didEndEditing)
        
        input.linkTextViewDidTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let text = self.linkTextView.text else { return }
                if text == "장소와 관련된 링크 주소를 입력해요" {
                    self.linkTextView.text = nil
                }
                self.linkTextView.textColor = Asset.Colors.black.color
                self.linkTextView.focusingBorder(color: Asset.Colors.orange.name)
            }).disposed(by: disposeBag)
        
        input.linkTextViewDidEndEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                WappleLog.debug("linkTextViewDidEndEvent")
                if self.linkTextView.text.isEmpty || self.linkTextView.text == nil {
                    self.originLinkText()
                }else { //비어있지 않을때
                    self.linkTextView.isEditable = false
                    self.linkTextView.dataDetectorTypes = []
                    guard let text = self.linkTextView.text else { return }
                    WappleLog.debug(text)
                    let myAttribute = [NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 15),  NSAttributedString.Key.foregroundColor: Asset.Colors.blue.color ]
                    let attributedString = NSMutableAttributedString(string: text, attributes: myAttribute)
                    attributedString.linked(text: text, url: text)
                    self.linkTextView.attributedText = attributedString
                    self.linkTextView.resignFirstResponder()
                    self.linkDeleteButton.isHidden = true
                }
                self.linkTextView.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        linkDeleteButton.rx.tap
            .subscribe(onNext: {
                WappleLog.debug("linkDeleteButton")
                self.originLinkText()
                self.linkTextView.focusingBorder(color: nil)
            }).disposed(by: disposeBag)
        
        output?.placeViewEnabled
            .subscribe(onNext: { bool in
                if bool {
                    self.placeAddLayout()
                }else {
                    self.placeInputTextFieldLayout()
                }
            }).disposed(by: disposeBag)
    }
    
    func originLinkText() {
        let myAttribute = [NSAttributedString.Key.font: UIFont.fontWithName(type: .regular, size: 15),  NSAttributedString.Key.foregroundColor: Asset.Colors.gray4.color ]
        let attributedString = NSMutableAttributedString(string: "장소와 관련된 링크 주소를 입력해요", attributes: myAttribute)
        linkTextView.attributedText = attributedString
        linkTextView.dataDetectorTypes = []
        
    }

}

extension EditPlaceViewController: UICollectionViewDelegate {
    
}

extension EditPlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let category = viewModel?.categoryInfo else { return 0 }
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        guard let categoryName = viewModel?.categoryInfo else { return cell }
        if indexPath.row == viewModel?.selectedCategoryIndex {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
        }
        cell.configureCell(name: categoryName[indexPath.row].name, isEditing: false)
        return cell
        
    }
}

extension EditPlaceViewController: UITextViewDelegate {
    
    fileprivate func placeCursor(_ textView: UITextView, _ location: CGPoint) {
       // place the cursor on tap position
       if let tapPosition = textView.closestPosition(to: location) {
           let uiTextRange = textView.textRange(from: tapPosition, to: tapPosition)
           
           if let start = uiTextRange?.start, let end = uiTextRange?.end {
               let loc = textView.offset(from: textView.beginningOfDocument, to: tapPosition)
               let length = textView.offset(from: start, to: end)
               textView.selectedRange = NSMakeRange(loc, length)
           }
       }
    }
    
    fileprivate func changeTextViewToNormalState() {
        WappleLog.debug("changeTextViewToNormalState")
        linkTextView.isEditable = true
        linkTextView.textColor = Asset.Colors.black.color
        linkTextView.becomeFirstResponder()
    }
    
    @objc func textViewDidTapped(recognizer: UITapGestureRecognizer) {
       guard let myTextView = recognizer.view as? UITextView else { return }
       let layoutManager = myTextView.layoutManager
       var location = recognizer.location(in: myTextView)
       location.x -= myTextView.textContainerInset.left
       location.y -= myTextView.textContainerInset.top

       let glyphIndex: Int = myTextView.layoutManager.glyphIndex(for: location, in: myTextView.textContainer, fractionOfDistanceThroughGlyph: nil)
       let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1), in: myTextView.textContainer)
       
       if glyphRect.contains(location) {
           let characterIndex: Int = layoutManager.characterIndexForGlyph(at: glyphIndex)
           let attributeName = NSAttributedString.Key.link
           let attributeValue = myTextView.textStorage.attribute(attributeName, at: characterIndex, effectiveRange: nil)
           if let url = attributeValue as? URL {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                   print("There is a problem in your link.")
               }
           } else {
               placeCursor(myTextView, location)
               changeTextViewToNormalState()
           }
       } else {
           changeTextViewToNormalState()
       }
    }

    func textViewDidChange(_ textView: UITextView) {
        linkDeleteButton.isHidden = false
    }
}

extension EditPlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryLabel.text = viewModel!.categoryInfo[indexPath.row].name
        cell.categoryLabel.sizeToFit()
        let cellWidth = cell.categoryLabel.frame.width + 34
        return CGSize(width: cellWidth, height: 33)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}
