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
    
    
   func setupLeftButton() {
       let numberOfItems = CGFloat(self.tabBar.items!.count)
       let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
       archiveButton.setImage(Asset.Assets.archive.image, for: .normal)
       archiveButton.setImage(Asset.Assets.archiveSelected.image, for: .selected)
       archiveButton.frame = CGRect(x: 0, y: 0, width: tabBarItemSize.width, height: tabBar.frame.size.height)
       var menuButtonFrame = archiveButton.frame
       menuButtonFrame.origin.x = (self.view.bounds.width/4) * 3

       self.archiveButton.frame = menuButtonFrame
       self.archiveButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
       self.view.addSubview(archiveButton)
       self.view.layoutIfNeeded()
       
       
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
            self.didTapLastItem = true
        } else {
            self.didTapLastItem = false
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return !didTapLastItem
    }
}
