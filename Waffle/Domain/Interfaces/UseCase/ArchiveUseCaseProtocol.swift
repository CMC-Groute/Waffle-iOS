//
//  ArchiveUseCaseProtocol.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation

protocol ArchiveUseCaseProtocol {
    func maximumTextLength(length: Int, s: String) -> String
    func checkCodeValid(code: String) -> Bool
}
