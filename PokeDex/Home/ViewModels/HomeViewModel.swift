//
//  HomeViewModel.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    
    typealias Input = (saveTapped: AnyPublisher<Void, Never>,
                       nextTapped: AnyPublisher<Void, Never>
    )
    
    private var pokedex = CurrentValueSubject<Pokedex, Never>(Pokedex())
    private var pokemonDetails = PassthroughSubject<Pokemon, Never>()

    
    @Published var avatarURL: URL?
    @Published var name: String = ""
    @Published var abilities: String = ""
    @Published var isLoading: Bool = true
    private var cancellableBag = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func fetchPokedox() {
        NetworkManager.shared.sendRequest(url: URL(string: API.pokedex.urlString)!)
            .replaceError(with: Pokedex())
            .sink { [weak self] pokedex in
                self?.pokedex.send(pokedex)
                self?.fetchRandomPokemon()
            }
            .store(in: &cancellableBag)
    }
    
    private func fetchPokemon(with id: String) {
        NetworkManager.shared.sendRequest(url: URL(string: String(format: API.pokemonDetails.urlString, id))!)
            .replaceEmpty(with: Pokemon())
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] pokemon in
                print(pokemon)
                self?.pokemonDetails.send(pokemon)
            })
            .store(in: &cancellableBag)
    }
    
    private func setupBindings() {
        isLoading = true
        fetchPokedox()
        
        pokemonDetails
            .sink { [weak self] pokemon in
                self?.name = pokemon.name.capitalized
                self?.avatarURL = URL(string: pokemon.avatar)
                self?.abilities = UIStrings.homeAbilities.localized + pokemon.abilities.map { $0.name }.joined(separator: ", ")
            }
            .store(in: &cancellableBag)

    }
    
    private func fetchRandomPokemon() {
        guard let randomPokemon = pokedex.value.pokemonEntries.randomElement() else {
            return
        }
        fetchPokemon(with: String(randomPokemon.id))
    }
    
    func process(_ input: Input) {
        input.saveTapped.sink { _ in
            print("Save tapped")
        }
        .store(in: &cancellableBag)
        
        input.nextTapped.sink { [weak self] _ in
            self?.fetchRandomPokemon()
        }
        .store(in: &cancellableBag)
    }
}
