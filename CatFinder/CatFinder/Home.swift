//
//  Home.swift
//  CatFinder
//
//  Created by Turma02-17 on 25/06/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("background-color")
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Image("logo-catfinder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                        Text("CatFinder")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(Color("text-color"))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 30) {
                        NavigationLink(destination: MissingPussies()) {
                            Text("Missing Cats")
                                .frame(width: 120, height: 30)
                                .padding(20)
                                .background(Color("button-color"))
                                .cornerRadius(7)
                                .foregroundStyle(Color("background-color"))
                        }
                        NavigationLink(destination: MissingPussies()) {
                            Text("Found Cats")
                                .frame(width: 120, height: 30)
                                .padding(20)
                                .background(Color("button-color"))
                                .cornerRadius(7)
                                .foregroundStyle(Color("background-color"))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    Home()
}
