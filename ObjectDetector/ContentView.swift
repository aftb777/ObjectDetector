//
//  ContentView.swift
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var imageLoaderViewModel = ImageLoaderViewModel()
    @State var viewModel = ContentViewModel()
    @State private var showLibrary = false
    @State private var showCamera = false
    @State private var imageToDisplay: Image?
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 300)
                if let imageToDisplay = imageToDisplay {
                    imageToDisplay
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                }
            }
            Text(viewModel.detection)
                .font(.system(size: 15, weight: .semibold))
                .padding(.top)
            Group {
                Button(action: {
                    showLibrary = true
                }, label: {
                    Text("Find Image")
                })
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, 20)
                Button(action: {
                    showCamera = true
                }, label: {
                    Text("Take Photo")
                })
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(.horizontal)
            Spacer()
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker { image in
                
                imageToDisplay = Image(uiImage: image)
                viewModel.detectObject(image: image)
            }
        }
        .onChange(of: imageLoaderViewModel.imageToUpload, { _, newValue in
            if let newValue = newValue {
                imageToDisplay = Image(uiImage: newValue)
                viewModel.detectObject(image: newValue)
            }
        })
        .photosPicker(isPresented: $showLibrary, selection: $imageLoaderViewModel.imageSelection, matching: .images, photoLibrary: .shared())
    }
}

#Preview {
    ContentView()
}
