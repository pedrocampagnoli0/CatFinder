//
//  RegisterPussy.swift
//  CatFinder
//
//  Created by Turma02-17 on 26/06/24.
//

import SwiftUI

struct RegisterPussy: View {
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State private var catName: String = "";
    var body: some View {
        ZStack {
            Color("background-color")
                .ignoresSafeArea()
            VStack {
                Text("Cat Name:")
                    .foregroundStyle(Color("text-color"))
                    .padding(.trailing, 250)
                    .font(.title2)
                TextField(
                    "Required",
                    text: $catName
                )
                .padding()
                .background(Color("button-color"))
                .cornerRadius(6)
                .foregroundColor(Color("background-color"))
                
                Spacer()
                
                Button("+") {
                    
                }
                .frame(width: 300, height: 400)
                .background(Color("button-color"))
                .foregroundColor(Color("background-color"))
                .font(.largeTitle)
                .bold()
                .cornerRadius(6)
                
                Spacer()
                
                Button("REGISTER") {
                    
                }
                .frame(width: 160, height: 60)
                .foregroundColor(Color("background-color"))
                .background(Color("button-color"))
                .cornerRadius(6)
                .font(.title3)
                .bold()
            }
            .padding()
        }
    }
}

#Preview {
    RegisterPussy()
}
