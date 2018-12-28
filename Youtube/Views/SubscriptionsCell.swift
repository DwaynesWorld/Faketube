//
//  SubscriptionCell.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/27/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

class SubscriptionsCell: FeedCell {
    override func fetchVideos() {
        VideoService.shared.fetchVideos(for: "subscriptions") { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
