//
//  TabBarViewController.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/18.
//

import UIKit

class TabBarViewController: UITabBarController {
    let archiveButton = UIButton(frame: CGRect.zero)
    var coordinator: TabBarCoordinator!
    var popUpView = UIView()
    
   override func viewDidLoad() {
       super.viewDidLoad()
   }
    
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       archiveButton.frame.origin.y = self.view.bounds.height
        - archiveButton.frame.height - self.view.safeAreaInsets.bottom - 3
        print(archiveButton.frame.origin.y)
    }
    
//    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
//        let tabBar = UITabBarItem(
//            title: nil,
//            image: UIImage(named: page.tabIconName())?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "\(page.tabIconName())-selected")?.withRenderingMode(.alwaysOriginal))
//        tabBar.tag = page.pageOrderNumber()
//        return tabBar
//
//    }
    
   func setupLeftButton() {
       let numberOfItems = CGFloat(self.tabBar.items!.count)
       let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
       archiveButton.setImage(Asset.Assets.archive.image, for: .normal)
       archiveButton.setImage(Asset.Assets.archiveSelected.image, for: .selected)
       archiveButton.frame = CGRect(x: 0, y: 0, width: tabBarItemSize.width, height: tabBar.frame.size.height)
       var menuButtonFrame = archiveButton.frame
       //menuButtonFrame.origin.y = self.view.bounds.height  //menuButtonFrame.height //- self.view.safeAreaInsets.bottom
       menuButtonFrame.origin.x = (self.view.bounds.width/4) * 3
       //- menuButtonFrame.size.width/2

       self.archiveButton.frame = menuButtonFrame
       self.archiveButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
       self.view.addSubview(archiveButton)
       self.view.layoutIfNeeded()
       
       
       self.popUpView.backgroundColor = .red
       self.popUpView.layer.opacity = 0.7
       self.popUpView.isHidden = true
       self.view.addSubview(self.popUpView)
       self.popUpView.snp.makeConstraints {
           $0.bottom.equalTo(self.tabBar.snp.top)
           $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
       }
   }
    
    @objc func didTapMenuButton() {
        if archiveButton.isSelected {
            archiveButton.isSelected = false
            popUpView.isHidden = true
        }else {
            archiveButton.isSelected = true
            popUpView.isHidden = false
        }
        
    }


}

