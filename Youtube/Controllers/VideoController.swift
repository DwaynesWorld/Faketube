//
//  VideoController.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/27/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit
import AVKit

class VideoController: NSObject {
    
    func showVideoPlayer() {
        print("some things")
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let view = UIView(frame: window.frame)
        view.backgroundColor = .white
        
        view.frame = CGRect(
            x: window.frame.width - 10,
            y: window.frame.height - 10,
            width: 10,
            height: 10)

        let height = window.frame.width * 9 / 16
        let videoPlayerFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: height + window.safeAreaInsets.top)
        let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
        
        view.addSubview(videoPlayerView)
        window.addSubview(view)
        
        let animation = {
            view.frame = window.frame
        }
        
        let completion : (Bool) -> Void = { (completed) -> Void in
            
        }
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: animation,
            completion: completion)
    }
}
