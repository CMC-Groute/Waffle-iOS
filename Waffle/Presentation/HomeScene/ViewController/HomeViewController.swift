//
//  HomeViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    @IBSegueAction func embedCardView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: SnapCarousel().environmentObject(UIStateModel()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        func setNavigationBar() {
            var image = Asset.Assets.wapple.image.withRenderingMode(.alwaysOriginal)
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 26
            let calendarButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.calendar.name)
            let bellButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.bell.name)
            
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [bellButton, spacer, calendarButton]
        }
        setNavigationBar()
    }
    
    
}
