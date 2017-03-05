//
//  Bundle.swift
//  DocInteraction
//
//  Created by span on 3/5/17.
//  Copyright © 2017 x. All rights reserved.
//

import Foundation

extension Bundle {
    var appGroupID: String {
        var components = Bundle.main.bundleIdentifier?.components(separatedBy: ".")
        components?.removeLast()
        let str = components?.joined(separator: ".")
        return str == nil ? "" : "group.\(str!)"
    }
}
