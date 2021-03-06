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
    var selectedLeftIndex:Int = 0 // default setting
    var selectedLocation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
    }
    
    func tableViewSetup() {
        leftTablewView.delegate = self
        leftTablewView.dataSource = self
        rightTablewView.delegate = self
        rightTablewView.dataSource = self
        
        leftTablewView.register(LocationLeftTableviewCell.self, forCellReuseIdentifier: LocationLeftTableviewCell.identifier)
        rightTablewView.register(LocationRightTableViewCell.self, forCellReuseIdentifier: LocationRightTableViewCell.identifier)
        rightTablewView.separatorStyle = .none
        leftTablewView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ButtonAddLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTablewView {
            return location.count
        }else {
            return location[selectedLeftIndex].1.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTablewView {
//            let leftSelectedView = UIView()
//            leftSelectedView.backgroundColor = Asset.Colors.yellow.color
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationLeftTableviewCell.identifier) as! LocationLeftTableviewCell
            cell.label.text = location[indexPath.row].0
//            cell.selectedBackgroundView = leftSelectedView
            return cell
        }else {
//            let rightSelectedView = UIView()
//            rightSelectedView.backgroundColor = Asset.Colors.orange.color
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationRightTableViewCell.identifier) as! LocationRightTableViewCell
//            cell.backgroundView = rightSelectedView
//            cell.selectedBackgroundView = rightSelectedView

            cell.label.text = location[selectedLeftIndex].1[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(45)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == leftTablewView {
            self.selectedLeftIndex = indexPath.row

            if let addLocationVC = self.parent as? AddLocationViewController {
                addLocationVC.doneButton.setUnEnabled(color: Asset.Colors.gray4.name)
            }
            self.rightTablewView.reloadData()
        }else { // rightView
            if let addLocationVC = self.parent as? AddLocationViewController {
                addLocationVC.doneButton.setEnabled(color: Asset.Colors.black.name)
                addLocationVC.selectedText = "\(location[selectedLeftIndex].0) \(location[selectedLeftIndex].1[indexPath.row])"
                
                
            }

        }

    }
    
    
}
