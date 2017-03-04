//
//  EditorController.swift
//  DocInteraction
//
//  Created by span on 3/3/17.
//  Copyright © 2017 x. All rights reserved.
//

import Foundation
import UIKit

class EditorController: UIViewController {

    var url: URL!
    var isModified = false {
        didSet {
            self.navigationItem.rightBarButtonItem?.isEnabled = isModified
        }
    }

    convenience init(url: URL) {
        self.init()
        self.url = url
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func loadView() {
        self.view = UITextView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let string = try? String(contentsOfFile: self.url.path, encoding: .utf8) {
            (self.view as! UITextView).text = string
        }
        self.navigationItem.title = (self.url.path as NSString).lastPathComponent
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(EditorController.onSave(_:)))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onTextViewChange(notification:)),
            name: .UITextViewTextDidChange,
            object: self.view
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    func onTextViewChange(notification: Notification) {
        self.isModified = true
    }

    func onSave(_ sender: UIBarButtonItem) {
        if self.isModified {
            try? (self.view as! UITextView).text.write(to: self.url, atomically: true, encoding: .utf8)
            self.isModified = false
            self.view.resignFirstResponder()
        }
    }

}
