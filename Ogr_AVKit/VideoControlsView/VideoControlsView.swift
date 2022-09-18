//
//  VideoControlsView.swift
//  Ogr_AVKit
//
//  Created by teyhan.uslu on 27.08.2022.
//

import UIKit
import AVKit

class VideoControlsView: UIView {

    override init(frame: CGRect) {
       super.init(frame: frame)
        commonInit()
     }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("VideoControlsView", owner: self)
        addSubview(allView)
        allView.frame = self.bounds
        allView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    var viewController: VideoScreenViewController?
    var player: AVPlayer!
    var is_start = true

    @IBOutlet var backBTN: UIButton!
    @IBOutlet var forBTN: UIButton!
    @IBOutlet var leftTapArea: UIView!
    @IBOutlet var rightTapArea: UIView!
    
    @IBOutlet var allView: UIView!
    @IBOutlet var playedTimeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var scrubber: UISlider!
    @IBOutlet var playPauseButton: UIButton!

    func prepareScreenElements(delegate: VideoScreenViewController, player: AVPlayer) {
        viewController = delegate
        self.player = player
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsedTime in
            self.updateVideoPlayerSlider()
        })
        backBTN.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50), forImageIn: .normal)
        forBTN.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50), forImageIn: .normal)
        playPauseButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50), forImageIn: .normal)
        createDoubleCheckTapGesture()
    }

    func updateVideoPlayerSlider() {
        if let currentItem = player?.currentItem {
            let duration = currentItem.duration
            if CMTIME_IS_INVALID(duration) || duration.value == 0 { return;}
            let currentTime = currentItem.currentTime()
            scrubber.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
            playedTimeLabel.text = timeIntervalToString(durationTime: CMTimeGetSeconds(currentTime))
            if is_start {
                totalTimeLabel.text = timeIntervalToString(durationTime: CMTimeGetSeconds(duration))
                is_start = false
            }
            viewController?.video.lastDuration = currentTime
            checkStop(current: CMTimeGetSeconds(currentTime), duration: CMTimeGetSeconds(duration))
        }
    }

    private func checkStop(current: Float64, duration: Float64){
        print("current:\(current)  duration:\(duration) ")
        if current.isEqual(to: duration), duration != 0 {
            player = nil
            viewController?.video.resetTime()
            viewController?.popThePage()
        }
    }

    private func timeIntervalToString(durationTime: TimeInterval) -> String {
        let minutes = Int(durationTime) / 60
        let seconds = Int(durationTime) % 60

        var minStr: String = "\(minutes)"
        if minutes < 10{
            minStr = "0\(minutes)"
        }
        var secStr: String = "\(seconds)"
        if seconds < 10{
            secStr = "0\(seconds)"
        }
        let videoDuration = "\(minStr):\(secStr)"
        return videoDuration
    }

    @IBAction func playPauseButtonTapped(_ sender: Any) {
        print(#function)
        guard let btn:UIButton = sender as? UIButton else { return }
        if !player.isPlaying {
            btn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            player.play()
        } else {
            btn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player.pause()
        }
    }

    @IBAction func scrubber(_ sender: Any) {
        guard let duration = player?.currentItem?.duration else { return }
        if CMTIME_IS_INVALID(duration) || duration.value == 0 { return }
        
        let value = Float64(scrubber.value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        player?.seek(to: seekTime )
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        print(#function)
        player = nil
        viewController?.popThePage()
    }

//    MARK: DoubleTap Management(time jump) when Controller UI Opened

    private func createDoubleCheckTapGesture(){
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(jumpForward))
        rightTap.numberOfTapsRequired = 2
        viewController?.tap.require(toFail: rightTap)
        rightTapArea.addGestureRecognizer(rightTap)

        let leftTap = UITapGestureRecognizer(target: self, action: #selector(jumpBackward))
        leftTap.numberOfTapsRequired = 2
        viewController?.tap.require(toFail: leftTap)
        leftTapArea.addGestureRecognizer(leftTap)
    }

    @IBAction func backwardButtonTapped(_ sender: Any) {
        print(#function)
        jumpBackward()
    }
    @objc func jumpBackward(){
        changeSeekTime(jump: -10)
        backBTN.isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            backBTN.isHighlighted = false
        }
    }

    @IBAction func forwardButtonTapped(_ sender: Any) {
        print(#function)
        jumpForward()
    }
    @objc func jumpForward(){
        changeSeekTime(jump: 10)
        forBTN.isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            forBTN.isHighlighted = false
        }
    }

    @objc private func changeSeekTime(jump: Int) {
        guard let duration = player?.currentItem?.duration else { return }
        if CMTIME_IS_INVALID(duration) || duration.value == 0 { return }
        var value = Float64(scrubber.value) * CMTimeGetSeconds(duration) + Float64(jump)
        if value < 0{
            value = 0
        }
        if value > CMTimeGetSeconds(duration){
            value = CMTimeGetSeconds(duration)
        }
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        player?.seek(to: seekTime )
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
