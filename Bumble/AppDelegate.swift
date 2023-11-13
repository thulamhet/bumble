//
//  AppDelegate.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 29/06/2023.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        @available(iOS 9.0, *)
        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return true}
                    
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
                    
            GIDSignIn.sharedInstance.configuration = config
            let handled = GIDSignIn.sharedInstance.handle(url)
            return handled
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

