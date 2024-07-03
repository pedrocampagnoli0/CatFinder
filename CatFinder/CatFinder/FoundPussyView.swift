//
//  FoundPussyView.swift
//  CatFinder
//
//  Created by Turma02-17 on 01/07/24.
//

import SwiftUI

struct FoundPussyView: View {
    
    @StateObject var vm = ViewModel()
    var i = 0
    var body: some View {
        ZStack {
            Color("background-color")
                .ignoresSafeArea()
            VStack {
                Text("YOU'VE")
                    .font(.largeTitle)
                    .foregroundStyle(Color("text-color"))
                
                if let cat = vm.cats.first {
                    AsyncImage(url: URL(string: cat.photos[3])) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .frame(width: 200, height: 200)
                        } else if phase.error != nil {
                            Text("Failed to load image")
                        } else {
                            ProgressView()
                        }
                        Text(cat.name)
                            .foregroundStyle(.white)
                            .font(.title)
                    }
                }
                //                Text(vm.cats[0].name)
//                AsyncImage(url: URL(string: vm.cats[0].photos[0]))
//                AsyncImage(url: URL(string: cat.photos[3])) {
//                    image in image.image?.resizable()
//                }
//                .frame(width: 100, height: 100)
                    
//                Image("logo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 300)
//                    .cornerRadius(150)
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
        .onAppear() {
            vm.fetchCats()
        }
    }
}

#Preview {
    FoundPussyView()
}
