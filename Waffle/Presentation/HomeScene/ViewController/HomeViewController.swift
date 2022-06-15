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

    }
    
}
