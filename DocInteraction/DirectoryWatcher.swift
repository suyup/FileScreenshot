//
//  DirectoryWatcher.swift
//  DocInteraction
//
//  Created by span on 3/3/17.
//  Copyright © 2017 x. All rights reserved.
//

import Foundation

protocol DirectoryWatcherDelegate: class {
    func directoryDidChange(_ folderWatcher: DirectoryWatcher)
}

class DirectoryWatcher {

    weak var delegate: DirectoryWatcherDelegate?
    private var dirFD: CInt = -1
    private var dirKQRef: DispatchSourceProtocol?

    deinit {
        self.invalidate()
    }

    class func watchFolderWithPath(_ watchPath: String, delegate watchDelegate: DirectoryWatcherDelegate) -> DirectoryWatcher? {
        let watcher = DirectoryWatcher()
        watcher.delegate = watchDelegate
        if watcher.startMonitoringDirectory(watchPath) {
            return watcher
        }
        return nil
    }

    func invalidate() {
        if dirKQRef != nil {
            dirKQRef!.cancel()
            dirKQRef = nil
        }

        if dirFD != -1 {
            close(dirFD)
            dirFD = -1
        }
    }

    private func kqueueFired() {
        delegate?.directoryDidChange(self)
    }

    private func startMonitoringDirectory(_ dirPath: String) -> Bool {
        if dirKQRef == nil && dirFD == -1 {
            dirFD = open((dirPath as NSString).fileSystemRepresentation, O_EVTONLY)
            if dirFD >= 0 {
                let dispatchSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: dirFD, eventMask: DispatchSource.FileSystemEvent.write, queue: DispatchQueue.main)
                dispatchSource.setEventHandler { [weak self] in
                    self?.kqueueFired()
                }
                dispatchSource.resume()
                dirKQRef = dispatchSource
                return true
            }
        }
        return false
    }
}
