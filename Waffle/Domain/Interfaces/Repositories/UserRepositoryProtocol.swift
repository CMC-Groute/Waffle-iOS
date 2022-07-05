//
//  UserRepositoryProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserRepositoryProtocol {
    //MARK: FROM
    func editProfile(profile: EditProfile)
    func updatePassword(password: Password) -> Observable<UpdatePasswordResponse>
    
    func getProfileInfo() -> Observable<ProfileInfo>
    func setAlarm(state: Bool)
                                                        
                                                            
}
