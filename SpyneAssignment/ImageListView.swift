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
                    if let uiImage = loadImageFromDocumentDirectory(imageName: image.imagePath) {
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
                }
            }
        }
        .listStyle(.plain)
    }
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        }
        return nil
    }

}


#Preview {
    ImageListView()
}
