//
//  MissingPussies.swift
//  CatFinder
//
//  Created by Turma02-17 on 25/06/24.
//

import SwiftUI

struct MissingPussies: View {
    @State private var showingSheet = false;
    var body: some View {
        ZStack {
            Color("background-color")
                .ignoresSafeArea()
            VStack {
                Text("Missing Cats")
                    .foregroundStyle(Color("text-color"))
                    .font(.title)
                VStack {
                    List {
                        Button("Info") {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet) {
                            PussyInfoSheetView()
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .foregroundColor(Color("text-color"))
                        .font(.title2)
                    }
                    .listStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    MissingPussies()
}
