//
//  Screenshotable.swift
//  DocInteraction
//
//  Created by span on 3/4/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit

protocol Screenshotable: UIGestureRecognizerDelegate {

    func screenshotTrigger(action: Selector) -> UIGestureRecognizer

    func fire(_ sender: UIGestureRecognizer)
}

extension Screenshotable {

    func screenshotTrigger(action: Selector) -> UIGestureRecognizer {
        let press = UILongPressGestureRecognizer(target: self, action: action)
        press.numberOfTouchesRequired = 3
        press.cancelsTouchesInView = false
        return press
    }
}

extension UIViewController: Screenshotable {

    var screenshotTrigger: UIGestureRecognizer {
        return self.screenshotTrigger(action: #selector(UIViewController.fire(_:)))
    }

    func fire(_ sender: UIGestureRecognizer) {
        if sender.state == .began, let view = sender.view {
            view.screenshot()
        }
    }
}
