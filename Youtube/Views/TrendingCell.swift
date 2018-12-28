//
//  TrendingCell.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/27/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    override func fetchVideos() {
        VideoService.shared.fetchVideos(for: "trending") { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
