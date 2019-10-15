//
//  DateFormatter.swift
//  Continuum
//
//  Created by Bethany Wride on 10/15/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import Foundation

extension Date {
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
