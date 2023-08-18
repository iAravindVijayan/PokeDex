//
//  PokeDex.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import Foundation

struct Pokedex: Decodable {
    let pokemonEntries: [PokemonEntry]
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case pokemonEntries = "pokemon_entries"
        case name
    }
    
    init() {
        pokemonEntries = []
        name = ""
    }
}


struct PokemonEntry: Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "entry_number"
        case name
        case pokemonSpecies = "pokemon_species"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let pokemonSpecies = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .pokemonSpecies)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try pokemonSpecies.decode(String.self, forKey: .name)
    }
}

extension PokemonEntry: Hashable {
    init(with coredataModel: PokemonModel) {
        name = coredataModel.name.unwrapped()
        id = Int(coredataModel.id)
    }
    
    
}
