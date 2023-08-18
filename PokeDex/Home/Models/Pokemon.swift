//
//  Pokemon.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import Foundation

struct Pokemon: Decodable {
    let name: String
    let abilities: [Abilities]
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "pokemon_entries"
        case abilities
        case id
    }
}
