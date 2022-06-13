//
//  UIButton.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/11.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIButton {
    func setEnabled(color: String?) {
        self.isUserInteractionEnabled = true
        self.isEnabled = true
        if let color = color {
            self.backgroundColor = UIColor(named: color)
            self.setTitleColor(UIColor(named: Asset.Colors.white.name), for: .normal)
        }
    }
    
    func setUnEnabled(color: String?) {
        self.isUserInteractionEnabled = false
        self.isEnabled = true
        if let color = color {
            self.backgroundColor = UIColor(named: color)
            self.setTitleColor(UIColor(named: Asset.Colors.white.name), for: .disabled)
        }
        
    }
    
    func setDisabled(with bool: Bool, color: String){
        self.isUserInteractionEnabled = !bool
        self.backgroundColor =  bool ? UIColor(named: color)!.withAlphaComponent(0.5) : UIColor(named: color)!
    }
}

extension Reactive where Base: UIButton {
    /// Reactive wrapper for `setTitle(_:for:)`
    public func title(for controlState: UIControl.State = []) -> Binder<String?> {
        Binder(self.base) { button, title in
            button.setTitle(title, for: controlState)
        }
    }

    /// Reactive wrapper for `setImage(_:for:)`
    public func image(for controlState: UIControl.State = []) -> Binder<UIImage?> {
        Binder(self.base) { button, image in
            button.setImage(image, for: controlState)
        }
    }

    /// Reactive wrapper for `setBackgroundImage(_:for:)`
    public func backgroundImage(for controlState: UIControl.State = []) -> Binder<UIImage?> {
        Binder(self.base) { button, image in
            button.setBackgroundImage(image, for: controlState)
        }
    }
    
}
