//
//  AccessToken.swift
//  AdoptLocal
//
//  Created by Morgan Duverney on 6/1/21.
//

import Foundation

struct AccessToken: Decodable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}
