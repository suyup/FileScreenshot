//
//  UIView+snapshot.swift
//  DocInteraction
//
//  Created by span on 3/4/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {

    @discardableResult
    func snapshot(destination dir: String = FileManager.default.applicationDocumentsDirectory) -> URL? {
        let filename = "\(UUID().uuidString).png"
        print("take snapshot: \(filename)")
        guard let snapshot = self.snapshot(view: self) else { return nil }
        let url = URL(fileURLWithPath: "\(dir)/\(filename)")
        do {
            try UIImagePNGRepresentation(snapshot)?.write(to: url)
        } catch let error {
            print(error)
            return nil
        }
        return url
    }

    fileprivate func snapshot(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        view.layer.render(in: context)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
