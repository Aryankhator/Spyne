//
//
// CameraImagePicker.swift
// SpyneAssignment
//
// Created by Aryan on 08/12/24
//
        

import SwiftUI
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
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    private func saveToDatabase(image: UIImage) {
          let imageName = UUID().uuidString + ".jpg"
          let imagePath = FileManager.default.temporaryDirectory.appendingPathComponent(imageName)
          guard let data = image.jpegData(compressionQuality: 0.8) else { return }
          
          do {
              try data.write(to: imagePath)
              let realm = try Realm()
              let imageModel = ImageModel()
              imageModel.id = UUID().uuidString
              imageModel.imagePath = imagePath.path
              imageModel.captureDate = Date()
              try realm.write {
                  realm.add(imageModel)
              }
          } catch {
              print("Error saving image: \(error)")
          }
      }
}


