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
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case abilities
        case id
        case avatar
        case sprites
        case other
        case official = "official-artwork"
        case frontDefault = "front_default"
    }
    
    init() {
        name = ""
        abilities = []
        id = -100
        avatar = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sprites = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .sprites)
        let other = try sprites.nestedContainer(keyedBy: CodingKeys.self, forKey: .other)
        let official = try other.nestedContainer(keyedBy: CodingKeys.self, forKey: .official)
        avatar = try official.decode(String.self, forKey: .frontDefault)
        name = try container.decode(String.self, forKey: .name)
        abilities = try container.decode([Abilities].self, forKey: .abilities)
        id = try container.decode(Int.self, forKey: .id)
    }
}


extension Pokemon {
    init(with coredataModel: PokemonModel) {
        name = coredataModel.name.unwrapped()
        id = Int(coredataModel.id)
        abilities = coredataModel.abilities?.components(separatedBy: ", ").map { Abilities(name: $0) } ?? []
        avatar = coredataModel.avatarURL.unwrapped()
    }
}
