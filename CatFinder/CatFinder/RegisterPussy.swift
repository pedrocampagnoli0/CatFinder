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
    @State private var currentIndex = 0;
    @State private var imagesCount = 0;
    let timer = Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()
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
                    Text("Insert Images: " + String(imagesCount) + "/18")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(Color("text-color"))
                    Button(action: {
                        self.showImagePicker.toggle()
                    }) {
                        ZStack {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300)
                                .grayscale(0.8)
                            
                            Text("+")
                                .font(.system(size: 130))
                                .opacity(0.7)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: 300, height: 300)
                    .background(Color("button-color"))
                    .foregroundColor(Color("background-color"))
                    .font(.largeTitle)
                    .bold()
                    .cornerRadius(150)
                    
                    VStack {
                        TabView(selection:$currentIndex) {
                            ForEach(0..<imageArray.count, id: \.self) { imageIndex in
                                imageArray[imageIndex].image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 250, height: 160)
                                    .cornerRadius(30)
                                    .clipped()
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    }
                    .onReceive(timer) { _ in
                        withAnimation {
                            currentIndex = (currentIndex + 1) % imageArray.count
                        }
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: .photoLibrary) { image in
                        self.image = Image(uiImage: image)
                        let img = IdentifiableImage(image: Image(uiImage: image))
                        self.imageArray.append(img)
                        imagesCount += 1
                    }
                }
                .padding(.top)
                
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
