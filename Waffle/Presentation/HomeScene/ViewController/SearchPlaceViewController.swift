//
//  SearchPlaceViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/03.
//

import UIKit
import SnapKit
import RxSwift

class SearchPlaceViewController: UIViewController {

    var viewModel: SearchPlaceViewModel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    let searchBar = UISearchBar()
    var isSearching: Bool = false
    let disposeBag = DisposeBag()
    
    var noSearchResultView: UIView = {
        let view = UIView()
        return view
    }()
    
    var noInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.black.color
        label.text = "검색 결과가 없습니다."
        label.font = UIFont.topPageTitleFont()
        return label
    }()
    
    var searchImageView: UIImageView = {
        let searchImage = Asset.Assets.searchEtc.image
        let imageView = UIImageView(image: searchImage)
        return imageView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableViewSetup()
        bindViewModel()
        resignForKeyboardNotification()
    }
    
    func resignForKeyboardNotification() {
        hideKeyboardWhenTappedAround()
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
        searchBar.becomeFirstResponder()
        selectButton.makeRounded(corner: 26)
        self.noSearchResultView.addSubview(searchImageView)
        self.noSearchResultView.addSubview(noInfoLabel)
        noInfoLabel.snp.makeConstraints {
            $0.centerX.equalTo(noSearchResultView)
            $0.top.equalTo(searchImageView.snp.bottom).offset(10)
        }
        searchImageView.snp.makeConstraints {
            $0.top.equalTo(170)
            $0.centerX.equalTo(noSearchResultView)
            $0.width.height.equalTo(50)
        }
        
        noSearchResultView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
        
        func setNavigationBar() {
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width //화면 너비
            searchBar.frame = CGRect(x: 0, y: 0, width: width - 40, height: 0)
            searchBar.placeholder = "장소 검색"
            navigationItem.titleView = searchBar
            let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
            navigationItem.leftBarButtonItem = backButton
        }
        setNavigationBar()
    }

    
    func tableViewSetup() {
        tableView.register(AddPlaceSearchTableViewCell.self, forCellReuseIdentifier: AddPlaceSearchTableViewCell.identifider)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func didTapBackButton() {
        viewModel?.back()
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        let input = SearchPlaceViewModel.Input(viewDidLoadEvent: Observable.just(()), selectedItem: self.tableView.rx.itemSelected.map { $0.row }, selectButton: selectButton.rx.tap.asObservable())
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        searchBar.rx.text.orEmpty
             .debounce(.microseconds(5), scheduler: MainScheduler.instance)
             .distinctUntilChanged()
             .subscribe(onNext: { searchText in
                 if searchText.isEmpty {
                     self.isSearching = false
                     viewModel.filteringPlace = []
                 }else {
                     self.isSearching = true
                     viewModel.filteringPlace = viewModel.place.filter{ $0.contains(searchText) }
                 }
                
                 self.tableView.reloadData()
             })
             .disposed(by: disposeBag)
    }
    
    
}

extension SearchPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let place = viewModel?.filteringPlace else {
            tableView.backgroundView  = noSearchResultView
            tableView.separatorStyle  = .none
            return 0
        }
        
        if isSearching == true && place.count == 0 { // 검색 중인데 데이터가 없을때
            tableView.backgroundView  = noSearchResultView
            tableView.separatorStyle  = .none
       }else {
           tableView.separatorStyle = .singleLine
           tableView.backgroundView = nil
        }
        
        return place.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddPlaceSearchTableViewCell.identifider) as! AddPlaceSearchTableViewCell
        cell.configureCell(title: "test", address: "test")
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(64)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectButton.setEnabled(color: Asset.Colors.black.name)
    }
}




