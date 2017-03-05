//
//  FileManager+Path.swift
//  DocInteraction
//
//  Created by span on 3/3/17.
//  Copyright © 2017 x. All rights reserved.
//

import Foundation

extension FileManager {

    var documentDir: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    }

    var temporaryDir: String {
        return NSTemporaryDirectory()
    }

    var appGroupDir: String {
        return self.containerURL(forSecurityApplicationGroupIdentifier: "app-group-id")?.path ?? ""
    }
}
