//
//  HomeUseCase.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/19.
//

import Foundation
import RxSwift

class HomeUsecase: HomeUsecaseProtocol {
    
    //MARK: Private property
    private var repository: HomeRepository!
    private var disposeBag = DisposeBag()
    
    //MARK: Response Subject
    var cardInfo = PublishSubject<[CardInfo]?>()
    var detailArchive = PublishSubject<DetailArhive?>()
    var deleteSuccess = PublishSubject<Bool>()
    var archiveCode = PublishSubject<String?>()
    var addCategory = PublishSubject<[PlaceCategory]?>()
    var deleteCategory = PublishSubject<Bool>()
    var networkError = BehaviorSubject<Bool>(value: false)
    
    var addPlaceSuccess = PublishSubject<(Bool, PlaceCategory)>()
    var setComfirmPlaceSuccess = PublishSubject<Bool>() // 장소 확정
    var cancelComfirmPlaceSuccess = PublishSubject<Bool>() // 장소 확정 취소
    
    var setLikePlaceSuccess = PublishSubject<Bool>() // 장소 좋아요
    var cancelLikePlaceSuccess = PublishSubject<Bool>() // 장소 좋아요 취소
    
    var getConfrimPlaceSuccess = PublishSubject<[PlaceInfo]?>() // 확정 장소 조회
    var getPlaceByCategorySuccess = PublishSubject<[PlaceInfo]?>() // 카테고리별 장소 조회
    var getSearchedPlaceSuccess = PublishSubject<PlaceSearchResponse>()
    var getDetailPlaceSuccess = PublishSubject<DetailPlaceInfo?>()
    var changeConfirmSquenceSuccess = PublishSubject<[PlaceInfo]?>() // 순서 변경 조회
    
    var getAlarmSuccess = PublishSubject<[Alarm]>() // 알림 데이터 가져오기
    var isReadAlarmSuccess = PublishSubject<Bool>() // 알림 읽었는지 확인
    var editPlaceSuccess = PublishSubject<(Bool, PlaceCategory)>() // 장소 수정
    var likeSendSuccess = PublishSubject<Bool>() // 좋아요 전송
    
    init(repository: HomeRepository){
        self.repository = repository
    }
    
    func saveArchiveId(idList: [Int]?) {
        UserDefaults.standard.set(idList, forKey: UserDefaultKey.joinArchiveId)
        WappleLog.debug("id 저장 \(UserDefaults.standard.array(forKey: UserDefaultKey.joinArchiveId) as? [Int])")
    }
    
