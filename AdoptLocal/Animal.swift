//
//  Animal.swift
//  AdoptLocal
//
//  Created by Morgan Duverney on 6/1/21.
//

import Foundation

struct AnimalCollection: Decodable {
    let animals: [Animal]
}

struct Animal: Decodable, Hashable {
    let id: Int
    let type: String
    let age: String
    let gender: String
    let name: String
    let description: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
