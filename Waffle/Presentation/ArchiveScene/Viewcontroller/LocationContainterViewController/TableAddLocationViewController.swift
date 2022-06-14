//
//  TableAddLocationViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/14.
//

import UIKit

class TableAddLocationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TableAddLocationViewController view did load")
        tableViewSetup()
        // Do any additional setup after loading the view.
    }
    
    
    func tableViewSetup(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension TableAddLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var content = cell.defaultContentConfiguration()
        content.text = "WWDC"
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(45)
    }
}
