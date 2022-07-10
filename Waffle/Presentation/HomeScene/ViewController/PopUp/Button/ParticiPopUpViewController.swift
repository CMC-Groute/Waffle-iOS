//
//  ParticiPopUpViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/23.
//

import UIKit
import RxSwift

class ParticiPopUpViewController: UIViewController {
    var coordinator: HomeCoordinator!
    var disposBag = DisposeBag()
    var detailArchive: DetailArhive?
    
    @IBOutlet private weak var frameView: UIView!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    private var maximumHeight: CGFloat = 486
    
    lazy var transparentView: UIImageView = {
        let image = Asset.Assets.transparentEtc.image
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
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
        countLabel.text = "\((detailArchive?.member.count ?? 0))명"
        frameView.makeRounded(width: nil, color: nil, value: 20)
        tableView.separatorColor = Asset.Colors.gray1.color
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.register(UINib(nibName: ParticipantsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ParticipantsTableViewCell.identifier)
        configureHeight()
    }
    
    private func configureHeight() {
        let tableViewlineHeight: CGFloat = 52
        let count: CGFloat = CGFloat(detailArchive?.member.count ?? 0)
        if count > 1 {
            if tableViewlineHeight * (count + 1) > maximumHeight {
                tableView.isScrollEnabled = true
                addTransparentView()
            }
            heightConstraint.constant += tableViewlineHeight * count
        }
    }
    
    private func addTransparentView() {
        view.addSubview(transparentView)
        transparentView.snp.makeConstraints {
            $0.leading.equalTo(tableView.snp.leading)
            $0.trailing.equalTo(tableView.snp.trailing)
            $0.bottom.equalTo(tableView.snp.bottom)
            $0.width.equalTo(tableView.snp.width)
            $0.height.equalTo(52)
        }
    }
    
    private func bindUI() {
        closeButton.rx.tap
            .subscribe(onNext: {
                self.coordinator.popToViewController(with: nil, width: nil, height: nil)
            }).disposed(by: disposBag)
    }

}

extension ParticiPopUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let topping = detailArchive?.member else { return 0 }
        return topping.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantsTableViewCell.identifier, for: indexPath) as! ParticipantsTableViewCell
        guard let toppingInfo = detailArchive?.member else { return cell }
        if indexPath.row == 0 {
            let wapple = toppingInfo.filter { $0.userId == detailArchive?.wappleId }
            cell.configureCell(info: wapple[0], type: .wapple)
        }else {
            var topping = toppingInfo.filter { $0.userId == detailArchive?.wappleId }
            topping += toppingInfo.filter { $0.userId != detailArchive?.wappleId }
            cell.configureCell(info: topping[indexPath.row], type: .topping)
        }
        return cell
    }
    
}

extension ParticiPopUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(52)
    }
}

