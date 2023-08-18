//
//  FooterView.swift
//  PokeDex
//
//  Created by Aravind Vijayan on 2023-08-19.
//

import Combine
import SwiftUI

struct FooterView: View {
    @StateObject var viewModel: PokedexViewModel
    private var saveTapped: PassthroughSubject<Void, Never>
    private var nextTapped: PassthroughSubject<Void, Never>
    
    init(viewModel: PokedexViewModel,
         saveTapped: PassthroughSubject<Void, Never>,
         nextTapped: PassthroughSubject<Void, Never>
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.saveTapped = saveTapped
        self.nextTapped = nextTapped
    }
    
    var body: some View {
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
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView(viewModel: PokedexViewModel(), saveTapped: PassthroughSubject<Void, Never>(), nextTapped: PassthroughSubject<Void, Never>())
    }
}
