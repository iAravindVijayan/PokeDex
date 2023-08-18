//
//  ContentView.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import SwiftUI
import Combine

struct PokedexView: View {
    @StateObject var viewModel: HomeViewModel
    
    private var saveTapped = PassthroughSubject<Void, Never>()
    private var nextTapped = PassthroughSubject<Void, Never>()
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        viewModel.process((
            saveTapped: saveTapped.eraseToAnyPublisher(),
            nextTapped: nextTapped.eraseToAnyPublisher()
        ))
    }
    
    var body: some View {
        ZStack {
            Color.pokeRed
                .ignoresSafeArea()
            VStack {
                HeaderView()
                AvatarView(viewModel: viewModel)
                DecriptionView(viewModel: viewModel)
                HStack {
                    Button(UIStrings.save.localized) {
                        saveTapped.send()
                    }
                    .frame(width: 100, height: 60)
                    .foregroundColor(.white)
                    .background(Color.darkGray)
                    .cornerRadius(12)
                    Spacer()
                    Button(UIStrings.next.localized) {
                        nextTapped.send()
                    }
                    .frame(width: 100, height: 60)
                    .foregroundColor(.white)
                    .background(Color.darkGray)
                    .cornerRadius(12)
                }.padding([.leading, .trailing], 32)
                    .padding(.top)
                    
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
        }
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView(viewModel: HomeViewModel())
    }
}

private struct AvatarView: View {
    @StateObject var viewModel: HomeViewModel
        
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ZStack {
            Color.black
            Color.white
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 4, trailing: 4))
            AsyncImage(url: viewModel.avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            } placeholder: {
                PokeLoadingIndicator(size: .medium)
            }
            .padding(EdgeInsets(top: 0, leading: 2, bottom: 2, trailing: 2))
        }
        .padding([.leading, .trailing], 16)
    }
    
    private func setupBindings() {
            
    }
}

private struct HeaderView: View {
    @State var saved = false
    var body: some View {
        HStack {
            Text(UIStrings.homeScreenTitle.localized)
                .font(.bold(.title)())
            Spacer()
            Image("PokeBall")
                .resizable()
                .frame(width: 40, height: 40)
                .offset(x: saved ? -15 : 0, y: saved ? 8 : 0)
                .scaleEffect(saved ? 1.5 : 1, anchor: .bottomLeading)
                .animation(.interpolatingSpring(stiffness: 170, damping: 8).delay(0.1), value: saved)
                .onTapGesture {
                    self.saved = !self.saved
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.saved = false
                    }
                }
        }
    }
}

struct DecriptionView: View {
    @StateObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
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
                    Text(viewModel.name)
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
                            .frame(maxWidth: .infinity,alignment: .leading)
                        Spacer()
                    }.padding(.all, 8)
                }
            }
            .padding([.leading, .trailing, .top], 8)
        }
        .frame(height: 200)
    }
}
