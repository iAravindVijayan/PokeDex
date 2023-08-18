//
//  HeaderView.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-19.
//

import SwiftUI
import Combine

struct HeaderView: View {
    @StateObject var viewModel: PokedexViewModel
    private var viewSavedPokemons: PassthroughSubject<Void, Never>
    
    init(viewModel: PokedexViewModel, viewSavedPokemons: PassthroughSubject<Void, Never>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.viewSavedPokemons = viewSavedPokemons
    }

    var body: some View {
        HStack {
            Text(UIStrings.homeScreenTitle.localized)
                .font(.bold(.title)())
            Spacer()
            Image("PokeBall")
                .resizable()
                .frame(width: 40, height: 40)
                .offset(x: viewModel.didSave ? -15 : 0, y: viewModel.didSave ? 8 : 0)
                .scaleEffect(viewModel.didSave ? 1.5 : 1, anchor: .bottomLeading)
                .animation(.interpolatingSpring(stiffness: 170, damping: 8).delay(0.1), value: viewModel.didSave)
                .onTapGesture {
                    viewSavedPokemons.send()
                }
        }
    }
}

struct Headerview_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(viewModel: PokedexViewModel(), viewSavedPokemons: PassthroughSubject<Void, Never>())
    }
}
