//
//  ContentView.swift
//  NetflixRoulette
//
//  Created by Daniel Plata on 22/01/2020.
//  Copyright © 2020 silverapps. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    Text("Cargando...")
                } else {
                    Text(viewModel.content?.title ?? "")
                    Image(uiImage: viewModel.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200.0, height: 300.0, alignment: .center)

                    Button(action: {
                        self.viewModel.isLoading.toggle()
                        self.viewModel.search()
                    }) {
                        Text("Random")
                        .padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                        .background(Color(hex: "FEB32B"))
                        .foregroundColor(.black)
                        .cornerRadius(35)
                    }.padding(.top, 50)
                }
            }
            .navigationBarTitle("Netflix Roulette")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
