//
//  Animal.swift
//  AdoptLocal
//
//  Created by Morgan Duverney on 6/1/21.
//

import Foundation

struct Animal: Decodable {
    let id: Int
    let type: String
    let age: String
    let gender: String
    let name: String
    let description: String?
}
