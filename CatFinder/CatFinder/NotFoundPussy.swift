//
//  NotFoundPussy.swift
//  CatFinder
//
//  Created by Turma02-17 on 03/07/24.
//

import SwiftUI

struct NotFoundPussy: View {
    var body: some View {
        ZStack {
            Color("background-color")
                .ignoresSafeArea()
            VStack {
                Text("THE CAT")
                    .font(.largeTitle)
                    .foregroundStyle(Color("text-color"))
                Image("sad-cat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                Text("IS NOT REGISTERED")
                    .font(.largeTitle)
                    .foregroundStyle(Color("text-color"))
                
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
            }
        }
    }
}

#Preview {
    NotFoundPussy()
}
