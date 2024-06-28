//
//  ContentView.swift
//  CatFinder
//
//  Created by Turma02-17 on 25/06/24.
//

import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("background-color"))
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color("unselected-item-color"))
    }
    var body: some View {
        VStack {
            TabView {
                Home()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                RegisterPussy()
                    .tabItem {
                        Label("Register Cat", systemImage: "square.and.arrow.up")
                    }
                Home()
                    .tabItem {
                        // TODO: trocar isso aqui :)
                        Label("Pussy", systemImage: "camera")
                    }
            }
            .accentColor(Color("button-color"))
        }
    }
}

#Preview {
    ContentView()
}
