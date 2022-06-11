//
//  SignUpCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/10.
//

import Foundation
import UIKit

final class SignUpCoordinator: SignUpCoordinatorProtocol {
   
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var signUpViewController: SignUpViewController
    
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .signUp
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(false, animated: true)
        self.signUpViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        setNavigationBar()
    }
    
    func setNavigationBar() {
//        let backImage = UIImage(named: Asset.Assets.btn.name)!.withRenderingMode(.alwaysOriginal)
//        UINavigationBar.appearance().backIndicatorImage = backImage
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -80.0), for: .default)
        let rightBarButton = UIBarButtonItem(image: UIImage(named: Asset.Assets.btn.name), style: .plain, target: self, action: nil)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .red
        let segmentBarItem = UIBarButtonItem(customView: view)
        
        self.navigationController.navigationBar.topItem!.setRightBarButtonItems([UIBarButtonItem(systemItem: .bookmarks)], animated: true)
        print("right")
        print(self.navigationController.navigationBar.topItem?.rightBarButtonItem)
        self.navigationController.navigationBar.topItem?.backButtonTitle = "he"
        self.navigationController.navigationBar.topItem!.rightBarButtonItem = rightBarButton
    }
            
    func start() {
        self.signUpViewController.viewModel = SignUpViewModel(coordinator: self, usecase: UserUseCase(repository: UserRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func termsStep() {
        let termsViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        self.navigationController.pushViewController(termsViewController, animated: true)
    }
    
    func setProfileImage() {
        let setProfileImageViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SetProfileImageViewController") as! SetProfileImageViewController
        self.navigationController.pushViewController(setProfileImageViewController, animated: true)
    }
    
}
