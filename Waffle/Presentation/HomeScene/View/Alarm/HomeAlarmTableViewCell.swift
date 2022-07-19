//
//  HomeAlarmTableViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/09.
//

import UIKit

final class HomeAlarmTableViewCell: UITableViewCell {
    static let identifier = "HomeAlarmTableViewCell"
    
    @IBOutlet private weak var archiveImageView: UIImageView!
    @IBOutlet private weak var dotButton: UIButton!
    @IBOutlet private weak var alarmText: UILabel!
    @IBOutlet private weak var dateText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    private func setUp() {
        dotButton.tintColor = Asset.Colors.red.color
        archiveImageView.makeCircleShape()
    }
    
    func configureCell(alarm: Alarm) {
        let alarmType = AlarmType(rawValue: alarm.pushType)
        var alarmString = ""
        switch alarmType {
            case .likes:
                alarmString = "\(alarm.nickName)님이 좋아요 조르기를 시전! \(alarm.archiveTitle)을 위해 가고 싶은 장소에 좋아요를 눌러주세요. ❤️👇"
            case .join:
                alarmString = "\(alarm.archiveTitle)에 \(alarm.nickName)님이 참여했어요."
            case .notDecided:
                alarmString = "\(alarm.archiveTitle) 약속의 만나는 날짜 또는 위치가 아직 정해지지 않았네요. 어서 정해봐요. 🤗"
            case .beforeDay:
                alarmString = "\(alarm.nickName)! 24시간 뒤 \(alarm.archiveTitle) 잊지 않았죠? 😝"
            case .none:
                alarmString = ""
        }
        let wappleIndex = WappleType.init(rawValue: alarm.placeImage)?.wappleIndex() ?? 0
        archiveImageView.image = UIImage(named: "detailWapple-\(wappleIndex)")
        alarmText.text = alarmString
        alarmText.asColor(targetList: [alarm.nickName, alarm.archiveTitle], color: Asset.Colors.orange.color)
    }
}
