//
//  Log.swift
//  Eleven Contacts
//
//  Created by Fabio Luiz on 27/05/19.
//  Copyright © 2019 Jobsity. All rights reserved.
//

import Foundation
import os.log

// MARK: Log class
class Log {
    public static func d(message log: StaticString) {
        os_log(log, log: OSLog.default, type: .debug)
    }
}
