//
//  AvatarView.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-19.
//

import Combine
import SwiftUI

struct AvatarView: View {
    @StateObject var viewModel: PokedexViewModel
        
    init(viewModel: PokedexViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ZStack {
            Color.black
            Color.white
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 4, trailing: 4))
            
            AsyncImage(url: viewModel.avatarURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo")
                default:
                    PokeLoadingIndicator(size: .medium)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 2, bottom: 2, trailing: 2))
        }
        .padding([.leading, .trailing], 16)
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(viewModel: PokedexViewModel())
    }
}
