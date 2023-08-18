//
//  Abilities.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import Foundation

struct Abilities: Decodable {
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case ability
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let abilitiy = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .ability)
        self.name = try abilitiy.decode(String.self, forKey: .name)
        self.url = try abilitiy.decode(String.self, forKey: .url)
    }
}
