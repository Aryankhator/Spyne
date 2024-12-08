//
//
// ImageModel.swift
// SpyneAssignment
//
// Created by Nand on 08/12/24
//
        

import Foundation
import RealmSwift

class ImageModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var imagePath: String
    @Persisted var captureDate: Date
    @Persisted var uploadStatus: UploadStatus = .pending
    
    enum UploadStatus: String, PersistableEnum {
        case pending, uploading, completed, failed
    }
}
