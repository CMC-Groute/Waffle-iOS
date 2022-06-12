//
//  SettingViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import UIKit
import Combine

class SettingViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNickname: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var changePWButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 42, height: 20))
        var version: String? {
            guard let dictionary = Bundle.main.infoDictionary, let version = dictionary["CFBundleShortVersionString"] as? String else { return ""}
            return version
        }
        label.text = version
        return label
    }()

    struct SettingOptions {
        let cell: SettingTableViewCell
        let handler: (() -> Void)?
    }
    
    private lazy var settingOptions: [SettingOptions] = {
        let alertCell = SettingTableViewCell(style: .switchControl)
        alertCell.title = "알림 설정"
        let alertOption = SettingOptions(cell: alertCell, handler: nil)

        let versionCell = SettingTableViewCell(style: .detail)
        versionCell.title = "앱버전"
        versionCell.detailText = versionLabel.text
        let appVersionOption = SettingOptions(cell: versionCell, handler: nil)
        
        let contributorCell = SettingTableViewCell(style: .detail)
        contributorCell.title = "개발자 정보"
        contributorCell.detailText = "gnelesh@gmail.com"
        let contributorsOption = SettingOptions(cell: contributorCell, handler: nil)
        
        let feedbackCell = SettingTableViewCell(style: .plain)
        feedbackCell.title = "피드백 남기기"
        let feedbackOption = SettingOptions(cell: feedbackCell, handler: nil)

        let privacyCell = SettingTableViewCell(style: .plain)
        privacyCell.title = "개인 정보 처리 방침"
        let privacyOption = SettingOptions(cell: privacyCell, handler: nil)
        
        let logoutCell = SettingTableViewCell(style: .plain)
        logoutCell.title = "로그아웃"
        let logoutOption = SettingOptions(cell: logoutCell, handler: nil)

        let options: [SettingOptions] = [alertOption, appVersionOption, contributorsOption, feedbackOption, privacyOption, logoutOption]
        return options
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    private func configureUI() {
        profileImage.makeCircleShape()
        changePWButton.round(corner: 25)
        changePWButton.layer.borderColor = UIColor(named: Asset.Colors.gray5.name)?.cgColor
        changePWButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor(named: Asset.Colors.gray5.name)?.cgColor
        editButton.layer.borderWidth = 1
        editButton.round(corner: 25)
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp_bottomMargin).offset(9)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(quitButton).offset(9)
        }
    }
    
    private func bindViewModel() {
        
    }
    
    
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let handler = settingOptions[indexPath.row].handler else { return }
        handler()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(48)
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingOptions[indexPath.row].cell
        cell.selectionStyle = .none
        return cell
    }
    
    
}


