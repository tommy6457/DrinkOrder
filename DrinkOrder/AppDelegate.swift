//
//  AppDelegate.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/8.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //修改BarButtonItem的字體(highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red: 216/255, green: 213/255, blue: 163/255, alpha: 1), .font: UIFont(name: "Songti TC", size: 15)!], for: .normal)
        //修改BarButtonItem的字體(highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red: 216/255, green: 213/255, blue: 163/255, alpha: 1), .font: UIFont(name: "Songti TC", size: 15)!], for: .highlighted)
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

