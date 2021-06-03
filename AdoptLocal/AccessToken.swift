//
//  AccessToken.swift
//  AdoptLocal
//
//  Created by Morgan Duverney on 6/1/21.
//

import Foundation

struct AccessToken: Decodable {
    let token: String
    let expiresIn: TimeInterval
    var expiresOn: Date {
        Date().addingTimeInterval(expiresIn)
    }
    
    func isValid() -> Bool {
        return Date() < expiresOn
    }
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case expiresIn = "expires_in"
    }
}
