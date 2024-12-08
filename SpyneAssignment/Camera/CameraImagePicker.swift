//
//
// CameraImagePicker.swift
// SpyneAssignment
//
// Created by Aryan on 08/12/24
//


import SwiftUI
import UIKit
import RealmSwift

struct CameraImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraImagePicker
        
        init(parent: CameraImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.saveToDatabase(image: image)
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    private func saveToDatabase(image: UIImage) {
        let imageName = UUID().uuidString + ".jpg"
        saveImageToDocumentDirectory(image: image, imageName: imageName)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        do {
            let imageModel = ImageModel()
            imageModel.id = UUID().uuidString
            imageModel.imagePath = imageName
            imageModel.captureDate = Date()
            let realm = try Realm()
            try? realm.write {
                realm.add(imageModel)
            }
            UploadManager.shared.upload(image: imageModel)
        } catch {
            print("Error saving image: \(error)")
        }
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
