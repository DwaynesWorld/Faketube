//
//  VideoPlayerView.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/27/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerView: UIView {
    
    var player: AVPlayer?
    var isPlaying = false
    
    lazy var pauseplayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(VideoPlayerView.handlePausePlay), for: .touchUpInside)
        return button
    }()
    
    lazy var gradientLayer: CALayer = {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.7, 1.2]
        return layer
    }()

    let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let controlsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let progressTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = ApplicationColor.primary
        slider.maximumTrackTintColor = .white
        slider.thumbTintColor = ApplicationColor.primary
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        slider.addTarget(self, action: #selector(VideoPlayerView.handleScrub), for: .valueChanged)
        
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        setupPlayerView()
        setupControlsContainer()
    }
    
    private func setupPlayerView() {
        guard
            let window = UIApplication.shared.keyWindow,
            let url = URL(string: "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4") else { fatalError() }
        
        player = AVPlayer(url: url)
        let layer = AVPlayerLayer(player: player)
        layer.frame = CGRect(x: 0, y: window.safeAreaInsets.top, width: frame.width, height: frame.height - window.safeAreaInsets.top)
        self.layer.addSublayer(layer)
        
        player?.volume = 0.5
        player?.isMuted = false
        player?.play()
        
        player?.addObserver(
            self,
            forKeyPath: "currentItem.loadedTimeRanges",
            options: .new,
            context: nil)
        
        player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1.0, preferredTimescale: 2),
            queue: DispatchQueue.main,
            using: progressTimeObserver)
    }
    
    private func setupControlsContainer() {
        controlsContainer.frame = frame
        addSubview(controlsContainer)
        
        controlsContainer.layer.addSublayer(gradientLayer)
        
        controlsContainer.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainer.addSubview(pauseplayButton)
        pauseplayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pauseplayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pauseplayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pauseplayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainer.addSubview(durationLabel)
        durationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        durationLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainer.addSubview(progressTimeLabel)
        progressTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        progressTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        progressTimeLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        progressTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainer.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: durationLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: progressTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainer.backgroundColor = .clear
            pauseplayButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                
                durationLabel.text = duration.getTimeStampString()
            }
        }
    }
    
    func progressTimeObserver(progressTime: CMTime) {
        progressTimeLabel.text = progressTime.getTimeStampString()
        
        if let duration = player?.currentItem?.duration {
            let progressSeconds = CMTimeGetSeconds(progressTime)
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = progressSeconds / totalSeconds
            videoSlider.setValue(Float(value), animated: true)
        }
    }
    
    @objc func handlePausePlay() {
        let image: UIImage?
        
        if isPlaying {
            player?.pause()
            image = UIImage(named: "play")
        } else {
            player?.play()
            image = UIImage(named: "pause")
        }
        
        pauseplayButton.setImage(image, for: .normal)
        isPlaying = !isPlaying
    }
    
    @objc func handleScrub() {
        
        if let duration = player?.currentItem?.duration {
            
            let totalSeconds = CMTimeGetSeconds(duration)
            let seekSeconds = totalSeconds * Double(videoSlider.value)
            let seekTime = CMTime(seconds: seekSeconds, preferredTimescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (done) in
                print("completed seeks")
            })
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
