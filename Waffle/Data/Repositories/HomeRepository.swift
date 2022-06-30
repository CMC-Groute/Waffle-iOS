//
//  HomeRepository.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation
import RxSwift

class HomeRepository: HomeRepositoryProtocol {
    let urlSessionNetworkService: URLSessionNetworkServiceProtocol
    var disposBag = DisposeBag()
    
    init(networkService: URLSessionNetworkServiceProtocol) {
        self.urlSessionNetworkService = networkService
    }
    
    func getCardInfo() -> Observable<[CardInfo]> {
        let dummy = [CardInfo(title: "와플이랑 데이트", date: "2022-01-23T22:14:22", place: "창원 마산 합포구", memo: "오늘 그동안 모은 돈으로 오마카세를 먹는 날!!! 다들 지금까지 너무 고생많고 우리 신나게 한번 먹어보자구", wapple: "기해", topping: ["원", "메이", "우리", "채원", "원", "메이", "우리", "채원", "원", "메이", "우리", "채원"], color: 0), CardInfo(title: "와플이랑 데이트", date: "2022-11-23T22:04:22", place: "창원 마산 합포구", memo: "오늘 그동안 모은 돈으로 오마카세를 먹는 날!!! 다들 지금까지 너무 고생많고 우리 신나게 한번 먹어보자구", wapple: "기해", topping: ["원", "메이", "우리", "채원"], color: 1), CardInfo(title: "와플이랑 데이트", date: "2022-11-23T22:04:22", place: "창원 마산 합포구", memo: "오늘 그동안 모은 돈으로 오마카세를 먹는 날!!! 다들 지금까지 너무 고생많고 우리 신나게 한번 먹어보자구", wapple: "기해", topping: ["원", "메이", "우리", "채원"], color: 2), CardInfo(title: "와플이랑 데이트", date: "2022-11-23T22:04:22", place: "창원 마산 합포구", memo: "오늘 그동안 모은 돈으로 오마카세를 먹는 날!!! 다들 지금까지 너무 고생많고 우리 신나게 한번 먹어보자구", wapple: "기해", topping: ["원", "메이", "우리", "채원"], color: 3), CardInfo(title: "와플이랑 데이트", date: nil, place: nil, memo: nil, wapple: "기해", topping: [], color: 4)]
        return Observable.of(dummy)
    }
    
    func getDetailArchiveInfo(id: Int) -> Observable<[DetailArhive]> {
        return Observable.of([])
    }
    
    func addCategory(id: Int, category: AddCategory) -> Observable<[GetCategory]> {
        return Observable.of([])
    }
    
    
    
}
