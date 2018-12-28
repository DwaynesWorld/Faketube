//
//  VideoService.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/25/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import Foundation

class VideoService: NSObject {
    static let shared = VideoService()
    override init() {}
    
    func fetchVideos(for feed: String, completion: @escaping ([Video]) -> ()) {
        guard let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/\(feed).json") else {
            fatalError()
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let videos = try decoder.decode([Video].self, from: data)
                
                DispatchQueue.main.async {
                    completion(videos)
                }
                
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
    }
}
