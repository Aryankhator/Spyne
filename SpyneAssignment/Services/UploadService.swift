//
//
// UploadService.swift
// SpyneAssignment
//
// Created by Nand on 08/12/24
//
        

import Foundation
import RealmSwift

final class UploadManager {
    static let shared = UploadManager()
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }

    func upload(image: ImageModel) {
        guard let url = URL(string: "https://www.clippr.ai/api/upload"),
              let imageData = try? Data(contentsOf: URL(fileURLWithPath: image.imagePath)) else {
            print("Invalid image or URL.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(UUID().uuidString).jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        let task = session.uploadTask(with: request, from: body) { data, response, error in
            let realm = try? Realm()
            if let error = error {
                print("Upload failed: \(error.localizedDescription)")
                try? realm?.write {
                    image.uploadStatus = .failed
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Upload failed: Invalid response")
                try? realm?.write {
                    image.uploadStatus = .failed
                }
                return
            }

            print("Upload successful!")
            try? realm?.write {
                image.uploadStatus = .completed
            }
        }
        task.resume()
        let realm = try? Realm()
        try? realm?.write {
            image.uploadStatus = .uploading
        }
    }
}

