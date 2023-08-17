//
//  View+extensions.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import SwiftUI

extension View {
    @inlinable func cornerRadiusWithBorder(radius: CGFloat = 16, borderWidth: CGFloat = 3) -> some View {
        self
            .cornerRadius(radius)
            .overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(.black, lineWidth: borderWidth)
        )
    }
}
