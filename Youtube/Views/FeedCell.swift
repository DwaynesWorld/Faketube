//
//  FeedCell.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/25/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

class FeedCell: BaseCell {
    
    var videos = [Video]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    fileprivate let cellId = "FeedCellId"
    
    override func setupViews() {
        super.setupViews()
        
        setupCollectionView()
        fetchVideos()
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        addConstraints(withformat: "H:|[v0]|", views: collectionView)
        addConstraints(withformat: "V:|[v0]|", views: collectionView)
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func fetchVideos() {

    }
}

extension FeedCell:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        return videos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId,
            for: indexPath) as! VideoCell

        cell.video = videos[indexPath.item]
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let thumbnailWidth = (frame.width - 16 - 16)
        let thumnailHeight = thumbnailWidth * (9 / 16)
        let spacing: CGFloat = 54
        let userProfileHeight: CGFloat = 44
        let separatorHeight: CGFloat = 1
        let height = thumnailHeight + spacing + userProfileHeight + separatorHeight

        return CGSize(width: frame.width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        let videoController = VideoController()
        videoController.showVideoPlayer()
        
        // get video url from video array at current index,
        // pass in to video controller
    }
}
