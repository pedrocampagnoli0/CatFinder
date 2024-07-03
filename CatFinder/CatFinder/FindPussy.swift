//
//  FindPussy.swift
//  CatFinder
//
//  Created by Turma02-17 on 01/07/24.
//

import SwiftUI

struct FindPussy: View {
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    @State var showImagePicker: Bool = false
    @State var imageArray: [IdentifiableImage] = [];
    @State private var currentIndex = 0;
    @State private var imagesCount = 0;
    @State var imageUpload: Image? = nil;
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image: UIImage?
    let timer = Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()
    @State private var catName: String = "";
    var body: some View {
        NavigationStack {
            ZStack {
                Color("background-color")
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    
                    Text("TAKE PHOTO")
                        .foregroundStyle(.white)
                        .font(.title3)
                    if(imagesCount < 1 && selectedImage == nil) {
                        Button(action: {
                            self.showCamera.toggle()
                        }) {
                            ZStack {
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                                    .grayscale(0.8)
                                
                                Text("+")
                                    .font(.system(size: 130))
                                    .opacity(0.7)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 250, height: 250)
                            .background(Color("button-color"))
                            .foregroundColor(Color("background-color"))
                            .font(.largeTitle)
                            .bold()
                        }
                        .fullScreenCover(isPresented: self.$showCamera) {
                            AccessCamera(selectedImage: self.$selectedImage)
                        }
                    }
                    
                    VStack {
                        if(imagesCount < 1 && image == nil) {
                            Button(action: {
                                self.showImagePicker.toggle()
                            }) {
                                Text("OR UPLOAD")
                            }
                            .frame(width: 160, height: 60)
                            .foregroundColor(Color("background-color"))
                            .background(Color("button-color"))
                            .cornerRadius(6)
                            .font(.title3)
                            .bold()
                        }
                        
                        VStack {
                            TabView(selection:$currentIndex) {
                                if(selectedImage != nil) {
                                    ZStack {
                                        Image(uiImage: selectedImage!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 250, height: 160)
                                            .cornerRadius(30)
                                            .clipped()
                                            .padding(.top)
                                        Button(action: {
                                            withAnimation{
                                                selectedImage = nil
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .resizable()
                                                .foregroundColor(Color("button-color"))
                                                .frame(width: 25, height: 25)
                                                .padding(.leading, 230)
                                                .padding(.bottom, 130)
                                        }
                                    }
                                }
                                ForEach(0..<imageArray.count, id: \.self) { imageIndex in
                                    ZStack {
                                        imageArray[imageIndex].image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 250, height: 160)
                                            .cornerRadius(30)
                                            .clipped()
                                            .tag(imageIndex)
                                            .padding(.top)
                                        Button(action: {
                                            withAnimation{
                                                removeImage(at: imageIndex)
                                                imagesCount -= 1
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .resizable()
                                                .foregroundColor(Color("button-color"))
                                                .frame(width: 25, height: 25)
                                                .padding(.leading, 230)
                                                .padding(.bottom, 130)
                                        }
                                    }
                                    
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
                            self.imageUpload = Image(uiImage: image)
                            let img = IdentifiableImage(image: Image(uiImage: image))
                            self.imageArray.append(img)
                            imagesCount += 1
                        }
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    NavigationLink(destination: FoundPussyView()) {
                        Text("FIND CAT")
                            .frame(width: 220, height: 80)
                            .foregroundColor(Color("background-color"))
                            .background(Color("button-color"))
                            .cornerRadius(6)
                            .font(.title)
                    }
//                    Button("FIND CAT") {
//                        imageArray.removeAll()
//                        imagesCount = 0
//                        catName = ""
//                    }
//                    .frame(width: 220, height: 80)
//                    .foregroundColor(Color("background-color"))
//                    .background(Color("button-color"))
//                    .cornerRadius(6)
//                    .font(.title)
                }
                .padding()
            }
        }
    }
    
    private func removeImage(at index: Int) {
        imageArray.remove(at: index)
        // Adjust currentIndex if the removed image was selected
        if currentIndex >= imageArray.count {
            currentIndex = imageArray.count - 1
        }
    }
}

#Preview {
    FindPussy()
}
