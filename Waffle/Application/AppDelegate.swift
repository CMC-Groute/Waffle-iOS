//
//  AppDelegate.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/03.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        KakaoSDK.initSDK(appKey: NotificationKey.kakaoShareAPIAppKey)
        UNUserNotificationCenter.current().delegate = self
        //최초 한번 실행
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
                if granted {
                    print("알림 등록이 완료되었습니다.")
                }
            }
        application.registerForRemoteNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                   -> Void) {
       let userInfo = notification.request.content.userInfo
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo[NotificationKey.aps])
            let pushNofiticationInfo = try JSONDecoder().decode(PushNotification.self, from: jsonData)
            let archiveId = pushNofiticationInfo.archiveId
            configureDetailInfo(with: archiveId)
        }
        catch {
            print("pushNofiticationInfo \(error)")
        }
        
       completionHandler([[.alert, .sound]])
     }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
         do {
             let jsonData = try JSONSerialization.data(withJSONObject: userInfo[NotificationKey.aps])
             let pushNofiticationInfo = try JSONDecoder().decode(PushNotification.self, from: jsonData)
             let archiveId = pushNofiticationInfo.archiveId
             configureDetailInfo(with: archiveId)
         }
         catch {
             print("pushNofiticationInfo \(error)")
         }

        completionHandler()
      }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
         do {
             let jsonData = try JSONSerialization.data(withJSONObject: userInfo[NotificationKey.aps])
             let pushNofiticationInfo = try JSONDecoder().decode(PushNotification.self, from: jsonData)
             let archiveId = pushNofiticationInfo.archiveId
             configureDetailInfo(with: archiveId)
         }
         catch {
             print("pushNofiticationInfo \(error)")
         }

      // Print full message.
      WappleLog.debug("didReceiveRemoteNotification \(userInfo)")
      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    private func configureDetailInfo(with archiveId: Int) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let appCoordinator = sceneDelegate.appCoordinator,
              let tabBarCoordinator = appCoordinator.findCoordinator(type: .tab) as? TabBarCoordinator,
              let homeCoordinator = appCoordinator.findCoordinator(type: .home) as? HomeCoordinator else { return }
        tabBarCoordinator.selectPage(.home)
        guard (homeCoordinator.navigationController.viewControllers.last
               is DetailArchiveViewController == false) else { return }
        homeCoordinator.detailArchive(archiveId: archiveId)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let deviceToken = fcmToken {
            WappleLog.debug("FCM Token \(deviceToken)")
            UserDefaults.standard.set(deviceToken, forKey: UserDefaultKey.deviceToken)
        }
    }
}
