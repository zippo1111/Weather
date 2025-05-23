//
//  Extension+UIImageView.swift
//  AuthAndMessages
//
//  Created by Mangust on 16.05.2025.
//

import UIKit

extension UIImageView {
    static let noImage = UIImage(systemName: "photo.artframe")

    func loadImage(from fileURL: URL) async throws {
        guard let data = try? Data(contentsOf: fileURL) else {
            print("Error loading image from file: \(fileURL)")
            self.image = UIImageView.noImage
            throw NetworkError.invalidURL
        }

        guard let image = UIImage(data: data) else {
            print("Error creating UIImage from data: \(data.count) bytes")
            self.image = UIImageView.noImage
            throw NetworkError.invalidURL
        }

        await MainActor.run {
            self.image = image
        }
    }
}
