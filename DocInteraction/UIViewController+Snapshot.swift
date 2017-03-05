//
//  UIViewController+Snapshot.swift
//  DocInteraction
//
//  Created by span on 3/4/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit

protocol Snapshotable: UIGestureRecognizerDelegate {

    var snapshotTrigger: UIGestureRecognizer { get }

    func fireSnapshot(_ sender: UIGestureRecognizer)
}

extension UIViewController: Snapshotable {

    var snapshotTrigger: UIGestureRecognizer {
        let press = UILongPressGestureRecognizer(target: self,
                                                 action: #selector(UIViewController.fireSnapshot(_:)))
        press.numberOfTouchesRequired = 3
        press.cancelsTouchesInView = false
        return press
    }

    func fireSnapshot(_ sender: UIGestureRecognizer) {
        if sender.state == .began, let view = sender.view {
            let _ = Snapshot(on: view)
        }
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
