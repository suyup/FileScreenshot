//
//  UIViewController.swift
//  DocInteraction
//
//  Created by span on 3/4/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit

protocol Snapshotable: UIGestureRecognizerDelegate {

    func snapshotTrigger(action: Selector) -> UIGestureRecognizer

    func fireSnapshot(_ sender: UIGestureRecognizer)
}

extension UIViewController: Snapshotable {

    func snapshotTrigger(action: Selector) -> UIGestureRecognizer {
        let press = UILongPressGestureRecognizer(target: self, action: action)
        press.numberOfTouchesRequired = 3
        press.cancelsTouchesInView = false
        return press
    }

    var snapshotTrigger: UIGestureRecognizer {
        return self.snapshotTrigger(action: #selector(UIViewController.fireSnapshot(_:)))
    }

    func fireSnapshot(_ sender: UIGestureRecognizer) {
        if sender.state == .began, let view = sender.view {
            let _ = Snapshot(on: view, strategy: SendStrategy.docInteratcion)
        }
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
