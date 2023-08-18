//
//  HomeViewModel.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import Combine
import Foundation

final class PokedexViewModel: ObservableObject {
    
    //MARK:- View Inputs
    typealias Input = (saveTapped: AnyPublisher<Void, Never>,
                       nextTapped: AnyPublisher<Void, Never>,
                       viewAppeared: AnyPublisher<Void, Never>,
                       viewSavedPokemons: AnyPublisher<Void, Never>,
                       tappedPokemon: AnyPublisher<Int, Never>
    )
    
    private var pokedex = CurrentValueSubject<Pokedex, Never>(Pokedex())
    private var pokemonDetails = CurrentValueSubject<Pokemon, Never>(Pokemon())

    //MARK:- View Outputs
    @Published var avatarURL: URL?
    @Published var name: String = ""
    @Published var abilities: String = ""
    @Published var didSave: Bool = false
    @Published var pokemonDatasource: [PokemonEntry] = []
    @Published var showPokemonList: Bool = false
    
    private var cancellableBag = Set<AnyCancellable>()
    private let networkManager: NetworkManager
    private let coreDataManager: CoreDataManager
    
    init(networkManager: NetworkManager = NetworkManager.shared,
         coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        fetchPokedox()
        setupBindings()
    }
    
    
    //MARK: Private functions
    private func fetchPokedox() {
        networkManager.sendRequest(url: URL(string: API.pokedex.urlString)!)
            .replaceError(with: Pokedex())
            .sink { [weak self] pokedex in
                self?.pokedex.send(pokedex)
                self?.fetchRandomPokemon()
            }
            .store(in: &cancellableBag)
    }
    
    private func fetchPokemon(with id: String) {
        networkManager.sendRequest(url: URL(string: String(format: API.pokemonDetails.urlString, id))!)
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
        pokemonDetails
            .sink { [weak self] pokemon in
                self?.name = pokemon.name
                self?.avatarURL = URL(string: pokemon.avatar)
                let abilities = pokemon.abilities.map { $0.name }.joined(separator: ", ")
                self?.abilities = abilities.isEmpty ? "" : UIStrings.homeAbilities.localized + abilities
            }
            .store(in: &cancellableBag)
    }
    
    private func fetchRandomPokemon() {
        guard let randomPokemon = pokedex.value.pokemonEntries.randomElement() else {
            return
        }
        avatarURL = nil
        fetchPokemon(with: String(randomPokemon.id))
    }
    
    private func animateSave(reverse: Bool) {
        didSave = true
        if reverse {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.didSave = false
            }
        }
    }
    
    private func fetchSavedPokemons() {
        let allPokemons = coreDataManager.getAllSavedPokemons().map { PokemonEntry(with: $0) }
        if !allPokemons.isEmpty {
            pokemonDatasource = allPokemons
        }
    }
    
    private func showOrHideSavedPokemons() {
        if showPokemonList {
            didSave = false
            showPokemonList = false
        } else {
            animateSave(reverse: false)
            fetchSavedPokemons()
            showPokemonList = true
        }
    }
    
    //MARK: Public methods
    func process(_ input: Input) {
        
        input.saveTapped.sink { [weak self] _ in
            guard let pokemon = self?.pokemonDetails.value,
                  !pokemon.name.isEmpty,
                  let coreDataManager = self?.coreDataManager,
                  coreDataManager.getPokemon(by: Int64(pokemon.id)) == nil
            else {
                return
            }
            let pokemonModel = PokemonModel(context: coreDataManager.persistentContainer.viewContext)
            pokemonModel.id = Int64(pokemon.id)
            pokemonModel.name = pokemon.name
            pokemonModel.abilities = pokemon.abilities.map { $0.name }.joined(separator: ", ")
            pokemonModel.avatarURL = pokemon.avatar
            coreDataManager.save()
            self?.animateSave(reverse: true)
        }
        .store(in: &cancellableBag)
        
        input.nextTapped.sink { [weak self] _ in
            self?.fetchRandomPokemon()
        }
        .store(in: &cancellableBag)
        
        input.viewAppeared.sink { [weak self] _ in
            guard let pokemon = self?.pokemonDetails.value,
                  !pokemon.name.isEmpty else {
                return
            }
            self?.fetchRandomPokemon()
        }
        .store(in: &cancellableBag)
        
        input.viewSavedPokemons.sink { [weak self] _ in
            self?.showOrHideSavedPokemons()
        }
        .store(in: &cancellableBag)
        
        input.tappedPokemon.sink { [weak self] id in
            self?.showOrHideSavedPokemons()
            self?.fetchPokemon(with: String(id))
        }
        .store(in: &cancellableBag)
    }
}
