//
//  CoreDataManager.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-18.
//

import Foundation
import CoreData

final class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Pokedex")
        persistentContainer.loadPersistentStores { _ , error in
            if let error = error {
                fatalError("Failed to initialize core data \(error)")
            }
        }
    }
    
    func save() {
        do {
            try persistentContainer.viewContext.save()
        }
        catch {
            persistentContainer.viewContext.rollback()
            print("Fail to save pokedex data with \(error)")
        }
    }
    
    func getAllSavedPokemons() -> [PokemonModel] {
        let fetchRequest: NSFetchRequest<PokemonModel> = PokemonModel.fetchRequest()

        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            print("Failed to fetch Pokemons \(error)")
            return []
        }
    }

    func getPokemon(by id: Int64) -> PokemonModel?  {
        let fetchRequest: NSFetchRequest<PokemonModel> = PokemonModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest).first
        }
        catch {
            print("Failed to fetch Pokemon \(error)")
            return nil
        }
    }
    
    func getPokemon(by name: String) -> PokemonModel?  {
        let fetchRequest: NSFetchRequest<PokemonModel> = PokemonModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest).first
        }
        catch {
            print("Failed to fetch Pokemon \(error)")
            return nil
        }
    }
}
