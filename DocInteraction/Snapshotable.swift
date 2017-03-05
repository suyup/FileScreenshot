//
//  Snapshotable.swift
//  DocInteraction
//
//  Created by span on 3/4/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit

protocol Snapshotable: UIGestureRecognizerDelegate {

    func snapshotTrigger(action: Selector) -> UIGestureRecognizer

    func fire(_ sender: UIGestureRecognizer)
}

extension Snapshotable {

    func snapshotTrigger(action: Selector) -> UIGestureRecognizer {
        let press = UILongPressGestureRecognizer(target: self, action: action)
        press.numberOfTouchesRequired = 3
        press.cancelsTouchesInView = false
        return press
    }
}
