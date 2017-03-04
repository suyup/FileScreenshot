//
//  AppDelegate.swift
//  DocInteraction
//
//  Created by span on 3/3/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit
import QuartzCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIGestureRecognizerDelegate {

    var window: UIWindow?

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func tap(_ sender: UITapGestureRecognizer) {
        if sender.state == .began, let vc = AppDelegate.topViewController() as? EditorController {
            AppDelegate.screenshot(view: vc.view)
        }
    }

    @discardableResult
    class func screenshot(view: UIView) -> Bool {

        func screenshot(view: UIView) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);
            //        guard let context = UIGraphicsGetCurrentContext() else { return nil }
            //        view.layer.render(in: context)
            view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }

        let filename = "\(UUID().uuidString).png"
        print("take screenshot: \(filename)")
        guard let screenshot = screenshot(view: view) else { return false }
        let url = URL(fileURLWithPath: "\(FileManager.default.applicationDocumentsDirectory)/\(filename)")
        let res = try? UIImagePNGRepresentation(screenshot)?.write(to: url)
        return res == nil ? false : true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(AppDelegate.tap(_:)))
        gesture.numberOfTouchesRequired = 3
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        self.window?.addGestureRecognizer(gesture)
        self.window?.isUserInteractionEnabled = true
        return true
    }

    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        guard let name = identifierComponents.last as? String else { return nil }
        switch name {
        case "Preview": return PreviewController()
        default: return nil
        }
    }

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

