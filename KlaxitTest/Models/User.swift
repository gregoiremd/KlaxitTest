//
//  User.swift
//  KlaxitTest
//
//  Created by Grégoire Marchand on 22/03/2022.
//

import Foundation

struct User: Codable {
    
    var firstName: String
    var lastName: String
    var pictureUrl: String
    var phoneNumber: String?
    var company: String?
    var profession: String?
    var address: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case pictureUrl = "picture_url"
        case phoneNumber = "phone_number"
        case company
        case profession = "job_position"
        case address
    }
    
}
