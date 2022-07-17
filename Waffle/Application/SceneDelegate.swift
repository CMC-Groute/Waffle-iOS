//
//  SceneDelegate.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/03.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let navigationController = UINavigationController()
    var disposedBag = DisposeBag()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        self.appCoordinator = AppCoordinator(navigationController)
        appCoordinator?.start()
        WappleLog.debug("jwtToken \(UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken))")
        
        if let url = connectionOptions.urlContexts.first?.url, let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken)  {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            let queries = components.queryItems
            var archiveId: Int = 0
            var archiveCode: String = ""
            
            queries?.forEach { (item) in
                if item.name == "archiveId" {
                    archiveId = Int(item.value ?? "0")!
                }else if item.name == "archiveCode" {
                    archiveCode = item.value ?? "0"
                }
            }
            
            //check if user 이미 join 중
            guard var archiveIdList = UserDefaults.standard.array(forKey: UserDefaultKey.joinArchiveId) as? [Int] else {
                return
            }
            
            guard let tabBarCoordinator = self.appCoordinator?.findCoordinator(type: .tab) as? TabBarCoordinator,
            let homeCoordinator = self.appCoordinator?.findCoordinator(type: .home) as? HomeCoordinator else { return }
            tabBarCoordinator.selectPage(.home)
            
            if archiveIdList.contains(archiveId) { // 이미 참여 중
                homeCoordinator.detailArchive(archiveId: archiveId)
            }else { //새롭게 참여 필요
                let archiveUsecase = ArchiveUsecase(repository: ArchiveRepository(networkService: URLSessionNetworkService()))
                archiveUsecase.joinArchive(code: archiveCode)
                archiveUsecase.joinArhicveSuccess
                    .subscribe(onNext: { status, id in
                    if status == .success {
                        guard let id = id else { return }
                        archiveIdList.append(id)
                        UserDefaults.standard.synchronize()
                        homeCoordinator.detailArchive(archiveId: id)
                    }
                }).disposed(by: disposedBag)
            }
        }else {
            appCoordinator?.start()
        }

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
            
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            let queries = components.queryItems
            var archiveId: Int = 0
            var archiveCode: String = ""
            
            queries?.forEach { (item) in
                if item.name == "archiveId" {
                    archiveId = Int(item.value ?? "0")!
                }else if item.name == "archiveCode" {
                    archiveCode = item.value ?? "0"
                }
            }
            
            //check if user 이미 join 중
            guard var archiveIdList = UserDefaults.standard.array(forKey: UserDefaultKey.joinArchiveId) as? [Int] else { return }
            
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                  let appCoordinator = sceneDelegate.appCoordinator,
                  let tabBarCoordinator = appCoordinator.findCoordinator(type: .tab) as? TabBarCoordinator,
                  let homeCoordinator = appCoordinator.findCoordinator(type: .home) as? HomeCoordinator else { return }
            tabBarCoordinator.selectPage(.home)
            
            if archiveIdList.contains(archiveId) { // 이미 참여 중
                guard (homeCoordinator.navigationController.viewControllers.last
                       is DetailArchiveViewController == false) else { return }
                homeCoordinator.detailArchive(archiveId: archiveId)
            }else { //새롭게 참여 필요
                let archiveUsecase = ArchiveUsecase(repository: ArchiveRepository(networkService: URLSessionNetworkService()))
                archiveUsecase.joinArchive(code: archiveCode)
                archiveUsecase.joinArhicveSuccess.subscribe(onNext: { status, id in
                    if status == .success {
                        guard let id = id else { return }
                        archiveIdList.append(id)
                        UserDefaults.standard.synchronize()
                        homeCoordinator.detailArchive(archiveId: id)
                    }
                }).disposed(by: disposedBag)
            }
        }else {
            self.appCoordinator = AppCoordinator(navigationController)
            appCoordinator?.start()
        }
    }


}

