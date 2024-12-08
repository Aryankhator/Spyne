//
//
// ContentView.swift
// SpyneAssignment
//
// Created by Aryan on 08/12/24
//
        

import SwiftUI

struct ContentView: View {
    @State var showCameraPicker: Bool = false
    @State var selectedCameraPhoto: UIImage?
    @State var imageArray: [UIImage] = []
    var body: some View {
        VStack {
            List(imageArray, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: .infinity)
                    .cornerRadius(10)
                    .padding(.vertical)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button {
                showCameraPicker = true
            }label: {
                Text(imageArray.count > 0 ? "Add More Images" : "Capture Image")
                    .padding()
                    .font(.title3).bold()
                    .foregroundStyle(.white)
                    .background(Color.cyan)
                    .cornerRadius(20)
            }
        }
        .padding()
        .sheet(isPresented: $showCameraPicker){
            CameraImagePicker(isPresented: $showCameraPicker, imageArray: $imageArray)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
