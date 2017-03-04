//
//  WebViewController.swift
//  DocInteraction
//
//  Created by span on 3/3/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIScrollViewDelegate {

    var url: URL!

    private var lastOffsetY: CGFloat = 0
    private var hide: Bool = false

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
        self.screenshotTrigger.delegate = self
        self.view.addGestureRecognizer(self.screenshotTrigger)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastOffsetY = scrollView.contentOffset.y
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.hide = scrollView.contentOffset.y > self.lastOffsetY
        self.navigationController?.setNavigationBarHidden(self.hide, animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return self.hide
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
}
