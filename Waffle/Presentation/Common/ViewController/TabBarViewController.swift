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
    
    var didTapPopUpItem: Bool = false
    let lastItemIndex = 1

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
        popUpView.isHidden = true
        view.addSubview(popUpView)
    }
}

extension TabBarViewController: ArchivePopUpViewDelegate {
    func didTapAddArchiveView() {
        self.tabBar.items![lastItemIndex].image = Asset.Assets.archive.image.withRenderingMode(.alwaysOriginal)
        if self.selectedIndex == 2 {
            self.selectedIndex = 0
        }
        self.coordinator.addArchive()
        popUpView.isHidden = true // 팝업뷰 닫기
    }
    
    func didTapInputArchiveView() {
        self.tabBar.items![lastItemIndex].image = Asset.Assets.archive.image.withRenderingMode(.alwaysOriginal)
        if self.selectedIndex == 2 {
            self.selectedIndex = 0
        }
        self.coordinator.inputCodeArchive()
        popUpView.isHidden = true
    }
    
    func didTapFrameView() {
        popUpViewHidden()
    }
    
    func popUpViewHidden() {
        guard let tabBarItems = self.tabBar.items else { return }
        if tabBarItems[lastItemIndex].image == Asset.Assets.archiveSelected.image.withRenderingMode(.alwaysOriginal) {
            tabBarItems[lastItemIndex].image = Asset.Assets.archive.image.withRenderingMode(.alwaysOriginal)
            popUpView.isHidden = true
        }else {
            tabBarItems[lastItemIndex].image =  Asset.Assets.archiveSelected.image.withRenderingMode(.alwaysOriginal)
            popUpView.isHidden = false
        }

        self.didTapPopUpItem = true
    }
    
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == lastItemIndex {
            popUpViewHidden()
        } else {
            self.didTapPopUpItem = false
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return !didTapPopUpItem
    }
}
