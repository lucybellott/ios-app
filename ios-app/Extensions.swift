//
//  Extensions.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/19/24.
//

import Foundation

// Extension for rounded Double to 0 decimals

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}
