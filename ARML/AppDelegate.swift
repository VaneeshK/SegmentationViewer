//
//  AppDelegate.swift
//  ARML
//
//  Created by Vaneesh on 28/03/2020.
//  Copyright © 2020 All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let viewController = ARViewController()

        window?.rootViewController = viewController

        window?.makeKeyAndVisible()

        return true
    }
}
