//
//  SceneDelegate.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        WappleLog.debug("jwtToken \(UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken))")
        self.appCoordinator = AppCoordinator(navigationController)
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {    
        if let url = URLContexts.first?.url, UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) != nil {
            //example: kakao9d221cbc36f57f5d7e31879b43c6a546://kakaolink?archiveId=19

            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            print(components.queryItems?.first?.name) // archiveId
            let archiveId = components.queryItems?.first?.value ?? "0"
            print(components.queryItems?.first?.value) // 19
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                  let appCoordinator = sceneDelegate.appCoordinator,
                  let tabBarCoordinator = appCoordinator.findCoordinator(type: .tab) as? TabBarCoordinator,
                  let homeCoordinator = appCoordinator.findCoordinator(type: .home) as? HomeCoordinator else { return }
            tabBarCoordinator.selectPage(.home)
            print("homeCoordinator.navigationController.viewControllers.last \(homeCoordinator.navigationController.viewControllers.last)")
            guard (homeCoordinator.navigationController.viewControllers.last
                   is DetailArchiveViewController == false) else { return }
            //마지막 화면이 DetailArchiveViewController가 아니였다면
            homeCoordinator.detailArchive(archiveId: Int(archiveId)!)
            
        }
//        else { // Login 화면으로 이동
//            self.appCoordinator = AppCoordinator(navigationController)
//            appCoordinator?.start()
//        }
    }


}

