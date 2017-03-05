//
//  AppDelegate.swift
//  DocInteraction
//
//  Created by span on 3/3/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication,
                     viewControllerWithRestorationIdentifierPath identifierComponents: [Any],
                     coder: NSCoder) -> UIViewController? {
        guard let name = identifierComponents.last as? String else { return nil }
        switch name {
        case "Preview": return PreviewController()
        default: return nil
        }
    }
}

extension AppDelegate {

    class func topViewController(on viewController: UIViewController? = nil) -> UIViewController? {
        var window: UIWindow?
        if let mainWindow = UIApplication.shared.delegate?.window {
            window = mainWindow
        } else {
            window = UIApplication.shared.windows.first
        }

        var vc: UIViewController? = viewController ?? window?.rootViewController

        if let v = vc as? UITabBarController {
            vc = v.selectedViewController!
        }

        if let v = vc as? UINavigationController {
            if let t = v.visibleViewController {
                vc = t
            } else if let t = v.topViewController {
                vc = t
            }
        }

        while let v = vc?.presentedViewController, (v as? UIAlertController) == nil {
            vc = vc?.presentedViewController
        }

        if let v = vc as? UINavigationController, let t = v.topViewController {
            vc = t
        }
        
        return vc
    }
}

