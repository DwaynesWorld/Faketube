//
//  VideoCell.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/23/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

class VideoCell: BaseCell {

    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "theweeknd_vevo_thumbnail")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "theweeknd_userprofile")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The Weeknd - Blank Space"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.text = "TheWeekndVEVO • 1,549,232,398 views • 2 years ago"
        view.textContainerInset = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
        view.textColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ApplicationColor.veryLightGray
        return view
    }()
    
    var video: Video? {
        didSet {
            guard let video = video, let channel = video.channel else { return }
            
            titleLabel.text = video.title
            setupTitleVariableConstraint(title: video.title ?? "")
            
            if let url = video.thumbnailImageName {
                thumbnailImageView.loadImage(usingUrlString: url)
            }
            
            if let profileImageUrl = channel.profileImageName,
                let channelName = channel.name {
                userProfileImageView.loadImage(usingUrlString: profileImageUrl)
                setupSubtitle(channelName: channelName, views: video.numberOfViews ?? 0)
            }
        }
    }

    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        super.setupViews()
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubtitle(channelName: String,  views: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        subtitleTextView.text  = "\(channelName) • \(numberFormatter.string(for: views) ?? "0") views • 2 years ago"
    }
    
    private func setupTitleVariableConstraint(title: String) {
        let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedRect = NSString(string: title)
            .boundingRect(with: size,
                          options: options,
                          attributes: [.font : UIFont.systemFont(ofSize: 14)],
                          context: nil)
        
        if estimatedRect.size.height > 20 {
            titleLabelHeightConstraint?.constant = 44
        } else {
            titleLabelHeightConstraint?.constant = 20
        }
    }
    
    private func setupSubviews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
    }
    
    private func setupConstraints() {
        addConstraints(withformat: "H:|-16-[v0]-16-|",
                       views: thumbnailImageView)
        
        addConstraints(withformat: "H:|-16-[v0(44)]", views: userProfileImageView)
        addConstraints(withformat: "V:[v0]-8-[v1(44)]", views: thumbnailImageView, userProfileImageView)
        
        addConstraints(withformat: "V:|-16-[v0]-8-[v1]-4-[v2(30)]-8-[v3(1)]|",
                       views: thumbnailImageView, titleLabel, subtitleTextView, separatorView)

        addConstraints(withformat: "H:|[v0]|",
                       views: separatorView)
        
        addConstraint(NSLayoutConstraint(item: titleLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: thumbnailImageView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 8))
        
        addConstraint(NSLayoutConstraint(item: titleLabel,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: userProfileImageView,
                                         attribute: .right,
                                         multiplier: 1,
                                         constant: 8))
        
        addConstraint(NSLayoutConstraint(item: titleLabel,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: thumbnailImageView,
                                         attribute: .right,
                                         multiplier: 1,
                                         constant: 0))
        
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel,
                                                        attribute: .height,
                                                        relatedBy: .equal,
                                                        toItem: self,
                                                        attribute: .height,
                                                        multiplier: 0,
                                                        constant: 20)
        addConstraint(titleLabelHeightConstraint!)
        
        addConstraint(NSLayoutConstraint(item: subtitleTextView,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: userProfileImageView,
                                         attribute: .right,
                                         multiplier: 1,
                                         constant: 8))
        
        addConstraint(NSLayoutConstraint(item: subtitleTextView,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: thumbnailImageView,
                                         attribute: .right,
                                         multiplier: 1,
                                         constant: 0))

        addConstraint(NSLayoutConstraint(item: subtitleTextView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .height,
                                         multiplier: 0,
                                         constant: 30))
    }
}
