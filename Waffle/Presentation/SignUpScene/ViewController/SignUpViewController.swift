//
//  SignUpViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/07.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    private lazy var backButton: UIButton = {
        var button = UIButton()
        let xmark = UIImage(systemName: "xmark")
        button.setImage(xmark, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 21), forImageIn: .normal)
        return button
    }()
    
    private lazy var oneProgressButton: UIButton = {
        var button = UIButton()
        let one = UIImage(systemName: "one")
        button.setImage(one, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 21), forImageIn: .normal)
        return button
    }()
    
    private lazy var twoProgressButton: UIButton = {
        var button = UIButton()
        let two = UIImage(systemName: "two")
        button.setImage(two, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 21), forImageIn: .normal)
        return button
    }()
    
    private lazy var threeProgressButton: UIButton = {
        var button = UIButton()
        let three = UIImage(systemName: "two")
        button.setImage(three, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 21), forImageIn: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI(){
        
        func setProgressNavigationBar() { // TO DO selected state 
            self.navigationItem.backBarButtonItem = UIBarButtonItem(customView: backButton)
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 15
            let progressOneButton = self.navigationItem.makeProgressButton(self, level: "one")
            let progressTwoButton = self.navigationItem.makeProgressButton(self, level: "two")
            let progreeeThreeButton = self.navigationItem.makeProgressButton(self, level: "three")
            self.navigationItem.rightBarButtonItems = [progreeeThreeButton, spacer, progressTwoButton, spacer, progressOneButton]
        }
    }
}
