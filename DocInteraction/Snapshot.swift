
//
//  Snapshot.swift
//  DocInteraction
//
//  Created by span on 3/5/17.
//  Copyright © 2017 x. All rights reserved.
//

import UIKit

enum SendStrategy {
    case docInteratcion
    case sharedPasteboard
    case sharedContainer
}

class Snapshot {

    static var sendStrategy: SendStrategy = .sharedPasteboard

    var view: UIView?
    var url: URL?
    var data: Data? {
        return url == nil ? nil : try? Data(contentsOf: url!)
    }
    var image: UIImage? {
        return data == nil ? nil : UIImage(data: data!)
    }

    private let pasteboard = UIPasteboard.withUniqueName()
    private static var dic: UIDocumentInteractionController?

    convenience init(on view: UIView, send: Bool = true, strategy: SendStrategy = .sharedPasteboard) {
        self.init()
        Snapshot.sendStrategy = strategy
        if self.take(view), send == true {
            let _ = self.send()
        }
    }

    func take(_ view: UIView) -> Bool {
        self.view = view
        url = view.snapshot(to: FileManager.default.documentDir)
        return url != nil
    }

    func send() -> Bool {
        guard let url = url else { return false }
        switch Snapshot.sendStrategy {
        case .docInteratcion:
            if let dic = Snapshot.dic {
                dic.url = url
            } else {
                Snapshot.dic = UIDocumentInteractionController(url: url)
            }
            return sendTo(docInteration: Snapshot.dic!)
        case .sharedPasteboard:
            return sendTo(pasteboard: self.pasteboard)
        case .sharedContainer:
            return sendTo(sharedContainer: FileManager.default.appGroupDir)
        }
    }

    private func sendTo(pasteboard: UIPasteboard) -> Bool {
        guard let image = image else { return false }
        var res = false
        let name = pasteboard.name.rawValue
        pasteboard.image = image
        if let url = URL(string: "awwb://snapshot?pasteboard=\(name)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                print("open \(url) success: \(success)")
                res = success
            }
        }
        return res
    }

    private func sendTo(sharedContainer path: String) -> Bool {
        var res = false
        if FileManager.default.fileExists(atPath: path) {
            let destination = URL(fileURLWithPath: "\(path)/\(UUID().uuidString).png")
            if let _ = try? FileManager.default.copyItem(at: url!, to: destination),
                let outurl = URL(string: "awwb://snapshot?path=\(destination.path)"),
                UIApplication.shared.canOpenURL(outurl) {
                UIApplication.shared.open(outurl, options: [:]) { success in
                    print("open \(outurl) success: \(success)")
                    res = success
                }
            }
        }
        return res
    }

    private func sendTo(docInteration dic: UIDocumentInteractionController) -> Bool {
        guard let view = view else { return false }
        dic.uti = "org.x.whiteboard"
        return dic.presentOpenInMenu(from: view.frame, in: view, animated: true)
    }
}
