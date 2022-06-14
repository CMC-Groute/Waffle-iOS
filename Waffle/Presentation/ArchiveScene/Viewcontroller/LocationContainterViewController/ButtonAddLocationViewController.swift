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
    var selectedLeftIndex:Int? = nil
    
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
            guard let index = selectedLeftIndex else {
                return location[0].1.count // 첫번째 지역으로 기본 셋팅
            }
        
            return location[index].1.count
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
            let rightSelectedView = UIView()
            rightSelectedView.backgroundColor = Asset.Colors.orange.color
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationRightTableViewCell.identifier) as! LocationRightTableViewCell
            cell.selectedBackgroundView = rightSelectedView
            guard let index = selectedLeftIndex else {
                cell.label.text = location[0].1[indexPath.row]
                return cell
            }
            cell.label.text = location[index].1[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(45)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == leftTablewView {
            self.selectedLeftIndex = indexPath.row
            self.rightTablewView.reloadData()
//            print("click cell \(indexPath)")
//            for i in 0..<location.count {
//                print(location.count)
//                if indexPath.row == i { continue }
//                let deselected: IndexPath = [0, i]
//                print("de selected row \(deselected)")
//                let deselectedCell = tableView.cellForRow(at: deselected) as! LocationLeftTableviewCell
//                deselectedCell.selected(isSelected: false)
//            }
        }else {
        
        }
       

        //새로 선택 셀 선택
        //cell.selected(isSelected: true)
    }
    
    
}
