//
//  PokeDexTests.swift
//  PokeDexTests
//
//  Created by Aravind Vijayan on 2023-08-19.
//

import Combine
import XCTest
@testable import PokeDex

final class PokeDexViewModelTests: XCTestCase {
    private var viewModel: PokedexViewModel!
    private var coreDataManager: CoreDataManager!
    
    private var saveTapped = PassthroughSubject<Void, Never>()
    private var nextTapped = PassthroughSubject<Void, Never>()
    private var tappedPokemon = PassthroughSubject<Int, Never>()
    private var viewAppeared = PassthroughSubject<Void, Never>()
    private var viewSavedPokemons = PassthroughSubject<Void, Never>()

    override func setUpWithError() throws {
        viewModel = PokedexViewModel(networkManager: .shared, coreDataManager: .shared)
        coreDataManager = CoreDataManager.shared
        viewModel.process((
            saveTapped: saveTapped.eraseToAnyPublisher(),
            nextTapped: nextTapped.eraseToAnyPublisher(),
            viewAppeared: viewAppeared.eraseToAnyPublisher(),
            viewSavedPokemons: viewSavedPokemons.eraseToAnyPublisher(),
            tappedPokemon: tappedPokemon.eraseToAnyPublisher()
        ))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveTapped() throws {
        let expect = expectation(description: "wait for API Call!!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.saveTapped.send()
            let savedPokemon = self.coreDataManager.getPokemon(by: self.viewModel.name)
            if savedPokemon?.name.unwrapped() == self.viewModel.name {
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 10)
    }
    
    func testNextTapped() throws {
        let expect = expectation(description: "wait for API Call!!")
        let previousName = viewModel.name
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.nextTapped.send()
            if previousName != self.viewModel.name && !self.viewModel.name.isEmpty  {
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
