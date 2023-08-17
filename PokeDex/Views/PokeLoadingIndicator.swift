//
//  PokeLoadingIndicator.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import SwiftUI

struct PokeLoadingIndicator: View {
    
    enum IndicatorSize: CGFloat {
        case small = 30
        case medium = 60
        case large = 90
    }
    
    @State private var isRotating = 0.0
    var size: IndicatorSize
    
    private var repeatingAnimation: Animation {
            Animation
                .default
                .speed(Double.random(in: 0.25...0.5))
                .repeatForever(autoreverses: false)
        }
    
    var body: some View {
        Image("PokeBall")
            .resizable()
            .rotationEffect(.degrees(isRotating))
            .onAppear {
                withAnimation(repeatingAnimation) {
                        isRotating = 360.0
                    }
            }
        .frame(width: size.rawValue, height: size.rawValue)
        .padding()
    }
}

struct PokeLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PokeLoadingIndicator(size: .large)
    }
}
