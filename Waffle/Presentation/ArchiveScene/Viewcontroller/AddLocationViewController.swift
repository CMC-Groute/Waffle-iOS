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
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    var buttonLocationVC: ButtonAddLocationViewController?
    var tableLocationVC: TableAddLocationViewController?
    var disposeBag = DisposeBag()
    var selectedText: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resignForKeyboardNotification()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.tableView.isHidden = true
        self.buttonView.isHidden = false
        bindUI()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ButtonAddLocationViewController" {
            buttonLocationVC = segue.destination as? ButtonAddLocationViewController
        }else {
            tableLocationVC = segue.destination as? TableAddLocationViewController
        }
    }
    
    private func configureUI() {
        self.doneButton.makeRounded(corner: 26)
        self.doneButton.setUnEnabled(color: Asset.Colors.gray4.name)
        func setNavigationBar() {
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width //화면 너비
            let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 40, height: 0))
            searchBar.placeholder = "지역 검색"
            searchBar.delegate = self
            navigationItem.titleView = searchBar
            let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
            navigationItem.leftBarButtonItem = backButton
        }
        setNavigationBar()
        
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func bindUI() {
        self.doneButton
            .rx.tap.subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
                if let addVC = self.navigationController?.topViewController as? AddArchiveViewController {
                    addVC.viewModel?.locationTextField.accept(self.selectedText)
                }else if let editVC = self.navigationController?.topViewController as? EditArchiveViewController {
                    editVC.archiveLocationTextField.addIconLeft(value: 9, icon: UIImage(named: "flagOrange")!, width: 15, height: 17)
                    editVC.archiveLocationTextField.text = self.selectedText
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



