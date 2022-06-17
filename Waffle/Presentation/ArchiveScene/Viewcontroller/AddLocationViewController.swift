//
//  AddLocationViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import RxSwift
import RxCocoa


class AddLocationViewController: UIViewController {
    @IBOutlet weak var doneButton: UIButton!
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var tableView: UIView!
    
    var buttonLocationVC: ButtonAddLocationViewController?
    var tableLocationVC: TableAddLocationViewController?
    var disposeBag = DisposeBag()
    var selectedText: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.tableView.isHidden = true
        self.buttonView.isHidden = false
        
        bindUI()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ButtonAddLocationViewController" {
            buttonLocationVC = segue.destination as? ButtonAddLocationViewController
        }else {
            tableLocationVC = segue.destination as? TableAddLocationViewController
        }
    }
    
    private func configureUI() {
        self.doneButton.round(corner: 25)
        self.doneButton.setUnEnabled(color: Asset.Colors.gray4.name)
        func setNavigationBar() {
            var bounds = UIScreen.main.bounds
            var width = bounds.size.width //화면 너비
            //searchController.searchBar.frame = CGRect(x: 0, y: 0, width: width - 28, height: 0)
            let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
            searchBar.placeholder = "지역 검색"
            searchBar.delegate = self
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
//            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//            backButton.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: -1000), for: .default)
//            navigationItem.backBarButtonItem = backButton
            
        }
        setNavigationBar()
        
    }
    
    
    func bindUI() {
        self.doneButton
            .rx.tap.subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
                if let vc = self.navigationController?.topViewController as? AddArchiveViewController {
                    vc.viewModel?.locationTextField.accept(self.selectedText)
                }
            }).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }


}

extension AddLocationViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let tableListVC = tableLocationVC else { return }
        self.selectedText = "" //초기화
        tableListVC.locationList = []
        tableListVC.isSearching = false
        self.doneButton.setUnEnabled(color: Asset.Colors.gray4.name)
        self.buttonView.isHidden = true
        self.tableView.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let tableListVC = tableLocationVC else { return }
        tableListVC.locationDataSetUp()
        tableListVC.isSearching = true
        tableListVC.locationList = tableListVC.locationList.filter { $0.contains(searchText) }
        if searchText == "" {
            tableListVC.locationList = []
            tableListVC.isSearching = false
        }
        self.tableLocationVC?.tableView.reloadData()
        
    }
    
    
}



