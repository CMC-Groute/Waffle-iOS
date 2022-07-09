//
//  TabBarViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/18.
//

import UIKit

class TabBarViewController: UITabBarController {
    var coordinator: HomeCoordinator!
    var popUpView = ArchivePopUpView()
    
    var didTapLastItem: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.popUpView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(self.tabBar.frame.height)
            $0.top.leading.trailing.equalTo(self.view)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.delegate = self
        self.delegate = self
        
        self.popUpView.isHidden = true
        self.view.addSubview(self.popUpView)
        //configureNavigationBar()
    }
}

extension TabBarViewController: ArchivePopUpViewDelegate {
    func didTapAddArchiveView() {
        self.tabBar.items![3].image = Asset.Assets.archive.image.withRenderingMode(.alwaysOriginal)
        self.coordinator.addArchive()
        popUpView.isHidden = true // 팝업뷰 닫기
    }
    
    func didTapInputArchiveView() {
        self.tabBar.items![3].image = Asset.Assets.archive.image.withRenderingMode(.alwaysOriginal)
        self.coordinator.inputCodeArchive()
        popUpView.isHidden = true
    }
    
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            popUpView.isHidden.toggle()
            if self.tabBar.items![item.tag].image == Asset.Assets.archiveSelected.image.withRenderingMode(.alwaysOriginal) {
                self.tabBar.items![item.tag].image = Asset.Assets.archive.image.withRenderingMode(.alwaysOriginal)
            }else {
                self.tabBar.items![item.tag].image =  Asset.Assets.archiveSelected.image.withRenderingMode(.alwaysOriginal)
            }

            self.didTapLastItem = true
        } else {
            self.didTapLastItem = false
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return !didTapLastItem
    }
}
