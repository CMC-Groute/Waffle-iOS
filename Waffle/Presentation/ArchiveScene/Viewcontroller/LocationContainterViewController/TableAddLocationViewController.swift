//
//  TableAddLocationViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/14.
//

import UIKit

class TableAddLocationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let location = Location.locationDictionary
    var locationList: [String] = []
    var originList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        locationDataSetUp()
    }
    
    
    func tableViewSetup(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func locationDataSetUp(){
        for i in location {
            let sido = i.0
            for j in i.1 {
                let sigungu = j
                self.locationList.append("\(sido) \(sigungu)")
            }
        }
        originList = locationList
    }

}

extension TableAddLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var content = cell.defaultContentConfiguration()
        content.text = locationList[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(45)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let addLocationVC = self.parent as? AddLocationViewController {
            addLocationVC.doneButton.setEnabled(color: Asset.Colors.black.name)
            addLocationVC.selectedText = locationList[indexPath.row]
        }
    }
}
