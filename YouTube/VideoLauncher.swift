//
//  VideoLauncher.swift
//  YouTube
//
//  Created by Hanlin Chen on 7/13/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit
import AVFoundation
class VideoPlayerView: UIView{
    let activityIndicator : UIActivityIndicatorView = {
       let avi = UIActivityIndicatorView()
        avi.style = UIActivityIndicatorView.Style.large
        avi.translatesAutoresizingMaskIntoConstraints = false
        avi.startAnimating()
    return avi
    }()
    var isPlaying = false
    lazy var pausePlayButton : UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    let controlsContainerView: UIView  = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
    
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    let currenTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    let videoSlider: UISlider = {
       let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.addTarget(self, action: #selector(handleValueChange), for: .valueChanged)
        return slider
    }()
    @objc func handleValueChange(){
        if let duration = player?.currentItem?.duration{
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: {
                (completed) in
            })
        }
    }
    @objc func handlePause(){
        if isPlaying {
                 player?.pause()
             pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        }else{
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
   

        isPlaying = !isPlaying
    }
    private func setupGradientLayer(){
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(layer)
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupPlayerView()
        setupGradientLayer()
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant:  -8 ).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        controlsContainerView.addSubview(currenTimeLabel)
        currenTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant:  8).isActive = true
        currenTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -2 ).isActive = true
        currenTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currenTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currenTimeLabel.rightAnchor, constant: 8 ).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backgroundColor = .black
        
        
    }
    var player: AVPlayer?
    private func setupPlayerView(){
        let urlString = "https://firebasestorage.googleapis.com/v0/b/myweb-b4a38.appspot.com/o/venom.mp4?alt=media&token=9e0591a8-8e4a-4cc0-b213-0c2f7ee72ad6"
         player = AVPlayer(url: URL(string: urlString)!)
        
        let playLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(playLayer)
        playLayer.frame = self.frame
        player?.play()
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: {(progressTime) in
            
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds) % 60)
            let minutesString = String(format: "%02d", Int(seconds) / 60)
            
            self.currenTimeLabel.text = "\(minutesString):\(secondsString)"
            if let duration = self.player?.currentItem?.duration{
                let durationSeconds = CMTimeGetSeconds(duration)
                self.videoSlider.value = Float(seconds / durationSeconds)
            }

            
            
        })
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges"{
            activityIndicator.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            if let duration = player?.currentItem?.duration{
            let seconds = CMTimeGetSeconds(duration)
            let secondsText = Int(seconds) % 60
            let minuteText = String(format: "%02d", Int(seconds) / 60)
            videoLengthLabel.text = "\(minuteText):\(secondsText)"
            }
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
}
class VideoLauncher: NSObject {
    func showVideoPlayers(){
        if let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first{
            let view  = UIView(frame: keyWindow.frame)
            
            view.backgroundColor = .white
            let height = keyWindow.frame.width * 9/16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
           let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height-10, width: 10, height: 10)
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }, completion: {
                (completed) in
                
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
                
            })
        }
    }
}
