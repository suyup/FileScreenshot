//
//  UIView+Screenshot.swift
//  DocInteraction
//
//  Created by span on 3/4/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {

    @discardableResult
    func screenshot(destination dir: String = FileManager.default.applicationDocumentsDirectory) -> Bool {
        let filename = "\(UUID().uuidString).png"
        print("take screenshot: \(filename)")
        guard let screenshot = self.screenshot(view: self) else { return false }
        let url = URL(fileURLWithPath: "\(dir)/\(filename)")
        do {
            try UIImagePNGRepresentation(screenshot)?.write(to: url)
        } catch let error {
            print(error)
            return false
        }
        return true
    }

    fileprivate func screenshot(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        view.layer.render(in: context)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
