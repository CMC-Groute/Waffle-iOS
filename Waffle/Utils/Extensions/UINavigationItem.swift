//
//   UINavigationItem.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/07.
//

import UIKit

extension UINavigationItem {
    func rightBarButton(_ target: Any?, level: String) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(named: level), for: .normal)
            
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
            
        return barButtonItem
    }
}
