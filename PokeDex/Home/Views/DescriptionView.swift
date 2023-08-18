//
//  DescriptionView.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-19.
//

import Combine
import SwiftUI

struct DescriptionView: View {
    @StateObject var viewModel: PokedexViewModel
    
    init(viewModel: PokedexViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.gray
                .cornerRadiusWithBorder()
            VStack {
                ZStack {
                    Color.retroGreen
                        .cornerRadiusWithBorder(radius: 16)
                        .frame(height: 40)
                    Text(viewModel.name.capitalized)
                        .font(.title2)
                }
                Spacer()
                ZStack {
                    Color.retroGreen
                        .border(.black, width: 3)
                    .padding(.bottom)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.abilities)
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                    }.padding(.all, 8)
                }
            }
            .padding([.leading, .trailing, .top], 8)
        }
        .frame(height: 200)
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(viewModel: PokedexViewModel())
    }
}
