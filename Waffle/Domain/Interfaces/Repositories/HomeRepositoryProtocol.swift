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
    //MARK: Archive
    func getCardInfo() -> Observable<GetCardResponse>
    func getDetailArchiveInfo(id: Int) -> Observable<GetDetailArchive>
    func deleteArchive(archiveId: Int) -> Observable<DefaultIntResponse>
    func getArchiveCode(id: Int) -> Observable<GetArchiveCode>
    
    //MARK: Category 추가, 삭제
    func addCategory(archiveId: Int, categoryName: [String]) -> Observable<AddCategoryResponse>
    func deleteCategory(archiveId: Int, categoryId: Int) -> Observable<DefaultIntResponse>
    
    //MARK: Place
    
    //MARK: Like
    
}
