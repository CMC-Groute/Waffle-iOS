//
//  EditArchiveViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/07.
//

import Foundation
import RxSwift
import RxCocoa

class EditArchiveViewModel {
    var usecase: ArchiveUsecase!
    var coordinator: HomeCoordinator!
    
    var disposeBag = DisposeBag()
    var detailArchive: DetailArhive?
    var archiveId: Int?
    
    init(usecase: ArchiveUsecase, coordinator: HomeCoordinator){
        self.usecase = usecase
        self.coordinator = coordinator
    }
    
//    let locationTextField = BehaviorRelay<String?>(value: nil) //외부에서 받아오는 데이터
//    let datePickerDate = BehaviorRelay<Date?>(value: nil)
//    let timePickerTime = BehaviorRelay<Date?>(value: nil)
    let defaultMemoText = "약속에 대한 간략한 정보나 토핑 멤버에게 보내고 싶은 메시지를 작성하면 좋아요"
    let dateTimeLaterButtonEnabled = BehaviorRelay<Bool>(value: false)
    let locationLaterButtonEnabled = BehaviorRelay<Bool>(value: false)
    let doneButtonEnabled = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        var nameTextFieldDidTapEvent: ControlEvent<Void>
        var memoTextViewDidTapEvent: ControlEvent<Void>
        
        var nameTextFieldDidEndEvent: ControlEvent<Void>
        var memoTextViewDidEndEvent: ControlEvent<Void>
        var memoTextViewEditing: ControlEvent<Void>
        
        var dateTimeLaterButton: Observable<Void>
        
        var locationTextFieldTapEvent: ControlEvent<Void>
        var locationLaterButton: Observable<Void>
        
        var editArchiveButton: Observable<Void>
    }
    
    struct Output {
////        var title = PublishRelay<String>()
////        var memo = BehaviorRelay<String?>(value: nil)
//        let dateTimeLaterButtonEnabled = BehaviorRelay<Bool>(value: false)
//       let locationLaterButtonEnabled = BehaviorRelay<Bool>(value: false)
//        let doneButtonEnabled = BehaviorRelay<Bool>(value: false)
    }
    
    func editButton(archiveInfo: AddArchive) {
        WappleLog.debug("archiveInfo \(archiveInfo)")
        guard let archiveId = archiveId else { return }
        self.usecase.editArchive(archiveId: archiveId, archive: archiveInfo)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        usecase.editArchiveSuccess
            .subscribe(onNext: { bool in
                if bool {
                    WappleLog.debug("editArchiveSuccess 약속 편집 성공")
                    self.coordinator.popViewController()
                }else {
                    WappleLog.error("약속을 만드는데 실패하였습니다.")
                }
            }).disposed(by: disposeBag)
//        guard let detailArchive = detailArchive else { return output }
//        if let date = detailArchive.date?.toDate(), let time = detailArchive.time?.toTime() {
//            WappleLog.debug("date \(date) time \(time)")
//            datePickerDate.accept(date) //"2022년 12월 02일"
//            timePickerTime.accept(time)  //("AM 12시 41분")
//            locationTextField.accept(detailArchive.place ?? nil)
//            output.title.accept(detailArchive.title)
//            output.memo.accept(detailArchive.memo ?? nil)
//        }
//
//        input.editArchiveButton
//            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
//            .withLatestFrom(Observable.combineLatest(output.title, datePickerDate, timePickerTime, output.memo, locationTextField))
//            .bind(onNext: { title, date, time, memo, location in
//                guard let archiveId = self.archiveId else { return }
//                var arhive = AddArchive(title: title)
//                if memo != defaultText { arhive.memo = memo }
//                let dateString = date?.sendDataFormat()
//                let timeString = time?.sendTimeFormat()
//                arhive.date = dateString
//                arhive.time = timeString
//                arhive.location = location
//                WappleLog.debug("EditArchiveViewModel \(title) \(date) \(time) \(memo) \(location)")
//                WappleLog.debug("EditArchiveViewModel \(dateString) \(timeString)")
//                 WappleLog.debug("EditArchiveViewModel total inputData \(arhive)")
////                self.usecase.editArchive(archiveId: archiveId, archive: arhive)
////                self.coordinator.popViewController()
//            }).disposed(by: disposeBag)
        
        //done button 활성화
//        Observable.combineLatest(output.name, datePickerDate, timePickerTime, output.dateTimeLaterButtonEnabled, self.locationTextField, output.locationLaterButtonEnabled)
//            .map{ !$0.0.isEmpty && ((!$0.1.isEmpty && !$0.2.isEmpty) || $0.3 == false) && (!($0.4 == nil) || $0.5 == false) } //false = 토핑이 원하는 위치로
//            .bind(to: output.doneButtonEnabled)
//            .disposed(by: disposeBag)
        
        input.locationTextFieldTapEvent
            .subscribe(onNext: {
                self.coordinator.addLocation()
            }).disposed(by: disposeBag)
        
        //output.doneButtonEnabled.accept(true)
        
        return output
    }
    
    func back() {
        self.coordinator.popToNavigaionController()
    }
    
    func maxInputRestricted(length: Int, s: String) -> String {
        return self.usecase.maximumTextLength(length: length, s: s)
    }
}
