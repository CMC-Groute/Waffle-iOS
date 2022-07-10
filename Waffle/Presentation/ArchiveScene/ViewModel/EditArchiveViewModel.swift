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
    
    init(usecase: ArchiveUsecase, coordinator: HomeCoordinator){
        self.usecase = usecase
        self.coordinator = coordinator
    }
    
    let locationTextField = BehaviorRelay<String?>(value: nil) //외부에서 받아오는 데이터
    let datePickerDate = BehaviorRelay<Date?>(value: nil)
    let timePickerTime = BehaviorRelay<Date?>(value: nil)
    
    struct Input {
        var nameTextField: Observable<String>
        var dateTextField: Observable<String>
        var timeTextField: Observable<String>
        var locationTextField: Observable<String>
        var memoTextView: Observable<String?>
        
        var nameTextFieldDidTapEvent: ControlEvent<Void>
        var memoTextViewDidTapEvent: ControlEvent<Void>
        
        var nameTextFieldDidEndEvent: ControlEvent<Void>
        var memoTextViewDidEndEvent: ControlEvent<Void>
        var memoTextViewEditing: ControlEvent<Void>
        
        var dateTimeLaterButton: Observable<Void>
        
        var locationTextFieldTapEvent: ControlEvent<Void>
        var locationLaterButton: Observable<Void>
        
        var addArchiveButton: Observable<Void>
    }
    
    struct Output {
        var navigationTitle = BehaviorRelay<String>(value: "약속 만들기")
        var editModeEnabled = BehaviorRelay<Bool>(value: false)
        let dateTimeLaterButtonEnabled = BehaviorRelay<Bool>(value: false)
        let locationLaterButtonEnabled = BehaviorRelay<Bool>(value: false)
        let doneButtonEnabled = BehaviorRelay<Bool>(value: false)
    }
    
    func maxInputRestricted(length: Int, s: String) -> String {
        return self.usecase.maximumTextLength(length: length, s: s)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        output.navigationTitle.accept("약속 편집하기")
        print("get edit archive \(detailArchive)")
        input.addArchiveButton
            .withLatestFrom(Observable.combineLatest(input.nameTextField, datePickerDate, timePickerTime, input.memoTextView, locationTextField))
            .bind(onNext: { name, date, time, memo, location in
                //TO DO change to edit
                var arhive = AddArchive(title: name)
                let defaultText = "약속에 대한 간략한 정보나 토핑 멤버에게 보내고 싶은 메시지를 작성하면 좋아요"
                if memo != defaultText {
                    arhive.memo = memo
                }
                let dateString = date?.sendDataFormat()
                let timeString = time?.sendTimeFormat()
                arhive.date = dateString
                arhive.time = timeString
                arhive.location = location
                WappleLog.debug("\(name) \(date) \(time) \(memo) \(location)")
                WappleLog.debug("\(dateString) \(timeString)")
                 WappleLog.debug("inputData \(arhive)")
                self.usecase.addArchive(archive: arhive)
            }).disposed(by: disposeBag)

        usecase.addArchiveSuccess
            .subscribe(onNext: { bool in
                if bool {
                    self.coordinator.popToRootViewController()
                }else {
                    WappleLog.error("약속을 만드는데 실패하였습니다.")
                }
            }).disposed(by: disposeBag)
        
        //done button 활성화
        Observable.combineLatest(input.nameTextField, input.dateTextField, input.timeTextField, output.dateTimeLaterButtonEnabled, self.locationTextField, output.locationLaterButtonEnabled)
            .map{ !$0.0.isEmpty && ((!$0.1.isEmpty && !$0.2.isEmpty) || $0.3 == false) && (!($0.4 == nil) || $0.5 == false) } //false = 토핑이 원하는 위치로
            .bind(to: output.doneButtonEnabled)
            .disposed(by: disposeBag)
        
        input.locationTextFieldTapEvent
            .subscribe(onNext: {
                self.coordinator.addLocation()
            }).disposed(by: disposeBag)
        
        if let _ = detailArchive {
            output.editModeEnabled.accept(true)
            output.doneButtonEnabled.accept(true)
        }
        return output
    }
    
    func back() {
        self.coordinator.popToNavigaionController()
    }
}
