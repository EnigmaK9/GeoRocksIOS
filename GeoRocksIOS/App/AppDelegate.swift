//
//  AppDelegate.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 12/12/24.
//
//  Description:
//  The AppDelegate handles Firebase configuration and other app lifecycle events.
//

import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Firebase is configured when the app launches.
        FirebaseApp.configure()
        return true
    }
}
