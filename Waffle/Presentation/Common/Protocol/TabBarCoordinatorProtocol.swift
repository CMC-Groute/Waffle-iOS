//
//  TabBarCoordinatorProtocol.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/06.
//

import UIKit

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: TabBarViewController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}
