//
//  UIViewController.swift
//  Waffle
//
//  Created by ์กฐ์์  on 2022/06/09.
//

import UIKit

extension UIViewController {

    func showToast(message : String, width: CGFloat, height: CGFloat, heightOffset: CGFloat = 100, corner: CGFloat = 28) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-heightOffset, width: width, height: height))
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = Asset.Colors.gray5.color
        toastLabel.textColor = Asset.Colors.white.color
        toastLabel.font = UIFont.fontWithName(type: .semibold, size: 13)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.center.x = self.view.frame.size.width/2
        toastLabel.layer.cornerRadius = corner
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveLinear, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
        
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
    func makeRounded(width: CGFloat?, borderColor: String?, value: CGFloat) {
        if let width = width {
            self.layer.borderWidth = width
        }
        if let color = borderColor {
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

extension UIViewController {

  func presentAlert(withTitle title: String, message : String) {
    DispatchQueue.main.async{
          let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let OKAction = UIAlertAction(title: "OK", style: .default)
          alertController.addAction(OKAction)
          self.present(alertController, animated: true, completion: nil)
      }
  }
}
