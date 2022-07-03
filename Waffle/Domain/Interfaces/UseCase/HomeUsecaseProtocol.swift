//
//  HomeUsecaseProtocol.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation

protocol HomeUsecaseProtocol {
    func getCardInfo()
    func deletePlace(placeId: Int)
    func editPlace(placeId: Int)
}
