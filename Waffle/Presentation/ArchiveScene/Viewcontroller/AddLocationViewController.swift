//
//  AddLocationViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit

class AddLocationViewController: UIViewController {
    @IBOutlet weak var doneButton: UIButton!
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var tableView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.tableView.isHidden = true
        self.buttonView.isHidden = false

    }
    
    private func configureUI() {
        self.doneButton.round(corner: 25)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }


}

extension AddLocationViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let childTableViewController = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "TableAddLocationViewController") as! TableAddLocationViewController
        addChild(childTableViewController)
        tableView.addSubview(childTableViewController.view)
        childTableViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(tableView)
        }
        self.buttonView.isHidden = true
        self.tableView.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
    
    
}



