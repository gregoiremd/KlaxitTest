//
//  Address.swift
//  KlaxitTest
//
//  Created by Grégoire Marchand on 22/03/2022.
//

import Foundation

class Address: Codable {
    
    var name: String
    var postcode: String
    var city: String
    var label: String

    init() {
        self.name = ""
        self.postcode = ""
        self.city = ""
        self.label = ""
    }
    
}
