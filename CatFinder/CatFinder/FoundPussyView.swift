//
//  FoundPussyView.swift
//  CatFinder
//
//  Created by Turma02-17 on 01/07/24.
//

import SwiftUI

struct FoundPussyView: View {
    @StateObject var vm = ViewModel()
    @State private var showingSheet = false
    
    @State var catAux : Cat?
    
    var body: some View {
        ZStack {
            Color("background-color")
                .ignoresSafeArea()
            VStack {
                Text("Found Cats")
                    .foregroundStyle(Color("text-color"))
                    .font(.title)
                    .sheet(isPresented: $showingSheet) {
                        PussyInfoSheetView(cat: $catAux)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                VStack {
                    List {
                        ForEach(vm.cats, id: \.self) { cat in
                            HStack {
                                if(cat.lost == false) {
                                    AsyncImage(url: URL(string: cat.photos[3])) {
                                        image in image.image?.resizable()
                                    }
                                    .frame(width: 100, height: 100)
                                    
                                    Text(cat.name)
                                        .foregroundStyle(Color("text-color"))
                                        .font(.title)
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Button("") {
                                        showingSheet.toggle()
                                        catAux = cat
                                    }
                                    
                                }
                            }
                            .listRowBackground(Color("background-color"))
                        }
                    }
                    .listStyle(.plain)
                    
                }
            }
            .onAppear() {
                vm.fetchCats()
                vm.fetchUsers()
            }
        }
    }
}

#Preview {
    FoundPussyView()
}
