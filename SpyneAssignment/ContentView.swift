//
//
// ContentView.swift
// SpyneAssignment
//
// Created by Aryan on 08/12/24
//
        

import SwiftUI
import RealmSwift

struct ContentView: View {
    @State var showCameraPicker: Bool = false
    
    var body: some View {
        VStack {
            ImageListView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                Button {
                    createDummyImageModelInBackground()
                }label: {
                    Text("Dummy Data")
                        .padding()
                        .font(.title3).bold()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(20)
                }
                Button {
                    showCameraPicker = true
                }label: {
                    Text("Capture Image")
                        .padding()
                        .font(.title3).bold()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(20)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showCameraPicker){
            CameraImagePicker(isPresented: $showCameraPicker)
                .ignoresSafeArea()
        }
    }
    
    func createDummyImageModelInBackground() {
        let name = UUID().uuidString + ".jpg"
            saveImageToDocumentDirectory(image: UIImage(named: "sample") ?? UIImage(), imageName: name)
                let dummyImageModel = ImageModel()
                dummyImageModel.id = UUID().uuidString
                dummyImageModel.imagePath = name
                dummyImageModel.captureDate = Date()
                dummyImageModel.uploadStatus = .pending

                do {
                    let realm = try Realm()

                    try realm.write {
                        realm.add(dummyImageModel)
                    }
                    print("Dummy image model added to Realm in background.")
                } catch {
                    print("Error adding dummy image model to Realm in background: \(error)")
                }
        UploadManager.shared.upload(image: dummyImageModel)
    }



    func saveImageToDocumentDirectory(image: UIImage, imageName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        
        if let data = image.jpegData(compressionQuality: 1.0), !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("File saved at \(fileURL.path)")
            } catch {
                print("Error saving file: \(error)")
            }
        } else {
            print("File already exists at \(fileURL.path)")
        }
    }

}

#Preview {
    ContentView()
}


