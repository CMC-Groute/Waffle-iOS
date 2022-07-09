//
//  HomeAlarmTableViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/09.
//

import UIKit

class HomeAlarmTableViewCell: UITableViewCell {
    static let identifier = "HomeAlarmTableViewCell"
    
    @IBOutlet weak var alrchiveImageView: UIImageView!
    
    @IBOutlet weak var alarmText: UILabel!
    
    @IBOutlet weak var dateText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    private func setUp() {
        alrchiveImageView.makeCircleShape()
    }
    
    func configureCell(test: String) {
        print("here \(test)")
        alarmText.text = test
    }
}
