//
//  ButtonAddLocationViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/14.
//

import UIKit

class ButtonAddLocationViewController: UIViewController {
    @IBOutlet weak var leftTablewView: UITableView!
    @IBOutlet weak var rightTablewView: UITableView!
    let location = Location.locationDictionary

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        tableViewSetup()
    }
    
    func tableViewSetup() {
        leftTablewView.delegate = self
        leftTablewView.dataSource = self
        rightTablewView.delegate = self
        rightTablewView.dataSource = self
        
        leftTablewView.register(LocationLeftTableviewCell.self, forCellReuseIdentifier: LocationLeftTableviewCell.identifier)
        rightTablewView.register(LocationRightTableViewCell.self, forCellReuseIdentifier: LocationRightTableViewCell.identifier)
    }
}

extension ButtonAddLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTablewView {
            return location.count
        }else {
            return location[0].count // 첫번째 지역으로 기본 셋팅
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTablewView {
            let cell =
        }else {
            
        }
    }
}
