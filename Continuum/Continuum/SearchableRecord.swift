//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Bethany Wride on 10/16/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import Foundation

protocol SearchableProtocol {
    func matches(searchTerm: String) -> Bool
}
