//
//  SettingCoordinatorProtocol.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/12.
//

import Foundation

protocol SettingCoordinatorProtocol: Coordinator {
    func editProfile(nickName: String, selectedIndex: Int)
    func changePassword()
    func logout()
    func quit()
}