    //MARK: 메인페이지 카드 조회
    func getCardInfo() {
        repository.getCardInfo()
            .catch { error -> Observable<GetCardResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getCardInfo error \(error)")
                return .just(GetCardResponse.errorResponse(status: error.rawValue, data: nil))
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("getCardInfo response \(response.status)")
                if response.status == URLSessionNetworkServiceError.unknownError.rawValue {
                    //network 연결 x
                    self.networkError.onNext(true)
                }else {
                    self.saveArchiveId(idList: response.data.map { $0.map { $0.id} })
                    self.cardInfo.onNext(response.data)
                    WappleLog.debug("getCardInfo \(response.data)")
                }
            }).disposed(by: disposeBag)
        }
    
    //MARK: 디테일 페이지 카드 조회
    func getDetailArchiveInfo(archiveId: Int) {
        repository.getDetailArchiveInfo(id: archiveId)
            .catch { error -> Observable<GetDetailArchive> in
                WappleLog.error("getDetailArchiveInfo error \(error)")
                let error = error as! URLSessionNetworkServiceError
                return .just(GetDetailArchive(status: error.rawValue, data: nil))
            }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detailArchive in
                guard let self = self else { return }
                WappleLog.debug("getDetailArchiveInfo \(detailArchive)")
                self.detailArchive.onNext(detailArchive.data)
            }).disposed(by: disposeBag)
        }
    
    //MARK: 카테고리 삭제
    func deleteCategory(archiveId: Int, categoryId: Int) {
        repository.deleteCategory(archiveId: archiveId, categoryId: categoryId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("deleteCategory error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.deleteCategory.onNext(true)
                }else {
                    self.deleteCategory.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 카테고리 추가
    func addCategory(archiveId: Int, categoryName: [String]) {
        repository.addCategory(archiveId: archiveId, categoryName: categoryName)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<AddCategoryResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("addCategory error \(error)")
                return .just(AddCategoryResponse(status: error.rawValue, data: nil))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("addCategory \(response.data)")
                if response.status == 200 {
                    self.addCategory.onNext(response.data)
                }else if response.status == 400 {
                    self.addCategory.onNext(nil)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 약속 나가기
    func deleteArchive(archiveId: Int) {
        repository.deleteArchive(archiveId: archiveId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("deleteArchive error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.deleteSuccess.onNext(true)
                }else {
                    self.deleteSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 좋아요 조르기
    func likeSend(archiveId: Int) {
        repository.likeSend(archiveId: archiveId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("likeSend error \(error)")
                return .just(DefaultResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("likeSend \(response.status)")
                if response.status == 200 {
                    self.likeSendSuccess.onNext(true)
                }else {
                    self.likeSendSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 약속 코드 조회
    func getArchiveCode(archiveId: Int, completion: () -> Void) {
        repository.getArchiveCode(id: archiveId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<GetArchiveCode> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getArchiveCode error \(error)")
                return .just(GetArchiveCode(status: error.rawValue, data: nil))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.archiveCode.onNext(response.data?.code)
            }).disposed(by: disposeBag)
    }

}

//MARK: Place API
extension HomeUsecase {
    //MARK: 장소 추가
    func addPlace(archiveId: Int, categoryId: Int, addPlace: AddPlace, category: PlaceCategory) {
        repository.addPlace(archiveId: archiveId, categoryId: categoryId, placeInfo: addPlace)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("addPlace error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.addPlaceSuccess.onNext((true, category))
                }else {
                    self.addPlaceSuccess.onNext((false, category))
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 확정 장소 조회
    func getConfirmPlace(archiveId: Int) {
        repository.getConfirmPlace(archiveId: archiveId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<GetPlaceByCategoryResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getConfirmPlace error \(error)")
                return .just(GetPlaceByCategoryResponse(status: error.rawValue, data: nil))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.getPlaceByCategorySuccess.onNext(response.data)
                }else {
                    self.getPlaceByCategorySuccess.onNext(nil)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 카테고리별 장소 조회
    func getPlaceByCategory(archiveId: Int, categoryId: Int) {
        repository.getPlaceByCategory(archiveId: archiveId, categoryId: categoryId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<GetPlaceByCategoryResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getPlaceByCategory error \(error)")
                return .just(GetPlaceByCategoryResponse(status: error.rawValue, data: nil))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("getPlaceByCategory \(response)")
                if response.status == 200 {
                    self.getPlaceByCategorySuccess.onNext(response.data)
                }else {
                    self.getPlaceByCategorySuccess.onNext(nil)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 장소 확정
    func setConfirmPlace(archiveId: Int, placeId: Int) {
        repository.setConfirmPlace(archiveId: archiveId, placeId: placeId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("setConfirmPlace error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("setConfirmPlace \(response)")
                if response.status == 200 {
                    self.setComfirmPlaceSuccess.onNext(true)
                }else {
                    self.setComfirmPlaceSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 장소 확정 취소
    func cancelConfirmPlace(archiveId: Int, placeId: Int) {
        repository.cancelConfirmPlace(archiveId: archiveId, placeId: placeId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("cancelConfirmPlace error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("cancelConfirmPlace \(response)")
                if response.status == 200 {
                    self.cancelComfirmPlaceSuccess.onNext(true)
                }else {
                    self.cancelComfirmPlaceSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 장소 삭제하기
    func deletePlace(archiveId: Int, placeId: Int) {
        repository.deletePlace(archiveId: archiveId, placeId: placeId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("deletePlace error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                WappleLog.debug("deletePlace \(response)")
                if response.status == 200 {
                    WappleLog.debug("장소 삭제 성공")
                }else {
                    WappleLog.debug("장소 삭제 실패")
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 장소 수정하기
    func editPlace(archiveId: Int, placeId: Int, editPlace: EditPlace, category: PlaceCategory) {
        WappleLog.debug("editPlace \(editPlace)")
        repository.editPlace(archiveId: archiveId, placeId: placeId, editPlace: editPlace)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getSearcPlace error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.editPlaceSuccess.onNext((true, category))
                }else {
                    self.editPlaceSuccess.onNext((false, category))
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 장소 검색
    func getSearcPlace(searchText: String, page: Int, size: Int) {
        WappleLog.debug("searchText \(searchText)")
        repository.getSearchedPlace(searchText: searchText, page: page, size: size)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<PlaceSearchResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getSearcPlace error \(error)")
                return .just(PlaceSearchResponse(documents: [], meta: nil))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if !response.documents.isEmpty {
                    self.getSearchedPlaceSuccess.onNext(response)
                }else {
                    self.getSearchedPlaceSuccess.onNext(PlaceSearchResponse(documents: []))
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 디테일 약속 조회
    func getDetailPlace(archiveId: Int, placeId: Int) {
        repository.getDetailPlace(archiveId: archiveId, placeId: placeId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DetailPlaceResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getDetailPlace error \(error)")
                return .just(DetailPlaceResponse(status: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if response.status == 200 {
                    self.getDetailPlaceSuccess.onNext(response.data)
                }else {
                    self.getDetailPlaceSuccess.onNext(nil)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 좋아요 누르기
    func addLike(placeId: Int){
        repository.addLike(placeId: placeId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("addLike error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("addLike \(response)")
                if response.status == 200 {
                    self.setLikePlaceSuccess.onNext(true)
                }else {
                    self.setLikePlaceSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 좋아요 취소하기
    func deleteLike(placeId: Int){
        repository.deleteLike(placeId: placeId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("deleteLike error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("deleteLike \(response)")
                if response.status == 200 {
                    self.cancelLikePlaceSuccess.onNext(true)
                }else {
                    self.cancelLikePlaceSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 확정 장소 순서 변경
    func changeConfirmSquence(archiveId: Int, placeSequence: GetPlaceSequence) {
        WappleLog.debug("sequece \(placeSequence)")
        repository.changeConfirmSquence(archiveId: archiveId, placeSequence: placeSequence)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<GetPlaceByCategoryResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("changeConfirmSquence error \(error)")
                return .just(GetPlaceByCategoryResponse(status: error.rawValue, data: nil))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("changeConfirmSquence \(response)")
                if response.status == 200 {
                    self.changeConfirmSquenceSuccess.onNext(response.data)
                }else {
                    self.changeConfirmSquenceSuccess.onNext(nil)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: 알람 데이터 가져오기
    func getAlarms() {
        repository.getAlarms()
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<GetAlarm> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("getAlarms error \(error)")
                return .just(GetAlarm(status: error.rawValue, data: []))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("getAlarms \(response)")
                if response.status == 200 {
                    self.getAlarmSuccess.onNext(response.data)
                }else {
                    self.getAlarmSuccess.onNext([])
                }
            }).disposed(by: disposeBag)
    }
    
    func isReadAlarm(alarmId: Int) {
        repository.isReadAlarm(alarmId: alarmId)
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<DefaultIntResponse> in
                let error = error as! URLSessionNetworkServiceError
                WappleLog.error("isReadAlarm error \(error)")
                return .just(DefaultIntResponse.errorResponse(code: error.rawValue))
            }.subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                WappleLog.debug("isReadAlarm \(response)")
                if response.status == 200 {
                    self.isReadAlarmSuccess.onNext(true)
                }else {
                    self.isReadAlarmSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
}

