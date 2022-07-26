//
//  SettingTableViewCell.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import UIKit
import SnapKit
import Combine
import RxSwift
import RxCocoa

protocol SettingTableViewCellDelegate: AnyObject {
    func didTapSwitch(isOn: Bool)
}

final class SettingTableViewCell: UITableViewCell {
    enum Style {
        case plain, detail, switchControl
    }
    
    static let identifier = "SettingTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Asset.Colors.black.name)
        label.text = "title"
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Asset.Colors.gray5.name)
        return label
    }()
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor(named: Asset.Colors.orange.name)
        switchControl.isOn = true
        return switchControl
    }()
    
    weak var delegate: SettingTableViewCellDelegate?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                self.titleLabel,
                self.detailLabel,
                self.switchControl
            ]
        )
        stackView.axis = .horizontal
        return stackView
    }()
    
    @Published var title: String?
    @Published var detailText: String?
    
    private var style: Style?
    private var cancellables: Set<AnyCancellable> = []
    
    convenience init(style: Style) {
        self.init()
        self.style = style
        self.configureUI()
        self.bindUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2.5, left: 0, bottom: 2.5, right: 0))
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
        switchControl.isOn = UserDefaults.standard.bool(forKey: UserDefaultKey.isOnAlarm)
        switchControl.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
        self.contentView.addSubview(stackView)
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.bottom.equalToSuperview().offset(-11)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-32)
        }

        switch self.style {
        case .plain:
            self.accessoryType = .disclosureIndicator
            self.detailLabel.isHidden = true
            self.switchControl.isHidden = true
        case .detail:
            self.detailLabel.isHidden = false
            self.switchControl.isHidden = true
        case .switchControl:
            self.detailLabel.isHidden = true
            self.switchControl.isHidden = false
        default: return
        }
    }
    
    @objc func didTapSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultKey.isOnAlarm)
        delegate?.didTapSwitch(isOn: sender.isOn)
    }


    private func bindUI() {
        self.$title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.titleLabel.text = title
            }
            .store(in: &self.cancellables)

        self.$detailText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detailText in
                self?.detailLabel.text = detailText
                self?.detailLabel.snp.updateConstraints { make in
                    make.width.equalTo(self?.detailLabel.intrinsicContentSize.width ?? 0)
                }
            }
            .store(in: &self.cancellables)

    }
    
    
}
