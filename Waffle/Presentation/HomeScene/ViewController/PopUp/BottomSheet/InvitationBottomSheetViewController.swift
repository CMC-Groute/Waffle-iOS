//
//  InvitationViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//


import UIKit
import RxSwift
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon

class InvitationBottomSheetViewController: UIViewController {
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet private weak var shareWithKakaoTalkButton: UIButton!
    @IBOutlet weak var copyCodeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var coordinator: HomeCoordinator!
    var disposeBag = DisposeBag()
    var archiveCode: String?
    var archiveId: Int?
    var detailArchive: DetailArhive?
    
    convenience init(coordinator: HomeCoordinator){
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func configureUI() {
        frameView.roundCorners(value: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        cancelButton.makeRounded(width: 1, borderColor: Asset.Colors.gray5.name, value: 26)
    }
    
    private func bindUI() {
        shareWithKakaoTalkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.sendLink()
            }).disposed(by: disposeBag)
        
        copyCodeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                UIPasteboard.general.string = self.archiveCode
                self.coordinator.popToViewController(with: "약속코드가 복사되었어요\n함께할 토핑들에게 공유해봐요", width: 184, height: 56)
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func sendLink() {
        guard let detailArchive = detailArchive else { return }

//        let link = Link(webUrl: URL(string:"https://developers.kakao.com"),
//                        mobileWebUrl: URL(string:"https://developers.kakao.com"))
        guard let archiveId = archiveId, let archiveCode = archiveCode else { return }
        let appLink = Link(androidExecutionParams: ["promiseId": "\(archiveId)", "promiseCode" : "\(archiveCode)"],
                            iosExecutionParams: ["archiveId": "\(archiveId)", "archiveCode" : "\(archiveCode)"])
        
        let button = Button(title: "약속에 참여하기", link: appLink)
        let title = "\(detailArchive.title)에 초대를 받았어요"
        var timeString: String = "⏰ "
        var placeString: String = "🚩 "
        
        if let date = detailArchive.date, let time = detailArchive.time {
            timeString += "\(date) \(time.amPmChangeFormat())"
        }else {
            timeString += DefaultDetailCardInfo.when.rawValue
        }
        
        if let place = detailArchive.place {
            placeString += "\(place)"
        }else {
            placeString += DefaultDetailCardInfo.where.rawValue
        }
        
        let imageLink = WappleType.init(rawValue: detailArchive.placeImage)?.wappleLink() ?? ""
        
        let content = Content(title: "\(title)\n\(timeString)\n\(placeString)",
                                imageUrl: URL(string: imageLink)!, imageWidth: 330, imageHeight: 370,
                                link: appLink)
        let feedTemplate = FeedTemplate(content: content, buttons: [button])
        WappleLog.debug("send feedTemplate \(feedTemplate)")
        //메시지 템플릿 encode
        if let feedTemplateJsonData = (try? SdkJSONEncoder.custom.encode(feedTemplate)) {

        //생성한 메시지 템플릿 객체를 jsonObject로 변환
            if let templateJsonObject = SdkUtils.toJsonObject(feedTemplateJsonData) {
                ShareApi.shared.shareDefault(templateObject:templateJsonObject) {(sharingResult, error) in
                    if let error = error {
                        print("not load \(error)")
                    }
                    else {
                        print("shareDefault(templateObject:templateJsonObject) success.")
                        
                        //do something
                        guard let sharingResult = sharingResult else { return }
                        UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
}
