//
//  Optionals+extensions.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-18.
//

import Foundation

extension Optional where Wrapped == String {
    func unwrapped() -> String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case .none:
            return ""
        }
    }
}
