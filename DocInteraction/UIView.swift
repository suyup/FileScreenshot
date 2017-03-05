//
//  UIView+Snapshot.swift
//  DocInteraction
//
//  Created by span on 3/4/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {

    func snapshot(to dir: String) -> URL? {
        guard let image = self.snapshot(), let data = UIImagePNGRepresentation(image) else {
            print("take snapshot fails")
            return nil
        }
        let filename = "\(UUID().uuidString).png"
        print("take snapshot success: \(filename)")
        let url = URL(fileURLWithPath: "\(dir)/\(filename)")
        do {
            try data.write(to: url)
        } catch {
            return nil
        }
        return url
    }

    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0);
        self.drawHierarchy(in: self.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
