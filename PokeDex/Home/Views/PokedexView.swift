//
//  ContentView.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-17.
//

import SwiftUI

struct PokeDexView: View {
    var body: some View {
        ZStack {
            Color.pokeRed
                .ignoresSafeArea()
            VStack {
                HeaderView()
                AvatarView()
                DecriptionView()
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 98, trailing: 16))
        }
    }
}

struct PokeDexView_Previews: PreviewProvider {
    static var previews: some View {
        PokeDexView()
    }
}

private struct AvatarView: View {
    @State private var avatar: Image?
    var body: some View {
        ZStack {
            Color.black
            Color.white
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 4, trailing: 4))
            PokeLoadingIndicator(size: .medium)
            if let avatar = avatar {
                avatar
                    .padding(EdgeInsets(top: 0, leading: 2, bottom: 2, trailing: 2))
            }
        }
        .padding([.leading, .trailing], 16)
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
    var name: String = "Pikachu"
    var body: some View {
        ZStack {
            Color.gray
                .cornerRadiusWithBorder()
            VStack {
                ZStack {
                    Color.retroGreen
                        .cornerRadiusWithBorder(radius: 16)
                        .frame(height: 40)
                    Text(name)
                        .font(.title2)
                }
                Spacer()
                ZStack {
                    Color.retroGreen
                        .border(.black, width: 3)
                    .padding(.bottom)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(.title2)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        Text(name)
                            .font(.title2)
                        Spacer()
                    }.padding(.all, 8)
                }
            }
            .padding([.leading, .trailing, .top], 8)
        }
        .frame(height: 200)
    }
}
