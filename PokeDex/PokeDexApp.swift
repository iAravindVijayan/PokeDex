//
//  PokeDexApp.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import SwiftUI

@main
struct PokeDexApp: App {
    var body: some Scene {
        WindowGroup {
            PokedexView(viewModel: HomeViewModel())
        }
    }
}
