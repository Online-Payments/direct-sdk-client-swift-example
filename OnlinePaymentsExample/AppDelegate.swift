//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        SVProgressHUD.setDefaultStyle(.dark)

        let shop = StartViewController()
        let nav = UINavigationController(rootViewController: shop)

        window?.rootViewController = nav
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        return true
    }
}
