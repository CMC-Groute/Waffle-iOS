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
    
    var frameView: UIView = {
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
        let searchImage = UIImage(named: "searchEtc")
        let imageView = UIImageView(image: searchImage)
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        locationDataSetUp()
        configureUI()
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
    
    func configureUI() {
        self.frameView.addSubview(searchImageView)
        self.frameView.addSubview(noInfoLabel)
        noInfoLabel.snp.makeConstraints {
            $0.centerX.equalTo(frameView)
            $0.top.equalTo(searchImageView.snp.bottom).offset(10)
        }
        searchImageView.snp.makeConstraints {
            $0.top.equalTo(170)
            $0.centerX.equalTo(frameView)
            $0.width.height.equalTo(50)
        }
        
        frameView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
        
    }
}

extension TableAddLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locationList.count > 0 {
           tableView.separatorStyle = .singleLine
           tableView.backgroundView = nil
       }else {
           tableView.backgroundView  = frameView
           tableView.separatorStyle  = .none
        }
        
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
