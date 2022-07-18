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
    func updateUserInfo(nickName: String, image: String) -> Observable<DefaultIntResponse>
    func updatePassword(password: Password) -> Observable<DefaultIntResponse>
    
    func getProfileInfo() -> Observable<UserInfoResponse>
    func setAlarm(state: Bool) -> Observable<DefaultIntResponse> 
    func quitUser() -> Observable<DefaultIntResponse>
                                    
                                                            
}
