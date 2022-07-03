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
    }
    
    func configureUI() {
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
            let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 40, height: 0))
            searchBar.placeholder = "장소 검색"
            searchBar.delegate = self
            navigationItem.titleView = searchBar
            let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
            navigationItem.leftBarButtonItem = backButton
        }
        setNavigationBar()
    }

    
    func tableViewSetup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func didTapBackButton() {
        viewModel?.back()
    }
    
    private func bindViewModel() {
        let input = SearchPlaceViewModel.Input(viewDidLoadEvent: Observable.just(()), selectedItem: self.tableView.rx.itemSelected.map { $0.row }, selectButton: selectButton.rx.tap.asObservable())
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
    }
    
    
}

extension SearchPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let place = viewModel?.place else {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            guard let place = viewModel?.place else { return cell }
            content.text = place[indexPath.row]
            cell.contentConfiguration = content
        } else {
            // Fallback on earlier versions
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(45)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectButton.setEnabled(color: Asset.Colors.black.name)
    }
}

extension SearchPlaceViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    
}




