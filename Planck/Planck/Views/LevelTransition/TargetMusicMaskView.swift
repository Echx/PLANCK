//
//  TargetMusicMaskView.swift
//  Planck
//
//  Created by Lei Mingyu on 16/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

/// The delegate will be notified when the music is end or the view is dismissed
protocol TargetMusicMaskViewDelegate {
    func didFinishPlaying()
    func musicMaskViewDidDismiss(view: TargetMusicMaskView)
}

/// This class is shown when the target music is playing
class TargetMusicMaskView: UIView {
    private let headphoneIconFrame = CGRect(x: 452, y: 324, width: 120, height: 120)
    // The headphone icon image
    private let headphoneImage = UIImage(named: XImageName.headePhone)
    private var audioPlayerList = [AVAudioPlayer]()
    
    // the delegte
    var delegate: TargetMusicMaskViewDelegate?
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        blurView.frame = self.bounds
        self.addSubview(blurView)
        
        let headphoneView = UIImageView(image: self.headphoneImage)
        
        headphoneView.frame = headphoneIconFrame
        self.addSubview(headphoneView)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show(targetMusic: XMusic) {
        self.alpha = 1
        let noteSequence = targetMusic.flattenMapping()
        if !noteSequence.isEmpty {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Float(NSEC_PER_SEC) * Float(MusicDefaults.musicBuffer))), dispatch_get_main_queue()) {
                // play the music note by note
                for (note, distance) in noteSequence {
                    let audioPlayer = AVAudioPlayer(contentsOfURL: note.getAudioFile(), error: nil)
                    self.audioPlayerList.append(audioPlayer)
                    audioPlayer.prepareToPlay()
                    audioPlayer.playAtTime(audioPlayer.deviceCurrentTime + NSTimeInterval(distance / Constant.lightSpeedBase))
                }
            }
            
            let longestDistance = noteSequence[noteSequence.count - 1].1
            let delayTime = Float(longestDistance / Constant.lightSpeedBase + MusicDefaults.musicBuffer * 4)
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Float(NSEC_PER_SEC) * Float(delayTime))), dispatch_get_main_queue()) {
                self.delegate?.didFinishPlaying()
                return
            }
        } else {
            let delayTime = Float(MusicDefaults.musicBuffer * 4)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Float(NSEC_PER_SEC) * Float(delayTime))), dispatch_get_main_queue()) {
                self.delegate?.didFinishPlaying()
                return
            }
        }
    }
    
    /// Hide the view and notify the delegate
    func hide() {
        UIView.animateWithDuration(0.3, animations: {
                self.alpha = 0
            }, completion: {
                finished in
                self.removeFromSuperview()
                self.delegate?.musicMaskViewDidDismiss(self)
            })
    }
}

