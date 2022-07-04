//
//  SettingViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SettingViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNickname: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var changePWButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    
    var viewModel: SettingViewModel?
    let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    private func configureUI() {
        profileImage.makeCircleShape()
        changePWButton.makeRounded(corner: 20)
        changePWButton.layer.borderColor = UIColor(named: Asset.Colors.gray5.name)?.cgColor
        changePWButton.layer.borderWidth = 1
        editButton.makeRounded(corner: 20)
        editButton.layer.borderColor = UIColor(named: Asset.Colors.gray5.name)?.cgColor
        editButton.layer.borderWidth = 1
        self.view.addSubview(self.tableView)
        
        quitButton.setAttributedTitle("탈퇴하기".underBarLine(), for: .normal)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(quitButton.snp.top).offset(-18)
            make.height.equalTo(290)
        }
    }
    
    private func bindViewModel() {
        let alertCell = settingOptions[0].cell
        let input = SettingViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in } , editButton: self.editButton.rx.tap.asObservable(), chagePWButton: self.changePWButton.rx.tap.asObservable(), setAlarmState: alertCell.switchControl.rx.controlEvent(.valueChanged), itemSelected: self.tableView.rx.itemSelected.asObservable(), quitButton: self.quitButton.rx.tap.asObservable())
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        
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


