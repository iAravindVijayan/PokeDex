//
//  API.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import Foundation

let kBaseURL = "https://pokeapi.co/api/v2/"

enum API: String {
    case pokedex = "pokedex/1/"
    case evolutionChain = "evolution-chain/%@"
    case pokemonDetails = "pokemon/%@"

    var urlString: String {
        return kBaseURL + self.rawValue
    }
}
