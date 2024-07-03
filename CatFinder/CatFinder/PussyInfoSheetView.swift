//
//  PussyInfoSheetView.swift
//  CatFinder
//
//  Created by Turma02-17 on 25/06/24.
//

import SwiftUI

struct PussyInfoSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var cat: Cat?;
    
    @StateObject var vm = ViewModel();
    var body: some View {
        ZStack {
            Color("background-color")
                .ignoresSafeArea()
            VStack {
                ForEach(vm.users, id: \.self) { user in
                    if(cat != nil) {
                        if(user.id == cat!.userId) {
                            AsyncImage(url: URL(string: cat!.photos[3])) {
                                image in image.image?.resizable()
                            }
                            .frame(width: 200, height: 200)
                            Text("Owner: " + user.name)
                                .foregroundStyle(Color("text-color"))
                                .font(.title2)
                                .padding(.top)
                            Text("Email: " + user.email)
                                .foregroundStyle(Color("text-color"))
                                .font(.title2)
                            Text("Phone number: " + user.phone)
                                .foregroundStyle(Color("text-color"))
                                .font(.title2)
                        }
                    }
                }
            }
            VStack {
                Button("Sheet View") {
                    dismiss()
                }
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
                .foregroundColor(Color("text-color"))
                
                Spacer()
                
                
            }
        }
        .onAppear() {
            vm.fetchUsers()
//            vm.cats.filter{
//                $0.userId == cat.userId
//            }
        }
    }
}


