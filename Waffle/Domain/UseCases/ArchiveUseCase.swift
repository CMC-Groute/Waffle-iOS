//
//  ArchiveUseCase.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import RxSwift
import RxCocoa

class ArchiveUseCase: ArchiveUseCaseProtocol {
    
    var repository: ArchiveRepository!
    
    init(repository: ArchiveRepository){
        self.repository = repository
    }
    
    func maximumTextLength(length: Int, s: String) -> String {
        print(s)
        if s.count > length {
            let index = s.index(s.startIndex, offsetBy: length)
            return String(s[..<index])
        }
        return s
    }
    
}
