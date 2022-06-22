//
//  HomeRepositoryProtocol.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomeRepositoryProtocol {
    func getCardInfo() -> Observable<[CardInfo]>
}