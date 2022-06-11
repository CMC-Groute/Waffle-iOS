//
//  SetProfileImageViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/11.
//

import Foundation
import UIKit

class SetProfileImageViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    func configureUI() {
        startButton.round(corner: 25)
        startButton.setUnEnabled(color: Asset.Colors.gray4.name)
        
        func setProgressNavigationBar() { // TO DO selected state
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            let progressOneButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProgressed1.name)
            let progressTwoButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProgressed2.name)
            let progreeeThreeButton = self.navigationItem.makeProgressButton(self, level: Asset.Assets.joinProcessed3.name)
            
            self.navigationItem.rightBarButtonItems = [progreeeThreeButton, spacer, progressTwoButton, spacer, progressOneButton]
        }
        
        setProgressNavigationBar()
    }
    
    private func bindViewModel() {
        
    }
}
