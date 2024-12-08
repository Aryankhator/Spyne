//
//
// ImageListView.swift
// SpyneAssignment
//
// Created by Nand on 08/12/24
//
        

import SwiftUI
import RealmSwift


struct ImageListView: View {
    @ObservedResults(ImageModel.self) var images

    var body: some View {
        List {
            ForEach(images) { image in
                HStack {
                    if let uiImage = UIImage(contentsOfFile: image.imagePath) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Captured: \(image.captureDate.shortDate() )")
                            .font(.callout)
                        Text("Status: \(image.uploadStatus.rawValue)")
                            .font(.callout)
                    }
                    
                    Spacer()
                    if image.uploadStatus == .failed {
                        Button("Retry") {
                            UploadManager.shared.upload(image: image)
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ImageListView()
}
