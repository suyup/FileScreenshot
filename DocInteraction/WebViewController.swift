//
//  WebViewController.swift
//  DocInteraction
//
//  Created by span on 3/3/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIScrollViewDelegate, Snapshotable {

    var url: URL!

    convenience init(url: URL) {
        self.init()
        self.url = url
    }

    override func loadView() {
        self.view = UIWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.view as! UIWebView).loadRequest(URLRequest(url: self.url))
        (self.view as! UIWebView).scrollView.delegate = self
        self.snapshotTrigger.delegate = self
        self.view.addGestureRecognizer(self.snapshotTrigger)
    }

    var snapshotTrigger: UIGestureRecognizer {
        return self.snapshotTrigger(action: #selector(WebViewController.fire(_:)))
    }

    var dic: UIDocumentInteractionController?

    func fire(_ sender: UIGestureRecognizer) {
        if sender.state == .began, let view = sender.view, let url = view.snapshot() {
            dic = UIDocumentInteractionController(url: url)
            dic!.uti = "org.x.whiteboard"
            let res = dic!.presentOpenInMenu(from: view.frame, in: view, animated: true)
            precondition(res, "shoule be able to open in")
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
