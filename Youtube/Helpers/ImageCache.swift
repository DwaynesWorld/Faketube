//
//  ImageCache.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/24/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

class ImageCache {
    
    let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        return cache
    }()
    
    static let shared = ImageCache()
    private init() {}
}
