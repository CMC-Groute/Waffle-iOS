//
//  SettingCoordinatorProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

protocol SettingCoordinatorProtocol: Coordinator {
    func editProfile()
    func changePassword()
    func logout()
    func quit()
}
