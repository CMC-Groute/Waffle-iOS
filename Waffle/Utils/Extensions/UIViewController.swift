//
//  UIViewController.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/09.
//

import Foundation
import UIKit

extension UIViewController {
    func showToast(message : String, width: Int) {
        let font = UIFont.fontWithName(type: .semibold, size: 13)
        var height = 34
        if width > 200 {
            print("here")
            height = 55
        }
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: CGFloat(width), height: 34))
        toastLabel.backgroundColor = Asset.Colors.gray6.color
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 17
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
    
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

extension UIView {
    func round(width: CGFloat?, color: String?, value: CGFloat) {
        if let width = width {
            self.layer.borderWidth = width
        }
        if let color = color {
            self.layer.borderColor = UIColor(named: color)?.cgColor
        }
        self.layer.cornerRadius = value
        
    }
    
    func makeCircleShape(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
    }
}
