//
//  MapViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        func setNavigationBar() {
            let image = Asset.Assets.wapple.image.withRenderingMode(.alwaysOriginal)
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 26
            let calendarButton = self.navigationItem.rightBarButton(self, level: Asset.Assets.calendar.name)
            let bellButton = self.navigationItem.rightBarButton(self, level: Asset.Assets.bell.name)
            
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [bellButton, spacer, calendarButton]
        }
        setNavigationBar()
    }

}
