//
//  UIImageView.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/24/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImage(usingUrlString str: String) {
        guard let url = URL(string: str) else { return }
        
        if let image = ImageCache.shared.cache.object(forKey: str as NSString) {
            self.image = image
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                
                ImageCache.shared.cache.setObject(image, forKey: str as NSString)
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        
        task.resume()
    }
}
