//
//  PreviewController.swift
//  DocInteraction
//
//  Created by span on 3/3/17.
//  Copyright © 2017 x. All rights reserved.
//

import Foundation
import QuickLook

class PreviewController: QLPreviewController {

    var url: URL!

    override var toolbarItems: [UIBarButtonItem]? {
        get { return nil }
        set {}
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.restorationIdentifier = "Preview"
        self.dataSource = self
        self.hidesBottomBarWhenPushed = true
    }

    convenience init(url: URL) {
        self.init()
        self.url = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.rightBarButtonItem?.action = #selector(PreviewController.tap(_:))
        self.screenshotTrigger.delegate = self
        self.view.addGestureRecognizer(self.screenshotTrigger)
    }

    func tap(_ sender: AnyObject) {
        self.view.screenshot()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(try? self.url.bookmarkData())
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        do {
            var stale: Bool = false
            self.url = try URL(resolvingBookmarkData: (coder.decodeObject() as? Data)!, bookmarkDataIsStale: &stale)
        } catch let error {
            print(error)
            self.url = URL(fileURLWithPath: "")
        }
    }
}

extension PreviewController: QLPreviewControllerDataSource {

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return FileManager.default.fileExists(atPath: self.url.path) ? 1 : 0
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.url as QLPreviewItem
    }
    
}
