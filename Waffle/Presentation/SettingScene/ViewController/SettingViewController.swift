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
import MessageUI

final class SettingViewController: UIViewController {
    struct SettingInfo {
        static var wappleOfficialEamil = "wapple2app@gmail.com"
        static var privacyPolicyAgreeLink = "https://imminent-tuna-9bf.notion.site/8b426b79f055403ca2dad4fe493f84a4"
        static var versionKey = "CFBundleShortVersionString"
    }
    @IBOutlet private weak var profileView: UIView!
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var profileNickname: UILabel!
    @IBOutlet private weak var profileEmail: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var changePWButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: SettingViewModel?
    private var disposeBag = DisposeBag()
    private var wappleOfficialEamil = "wapple2app@gmail.com"
    
    lazy var versionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 42, height: 20))
        var version: String? {
            guard let dictionary = Bundle.main.infoDictionary, let version = dictionary[SettingInfo.versionKey] as? String else { return ""}
            return version
        }
        label.text = version
        return label
    }()
    
    lazy var quitButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Asset.Colors.gray6.color, for: .normal)
        button.titleLabel?.font = UIFont.fontWithName(type: .medium, size: 13)
        button.setAttributedTitle("탈퇴하기".underBarLine(color: Asset.Colors.black.color), for: .normal)
        return button
    }()

    struct SettingOptions {
        let cell: SettingTableViewCell
    }
    
    private lazy var settingOptions: [SettingOptions] = {
        let alertCell = SettingTableViewCell(style: .switchControl)
        alertCell.title = "알림 설정"
        alertCell.delegate = self
        let alertOption = SettingOptions(cell: alertCell)

        let versionCell = SettingTableViewCell(style: .detail)
        versionCell.title = "앱버전"
        versionCell.detailText = versionLabel.text
        let appVersionOption = SettingOptions(cell: versionCell)
        
        let contributorCell = SettingTableViewCell(style: .detail)
        contributorCell.title = "개발자 정보"
        contributorCell.detailText = wappleOfficialEamil
        let contributorsOption = SettingOptions(cell: contributorCell)
        
        let feedbackCell = SettingTableViewCell(style: .plain)
        feedbackCell.title = "피드백 남기기"
        
        let feedbackOption = SettingOptions(cell: feedbackCell)

        let privacyCell = SettingTableViewCell(style: .plain)
        privacyCell.title = "개인 정보 처리 방침"
        let privacyOption = SettingOptions(cell: privacyCell)
        
        let logoutCell = SettingTableViewCell(style: .plain)
        logoutCell.title = "로그아웃"
        let logoutOption = SettingOptions(cell: logoutCell)

        let options: [SettingOptions] = [alertOption, appVersionOption, contributorsOption, feedbackOption, privacyOption, logoutOption]
        return options
    }()
    
    private func openFeedbackMail() {
        guard let mailtoString = "mailto:\(wappleOfficialEamil)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        if let mailtoUrl = URL(string: mailtoString) {
            if UIApplication.shared.canOpenURL(mailtoUrl) {
                    UIApplication.shared.open(mailtoUrl, options: [:])
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    private func configure() {
        configureUI()
        configureTableView()
    }
    
    private func configureUI() {
        profileImage.makeCircleShape()
        changePWButton.makeRounded(corner: 20)
        changePWButton.layer.borderColor = UIColor(named: Asset.Colors.gray5.name)?.cgColor
        changePWButton.layer.borderWidth = 1
        editButton.makeRounded(corner: 20)
        editButton.layer.borderColor = UIColor(named: Asset.Colors.gray5.name)?.cgColor
        editButton.layer.borderWidth = 1
    }
    
    private func configureTableView() {
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        addQuitView()
        
        func addQuitView() {
            let quitView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 48))
            quitView.addSubview(quitButton)
            quitButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(24)
                $0.top.equalToSuperview().offset(14)
                $0.centerY.equalToSuperview()
            }
            
            tableView.tableFooterView = quitView
        }
    }
    
    private func bindViewModel() {
        let alertCell = settingOptions[0].cell
        let input = SettingViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in } , editButton: self.editButton.rx.tap.asObservable(), chagePWButton: self.changePWButton.rx.tap.asObservable(), setAlarmState: alertCell.switchControl.rx.controlEvent(.valueChanged), itemSelected: self.tableView.rx.itemSelected.asObservable(), quitButton: self.quitButton.rx.tap.asObservable())
        
        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        
        output?.userImage
            .subscribe(onNext: { imageName in
                let index = WappleType.init(rawValue: imageName)?.wappleIndex() ?? 0
                self.profileImage.image = UIImage(named: "wapple-\(index)") ?? nil
            }).disposed(by: disposeBag)
        
        output?.userNickName
            .bind(to: profileNickname.rx.text)
            .disposed(by: disposeBag)
        
        output?.userEmail
            .bind(to: profileEmail.rx.text)
            .disposed(by: disposeBag)
    }

    
    
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 {
            openFeedbackMail()
        }else if indexPath.row == 4 { //이용 약관 동의
            if let url = URL(string: SettingInfo.privacyPolicyAgreeLink) {
                UIApplication.shared.open(url)
            }
        }
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

extension SettingViewController: SettingTableViewCellDelegate {
    func didTapSwitch(isOn: Bool) {
        viewModel?.setAlarm(isOn: isOn)
    }
    
    
}


