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
        cancelButton.makeRounded(width: 1, color: Asset.Colors.gray5.name, value: 26)
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
    
    private func updateImage() { //TO DO updateImage
        if let image = UIImage(named: "sample1") {
            ShareApi.shared.imageUpload(image:image) { [weak self] (imageUploadResult, error) in
                if let error = error {
                    print(error)
                }
                else {
                    let imageUrl = imageUploadResult?.infos.original.url
                    print("imageUpload() success.")
                }
            }
        }
    }
    
    private func sendLink() {
        updateImage()
//        let link = Link(webUrl: URL(string:"https://developers.kakao.com"),
//                        mobileWebUrl: URL(string:"https://developers.kakao.com"))
        guard let archiveId = archiveId else { return }
        let appLink = Link(androidExecutionParams: ["archiveId": "\(archiveId)"],
                            iosExecutionParams: ["archiveId": "\(archiveId)"])
        
        let button1 = Button(title: "약속에 참여하기", link: appLink)

        let content = Content(title: "우리 약속 어디서 만나?\n와플로 와, 와플에서 정하자!",
                                imageUrl: URL(string:"https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png")!,
                                link: appLink)
        let feedTemplate = FeedTemplate(content: content, buttons: [button1])
        
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
