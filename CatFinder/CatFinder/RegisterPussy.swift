//
//  RegisterPussy.swift
//  CatFinder
//
//  Created by Turma02-17 on 26/06/24.
//

import SwiftUI

struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: Image
}

struct RegisterPussy: View {
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State var showImagePicker: Bool = false
    @State var image: Image? = nil;
    @State var imageArray: [IdentifiableImage] = [];
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
                
                VStack {
                    Button(action: {
                        self.showImagePicker.toggle()
                    }) {
                        Text("+")
                    }
                    .frame(width: 250, height: 300)
                    .background(Color("button-color"))
                    .foregroundColor(Color("background-color"))
                    .font(.largeTitle)
                    .bold()
                    .cornerRadius(6)
                    
                    HStack {
                        ForEach(imageArray) { img in
                            img.image
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: .photoLibrary) { image in
                        self.image = Image(uiImage: image)
                        let img = IdentifiableImage(image: Image(uiImage: image))
                        self.imageArray.append(img)
                    }
                }
                
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
