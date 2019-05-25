//
//  DataHelper.swift
//  Eleven Contacts
//
//  Created by Fabio Luiz on 25/05/19.
//  Copyright © 2019 Jobsity. All rights reserved.
//

import Foundation

class DataHelper {
    
    static func getJsonData() -> Data? {
        if let path = Bundle.main.path(forResource: "contacts", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch let error as NSError {
                print("Core Data Error: \(error.debugDescription)")
            }
        }
        return nil
    }
}
