//
//  File.swift
//  
//
//  Created by Noel Conde Algarra on 9/12/23.
//

import Foundation
import OSLog

public extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let network = Logger(subsystem: subsystem, category: "network")
}
