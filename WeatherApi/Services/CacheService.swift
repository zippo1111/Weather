//
//  CacheService.swift
//  WeatherApi
//
//  Created by Mangust on 23.05.2025.
//

import UIKit

struct Cache {
    let images: [Int: UIImage]

    init(images: [Int: UIImage] = [:]) {
        self.images = images
    }

    func withUpdatedImage(_ image: UIImage?, for key: Int) {
        var newImages = images
        newImages[key] = image
//        return Cache(images: newImages)
    }
}

struct CacheService {
    private var cache: Cache

    init(cache: Cache = Cache()) {
        self.cache = cache
    }

    func contains(_ address: Int) -> Bool {
        cache.images.keys.contains(address)
    }

    func get(by key: Int) -> UIImage? {
        cache.images[key]
    }

    func set(value: UIImage?, for key: Int) {
        guard let _ = get(by: key) else {
            cache.withUpdatedImage(value, for: key)
//            return CacheService(cache: updatedCache)
            return
        }

        return
    }
}
