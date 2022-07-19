//
//  HomeAlarmViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/09.
//

import Foundation
import UIKit
import RxSwift

class HomeAlarmViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: HomeAlarmViewModel?
    
    var noSearchResultView: UIView = {
        let view = UIView()
        return view
    }()
    
    var noInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.black.color
        label.text = "아직 받은 알림이 없어요"
        label.font = UIFont.topPageTitleFont()
        return label
    }()
    
    var searchImageView: UIImageView = {
        let searchImage = Asset.Assets.searchEtc.image
        let imageView = UIImageView(image: searchImage)
        return imageView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindViewModel()
    }
    
    private func configure() {
        self.noSearchResultView.addSubview(searchImageView)
        self.noSearchResultView.addSubview(noInfoLabel)
        self.view.addSubview(noSearchResultView)
        
        searchImageView.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.centerX.equalTo(noSearchResultView)
            $0.width.height.equalTo(50)
        }
        noInfoLabel.snp.makeConstraints {
            $0.centerX.equalTo(noSearchResultView)
            $0.top.equalTo(searchImageView.snp.bottom).offset(10)
            $0.bottom.equalTo(noSearchResultView.snp.bottom).inset(10)
        }
        
        noSearchResultView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(130)
            $0.centerX.centerY.equalToSuperview()
        }
        
        func configureNavigationBar() {
            self.navigationController?.navigationBar.titleTextAttributes =  Common.navigationBarTitle()
            self.navigationItem.title = "알림"
            let backImage = Asset.Assets._24pxBtn.image.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
            navigationItem.leftBarButtonItem = backButton
        }
        
        configureNavigationBar()
        configureTableView()
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "HomeAlarmTableViewCell", bundle: nil), forCellReuseIdentifier: HomeAlarmTableViewCell.identifier)
    }
    
    private func bindViewModel(){
        let input =  HomeAlarmViewModel.Input(viewDidLoadEvent: Observable.just(()))
    }
}

extension HomeAlarmViewController: UITableViewDelegate {
    // 선택시

}

extension HomeAlarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel  = viewModel else { return 0 }
        if viewModel.alarmData.count == 0 { // 검색 중인데 데이터가 없을때
            tableView.backgroundView  = noSearchResultView
            tableView.separatorStyle  = .none
       }else {
           tableView.separatorStyle = .singleLine
           tableView.backgroundView = nil
        }
        
        return viewModel.alarmData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeAlarmTableViewCell.identifier) as! HomeAlarmTableViewCell
        guard let viewModel  = viewModel else { return cell }
        cell.configureCell(alarm: viewModel.alarmData[indexPath.row])
        return cell
    }
    
    
}
