//
//  UIStrings.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import Foundation

enum UIStrings: String {
    case homeScreenTitle = "home.title"
    case homeAbilities = "home.abilities"
    case save = "home.save"
    case next = "home.next"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
