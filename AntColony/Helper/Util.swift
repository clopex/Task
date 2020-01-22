//
//  Util.swift
//  AntColony
//
//  Created by Adis Mulabdic on 11/01/2020.
//  Copyright © 2020 Adis Mulabdic. All rights reserved.
//

import Foundation

class Util {
    static func isValidEmail(mail: String?) -> Bool {
        guard let mail = mail else {
            return false
        }
        let emailRegex = "[A-Za-z]+[A-Z0-9a-z\\._%+-]+@[A-Za-z]+[A-Za-z0-9\\.-]*\\.[A-Za-z]{2,3}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: mail)
    }
}
