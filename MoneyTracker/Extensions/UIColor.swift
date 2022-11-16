//
//  UIColor.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 16.11.2022.
//

import SwiftUI

extension UIColor {
    class func color(data: Data) -> UIColor? {
        return try?
        NSKeyedUnarchiver.unarchivedObject(ofClass: self, from: data) as? UIColor
    }

    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self,
                                                 requiringSecureCoding: false)
    }
}
