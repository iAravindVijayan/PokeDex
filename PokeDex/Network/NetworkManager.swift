//
//  NetworkManager.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//


import Combine
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func sendRequest<Model>(url: URL,
                            retryCount: Int = 0,
                            queue: DispatchQueue = .main
    ) -> AnyPublisher<Model, Error> where Model: Decodable  {
        
        return fetchData(url: url, retryCount: retryCount, queue: queue)
            .decode(type: Model.self, decoder: JSONDecoder())
            .receive(on: queue)
            .eraseToAnyPublisher()
    }
    
    func fetchData(url: URL,
                   retryCount: Int = 0,
                   queue: DispatchQueue = .main
    ) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, urlResponse in
                print("******Request******\n URL: ", url.absoluteString)
                guard let httpResponse = urlResponse as? HTTPURLResponse,
                      (200...300).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .retry(retryCount)
            .receive(on: queue)
            .eraseToAnyPublisher()
    }
}

enum NetworkError: Error {
    case wrongURL
    case unKnown
    case decodingError(Error)
    case invalidResponse
}
