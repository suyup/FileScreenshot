//
//  TableViewController.swift
//  DocInteraction
//
//  Created by span on 3/3/17.
//  Copyright © 2017 x. All rights reserved.
//

import MobileCoreServices
import UIKit
import QuickLook

let sampleDocs: [String] = [
    "Text Document.txt",
    "Image Document.jpg",
    "PDF Document.pdf",
    "HTML Document.html"
]

class TableViewController: UITableViewController {

    fileprivate var dirWatcher: DirectoryWatcher!
    fileprivate var documents: [URL] = []
    fileprivate var docInteractionController: UIDocumentInteractionController!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let watcher = DirectoryWatcher.watchFolderWithPath(FileManager.default.applicationDocumentsDirectory, delegate: self) {
            self.dirWatcher = watcher
            self.directoryDidChange(self.dirWatcher)
        } else {
            fatalError("cannot initiate directory watcher")
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TableViewController.addPressed(_:)))
    }

    // Mark:

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.documents.count > 0 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sampleDocs.count
        } else {
            return self.documents.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Sample Documents"
        } else {
            return "Document Folder"
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!

        let fileURL = self.fileURL(at: indexPath)
        self.setupDocInteractionController(url: fileURL)

        cell.imageView?.image = self.docInteractionController.icons.last
        cell.textLabel?.text = fileURL.lastPathComponent
        if let fileAttributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
            let fileSize = fileAttributes[FileAttributeKey.size] as? NSNumber {
            let fileSizeStr = ByteCountFormatter.string(fromByteCount: fileSize.int64Value, countStyle: .file)
            let uti = self.docInteractionController.uti ?? "unknown"
            cell.detailTextLabel?.text = "\(fileSizeStr) - \(uti)"
        }

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(TableViewController.handleLongPress(_:)))
        cell.imageView?.addGestureRecognizer(gesture)
        cell.imageView?.isUserInteractionEnabled = true

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = self.fileURL(at: indexPath)
        self.setupDocInteractionController(url: url)
        let uti = self.docInteractionController.uti ?? "unknown"
        let controller: UIViewController
        if uti == kUTTypePlainText as String {
            controller = EditorController(url: url)
        } else {
            controller = WebViewController(url: url)
        }

        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 { return nil }
        let rowAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let url = self.fileURL(at: indexPath)
            try? FileManager.default.removeItem(at: url)
        }
        return [rowAction]
    }

    // Mark:

    fileprivate func fileURL(at indexPath: IndexPath) -> URL {
        var fileURL: URL
        if indexPath.section == 0 {
            let path = Bundle.main.path(forResource: sampleDocs[indexPath.row], ofType: nil)
            fileURL = URL(fileURLWithPath: path!)
        } else {
            fileURL = self.documents[indexPath.row]
        }
        return fileURL
    }

    fileprivate func setupDocInteractionController(url: URL) {
        if self.docInteractionController == nil {
            self.docInteractionController = UIDocumentInteractionController(url: url)
        } else {
            self.docInteractionController.url = url
        }
    }

    func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if let indexPath = self.tableView.indexPathForRow(at: sender.location(in: self.tableView)),
                let view = sender.view {
                let fileURL = self.fileURL(at: indexPath)
                self.setupDocInteractionController(url: fileURL)
                let res = self.docInteractionController.presentOpenInMenu(from: view.frame, in: view, animated: true)
                precondition(res, "display open in fails")
            }
        }
    }

    func addPressed(_ sender: UIBarButtonItem) {
        self.present(self.addFileAlertController, animated: true, completion: nil)
    }

    fileprivate var addFileAlertController: UIAlertController {
        let alert = UIAlertController(title: "Add", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            if var text = alert.textFields?.first?.text?.trimmingCharacters(in: .illegalCharacters) {
                if text.characters.count == 0 {
                    text = alert.textFields!.first!.placeholder!
                }
                self.addNewFile(name: text)
            }
        }
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { textField in
            textField.placeholder = "New File"
        }
        return alert
    }

    fileprivate func addNewFile(name: String) {
        let path = (FileManager.default.applicationDocumentsDirectory as NSString).appendingPathComponent("\(name).txt")
        let data = "new file".data(using: .utf8)
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }
}

extension TableViewController: DirectoryWatcherDelegate {

    func directoryDidChange(_ folderWatcher: DirectoryWatcher) {
        self.documents.removeAll(keepingCapacity: true)
        let docDirPath = FileManager.default.applicationDocumentsDirectory
        let docDirContents = (try? FileManager.default.contentsOfDirectory(atPath: docDirPath)) ?? []

        for filename in docDirContents {
            let filePath = (docDirPath as NSString).appendingPathComponent(filename)
            let fileURL = URL(fileURLWithPath: filePath)

            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory), !isDirectory.boolValue {
                self.documents.append(fileURL)
            }
        }

        self.tableView.reloadData()
    }

}

