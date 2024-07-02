//
//  FoundPussyView.swift
//  CatFinder
//
//  Created by Turma02-17 on 01/07/24.
//

import SwiftUI

struct FoundPussyView: View {
    var body: some View {
        ZStack {
            Color("background-color")
                .ignoresSafeArea()
            VStack {
                Text("YOU'VE")
                    .font(.largeTitle)
                    .foregroundStyle(Color("text-color"))
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .cornerRadius(150)
                Text("FOUND IT")
                    .font(.largeTitle)
                    .foregroundStyle(Color("text-color"))
                
                Button("POST LOCATION") {
                    
                }
                .frame(width: 240, height: 70)
                .foregroundColor(Color("background-color"))
                .background(Color("button-color"))
                .cornerRadius(6)
                .font(.title2)
                .bold()
                .padding(30)
            }
        }
    }
}

#Preview {
    FoundPussyView()
}
