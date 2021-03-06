//
//  InputArchiveViewModel.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/16.
//

import Foundation
import RxSwift
import RxCocoa

enum CodeInvalidType: String {
    case already = "이미 중복된 회원이에요."
    case inValid = "존재하지 않는 약속 코드에요."
    case success = ""
}

final class InputArchiveCodeViewModel {
    var usecase: ArchiveUsecase!
    var coordinator: HomeCoordinator!
    
    var disposeBag = DisposeBag()
    
    init(usecase: ArchiveUsecase, coordinator: HomeCoordinator){
        self.usecase = usecase
        self.coordinator = coordinator
    }
    
    struct Input {
        let codeTextField: Observable<String>
        let codeTextFieldDidTapEvent: ControlEvent<Void>
        let codeTextFieldDidEndEvent: ControlEvent<Void>
        let joinButton: Observable<Void>
    }
    
    struct Output {
        let inValidCodeMessage = PublishRelay<(CodeInvalidType, Bool)>()
        let joinButtonEnabled = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.codeTextField
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                if !text.isEmpty { // 조건 : 한글자 이상 입력
                    output.joinButtonEnabled.accept(true)
                    output.inValidCodeMessage.accept((.success, false))
                }else {
                    output.joinButtonEnabled.accept(false)
                }
            }).disposed(by: disposeBag)
        
        input.joinButton
            .withLatestFrom(input.codeTextField)
            .subscribe(onNext: { [weak self] code in
                guard let self = self else { return }
                self.usecase.joinArchive(code: code)
            }).disposed(by: disposeBag)
        
        usecase.joinArhicveSuccess
            .subscribe(onNext: { [weak self] status, archiveId in
                guard let self = self else { return }
                guard let archiveId = archiveId else { return }
                switch status {
                case .inValid:
                    output.inValidCodeMessage.accept((.inValid, true))
                case .success:
                    output.inValidCodeMessage.accept((.success, false))
                    self.coordinator.detailArchive(archiveId: archiveId)
                case .already:
                    output.inValidCodeMessage.accept((.already, true))
                case .error:
                    output.inValidCodeMessage.accept((.inValid, true))
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func back() {
        coordinator.popToNavigaionController()
    }
}
