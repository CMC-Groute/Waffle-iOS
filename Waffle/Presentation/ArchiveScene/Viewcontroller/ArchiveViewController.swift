//
//  ArchiveViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import UIKit
import RxSwift

class ArchiveViewController: UIViewController {

    var disposBag = DisposeBag()
    var viewModel: ArchiveViewModel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    

}
