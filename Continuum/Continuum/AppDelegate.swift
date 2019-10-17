//
//  AppDelegate.swift
//  Continuum
//
//  Created by Bethany Wride on 10/15/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

// MARK: - Custom Functions
    func checkiCloudAccountStatus(completion: @escaping (_ success: Bool) -> Void) {
        CKContainer.default().accountStatus { (accountStatus, error) in
            if let error = error {
                print("Error checking iCloud account status : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            } else {
                DispatchQueue.main.async {
                    let tabBarController = self.window?.rootViewController
                    let errorText = "Sign into iCloud in Settings"
                    switch accountStatus {
                    case .available:
                        completion(true)
                    case .noAccount:
                        tabBarController?.presentSimpleAlertWith(title: errorText, message: "No Account Found")
                        completion(false)
                    case .couldNotDetermine:
                        tabBarController?.presentSimpleAlertWith(title: errorText, message: "Unknown error fetching your iCloud account")
                        completion(false)
                    case .restricted:
                        tabBarController?.presentSimpleAlertWith(title: errorText, message: "Your iCloud account is restricted")
                    @unknown default:
                        print("Unknown case")
                        completion(false)
                    }
                }
            }
        }
    } // End of function
} // End of class
