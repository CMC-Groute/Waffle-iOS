//
//  TabBarViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/18.
//

import UIKit

class TabBarViewController: UITabBarController {
    let archiveButton = UIButton(frame: CGRect.zero)
    var coordinator: ArchiveCoordinator!
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
    
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       archiveButton.frame.origin.y = self.view.bounds.height
        - archiveButton.frame.height - self.view.safeAreaInsets.bottom - 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.delegate = self
        self.delegate = self
        
        self.popUpView.isHidden = true
        self.view.addSubview(self.popUpView)
    }
    
    
    
    @objc func didTapLeftButton() {
        if archiveButton.isSelected {
            archiveButton.isSelected = false
            popUpView.isHidden = true
        }else {
            archiveButton.isSelected = true
            popUpView.isHidden = false
        }
        
    }


}

extension TabBarViewController: ArchivePopUpViewDelegate {
    func didTapAddArchiveView() {
        self.coordinator.addArchive()
        archiveButton.isSelected = false
        popUpView.isHidden = true // 팝업뷰 닫기
    }
    
    func didTapInputArchiveView() {
        self.coordinator.inputCodeArchive()
        archiveButton.isSelected = false
        popUpView.isHidden = true
    }
    
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //print("didSelect item \(item)")
        if item.tag == 3 {
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
