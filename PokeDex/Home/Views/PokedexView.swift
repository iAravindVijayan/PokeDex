//
//  ContentView.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import SwiftUI
import Combine

struct PokedexView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel: PokedexViewModel
    
    //MARK: Inputs for viewModel
    private var saveTapped = PassthroughSubject<Void, Never>()
    private var nextTapped = PassthroughSubject<Void, Never>()
    private var tappedPokemon = PassthroughSubject<Int, Never>()
    private var viewAppeared = PassthroughSubject<Void, Never>()
    private var viewSavedPokemons = PassthroughSubject<Void, Never>()
    
    init(viewModel: PokedexViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        viewModel.process((
            saveTapped: saveTapped.eraseToAnyPublisher(),
            nextTapped: nextTapped.eraseToAnyPublisher(),
            viewAppeared: viewAppeared.eraseToAnyPublisher(),
            viewSavedPokemons: viewSavedPokemons.eraseToAnyPublisher(),
            tappedPokemon: tappedPokemon.eraseToAnyPublisher()
        ))
    }
    
    var body: some View {
        ZStack {
            Color.pokeRed
                .ignoresSafeArea()
            VStack {
                HeaderView(viewModel: viewModel, viewSavedPokemons: viewSavedPokemons)
                ZStack(alignment: .init(horizontal: .center, vertical: .top)) {
                    VStack {
                        AvatarView(viewModel: viewModel)
                        DescriptionView(viewModel: viewModel)
                        FooterView(viewModel: viewModel, saveTapped: saveTapped, nextTapped: nextTapped)
                    }
                    if viewModel.showPokemonList {
                        List(viewModel.pokemonDatasource, id: \.self) { pokemon in
                            HStack{
                                Text(pokemon.name.capitalized)
                                    .foregroundColor(Color.darkGray)
                                    .font(.title2)
                                Spacer()
                            }
                            .background(Color.white)
                            .onTapGesture {
                                tappedPokemon.send(pokemon.id)
                            }
                        }
                        .background(Color.white)
                        .frame(height: 200)
                        .listStyle(PlainListStyle())
                        .cornerRadiusWithBorder()
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16))
        }.onChange(of: scenePhase) { newValue in
            if newValue == .active {
                viewAppeared.send()
            }
        }
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView(viewModel: PokedexViewModel())
    }
}
