//
//  WebViewController.swift
//  DocInteraction
//
//  Created by span on 3/3/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

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
        self.snapshotTrigger.delegate = self
        self.view.addGestureRecognizer(self.snapshotTrigger)
    }
}
