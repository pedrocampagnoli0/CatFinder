//
//  PussyInfoSheetView.swift
//  CatFinder
//
//  Created by Turma02-17 on 25/06/24.
//

import SwiftUI

struct PussyInfoSheetView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color("background-color")
                .ignoresSafeArea()
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
    }
}

#Preview {
    PussyInfoSheetView()
}
